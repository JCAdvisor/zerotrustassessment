import { ZtResponsiveSankey } from "@/components/nivo/sankey"
import { useContext } from "react"
import { ThemeProviderContext } from "@/contexts/ThemeContext"
import { SankeyDataNode } from "@/config/report-data"
import { translateSankeyLabel } from "@/lib/pt"

export const AuthMethodSankey = ({ data }: { data: SankeyDataNode[] }) => {
    const theme = useContext(ThemeProviderContext)
    const translatedData = data.map(item => ({
        ...item,
        source: translateSankeyLabel(item.source),
        target: translateSankeyLabel(item.target),
    }))

    return (
        <ZtResponsiveSankey
            isDark={(theme.theme === 'dark' || theme.theme === 'system' && window.matchMedia("(prefers-color-scheme: dark)").matches) ? true : false}
            data={{
                nodes: [
                    { id: "Usuários", nodeColor: "hsl(0, 0%, 17%)" },
                    { id: "Fator único", nodeColor: "hsl(0, 89%, 60%)" },
                    { id: "Suscetível a phishing", nodeColor: "hsl(25, 90%, 56%)" },
                    { id: "Telefone", nodeColor: "hsl(25, 90%, 56%)" },
                    { id: "Autenticador", nodeColor: "hsl(25, 90%, 56%)" },
                    { id: "Resistente a phishing", nodeColor: "hsl(142, 71%, 45%)" },
                    { id: "Chave de acesso", nodeColor: "hsl(142, 71%, 45%)" },
                    { id: "WHfB", nodeColor: "hsl(142, 71%, 45%)" },
                ],
                links: translatedData,
            }}
        />
    )
}
