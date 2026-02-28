/**
 * Adapter to integrate DiscordProgressStream with the message handler.
 * Provides callbacks compatible with GetReplyOptions.
 */

import type { RequestClient } from "@buape/carbon";
import { DiscordProgressStream, type DiscordProgressStreamOptions } from "../progress/index.js";
import type { TurnEndEvent } from "../progress/types.js";

export type ProgressStreamAdapterOptions = DiscordProgressStreamOptions & {
  /** Placeholder message to edit (if available) */
  placeholder?: { id: string } | null;
  /** Channel to send messages to */
  channelId: string;
  /** Discord REST client */
  rest: RequestClient;
  /** Timeout in ms (for finalizeTimeout display) */
  timeoutMs?: number;
};

export type ProgressStreamAdapter = {
  /** The underlying progress stream */
  stream: DiscordProgressStream;
  /** Start tracking progress */
  start: () => Promise<void>;
  /** Stop tracking (but don't finalize) */
  stop: () => void;
  /** Callback for onToolStart events */
  onToolStart: (payload: {
    name?: string;
    phase?: string;
    toolCallId?: string;
    args?: unknown;
  }) => void;
  /** Callback for onToolResult events (add this to replyOptions) */
  onToolResult: (payload: {
    name?: string;
    success?: boolean;
    summary?: string;
    toolCallId?: string;
  }) => void;
  /** Callback for onPartialReply - updates assistant text buffer */
  onPartialReply: (payload: { text?: string }) => void;
  /** Callback for turn end stats */
  onTurnEnd: (stats: TurnEndEvent) => void;
  /** Finalize with success */
  finalize: (finalText: string) => Promise<void>;
  /** Finalize with timeout */
  finalizeTimeout: (partialText?: string) => Promise<void>;
  /** Finalize with error */
  finalizeError: (errorMsg: string) => Promise<void>;
  /** Check if a placeholder message exists */
  hasPlaceholder: () => boolean;
  /** Get the message ID (if created) */
  getMessageId: () => string | undefined;
};

/**
 * Create a progress stream adapter for Discord message handling.
 */
export function createProgressStreamAdapter(
  opts: ProgressStreamAdapterOptions,
): ProgressStreamAdapter {
  const stream = new DiscordProgressStream(opts.placeholder ?? null, opts.channelId, opts.rest, {
    editIntervalMs: opts.editIntervalMs,
    maxChars: opts.maxChars,
    maxToolLines: opts.maxToolLines,
    maxAssistantChars: opts.maxAssistantChars,
    showStats: opts.showStats,
  });

  const hooks = stream.hooks();
  const timeoutMs = opts.timeoutMs;

  // Track tool call IDs to names for result matching
  const toolCallNames = new Map<string, string>();

  return {
    stream,

    start: async () => {
      await stream.start();
    },

    stop: () => {
      stream.stop();
    },

    onToolStart: (payload) => {
      const toolCallId = payload.toolCallId ?? `tool-${Date.now()}`;
      const name = payload.name ?? "tool";

      toolCallNames.set(toolCallId, name);

      hooks.onToolCall?.({
        id: toolCallId,
        name,
        args: payload.args as Record<string, unknown> | undefined,
      });
    },

    onToolResult: (payload) => {
      const toolCallId = payload.toolCallId ?? "";
      const name = payload.name ?? toolCallNames.get(toolCallId) ?? "tool";

      hooks.onToolResult?.({
        id: toolCallId,
        name,
        success: payload.success ?? true,
        summary: payload.summary ?? "done",
      });

      toolCallNames.delete(toolCallId);
    },

    onPartialReply: (payload) => {
      if (payload.text) {
        // The progress stream tracks text internally via onToken
        // But we can also just append to the buffer
        hooks.onToken?.(payload.text);
      }
    },

    onTurnEnd: (stats) => {
      hooks.onTurnEnd?.(stats);
    },

    finalize: async (finalText: string) => {
      await stream.finalize(finalText);
    },

    finalizeTimeout: async (partialText?: string) => {
      await stream.finalizeTimeout(partialText ?? "", timeoutMs);
    },

    finalizeError: async (errorMsg: string) => {
      await stream.finalizeError(errorMsg);
    },

    hasPlaceholder: () => Boolean(opts.placeholder),

    getMessageId: () => {
      // The progress stream doesn't expose messageId directly
      // We'd need to add that if needed
      return undefined;
    },
  };
}
