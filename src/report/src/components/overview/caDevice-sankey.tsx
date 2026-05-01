import { ZtResponsiveSankey } from "@/components/nivo/sankey";
import { useContext } from 'react';
import { ThemeProviderContext } from '@/contexts/ThemeContext'
import { SankeyDataNode } from "@/config/report-data";
import { translateSankeyLabel } from "@/lib/pt";

export const CaDeviceSankey = ({ data }: { data: SankeyDataNode[] }) => {
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
                    "id": "Entrada de usuário",
                    "nodeColor": "hsl(0, 0%, 17%)"
                },
                {
                    "id": "Não gerenciado",
                    "nodeColor": "hsl(0, 89%, 60%)"
                },
                {
                    "id": "Gerenciado",
                    "nodeColor": "hsl(25, 90%, 56%)"
                },
                {
                    "id": "Não conforme",
                    "nodeColor": "hsl(0, 89%, 60%)"
                },
                {
                    "id": "Em conformidade",
                    "nodeColor": "hsl(142, 71%, 45%)"
                },
            ],
            "links": translatedData
        }} />
    );
}
