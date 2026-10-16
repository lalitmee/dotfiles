import { APIResource } from "../core/resource.mjs";
import { buildHeaders } from "../internal/headers.mjs";
export class Completions extends APIResource {
    create(params, options) {
        const { betas, workspace_id, ...body } = params;
        return this._client.post('/v1/complete', {
            body,
            timeout: this._client._options.timeout ?? 600000,
            ...options,
            headers: buildHeaders([
                {
                    ...(betas?.toString() != null ? { 'anthropic-beta': betas?.toString() } : undefined),
                    ...(workspace_id != null ? { 'anthropic-workspace-id': workspace_id } : undefined),
                },
                options?.headers,
            ]),
            stream: params.stream ?? false,
        });
    }
}
//# sourceMappingURL=completions.mjs.map