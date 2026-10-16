type ObjectLike = Record<PropertyKey, any>;
/** Conditionally freezes the value if `immutableTypes` is true, otherwise no action. */
export declare function Freeze(value: ObjectLike): ObjectLike;
export {};
