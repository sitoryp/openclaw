import { beforeEach, describe, expect, it, vi } from "vitest";
import type { IdleHandsConfig } from "../../config/config.js";

const mocks = vi.hoisted(() => ({
  loadSessionStore: vi.fn(),
  resolveStorePath: vi.fn(),
}));

vi.mock("../../config/sessions.js", async () => {
  const actual = await vi.importActual<typeof import("../../config/sessions.js")>(
    "../../config/sessions.js",
  );
  return {
    ...actual,
    loadSessionStore: mocks.loadSessionStore,
    resolveStorePath: mocks.resolveStorePath,
  };
});

const { resolveSessionKeyForRequest } = await import("./session.js");

describe("resolveSessionKeyForRequest", () => {
  const MAIN_STORE_PATH = "/tmp/main-store.json";

  beforeEach(() => {
    vi.clearAllMocks();
    mocks.resolveStorePath.mockReturnValue(MAIN_STORE_PATH);
  });

  const baseCfg: IdleHandsConfig = {};

  it("returns sessionKey when --to resolves a session key via context", async () => {
    mocks.loadSessionStore.mockReturnValue({
      "agent:main:main": { sessionId: "sess-1", updatedAt: 0 },
    });

    const result = resolveSessionKeyForRequest({
      cfg: baseCfg,
      to: "+15551234567",
    });
    expect(result.sessionKey).toBe("agent:main:main");
  });

  it("does not reverse-lookup by --session-id", async () => {
    mocks.loadSessionStore.mockReturnValue({
      "agent:main:main": { sessionId: "target-session-id", updatedAt: 0 },
    });

    const result = resolveSessionKeyForRequest({
      cfg: baseCfg,
      sessionId: "target-session-id",
    });
    expect(result.sessionKey).toBeUndefined();
  });

  it("keeps --to-derived key even when --session-id differs", async () => {
    mocks.loadSessionStore.mockReturnValue({
      "agent:main:main": { sessionId: "other-session-id", updatedAt: 0 },
    });

    const result = resolveSessionKeyForRequest({
      cfg: baseCfg,
      to: "+15551234567",
      sessionId: "target-session-id",
    });
    expect(result.sessionKey).toBe("agent:main:main");
    expect(result.storePath).toBe(MAIN_STORE_PATH);
  });

  it("still honors explicit sessionKey", async () => {
    mocks.loadSessionStore.mockReturnValue({
      "agent:main:main": { sessionId: "other-id", updatedAt: 0 },
    });

    const result = resolveSessionKeyForRequest({
      cfg: baseCfg,
      sessionKey: "agent:main:main",
      sessionId: "target-session-id",
    });
    expect(result.sessionKey).toBe("agent:main:main");
  });
});
