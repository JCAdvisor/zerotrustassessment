import { ztAppConfig } from "@/config/app";
import { Icons } from "./icons";
import jc2Logo from "../assets/jc2sec.png";

export function Logo() {
    return (
        <>
            <Icons.logo className="h-10 w-10" />
            <div className="flex flex-col">
                <p className="font-bold">{ztAppConfig.name}</p>
                <p className="font-light text-xs text-muted-foreground">
                    boosted by <img src={jc2Logo} alt="JC2SEC" className="inline h-4" />
                </p>
            </div>

        </>
    )
}
