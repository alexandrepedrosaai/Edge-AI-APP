; Assembly representation of: collapsible.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/collapsible.tsx
; Generated from TypeScript

section .data
    file_name: db 'collapsible.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import * as CollapsiblePrimitive from "@radix-ui/react-collapsible";
; 
; function Collapsible({
;   ...props
; }: React.ComponentProps<typeof CollapsiblePrimitive.Root>) {
;   return <CollapsiblePrimitive.Root data-slot="collapsible" {...props} />;
; }
; 
; function CollapsibleTrigger({
;   ...props
; }: React.ComponentProps<typeof CollapsiblePrimitive.CollapsibleTrigger>) {
;   return (
;     <CollapsiblePrimitive.CollapsibleTrigger
;       data-slot="collapsible-trigger"
;       {...props}
;     />
;   );
; }
; 
; function CollapsibleContent({
;   ...props
; }: React.ComponentProps<typeof CollapsiblePrimitive.CollapsibleContent>) {
;   return (
;     <CollapsiblePrimitive.CollapsibleContent
;       data-slot="collapsible-content"
;       {...props}
;     />
;   );
; }
; 
; export { Collapsible, CollapsibleTrigger, CollapsibleContent };
; ============================================

main:
    ; Compiled from TypeScript
    ret
