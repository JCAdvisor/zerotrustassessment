import { useEffect } from "react";
import { toast } from "sonner";
import { reportData } from "@/config/report-data";

export function useDemoToast() {
    useEffect(() => {
        // Only show the toast if IsDemo is true
        if (reportData.IsDemo) {
            let toastId: string | number;

            // Show the toast after a short delay to ensure the app has loaded
            const timer = setTimeout(() => {
                toastId = toast.warning(
                    <div className="flex flex-col gap-2 w-full">
                        <div className="font-semibold break-words">
                            Relatório de demonstração da Avaliação de Zero Trust da Microsoft
                        </div>
                        <div className="text-sm text-muted-foreground flex flex-col gap-1 break-words">
                            <div className="break-words">
                                Esta é uma demonstração do relatório gerado pela{" "}
                                <a
                                    href="https://aka.ms/ZeroTrust/Assessment"
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="underline hover:text-primary break-all"
                                    onClick={(e) => e.stopPropagation()}
                                >
                                    Avaliação de Zero Trust
                                </a>
                                {" "}ferramenta.
                            </div>
                            <div className="break-words">
                                A versão mais recente deste relatório de demonstração está disponível em{" "}
                                <a
                                    href="https://aka.ms/ZeroTrust/Demo"
                                    target="_blank"
                                    rel="noopener noreferrer"
                                    className="underline hover:text-primary break-all"
                                    onClick={(e) => e.stopPropagation()}
                                >
                                    aka.ms/ZeroTrust/Demo
                                </a>
                                .
                            </div>
                        </div>
                    </div>,
                    {
                        duration: Infinity, // Keep it visible until dismissed
                        closeButton: true,
                        style: {
                            minWidth: "min(600px, calc(100vw - 32px))",
                            maxWidth: "calc(100vw - 32px)",
                        },
                        className: "break-words"
                    }
                );

                // Add click listener to dismiss toast when clicking anywhere on the page
                const handleClick = (e: MouseEvent) => {
                    const target = e.target as HTMLElement;
                    // Don't dismiss if clicking on links within the toast
                    if (target.tagName === 'A' && target.closest('[data-sonner-toast]')) {
                        return;
                    }
                    // Dismiss the toast and remove listener
                    toast.dismiss(toastId);
                    document.removeEventListener('click', handleClick);
                };

                // Add the click listener after a small delay to avoid immediate dismissal
                setTimeout(() => {
                    document.addEventListener('click', handleClick);
                }, 100);
            }, 500);

            return () => {
                clearTimeout(timer);
                if (toastId) {
                    toast.dismiss(toastId);
                }
            };
        }
    }, []);
}
