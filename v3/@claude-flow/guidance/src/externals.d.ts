declare module '@claude-flow/hooks' {
  export interface HookContext { [key: string]: any; }
  export interface HookResult { [key: string]: any; }
  export interface HookRegistrationOptions { [key: string]: any; }
  export interface HookRegistry { [key: string]: any; }
  export const HookEvent: any;
  export const HookPriority: any;
}
declare module '@claude-flow/memory';
declare module '@claude-flow/shared';
