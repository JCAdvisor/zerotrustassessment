import { buttonVariants } from "@/components/ui/button";
import { NavLink } from "react-router-dom";

export default function NoMatch() {
    return (
        <div className="bg-background text-foreground flex-grow flex items-center justify-center">
            <div className="space-y-4">
                <h2 className="text-8xl mb-4">404</h2>
                <h1 className="text-3xl font-semibold">Ops! Página não encontrada</h1>
                <p className="text-sm text-muted-foreground">Lamentamos, mas a página que você solicitou não foi encontrada</p>
                <NavLink to="/" className={buttonVariants()}>Voltar para a página inicial</NavLink>
            </div>
        </div>
    )
}
