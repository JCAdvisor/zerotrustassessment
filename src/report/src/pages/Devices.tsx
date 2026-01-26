import { PageHeader, PageHeaderHeading } from "@/components/page-header";
import { DataTable } from "@/components/test-table/data-table";
import { reportData } from "@/config/report-data";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { columns } from "@/components/test-table/columns";
import { Tabs, TabsContent, TabsList, TabsTrigger } from "@/components/ui/tabs";
import DevicesConfig from "@/components/DevicesConfig";
import { BarChart3, Settings } from "lucide-react";


export default function Devices() {
    return (
        <>
            <PageHeader>
                <PageHeaderHeading>Devices</PageHeaderHeading>
            </PageHeader>
            <Tabs defaultValue="assessment" className="w-full">
                <TabsList className="grid w-full grid-cols-2">
                    <TabsTrigger value="assessment" className="flex items-center gap-2">
                        <BarChart3 className="h-4 w-4" />
                        Resultados do Assessement
                    </TabsTrigger>
                    <TabsTrigger value="config" className="flex items-center gap-2">
                        <Settings className="h-4 w-4" />
                        Config
                    </TabsTrigger>
                </TabsList>
                <TabsContent value="assessment" className="space-y-4">
                    <Card>
                        <CardHeader>
                            <CardTitle className="mb-3">Resultados do Assessement</CardTitle>
                            <CardDescription>
                                Os resultados apresentados abaixo são baseados nos princípios de segurança detalhados no{" "}
                                <a
                                    href="https://learn.microsoft.com/intune/intune-service/protect/zero-trust-configure-security"
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="text-primary font-medium underline underline-offset-4 hover:underline"
                                >
                                    Microsoft Intune para maior segurança.
                                </a>
                                {" "}
                            </CardDescription>
                        </CardHeader>
                        <CardContent className="gap-4 px-4 pb-4 pt-1">
                            <DataTable isOverview={false} columns={columns} data={reportData.Tests} pillar="Devices" />
                        </CardContent>
                    </Card>
                </TabsContent>
                <TabsContent value="config" className="space-y-4">
                    <Card>
                        <CardHeader>
                            <CardTitle className="mb-3">Configuração de Dispositivo</CardTitle>
                            <CardDescription>Configuração de dispositivo e opções.
                            </CardDescription>
                        </CardHeader>
                        <CardContent className="gap-4 px-4 pb-4 pt-1">
                            <DevicesConfig />
                        </CardContent>
                    </Card>
                </TabsContent>
            </Tabs>
        </>
    )
}
