import Foundation

public enum IdleHandsDeviceCommand: String, Codable, Sendable {
    case status = "device.status"
    case info = "device.info"
}

public enum IdleHandsBatteryState: String, Codable, Sendable {
    case unknown
    case unplugged
    case charging
    case full
}

public enum IdleHandsThermalState: String, Codable, Sendable {
    case nominal
    case fair
    case serious
    case critical
}

public enum IdleHandsNetworkPathStatus: String, Codable, Sendable {
    case satisfied
    case unsatisfied
    case requiresConnection
}

public enum IdleHandsNetworkInterfaceType: String, Codable, Sendable {
    case wifi
    case cellular
    case wired
    case other
}

public struct IdleHandsBatteryStatusPayload: Codable, Sendable, Equatable {
    public var level: Double?
    public var state: IdleHandsBatteryState
    public var lowPowerModeEnabled: Bool

    public init(level: Double?, state: IdleHandsBatteryState, lowPowerModeEnabled: Bool) {
        self.level = level
        self.state = state
        self.lowPowerModeEnabled = lowPowerModeEnabled
    }
}

public struct IdleHandsThermalStatusPayload: Codable, Sendable, Equatable {
    public var state: IdleHandsThermalState

    public init(state: IdleHandsThermalState) {
        self.state = state
    }
}

public struct IdleHandsStorageStatusPayload: Codable, Sendable, Equatable {
    public var totalBytes: Int64
    public var freeBytes: Int64
    public var usedBytes: Int64

    public init(totalBytes: Int64, freeBytes: Int64, usedBytes: Int64) {
        self.totalBytes = totalBytes
        self.freeBytes = freeBytes
        self.usedBytes = usedBytes
    }
}

public struct IdleHandsNetworkStatusPayload: Codable, Sendable, Equatable {
    public var status: IdleHandsNetworkPathStatus
    public var isExpensive: Bool
    public var isConstrained: Bool
    public var interfaces: [IdleHandsNetworkInterfaceType]

    public init(
        status: IdleHandsNetworkPathStatus,
        isExpensive: Bool,
        isConstrained: Bool,
        interfaces: [IdleHandsNetworkInterfaceType])
    {
        self.status = status
        self.isExpensive = isExpensive
        self.isConstrained = isConstrained
        self.interfaces = interfaces
    }
}

public struct IdleHandsDeviceStatusPayload: Codable, Sendable, Equatable {
    public var battery: IdleHandsBatteryStatusPayload
    public var thermal: IdleHandsThermalStatusPayload
    public var storage: IdleHandsStorageStatusPayload
    public var network: IdleHandsNetworkStatusPayload
    public var uptimeSeconds: Double

    public init(
        battery: IdleHandsBatteryStatusPayload,
        thermal: IdleHandsThermalStatusPayload,
        storage: IdleHandsStorageStatusPayload,
        network: IdleHandsNetworkStatusPayload,
        uptimeSeconds: Double)
    {
        self.battery = battery
        self.thermal = thermal
        self.storage = storage
        self.network = network
        self.uptimeSeconds = uptimeSeconds
    }
}

public struct IdleHandsDeviceInfoPayload: Codable, Sendable, Equatable {
    public var deviceName: String
    public var modelIdentifier: String
    public var systemName: String
    public var systemVersion: String
    public var appVersion: String
    public var appBuild: String
    public var locale: String

    public init(
        deviceName: String,
        modelIdentifier: String,
        systemName: String,
        systemVersion: String,
        appVersion: String,
        appBuild: String,
        locale: String)
    {
        self.deviceName = deviceName
        self.modelIdentifier = modelIdentifier
        self.systemName = systemName
        self.systemVersion = systemVersion
        self.appVersion = appVersion
        self.appBuild = appBuild
        self.locale = locale
    }
}
