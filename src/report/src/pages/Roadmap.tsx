import { useMemo, useState } from "react"
import { Fragment } from "react"
import { PageHeader, PageHeaderHeading, PageHeaderDescription } from "@/components/page-header"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { reportData, Test } from "@/config/report-data"
import {
    Table, TableBody, TableCell, TableHead, TableHeader, TableRow
} from "@/components/ui/table"
import {
    Sheet, SheetContent, SheetHeader, SheetTitle
} from "@/components/ui/sheet"
import Markdown from "react-markdown"
import remarkGfm from "remark-gfm"
import { AlertTriangle, Settings, Users, Zap, TrendingUp, Target, Clock, BarChart3 } from "lucide-react"
import { StatusIcon } from "@/components/status-icon"
import { translateText } from "@/lib/pt"
import { WorkshopGuidesPanel } from "@/components/workshop-guides-panel"

const riskValue = { High: 3, Medium: 2, Low: 1 } as const
const effortValue = { Low: 3, Medium: 2, High: 1 } as const

function calcScore(test: Test): number {
    const r = riskValue[test.TestRisk as keyof typeof riskValue] ?? 1
    const e = effortValue[test.TestImplementationCost as keyof typeof effortValue] ?? 1
    return r + e
}

function assignPhase(s: number): 1 | 2 | 3 | 4 {
    if (s >= 5) return 1
    if (s === 4) return 2
    if (s === 3) return 3
    return 4
}

const phaseConfig = {
    1: {
        title: "Fase 1 — Quick Wins",
        desc: "Alto risco + Baixo esforço. Máxima relação custo-benefício. Implemente imediatamente.",
        Icon: Zap,
        color: "text-emerald-600",
        bg: "bg-emerald-50 dark:bg-emerald-950/30",
        border: "border-l-emerald-500",
    },
    2: {
        title: "Fase 2 — Alta Prioridade",
        desc: "Itens críticos que exigem planejamento e esforço moderado.",
        Icon: TrendingUp,
        color: "text-orange-500",
        bg: "bg-orange-50 dark:bg-orange-950/30",
        border: "border-l-orange-400",
    },
    3: {
        title: "Fase 3 — Planejado",
        desc: "Risco médio ou complexidade maior. Incorporar no planejamento de médio prazo.",
        Icon: Target,
        color: "text-blue-500",
        bg: "bg-blue-50 dark:bg-blue-950/30",
        border: "border-l-blue-400",
    },
    4: {
        title: "Fase 4 — Longo Prazo",
        desc: "Baixo risco ou alto esforço. Melhorias contínuas para o futuro.",
        Icon: Clock,
        color: "text-slate-500",
        bg: "bg-slate-50 dark:bg-slate-950/30",
        border: "border-l-slate-400",
    },
} as const

// Maps (Risk_Effort) → Phase based on score
const matrixPhase: Record<string, 1 | 2 | 3 | 4> = {
    High_Low: 1, High_Medium: 1, High_High: 2,
    Medium_Low: 1, Medium_Medium: 2, Medium_High: 3,
    Low_Low: 2, Low_Medium: 3, Low_High: 4,
}

const matrixBg: Record<1 | 2 | 3 | 4, string> = {
    1: "bg-emerald-100 dark:bg-emerald-950/60 border-emerald-300 dark:border-emerald-700",
    2: "bg-orange-100 dark:bg-orange-950/60 border-orange-300 dark:border-orange-700",
    3: "bg-blue-100 dark:bg-blue-950/60 border-blue-300 dark:border-blue-700",
    4: "bg-slate-100 dark:bg-slate-800/60 border-slate-300 dark:border-slate-600",
}

const matrixLabel: Record<1 | 2 | 3 | 4, string> = {
    1: "Quick Win", 2: "Alta Prior.", 3: "Planejado", 4: "Longo Prazo",
}

function RiskBadge({ risk }: { risk: string }) {
    if (risk === "High") return <Badge className="bg-red-100 text-red-800 dark:bg-red-950 dark:text-red-300 border border-red-200 hover:bg-red-100">Alto</Badge>
    if (risk === "Medium") return <Badge className="bg-orange-100 text-orange-800 dark:bg-orange-950 dark:text-orange-300 border border-orange-200 hover:bg-orange-100">Médio</Badge>
    return <Badge className="bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300 border hover:bg-slate-100">Baixo</Badge>
}

