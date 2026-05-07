import { ColumnDef } from "@tanstack/react-table"
import { Test } from "@/config/report-data"
import { ArrowUpDown } from "lucide-react"
import { Button } from "../ui/button"
import { impacts } from "./data-icons"
import { StatusIcon } from "../status-icon"
import { translateText } from "@/lib/pt"

export const columns: ColumnDef<Test>[] = [
    {
        accessorKey: "TestId",
        header: ({ column }) => (
            <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc") }>
                ID
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        meta: {
            label: "ID",
        },
    },
    {
        accessorKey: "TestTitle",
        meta: { label: "Nome" },
        header: ({ column }) => (
            <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc") }>
                Nome
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
    },
    {
        accessorKey: "TestCategory",
        meta: { label: "Categoria" },
        header: ({ column }) => (
            <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc") }>
                Categoria
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => {
            const category = row.getValue("TestCategory") as string

            if (!category) {
                return <span className="text-muted-foreground">N/D</span>
            }

            return <span>{translateText(category)}</span>
        },
    },
    {
        accessorKey: "TestSfiPillar",
        meta: { label: "Pilar SFI" },
        header: ({ column }) => (
            <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc") }>
                Pilar SFI (Secure Future Initiative)
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => {
            const sfiPillar = row.getValue("TestSfiPillar") as string

            if (!sfiPillar) {
                return <span className="text-muted-foreground">N/D</span>
            }

            return (
                <span className="rounded-md bg-purple-100 px-2 py-1 text-xs font-medium text-purple-900">
                    {translateText(sfiPillar)}
                </span>
            )
        },
    },
    {
        accessorKey: "TestMinimumLicense",
        meta: { label: "Licença mínima" },
        header: ({ column }) => (
            <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc") }>
                Lic. mínima
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => {
            const licensesValue = row.getValue("TestMinimumLicense")

            if (!licensesValue) {
                return <span className="text-muted-foreground">N/D</span>
            }

            const licenses = Array.isArray(licensesValue) ? licensesValue : [licensesValue]

            if (licenses.length === 0) {
                return <span className="text-muted-foreground">N/D</span>
            }

            return (
                <div className="flex flex-wrap items-center gap-1">
                    {licenses.map((license, index) => (
                        <span key={index} className="rounded-md bg-purple-100 px-2 py-1 text-xs font-medium text-purple-800">
                            {license}
                        </span>
                    ))}
                </div>
            )
        },
    },
    {
        accessorKey: "TestImpact",
        meta: { label: "Impacto ao usuário" },
        header: ({ column }) => (
            <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc") }>
                Impacto ao usuário
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => {
            const impact = impacts.find((item) => item.value === row.getValue("TestImpact"))

            if (!impact) {
                return null
            }

            return <span>{impact.label}</span>
        },
    },
    {
        accessorKey: "TestImplementationCost",
        meta: { label: "Esforço de implementação" },
        header: ({ column }) => (
            <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc") }>
                Esf. implementação
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => {
            const impact = impacts.find((item) => item.value === row.getValue("TestImplementationCost"))

            if (!impact) {
                return null
            }

            return <span>{impact.label}</span>
        },
    },
    {
        accessorKey: "TestRisk",
        meta: { label: "Risco" },
        header: ({ column }) => (
            <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc") }>
                Risco
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => {
            const impact = impacts.find((item) => item.value === row.getValue("TestRisk"))

            if (!impact) {
                return null
            }

            return (
                <div className="flex items-center">
                    {impact.icon && <impact.icon className="mr-2 h-4 w-4 text-muted-foreground" />}
                    <span>{impact.label}</span>
                </div>
            )
        },
    },
    {
        accessorKey: "TestStatus",
        meta: { label: "Status" },
        header: ({ column }) => (
            <Button variant="ghost" onClick={() => column.toggleSorting(column.getIsSorted() === "asc") }>
                Status
                <ArrowUpDown className="ml-2 h-4 w-4" />
            </Button>
        ),
        cell: ({ row }) => <StatusIcon Item={row.original} />,
    },
]
