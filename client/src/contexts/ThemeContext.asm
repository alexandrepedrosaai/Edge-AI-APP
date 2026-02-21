; Assembly representation of: ThemeContext.tsx
; Original: /home/ubuntu/Edge-AI-APP/client/src/contexts/ThemeContext.tsx
; Generated from TypeScript

section .data
    file_name: db 'ThemeContext.tsx', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; import React, { createContext, useContext, useEffect, useState } from "react";
; 
; type Theme = "light" | "dark";
; 
; interface ThemeContextType {
;   theme: Theme;
;   toggleTheme?: () => void;
;   switchable: boolean;
; }
; 
; const ThemeContext = createContext<ThemeContextType | undefined>(undefined);
; 
; interface ThemeProviderProps {
;   children: React.ReactNode;
;   defaultTheme?: Theme;
;   switchable?: boolean;
; }
; 
; export function ThemeProvider({
;   children,
;   defaultTheme = "light",
;   switchable = false,
; }: ThemeProviderProps) {
;   const [theme, setTheme] = useState<Theme>(() => {
;     if (switchable) {
;       const stored = localStorage.getItem("theme");
;       return (stored as Theme) || defaultTheme;
;     }
;     return defaultTheme;
;   });
; 
;   useEffect(() => {
;     const root = document.documentElement;
;     if (theme === "dark") {
;       root.classList.add("dark");
;     } else {
;       root.classList.remove("dark");
;     }
; 
;     if (switchable) {
;       localStorage.setItem("theme", theme);
;     }
;   }, [theme, switchable]);
; 
;   const toggleTheme = switchable
;     ? () => {
;         setTheme(prev => (prev === "light" ? "dark" : "light"));
;       }
;     : undefined;
; 
;   return (
;     <ThemeContext.Provider value={{ theme, toggleTheme, switchable }}>
;       {children}
;     </ThemeContext.Provider>
;   );
; }
; 
; export function useTheme() {
;   const context = useContext(ThemeContext);
;   if (!context) {
;     throw new Error("useTheme must be used within ThemeProvider");
;   }
;   return context;
; }
; ============================================

main:
    ; Compiled from TypeScript
    ret
