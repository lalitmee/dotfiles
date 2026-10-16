/**
 * Theme JSON validation, kept out of `theme.ts` on purpose.
 *
 * Validating user-authored theme files needs typebox, which costs ~17 MB of module graph to import.
 * Palette lookup does not, so a presentation that only uses built-in themes should never pay for it.
 * `main.ts` installs this validator before runtime resource loading; other consumers can opt in with
 * `setThemeJsonValidator()`. Built-in themes do not need validation.
 */
import { type Static, Type } from "typebox";
import { type ThemeColorValues } from "./theme-tokens.ts";
export declare const ColorValueSchema: Type.TUnion<[Type.TString, Type.TInteger]>;
export type ThemeColorValue = Static<typeof ColorValueSchema>;
export declare const ThemeJsonSchema: Type.TObject<{
    $schema: Type.TOptional<Type.TString>;
    name: Type.TString;
    appearance: Type.TOptional<Type.TUnion<[Type.TLiteral<"dark">, Type.TLiteral<"light">]>>;
    vars: Type.TOptional<Type.TRecord<"^.*$", Type.TUnion<[Type.TString, Type.TInteger]>>>;
    colors: Type.TUnsafe<ThemeColorValues<string | number>>;
    export: Type.TOptional<Type.TObject<{
        pageBg: Type.TOptional<Type.TUnion<[Type.TString, Type.TInteger]>>;
        cardBg: Type.TOptional<Type.TUnion<[Type.TString, Type.TInteger]>>;
        infoBg: Type.TOptional<Type.TUnion<[Type.TString, Type.TInteger]>>;
    }>>;
}>;
export type ValidatedThemeJson = Static<typeof ThemeJsonSchema>;
/** Validate one theme document, throwing a message that names the offending tokens. */
export declare function validateThemeJson(label: string, json: unknown): ValidatedThemeJson;
//# sourceMappingURL=theme-schema.d.ts.map