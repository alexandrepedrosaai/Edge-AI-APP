; Assembly representation of: kbd.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/kbd.tsx
; Generated from TypeScript

section .data
    file_name: db 'kbd.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import { cn } from "@/lib/utils";
; 
; function Kbd({ className, ...props }: React.ComponentProps<"kbd">) {
;   return (
;     <kbd
;       data-slot="kbd"
;       className={cn(
;         "bg-muted text-muted-foreground pointer-events-none inline-flex h-5 w-fit min-w-5 items-center justify-center gap-1 rounded-sm px-1 font-sans text-xs font-medium select-none",
;         "[&_svg:not([class*='size-'])]:size-3",
;         "[[data-slot=tooltip-content]_&]:bg-background/20 [[data-slot=tooltip-content]_&]:text-background dark:[[data-slot=tooltip-content]_&]:bg-background/10",
;         className
;       )}
;       {...props}
;     />
;   );
; }
; 
; function KbdGroup({ className, ...props }: React.ComponentProps<"div">) {
;   return (
;     <kbd
;       data-slot="kbd-group"
;       className={cn("inline-flex items-center gap-1", className)}
;       {...props}
;     />
;   );
; }
; 
; export { Kbd, KbdGroup };
; ============================================

main:
    ; Compiled from TypeScript
    ret
