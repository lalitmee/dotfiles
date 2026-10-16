/** Looks up an opaque capability without exposing the registry itself. */
export declare const findRegisteredX509Transport: (key: object) => any;
/** Records a capability only after the Node-only factory verifies its genuine private dispatcher. */
export declare const rememberRegisteredX509Transport: (key: object, value: any) => WeakMap<object, any>;
/** Privately brands sanitized connection errors shared across CommonJS and ESM clients. */
export declare const markTransientX509ConnectionError: (value: object) => WeakSet<object>;
/** Recognizes a transient connection without trusting public error properties. */
export declare const isTransientX509ConnectionError: (value: object) => boolean;
/** Privately brands issuer-generated retryable HTTP failures across module formats. */
export declare const markRetryableX509IssuerError: (value: object) => WeakSet<object>;
/** Recognizes only retryable HTTP errors produced by the trusted certificate exchange. */
export declare const isRetryableX509IssuerError: (value: object) => boolean;
/** Brands only clients whose transport capability was successfully validated. */
export declare const markApprovedX509Client: (value: object) => WeakSet<object>;
/** Recognizes immutable client ownership across mixed CommonJS and ESM helpers. */
export declare const isApprovedX509Client: (value: object) => boolean;
/** Records the sanitized OAuth response without trusting mutable public error properties. */
export declare const rememberX509OAuthError: (key: object, value: any) => WeakMap<object, any>;
/** Retrieves trusted OAuth metadata for public cross-module error normalization. */
export declare const findX509OAuthError: (key: object) => any;
/** Privately binds SDK-owned credentials to their immutable identity and approved transport. */
export declare const rememberX509Credential: (key: object, value: any) => WeakMap<object, any>;
/** Resolves only first-class credentials created by the optional Node transport helper. */
export declare const findX509Credential: (key: object) => any;
//# sourceMappingURL=x509-transport-state.d.cts.map