import Foundation

public enum IdleHandsChatTransportEvent: Sendable {
    case health(ok: Bool)
    case tick
    case chat(IdleHandsChatEventPayload)
    case agent(IdleHandsAgentEventPayload)
    case seqGap
}

public protocol IdleHandsChatTransport: Sendable {
    func requestHistory(sessionKey: String) async throws -> IdleHandsChatHistoryPayload
    func sendMessage(
        sessionKey: String,
        message: String,
        thinking: String,
        idempotencyKey: String,
        attachments: [IdleHandsChatAttachmentPayload]) async throws -> IdleHandsChatSendResponse

    func abortRun(sessionKey: String, runId: String) async throws
    func listSessions(limit: Int?) async throws -> IdleHandsChatSessionsListResponse

    func requestHealth(timeoutMs: Int) async throws -> Bool
    func events() -> AsyncStream<IdleHandsChatTransportEvent>

    func setActiveSessionKey(_ sessionKey: String) async throws
}

extension IdleHandsChatTransport {
    public func setActiveSessionKey(_: String) async throws {}

    public func abortRun(sessionKey _: String, runId _: String) async throws {
        throw NSError(
            domain: "IdleHandsChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "chat.abort not supported by this transport"])
    }

    public func listSessions(limit _: Int?) async throws -> IdleHandsChatSessionsListResponse {
        throw NSError(
            domain: "IdleHandsChatTransport",
            code: 0,
            userInfo: [NSLocalizedDescriptionKey: "sessions.list not supported by this transport"])
    }
}
