; Assembly representation of: progress.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/progress.tsx
; Generated from TypeScript

section .data
    file_name: db 'progress.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import * as React from "react";
; import * as ProgressPrimitive from "@radix-ui/react-progress";
; 
; import { cn } from "@/lib/utils";
; 
; function Progress({
;   className,
;   value,
;   ...props
; }: React.ComponentProps<typeof ProgressPrimitive.Root>) {
;   return (
;     <ProgressPrimitive.Root
;       data-slot="progress"
;       className={cn(
;         "bg-primary/20 relative h-2 w-full overflow-hidden rounded-full",
;         className
;       )}
;       {...props}
;     >
;       <ProgressPrimitive.Indicator
;         data-slot="progress-indicator"
;         className="bg-primary h-full w-full flex-1 transition-all"
;         style={{ transform: `translateX(-${100 - (value || 0)}%)` }}
;       />
;     </ProgressPrimitive.Root>
;   );
; }
; 
; export { Progress };
; ============================================

main:
    ; Compiled from TypeScript
    ret
