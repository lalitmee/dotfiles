import { type KeyId } from "@earendil-works/pi-tui";
import { type TSchemaOptions, Type } from "typebox";
export declare const KeyIdSchema: Type.TUnsafe<KeyId>;
export declare function keybindingValueSchema(options?: TSchemaOptions): Type.TUnion<[Type.TUnsafe<KeyId>, Type.TArray<Type.TUnsafe<KeyId>>]>;
export declare const KeybindingValueSchema: Type.TUnion<[Type.TUnsafe<KeyId>, Type.TArray<Type.TUnsafe<KeyId>>]>;
//# sourceMappingURL=key-id-schema.d.ts.map