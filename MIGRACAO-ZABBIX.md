# Plano de Migração de Monitoramento: UptimeRobot → Zabbix

| Campo         | Detalhe                              |
|---------------|--------------------------------------|
| **Versão**    | 1.0                                  |
| **Data**      | 20/05/2026                           |
| **Autor**     | JC2SEC Consultoria                   |
| **Status**    | Em revisão                           |

---

## 1 Introdução

Este documento foi elaborado pela JC2SEC Consultoria em resposta à necessidade identificada de consolidar as ferramentas de monitoramento utilizadas pelo Centro de Operações de Rede (NOC) em uma única plataforma corporativa.

A operação atual do NOC faz uso simultâneo de três soluções distintas — Zabbix, UptimeRobot e um site dedicado ao monitoramento de link de internet —, cuja alternância é realizada por meio de uma extensão de navegador que não passou pelo processo de homologação da Segurança da Informação. A coexistência dessas ferramentas, além de fragmentar a visibilidade operacional, representa um risco de segurança documentado e evitável.

A análise conduzida demonstrou que todas as capacidades de monitoramento atualmente distribuídas entre essas soluções podem ser integralmente absorvidas pelo Zabbix, sem perda de funcionalidade e sem custos adicionais de licenciamento.

Este documento apresenta:

- o diagnóstico do ambiente atual;
- os pré-requisitos técnicos para a migração;
- o roteiro de implementação no Zabbix, com guidelines técnicos detalhados;
- o plano de validação e transição;
- os critérios de encerramento do UptimeRobot.

O documento destina-se às equipes de TI, NOC e Segurança da Informação envolvidas na execução e aprovação da iniciativa.

---

## 2 Objetivo

Apresentar o plano de migração do monitoramento de disponibilidade atualmente realizado pelo UptimeRobot para o Zabbix, consolidando todas as verificações de disponibilidade, conectividade e status de serviços em uma única ferramenta corporativa.

A migração está alinhada à decisão da Segurança da Informação de não homologar a extensão de navegador 3‑2‑1 Revolver, utilizada para alternância visual entre os múltiplos sites de monitoramento, e à diretriz de reduzir a superfície de ataque do ambiente de operações.

---

## 3 Escopo da Migração

### 3.1 Itens Contemplados

- Monitoramento de disponibilidade externa (sites e serviços via HTTP/HTTPS e ICMP);
- Monitoramento do link de internet (latência, perda de pacotes e disponibilidade);
- Centralização das métricas, alertas e histórico no Zabbix;
- Criação de dashboards dedicados para exibição em telas de NOC;
- Validação funcional dos alertas e comparação com o ambiente anterior.

### 3.2 Itens Fora do Escopo

- Alteração de fluxos de notificação já existentes no Zabbix (salvo necessidade técnica identificada durante a implementação);
- Integrações com ferramentas externas não utilizadas atualmente pelo NOC.

---

## 4 Levantamento do Ambiente Atual

### 4.1 Inventário do UptimeRobot

Antes de iniciar a implementação, deverá ser levantada a lista completa de monitores configurados no UptimeRobot. Para cada monitor, registrar:

| Campo                  | Descrição                                              |
|------------------------|--------------------------------------------------------|
| Nome do monitor        | Identificador descritivo do serviço                    |
| URL / Destino          | Endereço completo monitorado                           |
| Tipo de monitor        | HTTP/HTTPS, Ping (ICMP), Port (TCP)                    |
| Intervalo de checagem  | Frequência atual (ex.: 1, 5 ou 15 minutos)             |
| Critério de falha      | Número de falhas consecutivas antes do alerta          |
| Contatos de alerta     | Destinatários atualmente configurados                  |

Esse inventário será a base de referência para criação dos itens equivalentes no Zabbix e para a validação durante o período de transição.

### 4.2 Avaliação do Ambiente Zabbix

Antes da migração, validar os seguintes pontos:

| Item                                 | Verificação necessária                                                        |
|--------------------------------------|-------------------------------------------------------------------------------|
| Versão do Zabbix                     | Confirmar versão instalada; recomendado 6.x LTS ou superior                  |
| Conectividade de rede                | Zabbix Server ou Proxy deve alcançar os destinos externos (portas 80, 443)   |
| Templates disponíveis                | Verificar se "Template Module ICMP Ping" e similares já estão importados     |
| Permissões de usuário                | Confirmar acesso para criar hosts, itens, triggers, templates e dashboards    |
| Capacidade do servidor               | Avaliar carga atual e impacto dos novos itens de monitoramento                |

