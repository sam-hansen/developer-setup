#!/usr/bin/env node
/**
 * MCP Server generated from OpenAPI spec for system-operations-api v1.0.0
 * Generated on: 2025-05-10T02:49:01.410Z
 */
/**
 * Server configuration
 */
export declare const SERVER_NAME = "system-operations-api";
export declare const SERVER_VERSION = "1.0.0";
export declare const API_BASE_URL = "";
/**
 * Type definition for cached OAuth tokens
 */
interface TokenCacheEntry {
    token: string;
    expiresAt: number;
}
/**
 * Declare global __oauthTokenCache property for TypeScript
 */
declare global {
    var __oauthTokenCache: Record<string, TokenCacheEntry> | undefined;
}
export {};