function EffortBadge({ effort }: { effort: string }) {
    if (effort === "Low") return <Badge className="bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-200 hover:bg-emerald-100">Baixo</Badge>
    if (effort === "High") return <Badge className="bg-red-100 text-red-800 dark:bg-red-950 dark:text-red-300 border border-red-200 hover:bg-red-100">Alto</Badge>
    return <Badge className="bg-orange-100 text-orange-800 dark:bg-orange-950 dark:text-orange-300 border border-orange-200 hover:bg-orange-100">Médio</Badge>
}

function PillarBadge({ pillar }: { pillar: string | null }) {
    if (!pillar) return null
    const labels: Record<string, string> = {
        Identity: "Identidade",
        Devices: "Dispositivos",
        Network: "Rede",
        Data: "Dados",
    }
    const colors: Record<string, string> = {
        Identity: "bg-purple-100 text-purple-800 dark:bg-purple-950 dark:text-purple-300 border-purple-200",
        Devices: "bg-blue-100 text-blue-800 dark:bg-blue-950 dark:text-blue-300 border-blue-200",
        Network: "bg-teal-100 text-teal-800 dark:bg-teal-950 dark:text-teal-300 border-teal-200",
        Data: "bg-amber-100 text-amber-800 dark:bg-amber-950 dark:text-amber-300 border-amber-200",
    }
    return (
        <Badge className={`border ${colors[pillar] ?? "bg-slate-100 text-slate-700"} hover:opacity-90`}>
            {labels[pillar] ?? pillar}
        </Badge>
    )
}

