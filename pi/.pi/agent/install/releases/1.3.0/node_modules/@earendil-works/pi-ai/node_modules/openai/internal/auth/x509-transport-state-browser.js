"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.findX509Credential = exports.rememberX509Credential = exports.findX509OAuthError = exports.rememberX509OAuthError = exports.isApprovedX509Client = exports.markApprovedX509Client = exports.isRetryableX509IssuerError = exports.markRetryableX509IssuerError = exports.isTransientX509ConnectionError = exports.markTransientX509ConnectionError = exports.rememberRegisteredX509Transport = exports.findRegisteredX509Transport = void 0;
/** Browser-safe capability state keeps CommonJS outside the ordinary SDK ESM graph. */
const registeredX509Transports = new WeakMap();
const transientX509ConnectionErrors = new WeakSet();
const retryableX509IssuerErrors = new WeakSet();
const approvedX509Clients = new WeakSet();
const approvedX509OAuthErrors = new WeakMap();
const approvedX509Credentials = new WeakMap();
/** Looks up an opaque capability without exposing the registry itself. */
exports.findRegisteredX509Transport = WeakMap.prototype.get.bind(registeredX509Transports);
/** Records a capability only after its Node-only factory validates the private dispatcher. */
exports.rememberRegisteredX509Transport = WeakMap.prototype.set.bind(registeredX509Transports);
/** Privately classifies sanitized issuer errors without exposing transport details. */
exports.markTransientX509ConnectionError = WeakSet.prototype.add.bind(transientX509ConnectionErrors);
/** Checks the private transient classification without retaining caller-owned errors. */
exports.isTransientX509ConnectionError = WeakSet.prototype.has.bind(transientX509ConnectionErrors);
/** Privately brands retryable issuer failures without exposing classification state. */
exports.markRetryableX509IssuerError = WeakSet.prototype.add.bind(retryableX509IssuerErrors);
/** Recognizes trusted issuer failures without evaluating caller-controlled properties. */
exports.isRetryableX509IssuerError = WeakSet.prototype.has.bind(retryableX509IssuerErrors);
/** Brands validated clients without exposing their mutable options or authentication fields. */
exports.markApprovedX509Client = WeakSet.prototype.add.bind(approvedX509Clients);
/** Recognizes private client ownership without caller-visible markers. */
exports.isApprovedX509Client = WeakSet.prototype.has.bind(approvedX509Clients);
/** Stores trusted OAuth metadata without exposing it to unrelated callers. */
exports.rememberX509OAuthError = WeakMap.prototype.set.bind(approvedX509OAuthErrors);
/** Retrieves trusted metadata when public OAuth errors cross module formats. */
exports.findX509OAuthError = WeakMap.prototype.get.bind(approvedX509OAuthErrors);
/** Privately binds SDK-owned credentials without importing Node or optional transport peers. */
exports.rememberX509Credential = WeakMap.prototype.set.bind(approvedX509Credentials);
/** Resolves only credentials registered by the optional Node authentication helper. */
exports.findX509Credential = WeakMap.prototype.get.bind(approvedX509Credentials);
//# sourceMappingURL=x509-transport-state-browser.js.map