; Assembly representation of: skeleton.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/skeleton.tsx
; Generated from TypeScript

section .data
    file_name: db 'skeleton.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import { cn } from "@/lib/utils";
; 
; function Skeleton({ className, ...props }: React.ComponentProps<"div">) {
;   return (
;     <div
;       data-slot="skeleton"
;       className={cn("bg-accent animate-pulse rounded-md", className)}
;       {...props}
;     />
;   );
; }
; 
; export { Skeleton };
; ============================================

main:
    ; Compiled from TypeScript
    ret
