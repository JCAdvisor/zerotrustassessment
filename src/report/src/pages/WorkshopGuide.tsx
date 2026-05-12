import { useMemo, useState, useEffect } from "react"
import { PageHeader, PageHeaderHeading, PageHeaderDescription } from "@/components/page-header"
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card"
import { Badge } from "@/components/ui/badge"
import { Button } from "@/components/ui/button"
import { Input } from "@/components/ui/input"
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs"
import {
    Sheet, SheetContent, SheetHeader, SheetTitle
} from "@/components/ui/sheet"
import { workshopData } from "@/config/workshop-data"
import type { WorkshopGuide as GuideItem, WorkshopPillar } from "@/config/workshop-data"
import Markdown from "react-markdown"
import remarkGfm from "remark-gfm"
import { Search, BookOpen, ChevronDown } from "lucide-react"

const PILLAR_ORDER: WorkshopPillar[] = [
    'Identidade',
    'Dispositivos',
    'Rede',
    'Dados',
    'Infraestrutura',
    'DevSecOps',
    'Inteligência Artificial',
    'Operações de Segurança',
]

const PILLAR_SHORT: Record<WorkshopPillar, string> = {
    'Identidade': 'Identidade',
    'Dispositivos': 'Dispositivos',
    'Rede': 'Rede',
    'Dados': 'Dados',
    'Infraestrutura': 'Infra.',
    'DevSecOps': 'DevSecOps',
    'Inteligência Artificial': 'IA',
    'Operações de Segurança': 'Op. Seg.',
}

const PAGE_SIZE = 30

function EffortBadge({ effort }: { effort: string | null }) {
    if (!effort) return null
    if (effort === 'Baixo')
        return <Badge className="bg-emerald-100 text-emerald-800 dark:bg-emerald-950 dark:text-emerald-300 border border-emerald-200 hover:bg-emerald-100 text-xs">Baixo</Badge>
    if (effort === 'Alto')
        return <Badge className="bg-red-100 text-red-800 dark:bg-red-950 dark:text-red-300 border border-red-200 hover:bg-red-100 text-xs">Alto</Badge>
    return <Badge className="bg-orange-100 text-orange-800 dark:bg-orange-950 dark:text-orange-300 border border-orange-200 hover:bg-orange-100 text-xs">Médio</Badge>
}

function ImpactBadge({ impact }: { impact: string | null }) {
    if (!impact) return null
    if (impact === 'Baixo')
        return <Badge className="bg-slate-100 text-slate-700 dark:bg-slate-800 dark:text-slate-300 border hover:bg-slate-100 text-xs">Imp. Baixo</Badge>
    if (impact === 'Alto')
        return <Badge className="bg-purple-100 text-purple-800 dark:bg-purple-950 dark:text-purple-300 border border-purple-200 hover:bg-purple-100 text-xs">Imp. Alto</Badge>
    return <Badge className="bg-blue-100 text-blue-800 dark:bg-blue-950 dark:text-blue-300 border border-blue-200 hover:bg-blue-100 text-xs">Imp. Médio</Badge>
}

function FilterButton({
    label, active, onClick,
}: { label: string; active: boolean; onClick: () => void }) {
    return (
        <Button
            variant={active ? "default" : "outline"}
            size="sm"
            onClick={onClick}
            className={`text-xs h-7 px-3 rounded-full ${active ? 'bg-purple-600 hover:bg-purple-700 text-white' : 'hover:bg-purple-50 hover:text-purple-700 dark:hover:bg-purple-950 dark:hover:text-purple-300'}`}
        >
            {label}
        </Button>
    )
}

