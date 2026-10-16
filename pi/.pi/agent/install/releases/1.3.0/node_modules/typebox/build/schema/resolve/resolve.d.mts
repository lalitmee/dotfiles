import * as Schema from '../types/index.mjs';
export declare const DefaultBase = "https://json-schema.org";
export interface StackFrame {
    context: Record<string, Schema.XSchema>;
    root: Schema.XSchemaObject;
    lexicalSchema: Schema.XSchemaObject;
    lexicalBase: string;
    referenceBase: string;
    resourceBase: string;
    ids: Schema.XId[];
    recursiveAnchors: Schema.XRecursiveAnchor[];
    dynamicAnchors: Schema.XDynamicAnchor[];
    inRetrievedFrame: boolean;
}
export interface RetrievedResource {
    target: Schema.XSchemaObject;
    base: string;
    root: Schema.XSchemaObject;
}
export interface ResolvedResource {
    target: Schema.XSchemaObject;
    resource: Schema.XId;
}
export interface RefResult {
    schema: Schema.XSchema | undefined;
    retrievedResource?: RetrievedResource;
    resolvedResource?: ResolvedResource;
}
export declare function Base(schema: Schema.XSchemaObject, base: string, target: Schema.XSchema): string | undefined;
export declare function Resource(context: Record<string, Schema.XSchema>, schema: Schema.XSchemaObject, base: string, ref: string): Schema.XId | undefined;
export declare function Ref(remotes: Record<string, Schema.XSchema>, schema: Schema.XSchemaObject, base: string, ref: string, applySchemaId?: boolean): Schema.XSchema | undefined;
export declare function DynamicRef(context: Record<string, Schema.XSchema>, root: Schema.XSchemaObject, base: string, schema: Schema.XSchemaObject, dynamicRef: Schema.XDynamicRef, dynamicAnchors: Schema.XDynamicAnchor[]): Schema.XSchema | undefined;
export declare function ResolveRef(stackframe: StackFrame, ref: Schema.XRef): RefResult;
export declare function ResolveRecursiveRef(stackframe: StackFrame, recursiveRef: Schema.XRecursiveRef): Schema.XSchema | undefined;
export declare function ResolveDynamicRef(stackframe: StackFrame, dynamicRef: Schema.XDynamicRef): Schema.XSchema | undefined;
