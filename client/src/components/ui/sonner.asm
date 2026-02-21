; Assembly representation of: sonner.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/sonner.tsx
; Generated from TypeScript

section .data
    file_name: db 'sonner.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import { useTheme } from "next-themes";
; import { Toaster as Sonner, type ToasterProps } from "sonner";
; 
; const Toaster = ({ ...props }: ToasterProps) => {
;   const { theme = "system" } = useTheme();
; 
;   return (
;     <Sonner
;       theme={theme as ToasterProps["theme"]}
;       className="toaster group"
;       style={
;         {
;           "--normal-bg": "var(--popover)",
;           "--normal-text": "var(--popover-foreground)",
;           "--normal-border": "var(--border)",
;         } as React.CSSProperties
;       }
;       {...props}
;     />
;   );
; };
; 
; export { Toaster };
; ============================================

main:
    ; Compiled from TypeScript
    ret
