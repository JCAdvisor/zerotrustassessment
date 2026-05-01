import {
    ArrowDownIcon,
    ArrowRightIcon,
    ArrowUpIcon,
    CheckCircledIcon,
    CrossCircledIcon,
    QuestionMarkCircledIcon,
    StopwatchIcon,
  } from "@radix-ui/react-icons"

  export const labels = [
    {
      value: "bug",
      label: "Erro",
    },
    {
      value: "feature",
      label: "Funcionalidade",
    },
    {
      value: "documentation",
      label: "Documentação",
    },
  ]

  export const statuses = [
    {
      value: "Passed",
      label: "Aprovado",
      icon: CheckCircledIcon,
      variant: "success"
    },
    {
      value: "Failed",
      label: "Reprovado",
      icon: CrossCircledIcon,
      variant: "destructive"
    },
    {
      value: "Investigate",
      label: "Investigar",
      icon: QuestionMarkCircledIcon,
      variant: "warning"
    },
    {
      value: "Skipped",
      label: "Ignorado",
      icon: StopwatchIcon,
      variant: "secondary"
    },
    {
      value: "Planned",
      label: "Planejado",
      icon: StopwatchIcon,
      variant: "secondary"
    },
  ]

  export const impacts = [
    {
      label: "Baixo",
      value: "Low",
      icon: ArrowDownIcon,
    },
    {
      label: "Médio",
      value: "Medium",
      icon: ArrowRightIcon,
    },
    {
      label: "Alto",
      value: "High",
      icon: ArrowUpIcon,
    },
  ]
