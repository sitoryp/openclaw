import Foundation

public enum IdleHandsCameraCommand: String, Codable, Sendable {
    case list = "camera.list"
    case snap = "camera.snap"
    case clip = "camera.clip"
}

public enum IdleHandsCameraFacing: String, Codable, Sendable {
    case back
    case front
}

public enum IdleHandsCameraImageFormat: String, Codable, Sendable {
    case jpg
    case jpeg
}

public enum IdleHandsCameraVideoFormat: String, Codable, Sendable {
    case mp4
}

public struct IdleHandsCameraSnapParams: Codable, Sendable, Equatable {
    public var facing: IdleHandsCameraFacing?
    public var maxWidth: Int?
    public var quality: Double?
    public var format: IdleHandsCameraImageFormat?
    public var deviceId: String?
    public var delayMs: Int?

    public init(
        facing: IdleHandsCameraFacing? = nil,
        maxWidth: Int? = nil,
        quality: Double? = nil,
        format: IdleHandsCameraImageFormat? = nil,
        deviceId: String? = nil,
        delayMs: Int? = nil)
    {
        self.facing = facing
        self.maxWidth = maxWidth
        self.quality = quality
        self.format = format
        self.deviceId = deviceId
        self.delayMs = delayMs
    }
}

public struct IdleHandsCameraClipParams: Codable, Sendable, Equatable {
    public var facing: IdleHandsCameraFacing?
    public var durationMs: Int?
    public var includeAudio: Bool?
    public var format: IdleHandsCameraVideoFormat?
    public var deviceId: String?

    public init(
        facing: IdleHandsCameraFacing? = nil,
        durationMs: Int? = nil,
        includeAudio: Bool? = nil,
        format: IdleHandsCameraVideoFormat? = nil,
        deviceId: String? = nil)
    {
        self.facing = facing
        self.durationMs = durationMs
        self.includeAudio = includeAudio
        self.format = format
        self.deviceId = deviceId
    }
}
