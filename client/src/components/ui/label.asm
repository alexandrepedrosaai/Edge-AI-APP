; Assembly representation of: label.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/label.tsx
; Generated from TypeScript

section .data
    file_name: db 'label.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import * as React from "react";
; import * as LabelPrimitive from "@radix-ui/react-label";
; 
; import { cn } from "@/lib/utils";
; 
; function Label({
;   className,
;   ...props
; }: React.ComponentProps<typeof LabelPrimitive.Root>) {
;   return (
;     <LabelPrimitive.Root
;       data-slot="label"
;       className={cn(
;         "flex items-center gap-2 text-sm leading-none font-medium select-none group-data-[disabled=true]:pointer-events-none group-data-[disabled=true]:opacity-50 peer-disabled:cursor-not-allowed peer-disabled:opacity-50",
;         className
;       )}
;       {...props}
;     />
;   );
; }
; 
; export { Label };
; ============================================

main:
    ; Compiled from TypeScript
    ret
