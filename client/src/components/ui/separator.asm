; Assembly representation of: separator.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/separator.tsx
; Generated from TypeScript

section .data
    file_name: db 'separator.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import * as React from "react";
; import * as SeparatorPrimitive from "@radix-ui/react-separator";
; 
; import { cn } from "@/lib/utils";
; 
; function Separator({
;   className,
;   orientation = "horizontal",
;   decorative = true,
;   ...props
; }: React.ComponentProps<typeof SeparatorPrimitive.Root>) {
;   return (
;     <SeparatorPrimitive.Root
;       data-slot="separator"
;       decorative={decorative}
;       orientation={orientation}
;       className={cn(
;         "bg-border shrink-0 data-[orientation=horizontal]:h-px data-[orientation=horizontal]:w-full data-[orientation=vertical]:h-full data-[orientation=vertical]:w-px",
;         className
;       )}
;       {...props}
;     />
;   );
; }
; 
; export { Separator };
; ============================================

main:
    ; Compiled from TypeScript
    ret