---

## 5 Pré-Requisitos Técnicos

Os itens abaixo devem ser verificados e resolvidos antes do início da implementação:

1. **Zabbix versão 6.x LTS ou superior** — versões anteriores podem não suportar todos os recursos de Web Scenarios e dashboard utilizados neste plano.
2. **Acesso de rede a destinos externos** — o Zabbix Server (ou Proxy, se aplicável) deve ter saída à internet nas portas 80 (HTTP) e 443 (HTTPS). Para checks ICMP, o servidor deve ter permissão para enviar pacotes ICMP.
3. **Credenciais administrativas no Zabbix** — o responsável pela implementação deve ter perfil de Super Admin ou Admin com permissão irrestrita sobre o grupo de hosts de destino.
4. **Acesso ao painel do UptimeRobot** — necessário para exportar o inventário completo de monitores (seção 4.1).
5. **Definição do Host Group de destino** — criar (ou identificar) o grupo de hosts que receberá os monitores externos, por exemplo: `Monitoramento Externo`.
6. **Alinhamento com a equipe de NOC** — confirmar janelas de manutenção e horários para os testes de validação.

---

## 6 Implementação no Zabbix

### 6.1 Organização de Hosts e Templates

Antes de criar os itens individuais, estabelecer a estrutura organizacional:

**Host Group recomendado:** `Monitoramento Externo` (ou `NOC – Externos`)

**Convenção de nomenclatura de hosts:**

```
EXT-<NOME_DO_SERVICO>
Exemplos: EXT-PORTAL-CLIENTE, EXT-ERP, EXT-GATEWAY-PAGAMENTO
```

**Abordagem de templates:**
- Criar um template por tipo de check (ex.: `Template NOC – Web HTTP`, `Template NOC – ICMP`).
- Vincular os templates aos hosts, mantendo os itens centralizados e reutilizáveis.
- Evitar itens avulsos diretamente no host; prefira herança via template para facilitar manutenção.

---

### 6.2 Monitoramento de Disponibilidade HTTP/HTTPS (Web Scenarios)

Web Scenarios são o equivalente direto dos monitores HTTP/HTTPS do UptimeRobot no Zabbix.

**Caminho de configuração:** `Configuration → Hosts → [Host] → Web → Create web scenario`

**Parâmetros recomendados:**

| Parâmetro           | Valor recomendado                          |
|---------------------|--------------------------------------------|
| Name                | Nome descritivo (ex.: `Verificação HTTPS – Portal`) |
| Update interval     | `1m` (equivalente ao menor intervalo do UptimeRobot) |
| Retries             | `2` (evita falso positivo por falha pontual) |
| Agent               | `Zabbix` (ou simular User-Agent específico se necessário) |

**Configuração do Step (etapa de verificação):**

| Campo               | Valor                                      |
|---------------------|--------------------------------------------|
| Name                | `Verificar homepage` (ou nome do passo)    |
| URL                 | `https://exemplo.com.br`                   |
| Required status codes | `200` (ou `200,301,302` se houver redirecionamentos esperados) |
| Timeout             | `15s`                                      |
| Follow redirects    | Ativado                                    |

**Itens gerados automaticamente pelo Web Scenario:**

| Item key                                    | Descrição                              |
|---------------------------------------------|----------------------------------------|
| `web.test.fail[Nome do Scenario]`           | 0 = OK, número = falha no step N       |
| `web.test.rspcode[Nome,Nome do Step]`       | Código HTTP retornado                  |
| `web.test.time[Nome,Nome do Step,resp]`     | Tempo de resposta em segundos          |

**Triggers recomendadas:**

```
# Indisponibilidade (falha em qualquer step)
Nome: [{HOST.NAME}] Serviço indisponível: {#SCENARIO}
Expressão: last(/HOST/web.test.fail[Nome do Scenario])<>0
Severidade: High

# Tempo de resposta elevado
Nome: [{HOST.NAME}] Tempo de resposta elevado: {#SCENARIO}
Expressão: last(/HOST/web.test.time[Nome,Nome do Step,resp])>5
Severidade: Warning
```

---

### 6.3 Monitoramento ICMP (Ping)

Utilizado para substituir monitores de Ping do UptimeRobot e para o monitoramento do link de internet.

**Template nativo recomendado:** `Template Module ICMP Ping` (disponível nos templates padrão do Zabbix 6.x)

