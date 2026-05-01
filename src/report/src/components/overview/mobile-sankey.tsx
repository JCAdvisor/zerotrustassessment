import { ZtResponsiveSankey } from "@/components/nivo/sankey";
import { useContext } from 'react';
import { ThemeProviderContext } from '@/contexts/ThemeContext'
import { SankeyDataNode } from "@/config/report-data";
import { translateSankeyLabel } from "@/lib/pt";

export const MobileSankey = ({ data }: { data: SankeyDataNode[] }) => {
    const theme = useContext(ThemeProviderContext);
    const translatedData = data.map(item => ({
        ...item,
        source: translateSankeyLabel(item.source),
        target: translateSankeyLabel(item.target),
    }));

    return (
        <ZtResponsiveSankey isDark={(theme.theme === 'dark' || theme.theme === 'system' && window.matchMedia("(prefers-color-scheme: dark)").matches) ? true : false} data={{
            "nodes": [
                {
                    "id": "Dispositivos móveis",
                    "nodeColor": "hsl(0, 0%, 40%)"
                },
                {
                    "id": "Android",
                    "nodeColor": "hsl(25, 90%, 56%)"
                },
                {
                    "id": "iOS",
                    "nodeColor": "hsl(205, 85%, 45%)"
                },
                {
                    "id": "Android (Corporativo)",
                    "nodeColor": "hsl(28, 95%, 54%)"
                },
                {
                    "id": "Android (Pessoal)",
                    "nodeColor": "hsl(18, 92%, 62%)"
                },
                {
                    "id": "iOS (Corporativo)",
                    "nodeColor": "hsl(210, 80%, 42%)"
                },
                {
                    "id": "iOS (Pessoal)",
                    "nodeColor": "hsl(200, 85%, 55%)"
                },
                {
                    "id": "Em conformidade",
                    "nodeColor": "hsl(142, 71%, 45%)"
                },
                {
                    "id": "Não conforme",
                    "nodeColor": "hsl(0, 89%, 60%)"
                },
            ],
            "links": translatedData
        }} />
    );
}
