/**
 * Progress message renderer - builds Discord markdown from progress state.
 * Adapted from IdleHands.
 */

import type { ProgressSnapshot } from "./types.js";

export type RenderOptions = {
  /** Max characters for Discord message (default: 1900) */
  maxChars?: number;
  /** Max tool lines to show (default: 8) */
  maxToolLines?: number;
  /** Max assistant preview chars (default: 1200) */
  maxAssistantChars?: number;
};

function escapeCodeFence(s: string): string {
  return String(s ?? "").replace(/```/g, "``\u200b`");
}

function clipEnd(s: string, maxChars: number): string {
  const t = String(s ?? "").trim();
  if (maxChars <= 0) {
    return "";
  }
  if (t.length <= maxChars) {
    return t;
  }
  return "…" + t.slice(t.length - (maxChars - 1));
}

function tail<T>(arr: T[], n: number): T[] {
  if (!Array.isArray(arr) || n <= 0) {
    return [];
  }
  return arr.length <= n ? arr : arr.slice(arr.length - n);
}

export type ProgressRenderInput = {
  /** Banner text (e.g., warnings) */
  banner?: string | null;
  /** Progress snapshot from TurnProgressController */
  snapshot: ProgressSnapshot;
  /** Accumulated assistant markdown text */
  assistantText?: string;
  /** Optional tool output tail */
  toolTail?: {
    stream: "stdout" | "stderr";
    lines: string[];
  } | null;
};

export function renderProgressMarkdown(input: ProgressRenderInput, opts?: RenderOptions): string {
  const maxChars = opts?.maxChars ?? 1900;
  const maxToolLines = opts?.maxToolLines ?? 8;
  const maxAssistantChars = opts?.maxAssistantChars ?? 1200;

  const parts: string[] = [];
  let usedChars = 0;

  const addPart = (text: string, separator = "\n\n"): boolean => {
    const sep = parts.length ? separator : "";
    const chunk = sep + text;
    if (usedChars + chunk.length > maxChars) {
      return false;
    }
    parts.push(chunk);
    usedChars += chunk.length;
    return true;
  };

  // Banner (if any)
  const banner = input.banner?.trim();
  if (banner) {
    addPart(`**${banner}**`);
  }

  // Status line
  const status = input.snapshot.statusLine?.trim();
  if (status) {
    addPart(`*${status}*`);
  } else {
    addPart("*⏳ Thinking...*");
  }

  // Tool lines block (code block for monospace)
  const toolLines = tail((input.snapshot.toolLines ?? []).filter(Boolean), maxToolLines);
  if (toolLines.length > 0) {
    const toolBlock = "```\n" + escapeCodeFence(toolLines.join("\n")) + "\n```";
    addPart(toolBlock);
  }

  // Tool output tail (for exec commands showing stdout/stderr)
  if (input.toolTail && input.toolTail.lines.length > 0) {
    const tailLines = tail(input.toolTail.lines, 4);
    const label = `↳ ${input.toolTail.stream}`;
    const tailBlock = `*${label}*\n\`\`\`\n${escapeCodeFence(tailLines.join("\n"))}\n\`\`\``;
    addPart(tailBlock);
  }

  // Assistant text preview
  const assistant = input.assistantText?.trim();
  if (assistant) {
    const clipped = clipEnd(assistant, maxAssistantChars);
    addPart(clipped);
  }

  let result = parts.join("");

  // Final safety truncation
  if (result.length > maxChars) {
    result = result.slice(0, maxChars - 1) + "…";
  }

  return result || "*⏳ Thinking...*";
}

/**
 * Render final message with tool history + final response.
 * Used when the run completes.
 */
export function renderFinalMessage(
  toolLines: string[],
  finalText: string,
  opts?: { maxChars?: number; maxToolLines?: number },
): string {
  const maxChars = opts?.maxChars ?? 1900;
  const maxToolLines = opts?.maxToolLines ?? 8;

  const parts: string[] = [];

  // Keep last N tool lines
  const keptLines = tail(toolLines.filter(Boolean), maxToolLines);
  if (keptLines.length > 0) {
    parts.push("```\n" + escapeCodeFence(keptLines.join("\n")) + "\n```");
  }

  // Final text
  const final = finalText?.trim();
  if (final) {
    parts.push(final);
  } else {
    parts.push("*(no response)*");
  }

  let result = parts.join("\n\n");

  if (result.length > maxChars) {
    result = result.slice(0, maxChars - 1) + "…";
  }

  return result;
}