export default function WorkshopGuide() {
    const [activePillar, setActivePillar] = useState<WorkshopPillar>('Identidade')
    const [search, setSearch] = useState('')
    const [effortFilter, setEffortFilter] = useState('')
    const [impactFilter, setImpactFilter] = useState('')
    const [displayCount, setDisplayCount] = useState(PAGE_SIZE)
    const [selectedGuide, setSelectedGuide] = useState<GuideItem | null>(null)
    const [sheetOpen, setSheetOpen] = useState(false)

    const filtered = useMemo(() => {
        const q = search.toLowerCase()
        return workshopData.filter(g =>
            g.pillar === activePillar &&
            (q === '' || g.title.toLowerCase().includes(q) || g.filename.toLowerCase().includes(q)) &&
            (effortFilter === '' || g.effort === effortFilter) &&
            (impactFilter === '' || g.impact === impactFilter)
        )
    }, [activePillar, search, effortFilter, impactFilter])

    useEffect(() => {
        setDisplayCount(PAGE_SIZE)
    }, [activePillar, search, effortFilter, impactFilter])

    const visible = filtered.slice(0, displayCount)
    const pillarCount = (p: WorkshopPillar) => workshopData.filter(g => g.pillar === p).length

    return (
        <>
            <PageHeader>
                <div>
                    <PageHeaderHeading>Guia de Implementação</PageHeaderHeading>
                    <PageHeaderDescription>
                        Walkthroughs de implementação Zero Trust por pilar — referência Microsoft para cada controle.
                    </PageHeaderDescription>
                </div>
            </PageHeader>

            <Tabs
                value={activePillar}
                onValueChange={v => setActivePillar(v as WorkshopPillar)}
                className="w-full"
            >
                <TabsList className="flex flex-wrap h-auto gap-1 mb-4">
                    {PILLAR_ORDER.map(p => (
                        <TabsTrigger key={p} value={p} className="text-xs px-3">
                            {PILLAR_SHORT[p]}
                            <span className="ml-1.5 text-[10px] opacity-60">{pillarCount(p)}</span>
                        </TabsTrigger>
                    ))}
                </TabsList>

                {PILLAR_ORDER.map(p => (
                    <TabsContent key={p} value={p}>
                        {/* Filters */}
                        <div className="flex flex-wrap items-center gap-3 mb-4">
                            <div className="relative flex-1 min-w-[200px] max-w-sm">
                                <Search className="absolute left-2.5 top-2 h-4 w-4 text-muted-foreground" />
                                <Input
                                    placeholder="Buscar por título ou ID..."
                                    value={search}
                                    onChange={e => setSearch(e.target.value)}
                                    className="pl-8 h-8 text-sm"
                                />
                            </div>

                            <div className="flex items-center gap-1.5">
                                <span className="text-xs text-muted-foreground font-medium">Esforço:</span>
                                <FilterButton label="Baixo" active={effortFilter === 'Baixo'} onClick={() => setEffortFilter(f => f === 'Baixo' ? '' : 'Baixo')} />
                                <FilterButton label="Médio" active={effortFilter === 'Médio'} onClick={() => setEffortFilter(f => f === 'Médio' ? '' : 'Médio')} />
                                <FilterButton label="Alto" active={effortFilter === 'Alto'} onClick={() => setEffortFilter(f => f === 'Alto' ? '' : 'Alto')} />
                            </div>

                            <div className="flex items-center gap-1.5">
                                <span className="text-xs text-muted-foreground font-medium">Impacto:</span>
                                <FilterButton label="Baixo" active={impactFilter === 'Baixo'} onClick={() => setImpactFilter(f => f === 'Baixo' ? '' : 'Baixo')} />
                                <FilterButton label="Médio" active={impactFilter === 'Médio'} onClick={() => setImpactFilter(f => f === 'Médio' ? '' : 'Médio')} />
                                <FilterButton label="Alto" active={impactFilter === 'Alto'} onClick={() => setImpactFilter(f => f === 'Alto' ? '' : 'Alto')} />
                            </div>

                            <span className="text-xs text-muted-foreground ml-auto">
                                {filtered.length === workshopData.filter(g => g.pillar === p).length
                                    ? `${filtered.length} guias`
                                    : `${filtered.length} de ${workshopData.filter(g => g.pillar === p).length} guias`}
                            </span>
                        </div>

                        {/* Card grid */}
                        {visible.length === 0 ? (
                            <div className="flex flex-col items-center justify-center py-16 text-muted-foreground gap-2">
                                <BookOpen className="h-8 w-8 opacity-30" />
                                <span className="text-sm">Nenhum guia encontrado para os filtros selecionados.</span>
                            </div>
                        ) : (
                            <>
                                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                                    {visible.map(guide => (
                                        <Card
                                            key={guide.filename}
                                            className="cursor-pointer hover:border-purple-300 hover:shadow-sm transition-all dark:hover:border-purple-700"
                                            onClick={() => { setSelectedGuide(guide); setSheetOpen(true) }}
                                        >
                                            <CardHeader className="pb-2 pt-4 px-4">
                                                <div className="text-[10px] font-mono text-muted-foreground mb-1">{guide.filename}</div>
                                                <CardTitle className="text-sm font-medium leading-snug line-clamp-3">
                                                    {guide.title}
                                                </CardTitle>
                                            </CardHeader>
                                            <CardContent className="px-4 pb-4">
                                                <div className="flex flex-wrap gap-1.5 mt-1">
                                                    {guide.effort && (
                                                        <div className="flex items-center gap-1">
                                                            <span className="text-[10px] text-muted-foreground">Esf.:</span>
                                                            <EffortBadge effort={guide.effort} />
                                                        </div>
                                                    )}
                                                    {guide.impact && (
                                                        <ImpactBadge impact={guide.impact} />
                                                    )}
                                                </div>
                                            </CardContent>
                                        </Card>
                                    ))}
                                </div>

                                {displayCount < filtered.length && (
                                    <div className="flex justify-center mt-6">
                                        <Button
                                            variant="outline"
                                            onClick={() => setDisplayCount(c => c + PAGE_SIZE)}
                                            className="gap-2"
                                        >
                                            <ChevronDown className="h-4 w-4" />
                                            Exibir mais ({Math.min(PAGE_SIZE, filtered.length - displayCount)} de {filtered.length - displayCount} restantes)
                                        </Button>
                                    </div>
                                )}
                            </>
                        )}
                    </TabsContent>
                ))}
            </Tabs>

            {/* Detail Sheet */}
            <Sheet open={sheetOpen} onOpenChange={setSheetOpen}>
                <SheetContent side="right" className="md:min-w-[700px] lg:min-w-[900px] overflow-y-auto">
                    {selectedGuide && (
                        <>
                            <SheetHeader>
                                <div className="text-xs font-mono text-muted-foreground mb-1">{selectedGuide.filename}</div>
                                <SheetTitle className="text-xl text-left leading-snug">{selectedGuide.title}</SheetTitle>
                            </SheetHeader>

                            <div className="flex flex-wrap gap-2 mt-4 mb-6">
                                {selectedGuide.effort && (
                                    <div className="flex items-center gap-1.5 text-sm">
                                        <span className="text-muted-foreground font-medium">Esforço de implementação:</span>
                                        <EffortBadge effort={selectedGuide.effort} />
                                    </div>
                                )}
                                {selectedGuide.impact && (
                                    <div className="flex items-center gap-1.5 text-sm">
                                        <span className="text-muted-foreground font-medium">Impacto ao usuário:</span>
                                        <ImpactBadge impact={selectedGuide.impact} />
                                    </div>
                                )}
                            </div>

                            <div className="prose dark:prose-invert max-w-none">
                                <Markdown remarkPlugins={[remarkGfm]}>
                                    {selectedGuide.content}
                                </Markdown>
                            </div>
                        </>
                    )}
                </SheetContent>
            </Sheet>
        </>
    )
}