export default function Roadmap() {
    const [selectedTest, setSelectedTest] = useState<Test | null>(null)
    const [sheetOpen, setSheetOpen] = useState(false)

    const failedTests = useMemo(() =>
        reportData.Tests.filter(t => t.TestStatus === "Failed" || t.TestStatus === "Investigate"),
        []
    )

    const { phaseGroups, matrixCounts } = useMemo(() => {
        const groups: Record<1 | 2 | 3 | 4, Test[]> = { 1: [], 2: [], 3: [], 4: [] }
        const counts: Record<string, number> = {}

        for (const test of failedTests) {
            const s = calcScore(test)
            const p = assignPhase(s)
            groups[p].push(test)

            const key = `${test.TestRisk}_${test.TestImplementationCost}`
            counts[key] = (counts[key] ?? 0) + 1
        }

        for (const p of [1, 2, 3, 4] as const) {
            groups[p].sort((a, b) =>
                calcScore(b) - calcScore(a) ||
                (riskValue[b.TestRisk as keyof typeof riskValue] ?? 1) -
                (riskValue[a.TestRisk as keyof typeof riskValue] ?? 1)
            )
        }

        return { phaseGroups: groups, matrixCounts: counts }
    }, [failedTests])

    const quickWinsCount = phaseGroups[1].length
    const highRiskCount = failedTests.filter(t => t.TestRisk === "High").length
    const lowEffortCount = failedTests.filter(t => t.TestImplementationCost === "Low").length

    const risks = ["High", "Medium", "Low"] as const
    const efforts = ["Low", "Medium", "High"] as const

    return (
        <>
            <PageHeader>
                <div>
                    <PageHeaderHeading>Roadmap de Correções</PageHeaderHeading>
                    <PageHeaderDescription>
                        Plano de execução priorizado por quick wins — menor esforço com maior impacto primeiro.
                    </PageHeaderDescription>
                </div>
            </PageHeader>

            {/* KPI Cards */}
            <div className="grid grid-cols-2 lg:grid-cols-4 gap-4 mb-6">
                <Card>
                    <CardHeader className="pb-2">
                        <CardTitle className="text-sm font-medium text-muted-foreground">Total a corrigir</CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold">{failedTests.length}</div>
                        <p className="text-xs text-muted-foreground mt-1">falhas e itens a investigar</p>
                    </CardContent>
                </Card>

                <Card className="border-emerald-200 dark:border-emerald-800">
                    <CardHeader className="pb-2">
                        <CardTitle className="text-sm font-medium text-emerald-600 flex items-center gap-1">
                            <Zap className="h-4 w-4" /> Quick Wins
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-emerald-600">{quickWinsCount}</div>
                        <p className="text-xs text-muted-foreground mt-1">baixo esforço + alto impacto</p>
                    </CardContent>
                </Card>

                <Card className="border-red-200 dark:border-red-900">
                    <CardHeader className="pb-2">
                        <CardTitle className="text-sm font-medium text-red-600 flex items-center gap-1">
                            <AlertTriangle className="h-4 w-4" /> Risco Alto
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-red-600">{highRiskCount}</div>
                        <p className="text-xs text-muted-foreground mt-1">falhas de risco elevado</p>
                    </CardContent>
                </Card>

                <Card className="border-blue-200 dark:border-blue-900">
                    <CardHeader className="pb-2">
                        <CardTitle className="text-sm font-medium text-blue-500 flex items-center gap-1">
                            <BarChart3 className="h-4 w-4" /> Baixo Esforço
                        </CardTitle>
                    </CardHeader>
                    <CardContent>
                        <div className="text-3xl font-bold text-blue-500">{lowEffortCount}</div>
                        <p className="text-xs text-muted-foreground mt-1">implementação simplificada</p>
                    </CardContent>
                </Card>
            </div>

            {/* Risk × Effort Matrix */}
            <Card className="mb-6">
                <CardHeader>
                    <CardTitle className="flex items-center gap-2 text-base">
                        <BarChart3 className="h-5 w-5" />
                        Matriz Risco × Esforço
                    </CardTitle>
                </CardHeader>
                <CardContent>
                    <div className="grid grid-cols-[auto_1fr_1fr_1fr] gap-2 text-xs max-w-xl">
                        <div />
                        {efforts.map(e => (
                            <div key={e} className="text-center font-semibold text-muted-foreground py-1">
                                Esforço {translateText(e)}
                            </div>
                        ))}
                        {risks.map(risk => (
                            <Fragment key={risk}>
                                <div className="flex items-center font-semibold text-muted-foreground pr-3 text-right text-xs whitespace-nowrap">
                                    Risco {translateText(risk)}
                                </div>
                                {efforts.map(effort => {
                                    const key = `${risk}_${effort}`
                                    const p = matrixPhase[key]
                                    const count = matrixCounts[key] ?? 0
                                    return (
                                        <div
                                            key={key}
                                            className={`rounded-lg border p-3 text-center flex flex-col items-center justify-center gap-1 min-h-[72px] ${matrixBg[p]}`}
                                        >
                                            <span className="text-2xl font-bold">{count}</span>
                                            <span className="text-[10px] font-medium opacity-60 leading-tight">{matrixLabel[p]}</span>
                                        </div>
                                    )
                                })}
                            </Fragment>
                        ))}
                    </div>
                    <div className="flex gap-4 mt-4 text-xs text-muted-foreground flex-wrap">
                        <div className="flex items-center gap-1.5">
                            <span className="w-3 h-3 rounded bg-emerald-300 dark:bg-emerald-800 inline-block" />
                            <span>Quick Win (Fase 1)</span>
                        </div>
                        <div className="flex items-center gap-1.5">
                            <span className="w-3 h-3 rounded bg-orange-300 dark:bg-orange-800 inline-block" />
                            <span>Alta Prioridade (Fase 2)</span>
                        </div>
                        <div className="flex items-center gap-1.5">
                            <span className="w-3 h-3 rounded bg-blue-300 dark:bg-blue-800 inline-block" />
                            <span>Planejado (Fase 3)</span>
                        </div>
                        <div className="flex items-center gap-1.5">
                            <span className="w-3 h-3 rounded bg-slate-300 dark:bg-slate-600 inline-block" />
                            <span>Longo Prazo (Fase 4)</span>
                        </div>
                    </div>
                </CardContent>
            </Card>

            {/* Phase Tables */}
            {([1, 2, 3, 4] as const).map(p => {
                const cfg = phaseConfig[p]
                const tests = phaseGroups[p]
                if (tests.length === 0) return null

                return (
                    <Card key={p} className={`mb-6 border-l-4 ${cfg.border}`}>
                        <CardHeader className={`${cfg.bg} rounded-t-lg pb-3`}>
                            <CardTitle className={`flex items-center gap-2 ${cfg.color}`}>
                                <cfg.Icon className="h-5 w-5" />
                                {cfg.title}
                                <Badge variant="secondary" className="ml-1">{tests.length}</Badge>
                            </CardTitle>
                            <p className="text-sm text-muted-foreground">{cfg.desc}</p>
                        </CardHeader>
                        <CardContent className="p-0">
                            <Table>
                                <TableHeader>
                                    <TableRow>
                                        <TableHead className="w-[45%]">Título</TableHead>
                                        <TableHead>Pilar</TableHead>
                                        <TableHead>Risco</TableHead>
                                        <TableHead>Esforço</TableHead>
                                        <TableHead>Licença mínima</TableHead>
                                    </TableRow>
                                </TableHeader>
                                <TableBody>
                                    {tests.map(test => (
                                        <TableRow
                                            key={test.TestId}
                                            className="cursor-pointer hover:bg-muted/50"
                                            onClick={() => { setSelectedTest(test); setSheetOpen(true) }}
                                        >
                                            <TableCell className="font-medium">{test.TestTitle}</TableCell>
                                            <TableCell><PillarBadge pillar={test.TestPillar} /></TableCell>
                                            <TableCell><RiskBadge risk={test.TestRisk} /></TableCell>
                                            <TableCell><EffortBadge effort={test.TestImplementationCost} /></TableCell>
                                            <TableCell className="text-xs text-muted-foreground">
                                                {Array.isArray(test.TestMinimumLicense)
                                                    ? test.TestMinimumLicense.join(", ")
                                                    : (test.TestMinimumLicense ?? "—")}
                                            </TableCell>
                                        </TableRow>
                                    ))}
                                </TableBody>
                            </Table>
                        </CardContent>
                    </Card>
                )
            })}

            {/* Detail Sheet */}
            <Sheet open={sheetOpen} onOpenChange={setSheetOpen}>
                <SheetContent side="right" className="md:min-w-[700px] lg:min-w-[900px] overflow-y-auto">
                    <SheetHeader>
                        <SheetTitle className="text-2xl text-left">{selectedTest?.TestTitle}</SheetTitle>
                    </SheetHeader>
                    {selectedTest && (
                        <div className="grid pt-6 gap-6">
                            <Card>
                                <CardContent className="pt-4">
                                    <div className="flex flex-wrap gap-6 text-sm">
                                        <div className="flex items-center gap-2">
                                            <AlertTriangle className="h-4 w-4 text-muted-foreground" />
                                            <span className="font-semibold">Risco:</span>
                                            <RiskBadge risk={selectedTest.TestRisk} />
                                        </div>
                                        <div className="flex items-center gap-2">
                                            <Settings className="h-4 w-4 text-muted-foreground" />
                                            <span className="font-semibold">Esforço:</span>
                                            <EffortBadge effort={selectedTest.TestImplementationCost} />
                                        </div>
                                        <div className="flex items-center gap-2">
                                            <Users className="h-4 w-4 text-muted-foreground" />
                                            <span className="font-semibold">Impacto ao usuário:</span>
                                            <span>{translateText(selectedTest.TestImpact)}</span>
                                        </div>
                                    </div>
                                </CardContent>
                            </Card>

                            <Card>
                                <CardHeader>
                                    <CardTitle className="flex items-center gap-2">
                                        <span>Resultado do teste</span>
                                        <StatusIcon Item={selectedTest} />
                                    </CardTitle>
                                </CardHeader>
                                <CardContent>
                                    <Markdown className="prose max-w-fit dark:prose-invert" remarkPlugins={[remarkGfm]}>
                                        {selectedTest.TestResult}
                                    </Markdown>
                                </CardContent>
                            </Card>

                            <Card>
                                <CardHeader><CardTitle>O que foi verificado</CardTitle></CardHeader>
                                <CardContent>
                                    <Markdown className="prose max-w-fit dark:prose-invert" remarkPlugins={[remarkGfm]}>
                                        {selectedTest.TestDescription}
                                    </Markdown>
                                </CardContent>
                            </Card>

                            <WorkshopGuidesPanel test={selectedTest} />
                        </div>
                    )}
                </SheetContent>
            </Sheet>
        </>
    )
}
