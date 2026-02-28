import Foundation

public enum IdleHandsLocationMode: String, Codable, Sendable, CaseIterable {
    case off
    case whileUsing
    case always
}
