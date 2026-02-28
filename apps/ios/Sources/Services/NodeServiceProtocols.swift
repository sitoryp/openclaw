import CoreLocation
import Foundation
import IdleHandsKit
import UIKit

typealias IdleHandsCameraSnapResult = (format: String, base64: String, width: Int, height: Int)
typealias IdleHandsCameraClipResult = (format: String, base64: String, durationMs: Int, hasAudio: Bool)

protocol CameraServicing: Sendable {
    func listDevices() async -> [CameraController.CameraDeviceInfo]
    func snap(params: IdleHandsCameraSnapParams) async throws -> IdleHandsCameraSnapResult
    func clip(params: IdleHandsCameraClipParams) async throws -> IdleHandsCameraClipResult
}

protocol ScreenRecordingServicing: Sendable {
    func record(
        screenIndex: Int?,
        durationMs: Int?,
        fps: Double?,
        includeAudio: Bool?,
        outPath: String?) async throws -> String
}

@MainActor
protocol LocationServicing: Sendable {
    func authorizationStatus() -> CLAuthorizationStatus
    func accuracyAuthorization() -> CLAccuracyAuthorization
    func ensureAuthorization(mode: IdleHandsLocationMode) async -> CLAuthorizationStatus
    func currentLocation(
        params: IdleHandsLocationGetParams,
        desiredAccuracy: IdleHandsLocationAccuracy,
        maxAgeMs: Int?,
        timeoutMs: Int?) async throws -> CLLocation
    func startLocationUpdates(
        desiredAccuracy: IdleHandsLocationAccuracy,
        significantChangesOnly: Bool) -> AsyncStream<CLLocation>
    func stopLocationUpdates()
    func startMonitoringSignificantLocationChanges(onUpdate: @escaping @Sendable (CLLocation) -> Void)
    func stopMonitoringSignificantLocationChanges()
}

protocol DeviceStatusServicing: Sendable {
    func status() async throws -> IdleHandsDeviceStatusPayload
    func info() -> IdleHandsDeviceInfoPayload
}

protocol PhotosServicing: Sendable {
    func latest(params: IdleHandsPhotosLatestParams) async throws -> IdleHandsPhotosLatestPayload
}

protocol ContactsServicing: Sendable {
    func search(params: IdleHandsContactsSearchParams) async throws -> IdleHandsContactsSearchPayload
    func add(params: IdleHandsContactsAddParams) async throws -> IdleHandsContactsAddPayload
}

protocol CalendarServicing: Sendable {
    func events(params: IdleHandsCalendarEventsParams) async throws -> IdleHandsCalendarEventsPayload
    func add(params: IdleHandsCalendarAddParams) async throws -> IdleHandsCalendarAddPayload
}

protocol RemindersServicing: Sendable {
    func list(params: IdleHandsRemindersListParams) async throws -> IdleHandsRemindersListPayload
    func add(params: IdleHandsRemindersAddParams) async throws -> IdleHandsRemindersAddPayload
}

protocol MotionServicing: Sendable {
    func activities(params: IdleHandsMotionActivityParams) async throws -> IdleHandsMotionActivityPayload
    func pedometer(params: IdleHandsPedometerParams) async throws -> IdleHandsPedometerPayload
}

struct WatchMessagingStatus: Sendable, Equatable {
    var supported: Bool
    var paired: Bool
    var appInstalled: Bool
    var reachable: Bool
    var activationState: String
}

struct WatchQuickReplyEvent: Sendable, Equatable {
    var replyId: String
    var promptId: String
    var actionId: String
    var actionLabel: String?
    var sessionKey: String?
    var note: String?
    var sentAtMs: Int?
    var transport: String
}

struct WatchNotificationSendResult: Sendable, Equatable {
    var deliveredImmediately: Bool
    var queuedForDelivery: Bool
    var transport: String
}

protocol WatchMessagingServicing: AnyObject, Sendable {
    func status() async -> WatchMessagingStatus
    func setReplyHandler(_ handler: (@Sendable (WatchQuickReplyEvent) -> Void)?)
    func sendNotification(
        id: String,
        params: IdleHandsWatchNotifyParams) async throws -> WatchNotificationSendResult
}

extension CameraController: CameraServicing {}
extension ScreenRecordService: ScreenRecordingServicing {}
extension LocationService: LocationServicing {}
