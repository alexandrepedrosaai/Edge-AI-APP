; Assembly representation of: useMobile.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/hooks/useMobile.tsx
; Generated from TypeScript

section .data
    file_name: db 'useMobile.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import * as React from "react";
; 
; const MOBILE_BREAKPOINT = 768;
; 
; export function useIsMobile() {
;   const [isMobile, setIsMobile] = React.useState<boolean | undefined>(
;     undefined
;   );
; 
;   React.useEffect(() => {
;     const mql = window.matchMedia(`(max-width: ${MOBILE_BREAKPOINT - 1}px)`);
;     const onChange = () => {
;       setIsMobile(window.innerWidth < MOBILE_BREAKPOINT);
;     };
;     mql.addEventListener("change", onChange);
;     setIsMobile(window.innerWidth < MOBILE_BREAKPOINT);
;     return () => mql.removeEventListener("change", onChange);
;   }, []);
; 
;   return !!isMobile;
; }
; ============================================

main:
    ; Compiled from TypeScript
    ret
