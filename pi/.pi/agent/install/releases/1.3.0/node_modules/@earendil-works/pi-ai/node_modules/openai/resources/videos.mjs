// File generated from our OpenAPI spec by Castiron. See CONTRIBUTING.md for details.
import { APIResource } from "../core/resource.mjs";
import { ConversationCursorPage } from "../core/pagination.mjs";
import { buildHeaders } from "../internal/headers.mjs";
import { maybeMultipartFormRequestOptions, multipartFormRequestOptions } from "../internal/uploads.mjs";
import { path } from "../internal/utils/path.mjs";
/**
 * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
 */
export class Videos extends APIResource {
    /**
     * Create a new video generation job from a prompt and optional reference assets.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    create(body, options) {
        return this._client.post('/videos', multipartFormRequestOptions({ body, ...options, __security: { bearerAuth: true } }, this._client));
    }
    /**
     * Fetch the latest metadata for a generated video.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    retrieve(videoID, options) {
        return this._client.get(path `/videos/${videoID}`, { ...options, __security: { bearerAuth: true } });
    }
    /**
     * List recently generated videos for the current project.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    list(query = {}, options) {
        return this._client.getAPIList('/videos', (ConversationCursorPage), {
            query,
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Permanently delete a completed or failed video and its stored assets.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    delete(videoID, options) {
        return this._client.delete(path `/videos/${videoID}`, { ...options, __security: { bearerAuth: true } });
    }
    /**
     * Create a character from an uploaded video.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    createCharacter(body, options) {
        return this._client.post('/videos/characters', multipartFormRequestOptions({ body, ...options, __security: { bearerAuth: true } }, this._client));
    }
    /**
     * Download the generated video bytes or a derived preview asset.
     *
     * Streams the rendered video content for the specified video job.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    downloadContent(videoID, query = {}, options) {
        return this._client.get(path `/videos/${videoID}/content`, {
            query,
            ...options,
            headers: buildHeaders([{ Accept: 'application/binary' }, options?.headers]),
            __security: { bearerAuth: true },
            __binaryResponse: true,
        });
    }
    /**
     * Create a new video generation job by editing a source video or existing
     * generated video.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    edit(body, options) {
        return this._client.post('/videos/edits', multipartFormRequestOptions({ body, ...options, __security: { bearerAuth: true } }, this._client));
    }
    /**
     * Create an extension of a completed video.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    extend(body, options) {
        return this._client.post('/videos/extensions', multipartFormRequestOptions({ body, ...options, __security: { bearerAuth: true } }, this._client));
    }
    /**
     * Fetch a character.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    getCharacter(characterID, options) {
        return this._client.get(path `/videos/characters/${characterID}`, {
            ...options,
            __security: { bearerAuth: true },
        });
    }
    /**
     * Create a remix of a completed video using a refreshed prompt.
     *
     * @deprecated The Sora API is scheduled to permanently shut down on September 24, 2026.
     */
    remix(videoID, body, options) {
        return this._client.post(path `/videos/${videoID}/remix`, maybeMultipartFormRequestOptions({ body, ...options, __security: { bearerAuth: true } }, this._client));
    }
}
//# sourceMappingURL=videos.mjs.map