**Itens disponíveis no template:**

| Item key          | Descrição                                            |
|-------------------|------------------------------------------------------|
| `icmpping`        | Disponibilidade (1 = alcançável, 0 = sem resposta)   |
| `icmppingloss`    | Percentual de perda de pacotes (0–100%)              |
| `icmppingsec`     | Latência média em segundos                           |

**Parâmetros de ping recomendados** (configurar em `Administration → General → ICMP ping`):

| Parâmetro   | Valor recomendado |
|-------------|-------------------|
| Count       | `3`               |
| Interval    | `200ms`           |
| Size        | `56 bytes`        |
| Timeout     | `500ms`           |

**Triggers recomendadas:**

```
# Host indisponível (3 checks consecutivos falhando)
Nome: [{HOST.NAME}] Host inacessível via ICMP
Expressão: max(/HOST/icmpping,#3)=0
Severidade: High

# Perda de pacotes moderada
Nome: [{HOST.NAME}] Perda de pacotes elevada (>20%)
Expressão: last(/HOST/icmppingloss)>20
Severidade: Warning

# Perda de pacotes crítica
Nome: [{HOST.NAME}] Perda de pacotes crítica (>50%)
Expressão: last(/HOST/icmppingloss)>50
Severidade: High

# Latência elevada
Nome: [{HOST.NAME}] Latência elevada (>100ms)
Expressão: last(/HOST/icmppingsec)>0.1
Severidade: Warning
```

---

### 6.4 Monitoramento TCP (Verificação de Porta)

Utilizado quando o UptimeRobot monitora uma porta específica (ex.: porta 443, 8443, 3306).

**Tipo de item:** `Simple check`

**Keys disponíveis:**

```
# Verificação de disponibilidade de porta TCP
net.tcp.service[tcp,,<PORTA>]
Exemplos:
  net.tcp.service[http,,80]
  net.tcp.service[https,,443]
  net.tcp.service[tcp,,8080]

# Tempo de resposta do serviço
net.tcp.service.perf[tcp,,<PORTA>]
```

**Trigger recomendada:**

```
Nome: [{HOST.NAME}] Porta <PORTA> inacessível
Expressão: last(/HOST/net.tcp.service[tcp,,443])=0
Severidade: High
```

---

### 6.5 Monitoramento de Link de Internet

Para substituir o site dedicado de monitoramento de link, configurar um host representando o link de internet com os seguintes itens:

- Aplicar o template `Template Module ICMP Ping` apontando para destinos externos confiáveis (ex.: `8.8.8.8`, `1.1.1.1`, `200.160.0.8`).
- Usar múltiplos destinos para evitar falso positivo causado por indisponibilidade de um único servidor externo.
- Criar trigger composta que dispare alerta somente quando **dois ou mais** destinos falharem simultaneamente.

**Exemplo de trigger com múltiplos destinos:**

```
Nome: [Link Internet] Indisponibilidade de link detectada
Expressão:
  max(/EXT-LINK-INTERNET-DNS-GOOGLE/icmpping,#3)=0
  and
  max(/EXT-LINK-INTERNET-CLOUDFLARE/icmpping,#3)=0
Severidade: Disaster
```

---

## 7 Dashboards para o NOC

### 7.1 Estrutura Recomendada

Criar ao menos um dashboard dedicado ao NOC com a seguinte composição de widgets:

| Widget          | Configuração recomendada                                              |
|-----------------|-----------------------------------------------------------------------|
| **Problems**    | Filtrar por Host Group `Monitoramento Externo`; ordenar por severidade |
| **Item value**  | Exibir métricas de latência e perda de pacotes do link de internet   |
| **Clock**       | Exibir horário local (referência para operação)                       |
| **Map**         | Mapa de rede com os hosts externos (opcional, para visão geográfica) |

### 7.2 Configuração de Severidades Visuais

Configurar as cores de severidade em `Administration → General → Trigger severities` para garantir boa visibilidade nas telas de NOC:

| Severidade   | Cor sugerida      |
|--------------|-------------------|
| Disaster     | Vermelho escuro   |
| High         | Vermelho          |
| Average      | Laranja           |
| Warning      | Amarelo           |
| Information  | Azul claro        |

### 7.3 Modo Quiosque no Microsoft Edge

Para exibição permanente nas telas do NOC, sem extensões e sem interface do navegador:

