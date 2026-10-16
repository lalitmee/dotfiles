/**
 * Checks whether a webhook header requires constant-work HMAC signing without
 * retaining an unbounded number of signature candidates.
 *
 * @internal
 */
export declare function webhookSignatureRequiresSigning(signatureHeader: string): boolean;
/**
 * Checks the timestamp and HMAC signatures after the resource has validated its
 * crypto capabilities, secret, and required headers.
 *
 * @internal
 */
export declare function verifyWebhookSignature(payload: string, signatureHeader: string, timestamp: string, webhookId: string, secret: string, tolerance: number): Promise<void>;
//# sourceMappingURL=webhook-signature.d.mts.map