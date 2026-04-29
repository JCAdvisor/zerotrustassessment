import { PageHeader, PageHeaderHeading } from "@/components/page-header";
import { Card, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";

export default function Apps() {
    return (
        <>
            <PageHeader>
                <PageHeaderHeading>Apps</PageHeaderHeading>
            </PageHeader>
            <Card>
                <CardHeader>
                    <CardTitle>Disponível em breve</CardTitle>
                    <CardDescription>Quem pode ter paciência pode ter o que quiser. - Benjamin Franklin
                    </CardDescription>
                </CardHeader>
            </Card>
        </>
    )
}
