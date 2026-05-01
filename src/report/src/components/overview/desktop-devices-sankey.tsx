import { ZtResponsiveSankey } from "@/components/nivo/sankey";
import { useContext } from 'react';
import { ThemeProviderContext } from '@/contexts/ThemeContext'
import { SankeyDataNode } from "@/config/report-data";
import { translateSankeyLabel } from "@/lib/pt";

export const DesktopDevicesSankey = ({ data }: { data: SankeyDataNode[] }) => {
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
                    "id": "Dispositivos desktop",
                    "nodeColor": "hsl(0, 0%, 40%)"
                },
                {
                    "id": "Windows",
                    "nodeColor": "hsl(208, 100%, 42%)"
                },
                {
                    "id": "macOS",
                    "nodeColor": "hsl(270, 35%, 48%)"
                },
                {
                    "id": "Ingressado no Entra",
                    "nodeColor": "hsl(0, 0%, 65%)"
                },
                {
                    "id": "Registrado no Entra",
                    "nodeColor": "hsl(0, 0%, 55%)"
                },
                {
                    "id": "Ingresso híbrido no Entra",
                    "nodeColor": "hsl(0, 0%, 45%)"
                },
                {
                    "id": "Em conformidade",
                    "nodeColor": "hsl(142, 71%, 45%)"
                },
                {
                    "id": "Não conforme",
                    "nodeColor": "hsl(0, 89%, 60%)"
                },
                {
                    "id": "Não gerenciado",
                    "nodeColor": "hsl(0, 89%, 60%)"
                },

            ],
            "links": translatedData
        }} />
    );
}
