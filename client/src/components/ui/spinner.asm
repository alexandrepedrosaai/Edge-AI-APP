; Assembly representation of: spinner.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/spinner.tsx
; Generated from TypeScript

section .data
    file_name: db 'spinner.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import { Loader2Icon } from "lucide-react";
; 
; import { cn } from "@/lib/utils";
; 
; function Spinner({ className, ...props }: React.ComponentProps<"svg">) {
;   return (
;     <Loader2Icon
;       role="status"
;       aria-label="Loading"
;       className={cn("size-4 animate-spin", className)}
;       {...props}
;     />
;   );
; }
; 
; export { Spinner };
; ============================================

main:
    ; Compiled from TypeScript
    ret
