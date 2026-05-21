import * as React from "react"

import {
    ColumnDef,
    ColumnFiltersState,
    SortingState,
    VisibilityState,
    flexRender,
    getCoreRowModel,
    getFilteredRowModel,
    getSortedRowModel,
    useReactTable,
} from "@tanstack/react-table"

import {
    Table,
    TableBody,
    TableCell,
    TableHead,
    TableHeader,
    TableRow,
} from "@/components/ui/table"

import Markdown from 'react-markdown'
import remarkGfm from 'remark-gfm'
import { AlertTriangle, Settings, Users, Shield, Eye, Wrench, Lock, Building, Zap, Columns } from "lucide-react"
import { translateSfiPillar, translateStatusLabel } from "@/lib/pt"

import { Button } from "@/components/ui/button"
import {
    DropdownMenu,
    DropdownMenuCheckboxItem,
    DropdownMenuContent,
    DropdownMenuTrigger,
} from "@/components/ui/dropdown-menu"
import { Input } from "@/components/ui/input"

interface DataTableProps<TData extends Test, TValue> {
    columns: ColumnDef<TData, TValue>[]
    data: TData[]
    pillar?: string
    isOverview?: boolean
}

import {
    Sheet,
    SheetContent,
    SheetHeader,
    SheetTitle,
} from "@/components/ui/sheet"
import { Test } from "@/config/report-data"
import { Card, CardContent, CardHeader, CardTitle } from "../ui/card"
import { StatusIcon } from "../status-icon"
// import { WorkshopGuidesPanel } from "@/components/workshop-guides-panel"