```powershell
# Executar via GPO ou script de inicialização da estação NOC
Start-Process "msedge.exe" -ArgumentList `
  "--kiosk", "https://<ZABBIX_URL>/zabbix/zabbix.php?action=dashboard.view&dashboardid=<ID>", `
  "--edge-kiosk-type=fullscreen", `
  "--no-first-run"
```

> Substituir `<ZABBIX_URL>` pelo endereço do servidor Zabbix e `<ID>` pelo ID do dashboard criado.

---

## 8 Validação e Período de Transição

### 8.1 Operação em Paralelo

Durante um período mínimo de **5 a 10 dias úteis**, Zabbix e UptimeRobot operarão simultaneamente. O objetivo é confirmar que o Zabbix detecta as mesmas condições que o UptimeRobot, sem omissões ou atrasos relevantes.

### 8.2 Critérios de Aprovação

A migração será considerada validada quando **todos** os itens abaixo forem confirmados:

| Critério                                                                 | Responsável  | Status |
|--------------------------------------------------------------------------|--------------|--------|
| Todos os monitores do UptimeRobot replicados no Zabbix                   | TI           | [ ]    |
| Nenhuma discrepância de detecção em 5 dias de operação paralela          | NOC          | [ ]    |
| Tempo de alerta no Zabbix ≤ tempo de alerta no UptimeRobot               | NOC          | [ ]    |
| Dashboards do NOC exibindo corretamente em modo quiosque                 | NOC / TI     | [ ]    |
| Triggers testadas com simulação de falha controlada                      | TI           | [ ]    |
| Revisão e aprovação formal pela Segurança da Informação                  | SI           | [ ]    |

### 8.3 Ajustes Durante a Transição

Quaisquer discrepâncias identificadas durante o período paralelo devem ser registradas, analisadas e corrigidas no Zabbix antes da desativação do UptimeRobot. Não serão considerados motivos de bloqueio alertas de menor severidade com diferença de tempo inferior a 2 minutos.

---

## 9 Desativação do UptimeRobot

Após a aprovação formal de todos os critérios da seção 8.2:

1. Desativar (pausar) todos os monitores no UptimeRobot — **não excluir** até decorridos 30 dias da desativação.
2. Remover o UptimeRobot dos favoritos e painéis das estações do NOC.
3. Revogar acessos ao UptimeRobot para usuários operacionais.
4. Registrar a data de desativação e arquivar o inventário exportado (seção 4.1) por ao menos 90 dias.
5. Após 30 dias sem ocorrências que demandem reversão, excluir a conta ou encerrar a assinatura.

---

## 10 Operação Pós-Migração

Com a consolidação concluída:

- O NOC utilizará exclusivamente dashboards do Zabbix para acompanhamento do ambiente.
- A exibição nas telas de NOC será feita pelo Microsoft Edge em modo quiosque, sem extensões de terceiros.
- A extensão 3‑2‑1 Revolver deixará de ser necessária e não deverá ser reinstalada.
- O ambiente passará a operar com menor superfície de ataque e maior estabilidade operacional.

---

## 11 Benefícios da Migração

| Benefício                                              | Impacto                                         |
|--------------------------------------------------------|-------------------------------------------------|
| Eliminação de ferramenta externa não homologada        | Redução de risco de segurança                   |
| Eliminação da extensão de navegador não homologada     | Conformidade com política de SI                 |
| Centralização de todo o monitoramento no Zabbix        | Operação mais simples e eficiente               |
| Visibilidade unificada em um único dashboard           | Menor tempo de resposta do NOC a incidentes     |
| Sem custos adicionais de licenciamento                 | Aproveitamento do investimento já realizado     |
| Histórico e métricas centralizados                     | Facilita análise de causa raiz e relatórios     |

---

## 12 Conclusão

A migração do monitoramento do UptimeRobot para o Zabbix é tecnicamente viável, de baixo risco operacional e plenamente alinhada às diretrizes de Segurança da Informação. A análise do ambiente atual demonstrou que o Zabbix possui todos os recursos necessários para absorver as capacidades das ferramentas atualmente utilizadas, sem qualquer perda funcional.

A iniciativa viabiliza a descontinuação da extensão 3‑2‑1 Revolver — não homologada — e elimina a dependência de múltiplos painéis de monitoramento na operação do NOC. O resultado esperado é um ambiente operacional mais simples, mais seguro e igualmente eficaz na detecção e tratamento de incidentes de disponibilidade.

A JC2SEC Consultoria está disponível para apoiar a execução de qualquer etapa descrita neste documento.
