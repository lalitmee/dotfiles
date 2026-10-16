/**
 * MCP resources, through the tools Codex and opencode use: `list_mcp_resources`,
 * `list_mcp_resource_templates`, and `read_mcp_resource`. They take a `server` argument and cover
 * every connected server with resources, so models trained on those tools use them unchanged.
 *
 * Listings are JSON, as in Codex: `{ server?, resources: [{ server, ...resource }], nextCursor? }`.
 * With a `server`, one page is listed and `cursor` continues it; without, every page of every server.
 * MCP App resources (`ui://` URIs and `profile=mcp-app` HTML) are left out, since they are user
 * interfaces for hosts that render them, and so are icons. Read resources become text and images for
 * the model; binary resources are saved to temp files. Scripts get the JSON payloads.
 */
import type { ListResourcesResult, ListResourceTemplatesResult, McpRequestOptions, ReadResourceResult, Resource, ResourceTemplate } from "@earendil-works/pi-mcp";
import type { TSchema } from "typebox";
import type { ToolDefinition } from "../../core/extensions/types.ts";
import { LIST_MCP_RESOURCE_TEMPLATES_TOOL, LIST_MCP_RESOURCES_TOOL, READ_MCP_RESOURCE_TOOL } from "../../core/mcp-servers.ts";
import type { McpExposure } from "./config.ts";
import { type McpToolDetails } from "./tools.ts";
export { LIST_MCP_RESOURCE_TEMPLATES_TOOL, LIST_MCP_RESOURCES_TOOL, READ_MCP_RESOURCE_TOOL };
/** A connected server that offers resources. */
export interface McpResourceServer {
    name: string;
    timeoutMs: number;
    resourcesPage(cursor: string | undefined, options: McpRequestOptions): Promise<ListResourcesResult>;
    resourceTemplatesPage(cursor: string | undefined, options: McpRequestOptions): Promise<ListResourceTemplatesResult>;
    allResources(options: McpRequestOptions): Promise<Resource[]>;
    allResourceTemplates(options: McpRequestOptions): Promise<ResourceTemplate[]>;
    readResource(uri: string, options: McpRequestOptions): Promise<ReadResourceResult>;
}
/**
 * The three resource tools. `servers` returns the servers whose resources they reach, at call time.
 */
export declare function createMcpResourceToolDefinitions(options: {
    exposure: McpExposure;
    servers: () => readonly McpResourceServer[];
}): ToolDefinition<TSchema, McpToolDetails>[];
//# sourceMappingURL=resources.d.ts.map