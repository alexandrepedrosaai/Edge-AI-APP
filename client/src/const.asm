; Assembly representation of: const.ts
; Original: /home/ubuntu/Edge-AI-APP/client/src/const.ts
; Generated from TypeScript

section .data
    file_name: db 'const.ts', 0
    file_type: db 'TypeScript', 0

section .text
    global main

; TypeScript Source Code (as comments)
; ============================================
; export { COOKIE_NAME, ONE_YEAR_MS } from "@shared/const";
; 
; // Generate login URL at runtime so redirect URI reflects the current origin.
; export const getLoginUrl = () => {
;   const oauthPortalUrl = import.meta.env.VITE_OAUTH_PORTAL_URL;
;   const appId = import.meta.env.VITE_APP_ID;
;   const redirectUri = `${window.location.origin}/api/oauth/callback`;
;   const state = btoa(redirectUri);
; 
;   const url = new URL(`${oauthPortalUrl}/app-auth`);
;   url.searchParams.set("appId", appId);
;   url.searchParams.set("redirectUri", redirectUri);
;   url.searchParams.set("state", state);
;   url.searchParams.set("type", "signIn");
; 
;   return url.toString();
; };
; ============================================

main:
    ; Compiled from TypeScript
    ret
