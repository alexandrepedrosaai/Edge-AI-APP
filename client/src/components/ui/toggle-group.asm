; Assembly representation of: toggle-group.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/components/ui/toggle-group.tsx
; Generated from TypeScript

section .data
    file_name: db 'toggle-group.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; "use client";
; 
; import * as React from "react";
; import * as ToggleGroupPrimitive from "@radix-ui/react-toggle-group";
; import { type VariantProps } from "class-variance-authority";
; 
; import { cn } from "@/lib/utils";
; import { toggleVariants } from "@/components/ui/toggle";
; 
; const ToggleGroupContext = React.createContext<
;   VariantProps<typeof toggleVariants>
; >({
;   size: "default",
;   variant: "default",
; });
; 
; function ToggleGroup({
;   className,
;   variant,
;   size,
;   children,
;   ...props
; }: React.ComponentProps<typeof ToggleGroupPrimitive.Root> &
;   VariantProps<typeof toggleVariants>) {
;   return (
;     <ToggleGroupPrimitive.Root
;       data-slot="toggle-group"
;       data-variant={variant}
;       data-size={size}
;       className={cn(
;         "group/toggle-group flex w-fit items-center rounded-md data-[variant=outline]:shadow-xs",
;         className
;       )}
;       {...props}
;     >
;       <ToggleGroupContext.Provider value={{ variant, size }}>
;         {children}
;       </ToggleGroupContext.Provider>
;     </ToggleGroupPrimitive.Root>
;   );
; }
; 
; function ToggleGroupItem({
;   className,
;   children,
;   variant,
;   size,
;   ...props
; }: React.ComponentProps<typeof ToggleGroupPrimitive.Item> &
;   VariantProps<typeof toggleVariants>) {
;   const context = React.useContext(ToggleGroupContext);
; 
;   return (
;     <ToggleGroupPrimitive.Item
;       data-slot="toggle-group-item"
;       data-variant={context.variant || variant}
;       data-size={context.size || size}
;       className={cn(
;         toggleVariants({
;           variant: context.variant || variant,
;           size: context.size || size,
;         }),
;         "min-w-0 flex-1 shrink-0 rounded-none shadow-none first:rounded-l-md last:rounded-r-md focus:z-10 focus-visible:z-10 data-[variant=outline]:border-l-0 data-[variant=outline]:first:border-l",
;         className
;       )}
;       {...props}
;     >
;       {children}
;     </ToggleGroupPrimitive.Item>
;   );
; }
; 
; export { ToggleGroup, ToggleGroupItem };
; ============================================

main:
    ; Compiled from TypeScript
    ret