export function DataTable<TData extends Test, TValue>({
    columns,
    data,
    pillar,
    isOverview = false,
}: DataTableProps<TData, TValue>) {
    // Function to get icon for SFI pillar
    const getSfiPillarIcon = (pillar: string) => {
        if (pillar.includes("Monitorar e detectar ciberameaças")) return Eye;
        if (pillar.includes("Proteger sistemas de engenharia")) return Wrench;
        if (pillar.includes("Proteger identidades e segredos")) return Lock;
        if (pillar.includes("Proteger tenants e sistemas em produção") || pillar.includes("Proteger locatários e isolar sistemas de produção")) return Building;
        if (pillar.includes("Acelerar resposta e remediação")) return Zap;
        if (pillar.includes("Proteger redes")) return Shield;
        return Shield;
    };

    // SFI Pillar descriptions and benefits dictionaries
    const sfiPillarDescriptionDict: {[key: string]: string} = {
        "Proteger identidades e segredos": "Garante que identidades humanas e de máquinas sejam criadas, gerenciadas e protegidas ao longo de todo o ciclo de vida, usando autenticação forte, acesso condicional, MFA resistente a phishing e gerenciamento seguro de credenciais e segredos.",
        "Proteger locatários e isolar sistemas de produção": "Assegura que os locatários do Microsoft 365 e Entra ID estejam configurados com isolamento adequado, governança centralizada, controles de acesso de emergência e separação entre ambientes de produção e não produção.",
        "Proteger tenants e sistemas em produção": "Assegura que os locatários do Microsoft 365 e Entra ID estejam configurados com isolamento adequado, governança centralizada, controles de acesso de emergência e separação entre ambientes de produção e não produção.",
        "Proteger redes": "Aplica segmentação de rede, controle de tráfego, proteção contra exfiltração de dados e políticas de acesso baseadas em identidade para garantir que apenas comunicações autorizadas fluam entre recursos corporativos e externos.",
        "Proteger sistemas de engenharia": "Protege os sistemas, ferramentas e pipelines usados no desenvolvimento e operação de software, garantindo que o acesso seja controlado, o código seja auditado e as dependências sejam verificadas para prevenir comprometimentos na cadeia de suprimento.",
        "Monitorar e detectar ciberameaças": "Implementa visibilidade contínua sobre o ambiente por meio de logs de auditoria, alertas, SIEM e análise comportamental para identificar atividades suspeitas, anomalias e ameaças antes que causem impacto significativo.",
        "Acelerar resposta e remediação": "Reduz o tempo de detecção e resposta a incidentes por meio de automação, playbooks, integração entre ferramentas de segurança e processos bem definidos de contenção, erradicação e recuperação.",
    };

    const sfiPillarBenefitsDict: {[key: string]: string} = {
        "Proteger identidades e segredos": "Reduz o risco de comprometimento de contas ao exigir autenticação forte e eliminar credenciais fracas. Melhora a conformidade com LGPD e ISO 27001 ao garantir rastreabilidade e controle sobre quem acessa o quê e quando.",
        "Proteger locatários e isolar sistemas de produção": "Evita movimentação lateral entre ambientes e limita o impacto de comprometimentos. Garante que alterações em produção sejam controladas e auditadas, reduzindo riscos de configurações incorretas e acessos não autorizados.",
        "Proteger tenants e sistemas em produção": "Evita movimentação lateral entre ambientes e limita o impacto de comprometimentos. Garante que alterações em produção sejam controladas e auditadas, reduzindo riscos de configurações incorretas e acessos não autorizados.",
        "Proteger redes": "Limita a superfície de ataque reduzindo comunicações desnecessárias entre sistemas. Protege dados em trânsito e previne exfiltração, contribuindo para conformidade regulatória e resiliência operacional.",
        "Proteger sistemas de engenharia": "Previne a introdução de vulnerabilidades por meio de ferramentas ou dependências comprometidas. Garante integridade do código e rastreabilidade das mudanças, reduzindo riscos associados a ataques à cadeia de suprimento de software.",
        "Monitorar e detectar ciberameaças": "Permite identificação precoce de ameaças, reduzindo o tempo de permanência de atacantes no ambiente. Apoia investigações forenses, conformidade regulatória e melhora contínua da postura de segurança com base em dados reais.",
        "Acelerar resposta e remediação": "Reduz o impacto de incidentes ao diminuir o tempo entre detecção e contenção. Automatiza ações repetitivas, libera analistas para tarefas de maior valor e melhora a resiliência organizacional diante de ameaças persistentes.",
    };

    // Organize data by SFI pillar for overview mode
    const overviewData = React.useMemo(() => {
        const result: { [key: string]: TData[] } = {};
        data.forEach((test: TData) => {
            const sfiPillar = (test as any).TestSfiPillar;
            if (sfiPillar) {
                if (!result[sfiPillar]) {
                    result[sfiPillar] = [];
                }
                result[sfiPillar].push(test);
            }
        });
        return result;
    }, [data]);

    // Early return for overview mode rendering
    if (isOverview) {
        return (
            <div className="rounded-md border">
                <Table>
                    <TableHeader>
                        <TableRow>
                            <TableHead>Pilar SFI</TableHead>
                            <TableHead>Descrição</TableHead>
                            <TableHead>Total</TableHead>
                            <TableHead>Falhas</TableHead>
                            <TableHead>Benefícios</TableHead>
                        </TableRow>
                    </TableHeader>
                    <TableBody>
                        {Object.entries(overviewData).map(([sfiPillar, tests]: [string, TData[]]) => {
                            const failedCount = tests.filter(
                                (test: TData) => (test as any).TestStatus === "Failed"
                            ).length;
                            const PillarIcon = getSfiPillarIcon(sfiPillar);

                            return (
                                <TableRow key={sfiPillar}>
                                    <TableCell className="font-medium">
                                        <div className="flex items-center gap-2">
                                            <PillarIcon className="h-4 w-4 flex-shrink-0 text-muted-foreground" />
                                            <span>{sfiPillar}</span>
                                        </div>
                                    </TableCell>
                                    <TableCell className="max-w-xs">
                                        <p className="text-sm text-muted-foreground">
                                            {sfiPillarDescriptionDict[sfiPillar] || "Descrição não disponível"}
                                        </p>
                                    </TableCell>
                                    <TableCell className="text-center">{tests.length}</TableCell>
                                    <TableCell className="text-center">
                                        <span className="text-red-600 font-semibold">
                                            {failedCount}
                                        </span>
                                    </TableCell>
                                    <TableCell>
                                        <p className="text-sm">
                                            {sfiPillarBenefitsDict[sfiPillar] || "Benefícios não disponíveis"}
                                        </p>
                                    </TableCell>
                                </TableRow>
                            );
                        })}
                    </TableBody>
                </Table>
            </div>
        );
    }

    const [sorting, setSorting] = React.useState<SortingState>(
        pillar === "Devices"
            ? [
                { id: "TestCategory", desc: false },
                { id: "TestStatus", desc: false },
                { id: "TestTitle", desc: false }
              ]
            : []
    )
    const [columnFilters, setColumnFilters] = React.useState<ColumnFiltersState>([])
    const [globalFilter, setGlobalFilter] = React.useState("");
    const [selectedSfiPillars, setSelectedSfiPillars] = React.useState<string[]>([]);
    const [selectedRisks, setSelectedRisks] = React.useState<string[]>([]);
    const [selectedStatuses, setSelectedStatuses] = React.useState<string[]>([]);
    const [columnVisibility, setColumnVisibility] = React.useState<VisibilityState>({
        // Hide TestImpact by default
        TestImpact: false,
        TestImplementationCost: false,
        // Hide TestId by default
        TestId: false,
        // Hide TestSfiPillar by default since we have toggle filters
        TestSfiPillar: false,
        // Hide TestMinimumLicense by default
        TestMinimumLicense: false,
        // Category visible for Devices, hidden for Identity
        TestCategory: pillar === "Devices" ? true : false,
        // Optionally specify other columns here (true => visible, false => hidden)
        // TestRisk: true,
        // TestStatus: true,
    })
    const [rowSelection, setRowSelection] = React.useState({})

    // First filter by pillar if specified (for unique value calculations)
    const pillarFilteredData = React.useMemo(() => {
        if (pillar) {
            return data.filter(item =>
                item.TestPillar === pillar
            );
        }
        return data;
    }, [data, pillar]);

    // Filter the data by pillar, selected SFI pillars, risks, and statuses if any are selected
    const filteredData = React.useMemo(() => {
        let result = pillarFilteredData;

        // Filter by SFI pillars if any are selected
        if (selectedSfiPillars.length > 0) {
            result = result.filter(item =>
                item.TestSfiPillar && selectedSfiPillars.includes(item.TestSfiPillar)
            );
        }

        // Filter by risks if any are selected
        if (selectedRisks.length > 0) {
            result = result.filter(item =>
                item.TestRisk && selectedRisks.includes(item.TestRisk)
            );
        }

        // Filter by statuses if any are selected
        if (selectedStatuses.length > 0) {
            result = result.filter(item =>
                item.TestStatus && selectedStatuses.includes(item.TestStatus)
            );
        } else {
            // If no status filters are selected, exclude "Planned" items by default
            result = result.filter(item => item.TestStatus !== "Planned");
        }

        return result;
    }, [pillarFilteredData, selectedSfiPillars, selectedRisks, selectedStatuses]);

    // Get unique SFI pillars for the filter dropdown
    const uniqueSfiPillars = React.useMemo(() => {
        const pillars = pillarFilteredData
            .map(item => item.TestSfiPillar)
            .filter((pillar): pillar is string => pillar !== null && pillar !== undefined);
        return Array.from(new Set(pillars)).sort();
    }, [pillarFilteredData]);

    // Get unique risks for the filter toggles
    const uniqueRisks = React.useMemo(() => {
        const risks = pillarFilteredData
            .map(item => item.TestRisk)
            .filter((risk): risk is string => risk !== null && risk !== undefined);
        const uniqueRiskSet = Array.from(new Set(risks));
        // Custom order: High, Medium, Low
        const riskOrder = ['High', 'Medium', 'Low'];
        return uniqueRiskSet.sort((a, b) => {
            const indexA = riskOrder.indexOf(a);
            const indexB = riskOrder.indexOf(b);
            // If both are in the custom order, sort by that order
            if (indexA !== -1 && indexB !== -1) return indexA - indexB;
            // If only one is in the custom order, prioritize it
            if (indexA !== -1) return -1;
            if (indexB !== -1) return 1;
            // If neither is in the custom order, sort alphabetically
            return a.localeCompare(b);
        });
    }, [pillarFilteredData]);

    // Get unique statuses for the filter toggles
    const uniqueStatuses = React.useMemo(() => {
        const statuses = pillarFilteredData
            .map(item => item.TestStatus)
            .filter((status): status is string => status !== null && status !== undefined);
        const uniqueStatusSet = Array.from(new Set(statuses));
        // Custom order: Passed, Failed, Planned
        const statusOrder = ['Passed', 'Failed', 'Planned'];
        return uniqueStatusSet.sort((a, b) => {
            const indexA = statusOrder.indexOf(a);
            const indexB = statusOrder.indexOf(b);
            // If both are in the custom order, sort by that order
            if (indexA !== -1 && indexB !== -1) return indexA - indexB;
            // If only one is in the custom order, prioritize it
            if (indexA !== -1) return -1;
            if (indexB !== -1) return 1;
            // If neither is in the custom order, sort alphabetically
            return a.localeCompare(b);
        });
    }, [pillarFilteredData]);

    const table = useReactTable({
        data: filteredData,
        columns,
        enableRowSelection: true,
        getCoreRowModel: getCoreRowModel(),
        onSortingChange: setSorting,
        getSortedRowModel: getSortedRowModel(),
        onGlobalFilterChange: setGlobalFilter,
        onColumnFiltersChange: setColumnFilters,
        getFilteredRowModel: getFilteredRowModel(),
        onColumnVisibilityChange: setColumnVisibility,
        onRowSelectionChange: stateUpdater => {
            setRowSelection({}); // <-- First reset the current selection
            setRowSelection(stateUpdater);
        },

        state: {
            sorting,
            columnFilters,
            globalFilter,
            columnVisibility,
            rowSelection,
        },
    })

    const [sheetOpen, setSheetOpen] = React.useState(false);
    const [selectedRow, setSelectedRow] = React.useState<Test | null>(null);

    return (

        <div>
            {!isOverview && (
            <div className="flex items-center py-4 justify-between">
                <div className="flex items-center gap-4">
                    <Input
                        placeholder="Buscar por nome..."
                        value={globalFilter ?? ''}
                        onChange={(e) => table.setGlobalFilter(String(e.target.value))}
                        className="max-w-sm"
                    />

                    {/* Risk Filter Toggles */}
                    <div className="flex items-center gap-1">
                        <span className="text-xs font-medium text-muted-foreground mr-1">Risco:</span>
                        {uniqueRisks.map((risk) => {
                            const isSelected = selectedRisks.includes(risk);
                            const riskCount = data.filter(item => item.TestRisk === risk).length;
                            return (
                                <Button
                                    key={risk}
                                    variant={isSelected ? "default" : "outline"}
                                    size="sm"
                                    onClick={() => {
                                        if (isSelected) {
                                            setSelectedRisks(prev => prev.filter(r => r !== risk));
                                        } else {
                                            setSelectedRisks(prev => [...prev, risk]);
                                        }
                                    }}
                                    className={`text-xs h-6 px-3 py-1 rounded-full ${isSelected ? 'bg-purple-600 hover:bg-purple-700 text-white' : 'hover:bg-purple-50 hover:text-purple-700 hover:border-purple-300 dark:hover:bg-purple-950 dark:hover:text-purple-300'}`}
                                    title={`${translateStatusLabel(risk)} (${riskCount} testes)`}
                                >
                                    {translateStatusLabel(risk)}
                                </Button>
                            );
                        })}
                    </div>

                    {/* Status Filter Toggles */}
                    <div className="flex items-center gap-1">
                        <span className="text-xs font-medium text-muted-foreground mr-1">Status:</span>
                        {uniqueStatuses.map((status) => {
                            const isSelected = selectedStatuses.includes(status);
                            const statusCount = data.filter(item => item.TestStatus === status).length;

                            // Get color classes based on status type
                            const getStatusColors = (status: string, isSelected: boolean) => {
                                if (status === 'Passed') {
                                    return isSelected
                                        ? 'bg-purple-600 hover:bg-purple-700 text-white'
                                        : 'hover:bg-purple-50 hover:text-purple-700 hover:border-purple-300 dark:hover:bg-purple-950 dark:hover:text-purple-300';
                                } else if (status === 'Failed') {
                                    return isSelected
                                        ? 'bg-red-600 hover:bg-red-700 text-white'
                                        : 'hover:bg-red-50 hover:text-red-700 hover:border-red-300 dark:hover:bg-red-950 dark:hover:text-red-300';
                                } else { // Planned and other statuses
                                    return isSelected
                                        ? 'bg-orange-500 hover:bg-orange-600 text-white'
                                        : 'hover:bg-orange-50 hover:text-orange-700 hover:border-orange-300 dark:hover:bg-orange-950 dark:hover:text-orange-300';
                                }
                            };

                            return (
                                <Button
                                    key={status}
                                    variant={isSelected ? "default" : "outline"}
                                    size="sm"
                                    onClick={() => {
                                        if (isSelected) {
                                            setSelectedStatuses(prev => prev.filter(s => s !== status));
                                        } else {
                                            setSelectedStatuses(prev => [...prev, status]);
                                        }
                                    }}
                                    className={`text-xs h-6 px-3 py-1 rounded-full ${getStatusColors(status, isSelected)}`}
                                    title={`${translateStatusLabel(status)} (${statusCount} testes)`}
                                >
                                    {translateStatusLabel(status)}
                                </Button>
                            );
                        })}
                    </div>
                </div>

                <div className="flex items-center gap-4">
                    <DropdownMenu>
                        <DropdownMenuTrigger asChild>
                            <Button variant="outline" size="sm">
                                <Columns className="h-4 w-4" />
                            </Button>
                        </DropdownMenuTrigger>
                        <DropdownMenuContent align="end">
                            {table
                                .getAllColumns()
                                .filter(
                                    (column) => column.getCanHide()
                                )
                                .map((column) => {
                                    return (
                                        <DropdownMenuCheckboxItem
                                            key={column.id}
                                            className="capitalize"
                                            checked={column.getIsVisible()}
                                            onCheckedChange={(value) =>
                                                column.toggleVisibility(!!value)
                                            }
                                        >
                                            {column.columnDef.meta?.label ?? column.id}
                                        </DropdownMenuCheckboxItem>
                                    )
                                })}
                        </DropdownMenuContent>
                    </DropdownMenu>
                </div>
            </div>
            )}

            {!isOverview && (
            <div className="mb-4">
                <div className="flex items-center justify-between mb-3">
                    <div className="flex items-center gap-2">
                        <span className="text-sm font-medium">Filtrar por Pilar SFI (Secure Future Initiative):</span>
                        {selectedSfiPillars.length > 0 && (
                            <Button
                                variant="ghost"
                                size="sm"
                                onClick={() => setSelectedSfiPillars([])}
                                className="h-6 px-2 text-xs text-muted-foreground hover:text-foreground"
                            >
                                Limpar tudo ({selectedSfiPillars.length})
                            </Button>
                        )}
                    </div>
                    <div className="flex items-center gap-4">
                        {/* Clear all filters button */}
                        {(selectedSfiPillars.length > 0 || selectedRisks.length > 0 || selectedStatuses.length > 0) && (
                            <Button
                                variant="ghost"
                                size="sm"
                                onClick={() => {
                                    setSelectedSfiPillars([]);
                                    setSelectedRisks([]);
                                    setSelectedStatuses([]);
                                }}
                                className="h-6 px-2 text-xs text-muted-foreground hover:text-foreground"
                            >
                                Limpar todos os filtros
                            </Button>
                        )}
                        <div className="text-xs text-muted-foreground">
                            Exibindo {filteredData.length} de {pillarFilteredData.length} testes
                        </div>
                    </div>
                </div>
                <div className="flex flex-wrap gap-2">
                    {uniqueSfiPillars.map((pillar) => {
                        const isSelected = selectedSfiPillars.includes(pillar);
                        const pillarCount = data.filter(item => item.TestSfiPillar === pillar).length;
                        const PillarIcon = getSfiPillarIcon(pillar);
                        return (
                            <Button
                                key={pillar}
                                variant={isSelected ? "default" : "outline"}
                                size="sm"
                                onClick={() => {
                                    if (isSelected) {
                                        setSelectedSfiPillars(prev => prev.filter(p => p !== pillar));
                                    } else {
                                        setSelectedSfiPillars(prev => [...prev, pillar]);
                                    }
                                }}
                                className={`text-xs max-w-96 h-auto py-1 px-4 rounded-full ${isSelected ? 'bg-purple-600 hover:bg-purple-700 text-white' : 'hover:bg-purple-50 hover:text-purple-700 hover:border-purple-300 dark:hover:bg-purple-950 dark:hover:text-purple-300'}`}
                                title={`${translateSfiPillar(pillar)} (${pillarCount} testes)`}
                            >
                                <PillarIcon className="mr-2 h-3 w-3 flex-shrink-0" />
                                <span className="whitespace-normal text-left leading-tight">
                                    {translateSfiPillar(pillar)}
                                </span>
                            </Button>
                        );
                    })}
                </div>
            </div>
            )}

            <div className="rounded-md border">
                <Table>
                    <TableHeader>
                        {table.getHeaderGroups().map((headerGroup) => (
                            <TableRow key={headerGroup.id}>
                                {headerGroup.headers.map((header) => {
                                    return (
                                        <TableHead key={header.id}>
                                            {header.isPlaceholder
                                                ? null
                                                : flexRender(
                                                    header.column.columnDef.header,
                                                    header.getContext()
                                                )}
                                        </TableHead>
                                    )
                                })}
                            </TableRow>
                        ))}
                    </TableHeader>
                    <TableBody>
                        {table.getRowModel().rows?.length ? (
                            table.getRowModel().rows.map((row) => (
                                <TableRow
                                    className="cursor-pointer"
                                    key={row.id}
                                    data-state={row.getIsSelected() && "selected"}
                                    onClick={() => {
                                        setSelectedRow(row.original);
                                        setSheetOpen(true)
                                    }}
                                >
                                    {row.getVisibleCells().map((cell) => (
                                        <TableCell key={cell.id}>
                                            {flexRender(cell.column.columnDef.cell, cell.getContext())}
                                        </TableCell>
                                    ))}
                                </TableRow>
                            ))
                        ) : (
                            <TableRow>
                                <TableCell colSpan={columns.length} className="h-24 text-center">
                                    Sem resultados.
                                </TableCell>
                            </TableRow>
                        )}
                    </TableBody>
                </Table>
            </div>
            <Sheet open={sheetOpen} onOpenChange={setSheetOpen}>
                <SheetContent side="right" className="md:min-w-[700px] lg:min-w-[900px] overflow-y-auto" allowMaximize>
                    <SheetHeader>
                        <SheetTitle className="text-2xl text-left">{selectedRow?.TestTitle}</SheetTitle>
                    </SheetHeader>
                    <div className="grid pt-10 gap-6">
                        <Card>
                            <CardHeader>
                                {/* Row of icons + labels below the title, spread out across the row */}
                                <div className="mt-2 flex w-full justify-between text-sm">
                                    {/* Risk */}
                                    <div className="flex items-center gap-2">
                                        <AlertTriangle className="h-4 w-4 text-foreground" />
                                        <span className="font-semibold">Risco:</span>
                                        <span>{translateStatusLabel(selectedRow?.TestRisk ?? "N/D")}</span>
                                    </div>
                                    {/* Impact */}
                                    <div className="flex items-center gap-2">
                                        <Users className="h-4 w-4 text-foreground" />
                                        <span className="font-semibold">Impacto ao usuário:</span>
                                        <span>{translateStatusLabel(selectedRow?.TestImpact ?? "N/D")}</span>
                                    </div>
                                    {/* Implementation Cost */}
                                    <div className="flex items-center gap-2">
                                        <Settings className="h-4 w-4 text-foreground" />
                                        <span className="font-semibold">Esforço de implementação:</span>
                                        <span>{translateStatusLabel(selectedRow?.TestImplementationCost ?? "N/D")}</span>
                                    </div>
                                </div>
                            </CardHeader>
                        </Card>
                    </div>
                    <div className="grid pt-10 gap-6">
                        <Card>
                            <CardHeader><CardTitle>
                                <div className="flex">
                                    <span className="pr-3"> Resultado do teste → </span><StatusIcon Item={selectedRow!} />
                                </div></CardTitle>
                            </CardHeader>
                            <CardContent>
                                <Markdown className="prose max-w-fit dark:prose-invert" remarkPlugins={[remarkGfm]}>{selectedRow?.TestResult}</Markdown>
                            </CardContent>
                        </Card>

                        <Card>
                            <CardHeader><CardTitle>O que foi verificado</CardTitle></CardHeader>
                            <CardContent>
                                <Markdown className="prose max-w-fit dark:prose-invert" remarkPlugins={[remarkGfm]}>{selectedRow?.TestDescription}</Markdown>
                            </CardContent>
                        </Card>

                        {/* {selectedRow && <WorkshopGuidesPanel test={selectedRow} />} */}
                    </div>
                </SheetContent>
            </Sheet>

        </div>
    )
}
