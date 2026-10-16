import { APIResource } from "../../../../core/resource.mjs";
import * as AgentsAPI from "../agents.mjs";
import * as FilesAPI from "./files.mjs";
import { EnvironmentFile, EnvironmentFilesPage, FileCreateParams, FileListParams, Files } from "./files.mjs";
import * as TemplatesAPI from "./templates.mjs";
import { EnvironmentTemplate, EnvironmentTemplateDeleted, EnvironmentTemplatesPage, TemplateCreateParams, TemplateListParams, TemplateUpdateParams, Templates } from "./templates.mjs";
import { APIPromise } from "../../../../core/api-promise.mjs";
import { RequestOptions } from "../../../../internal/request-options.mjs";
export declare class Environments extends APIResource {
    files: FilesAPI.Files;
    templates: TemplatesAPI.Templates;
    /**
     * Retrieves an execution environment's connection status and safe installed
     * metadata. See
     * [environment lifecycle](https://developers.openai.com/api/docs/guides/agents-api/environments/lifecycle).
     *
     * @example
     * ```ts
     * const environmentInfo =
     *   await client.beta.agents.environments.retrieve(
     *     'environment_id',
     *   );
     * ```
     */
    retrieve(environmentID: string, options?: RequestOptions): APIPromise<EnvironmentInfo>;
}
/**
 * Safe metadata for a first-class execution environment.
 */
export interface EnvironmentInfo {
    /**
     * The ID of the environment.
     */
    id: string;
    /**
     * Files installed in the environment, without their contents.
     */
    files: Array<AgentsAPI.HostedEnvironmentFile>;
    /**
     * The object type. Always `agent.environment`.
     */
    object: 'agent.environment';
    /**
     * Plugins installed in the environment, without their archive contents.
     */
    plugins: Array<AgentsAPI.HostedPlugin>;
    /**
     * Skills installed in the environment, without their archive contents.
     */
    skills: Array<AgentsAPI.HostedSkill>;
    /**
     * The current environment connection status.
     */
    status: 'pending' | 'connected' | 'disconnected' | 'expired' | 'failed';
    /**
     * Whether the environment is hosted by OpenAI or by the application.
     */
    type: 'openai_hosted' | 'self_hosted';
}
export declare namespace Environments {
    export { type EnvironmentInfo as EnvironmentInfo };
    export { Files as Files, type EnvironmentFile as EnvironmentFile, type EnvironmentFilesPage as EnvironmentFilesPage, type FileCreateParams as FileCreateParams, type FileListParams as FileListParams, };
    export { Templates as Templates, type EnvironmentTemplate as EnvironmentTemplate, type EnvironmentTemplateDeleted as EnvironmentTemplateDeleted, type EnvironmentTemplatesPage as EnvironmentTemplatesPage, type TemplateCreateParams as TemplateCreateParams, type TemplateUpdateParams as TemplateUpdateParams, type TemplateListParams as TemplateListParams, };
}
//# sourceMappingURL=environments.d.mts.map