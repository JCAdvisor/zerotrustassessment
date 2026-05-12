import { useMemo } from "react"
import Markdown from "react-markdown"
import remarkGfm from "remark-gfm"
import { BookOpen } from "lucide-react"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import {
    Accordion, AccordionContent, AccordionItem, AccordionTrigger,
} from "@/components/ui/accordion"
import { workshopData } from "@/config/workshop-data"
import type { WorkshopGuide, WorkshopPillar } from "@/config/workshop-data"
import type { Test } from "@/config/report-data"

const PILLAR_MAP: Partial<Record<string, WorkshopPillar>> = {
    Identity: "Identidade",
    Devices: "Dispositivos",
    Network: "Rede",
    Data: "Dados",
    Infrastructure: "Infraestrutura",
}

function scoreGuide(guide: WorkshopGuide, keywords: string[]): number {
    if (keywords.length === 0) return 0
    const text = (guide.title + " " + guide.filename).toLowerCase()
    return keywords.reduce((acc, kw) => acc + (text.includes(kw) ? 1 : 0), 0)
}

function findRelatedGuides(test: Test, limit = 5): WorkshopGuide[] {
    const workshopPillar = test.TestPillar ? PILLAR_MAP[test.TestPillar] : undefined
    if (!workshopPillar) return []

    const pillarGuides = workshopData.filter(g => g.pillar === workshopPillar)

    const keywords = (test.TestTitle + " " + (test.TestCategory ?? ""))
        .toLowerCase()
        .replace(/[^\w\s]/g, " ")
        .split(/\s+/)
        .filter(w => w.length > 3)

    if (keywords.length === 0) return pillarGuides.slice(0, limit)

    return pillarGuides
        .map(g => ({ guide: g, score: scoreGuide(g, keywords) }))
        .sort((a, b) => b.score - a.score || a.guide.filename.localeCompare(b.guide.filename))
        .slice(0, limit)
        .map(s => s.guide)
}

function EffortBadge({ effort }: { effort: string | null }) {
    if (!effort) return null
    if (effort === "Baixo")
        return <Badge className="bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-200 hover:bg-emerald-100 text-xs">Esf. Baixo</Badge>
    if (effort === "Alto")
        return <Badge className="bg-red-100 text-red-800 dark:bg-red-950 dark:text-red-300 border border-red-200 hover:bg-red-100 text-xs">Esf. Alto</Badge>
    return <Badge className="bg-orange-100 text-orange-800 dark:bg-orange-950 dark:text-orange-300 border border-orange-200 hover:bg-orange-100 text-xs">Esf. Médio</Badge>
}

function ImpactBadge({ impact }: { impact: string | null }) {
    if (!impact) return null
    if (impact === "Baixo")
        return <Badge className="bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300 border hover:bg-slate-100 text-xs">Imp. Baixo</Badge>
    if (impact === "Alto")
        return <Badge className="bg-purple-100 text-purple-800 dark:bg-purple-950 dark:text-purple-300 border border-purple-200 hover:bg-purple-100 text-xs">Imp. Alto</Badge>
    return <Badge className="bg-blue-100 text-blue-800 dark:bg-blue-950 dark:text-blue-300 border border-blue-200 hover:bg-blue-100 text-xs">Imp. Médio</Badge>
}

interface WorkshopGuidesPanelProps {
    test: Test
    maxGuides?: number
}

export function WorkshopGuidesPanel({ test, maxGuides = 5 }: WorkshopGuidesPanelProps) {
    const guides = useMemo(() => findRelatedGuides(test, maxGuides), [test, maxGuides])

    if (guides.length === 0) return null

    return (
        <Card>
            <CardHeader className="pb-3">
                <CardTitle className="flex items-center gap-2 text-base">
                    <BookOpen className="h-5 w-5 text-purple-600 dark:text-purple-400" />
                    Guias de Implementação
                </CardTitle>
                <p className="text-sm text-muted-foreground">
                    Walkthroughs Microsoft para este controle — clique para expandir.
                </p>
            </CardHeader>
            <CardContent className="pt-0">
                <Accordion type="single" collapsible className="w-full">
                    {guides.map(guide => (
                        <AccordionItem key={guide.filename} value={guide.filename} className="border rounded-lg mb-2 px-3 last:mb-0">
                            <AccordionTrigger className="hover:no-underline py-3 [&>svg]:ml-2 [&>svg]:shrink-0">
                                <div className="flex flex-col items-start gap-1 text-left min-w-0 mr-2">
                                    <span className="text-[10px] font-mono text-muted-foreground leading-none">{guide.filename}</span>
                                    <span className="text-sm font-medium leading-snug">{guide.title}</span>
                                    <div className="flex flex-wrap gap-1 mt-0.5">
                                        <EffortBadge effort={guide.effort} />
                                        <ImpactBadge impact={guide.impact} />
                                    </div>
                                </div>
                            </AccordionTrigger>
                            <AccordionContent className="pb-4">
                                <div className="border-t pt-3">
                                    <Markdown
                                        className="prose prose-sm dark:prose-invert max-w-none"
                                        remarkPlugins={[remarkGfm]}
                                    >
                                        {guide.content}
                                    </Markdown>
                                </div>
                            </AccordionContent>
                        </AccordionItem>
                    ))}
                </Accordion>
            </CardContent>
        </Card>
    )
}
