import type { TValidationError } from '../../error/index.mjs';
export declare function HasUnevaluated(context: Record<PropertyKey, unknown>, schema: unknown): boolean;
export declare class BuildContext {
    private readonly hasUnevaluated;
    constructor(hasUnevaluated: boolean);
    UseUnevaluated(): boolean;
    Push(): string;
    Pop(): string;
    AddIndex(index: string): string;
    AddKey(key: string): string;
    Merge(results: string): string;
}
export declare class CheckContext {
    private readonly stack;
    constructor();
    Push(): true;
    Pop(): true;
    AddIndex(index: number): true;
    AddKey(key: string): true;
    GetIndices(): Set<number>;
    GetKeys(): Set<string>;
    Merge(results: CheckContext[]): true;
}
export declare class ErrorContext extends CheckContext {
    private readonly errors;
    constructor();
    AtCapacity(): boolean;
    AddError(error: TValidationError): false;
    GetErrors(): TValidationError[];
}
