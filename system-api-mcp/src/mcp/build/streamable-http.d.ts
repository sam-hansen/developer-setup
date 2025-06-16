/**
 * StreamableHTTP server setup for HTTP-based MCP communication using Hono
 */
import { Hono } from 'hono';
import { Server } from "@modelcontextprotocol/sdk/server/index.js";
/**
 * Sets up a web server for the MCP server using StreamableHTTP transport
 *
 * @param server The MCP Server instance
 * @param port The port to listen on (default: 3000)
 * @returns The Hono app instance
 */
export declare function setupStreamableHttpServer(server: Server, port?: number): Promise<Hono<import("hono/types").BlankEnv, import("hono/types").BlankSchema, "/">>;
