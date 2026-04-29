import { PageHeader, PageHeaderHeading } from "@/components/page-header";
import { Card, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

export default function Infrastructure() {
    return (
        <>
            <PageHeader>
                <PageHeaderHeading>Infraestrutura</PageHeaderHeading>
            </PageHeader>
            <Card>
                <CardHeader>
                    <CardTitle>Em breve</CardTitle>
                    <CardDescription> A paciência é amarga, mas seu fruto é doce. -Jean-Jacques Rousseau</CardDescription>
                </CardHeader>
            </Card>
        </>
    )
}
