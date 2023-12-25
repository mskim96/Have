/**
 * Abstract:
 * Implemention of ReminderRepository.
 */

import Foundation

class DefaultReminderRepository: ReminderRepository {
    
    private let reminderDataSource: ReminderNetworkDataSource = DefaultReminderNetworkDataSource()
    
    func getReminders() async throws -> [Reminder] {
        return try await reminderDataSource.getReminders().toExternalModel()
    }
    
    func getReminder(withId id: Reminder.ID) async throws -> Reminder {
        return try await reminderDataSource.getReminder(withId: id).toExternalModel()
    }
    
    func addReminder(_ reminder: Reminder) async throws {
        try await reminderDataSource.insertReminder(reminder.toNetworkModel())
    }
    
    func updateReminder(_ reminder: Reminder) async throws {
        try await reminderDataSource.updateReminder(reminder.toNetworkModel())
    }
    
    func completeReminder(withId id: Reminder.ID) async throws {
        try await reminderDataSource.updateCompleted(withId: id)
    }
    
    func flagReminder(withId id: Reminder.ID) async throws {
        try await reminderDataSource.updateFlagged(withId: id)
    }
    
    func deleteReminder(withId id: Reminder.ID) async throws {
        try await reminderDataSource.deleteReminder(withId: id)
    }
    
    func deleteReminders(withReminderListRef refId: ReminderList.ID) async throws {
        try await reminderDataSource.deleteReminder(withReminderListRef: refId)
    }
}
