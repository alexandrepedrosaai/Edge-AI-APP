; Assembly representation of: avatar.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/avatar.tsx
; Generated from TypeScript

section .data
    file_name: db 'avatar.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import * as React from "react";
; import * as AvatarPrimitive from "@radix-ui/react-avatar";
; 
; import { cn } from "@/lib/utils";
; 
; function Avatar({
;   className,
;   ...props
; }: React.ComponentProps<typeof AvatarPrimitive.Root>) {
;   return (
;     <AvatarPrimitive.Root
;       data-slot="avatar"
;       className={cn(
;         "relative flex size-8 shrink-0 overflow-hidden rounded-full",
;         className
;       )}
;       {...props}
;     />
;   );
; }
; 
; function AvatarImage({
;   className,
;   ...props
; }: React.ComponentProps<typeof AvatarPrimitive.Image>) {
;   return (
;     <AvatarPrimitive.Image
;       data-slot="avatar-image"
;       className={cn("aspect-square size-full", className)}
;       {...props}
;     />
;   );
; }
; 
; function AvatarFallback({
;   className,
;   ...props
; }: React.ComponentProps<typeof AvatarPrimitive.Fallback>) {
;   return (
;     <AvatarPrimitive.Fallback
;       data-slot="avatar-fallback"
;       className={cn(
;         "bg-muted flex size-full items-center justify-center rounded-full",
;         className
;       )}
;       {...props}
;     />
;   );
; }
; 
; export { Avatar, AvatarImage, AvatarFallback };
; ============================================

main:
    ; Compiled from TypeScript
    ret
