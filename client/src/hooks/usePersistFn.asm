; Assembly representation of: usePersistFn.ts
; Original: /home/ubuntu/Edge-AI-APP/client/src/hooks/usePersistFn.ts
; Generated from TypeScript

section .data
    file_name: db 'usePersistFn.ts', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import { useRef } from "react";
; 
; type noop = (...args: any[]) => any;
; 
; /**
;  * usePersistFn instead of useCallback to reduce cognitive load
;  */
; export function usePersistFn<T extends noop>(fn: T) {
;   const fnRef = useRef<T>(fn);
;   fnRef.current = fn;
; 
;   const persistFn = useRef<T>(null);
;   if (!persistFn.current) {
;     persistFn.current = function (this: unknown, ...args) {
;       return fnRef.current!.apply(this, args);
;     } as T;
;   }
; 
;   return persistFn.current!;
; }
; ============================================

main:
    ; Compiled from TypeScript
    ret
