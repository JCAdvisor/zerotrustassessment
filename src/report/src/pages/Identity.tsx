import { PageHeader, PageHeaderHeading } from "@/components/page-header";
import { DataTable } from "@/components/test-table/data-table";
import { reportData } from "@/config/report-data";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { columns } from "@/components/test-table/columns";

export default function Identity() {
    return (
        <>
            <PageHeader>
                <PageHeaderHeading>Identidade</PageHeaderHeading>
            </PageHeader>
            <Card>
                <CardHeader>
                    <CardTitle className="mb-3">Resultados da avaliação</CardTitle>
                    <CardDescription>
                        Os resultados apresentados abaixo são baseados nas diretrizes de segurança detalhadas no guia{" "}
                        <a
                            href="https://learn.microsoft.com/en-us/entra/fundamentals/configure-security"
                            target="_blank"
                            rel="noopener noreferrer"
                            className="text-primary font-medium underline underline-offset-4 hover:underline"
                        >
                            Configurar Microsoft Entra para aumentar a segurança
                        </a>
                        {" "}.
                    </CardDescription>
                </CardHeader>
                <CardContent className="gap-4 px-4 pb-4 pt-1">
                <DataTable columns={columns} data={reportData.Tests} pillar="Identity" />
                </CardContent>
            </Card>
        </>
    )
}
