import Foundation

public enum IdleHandsRemindersCommand: String, Codable, Sendable {
    case list = "reminders.list"
    case add = "reminders.add"
}

public enum IdleHandsReminderStatusFilter: String, Codable, Sendable {
    case incomplete
    case completed
    case all
}

public struct IdleHandsRemindersListParams: Codable, Sendable, Equatable {
    public var status: IdleHandsReminderStatusFilter?
    public var limit: Int?

    public init(status: IdleHandsReminderStatusFilter? = nil, limit: Int? = nil) {
        self.status = status
        self.limit = limit
    }
}

public struct IdleHandsRemindersAddParams: Codable, Sendable, Equatable {
    public var title: String
    public var dueISO: String?
    public var notes: String?
    public var listId: String?
    public var listName: String?

    public init(
        title: String,
        dueISO: String? = nil,
        notes: String? = nil,
        listId: String? = nil,
        listName: String? = nil)
    {
        self.title = title
        self.dueISO = dueISO
        self.notes = notes
        self.listId = listId
        self.listName = listName
    }
}

public struct IdleHandsReminderPayload: Codable, Sendable, Equatable {
    public var identifier: String
    public var title: String
    public var dueISO: String?
    public var completed: Bool
    public var listName: String?

    public init(
        identifier: String,
        title: String,
        dueISO: String? = nil,
        completed: Bool,
        listName: String? = nil)
    {
        self.identifier = identifier
        self.title = title
        self.dueISO = dueISO
        self.completed = completed
        self.listName = listName
    }
}

public struct IdleHandsRemindersListPayload: Codable, Sendable, Equatable {
    public var reminders: [IdleHandsReminderPayload]

    public init(reminders: [IdleHandsReminderPayload]) {
        self.reminders = reminders
    }
}

public struct IdleHandsRemindersAddPayload: Codable, Sendable, Equatable {
    public var reminder: IdleHandsReminderPayload

    public init(reminder: IdleHandsReminderPayload) {
        self.reminder = reminder
    }
}
