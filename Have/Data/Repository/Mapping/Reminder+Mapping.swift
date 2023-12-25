/**
 * Abstract:
 * Extensions for Mapping Reminders
 */

import Foundation

// MARK: - Network to external

extension NetworkReminder {
    /// Mapping the network model to external model.
    func toExternalModel() -> Reminder {
        return Reminder(
            id: self.id,
            title: self.title,
            notes: self.notes,
            dueDate: self.dueDate,
            dueTime: self.dueTime,
            isCompleted: self.isCompleted,
            isFlagged: self.isFlagged,
            reminderListRefId: self.reminderListRefId
        )
    }
}

extension [NetworkReminder] {
    /// Mapping the network models to external models.
    func toExternalModel() -> [Reminder] {
        return self.isEmpty ? [] : self.map { $0.toExternalModel() }
    }
}

// MARK: - External to Network

extension Reminder {
    /// Mapping the external model to network model.
    func toNetworkModel() -> NetworkReminder {
        return NetworkReminder(
            id: self.id,
            title: self.title,
            notes: self.notes,
            dueDate: self.dueDate,
            dueTime: self.dueTime,
            isCompleted: self.isCompleted,
            isFlagged: self.isFlagged,
            reminderListRefId: self.reminderListRefId,
            createdAt: Date()
        )
    }
}

extension [Reminder] {
    /// Mapping the external models to network models.
    func toNetworkModel() -> [NetworkReminder] {
        return self.isEmpty ? [] : self.map { $0.toNetworkModel() }
    }
}
