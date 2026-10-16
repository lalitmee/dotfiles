/** Looks up an opaque capability without exposing the registry itself. */
export declare const findRegisteredX509Transport: (key: object) => any;
/** Records a capability only after its Node-only factory validates the private dispatcher. */
export declare const rememberRegisteredX509Transport: (key: object, value: any) => WeakMap<object, any>;
/** Privately classifies sanitized issuer errors without exposing transport details. */
export declare const markTransientX509ConnectionError: (value: object) => WeakSet<object>;
/** Checks the private transient classification without retaining caller-owned errors. */
export declare const isTransientX509ConnectionError: (value: object) => boolean;
/** Privately brands retryable issuer failures without exposing classification state. */
export declare const markRetryableX509IssuerError: (value: object) => WeakSet<object>;
/** Recognizes trusted issuer failures without evaluating caller-controlled properties. */
export declare const isRetryableX509IssuerError: (value: object) => boolean;
/** Brands validated clients without exposing their mutable options or authentication fields. */
export declare const markApprovedX509Client: (value: object) => WeakSet<object>;
/** Recognizes private client ownership without caller-visible markers. */
export declare const isApprovedX509Client: (value: object) => boolean;
/** Stores trusted OAuth metadata without exposing it to unrelated callers. */
export declare const rememberX509OAuthError: (key: object, value: any) => WeakMap<object, any>;
/** Retrieves trusted metadata when public OAuth errors cross module formats. */
export declare const findX509OAuthError: (key: object) => any;
/** Privately binds SDK-owned credentials without importing Node or optional transport peers. */
export declare const rememberX509Credential: (key: object, value: any) => WeakMap<object, any>;
/** Resolves only credentials registered by the optional Node authentication helper. */
export declare const findX509Credential: (key: object) => any;
//# sourceMappingURL=x509-transport-state-browser.d.mts.map