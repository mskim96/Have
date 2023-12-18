/**
 * Abstract:
 * Protocol for the Reminder in the data layer.
 */

import Foundation

protocol ReminderRepository {
    
    /// Retrieves the avaliable reminders.
    ///
    /// - Returns: available all reminders.
    ///
    func getReminders() -> [Reminder]
    
    /// Retrieves a specific reminder using its id.
    ///
    /// - Parameters:
    ///   - id: id of the reminder.
    ///
    /// - Returns: The reminder with the id.
    ///
    func getReminder(withId id: Reminder.ID) -> Reminder
    
    /// Add new reminder.
    ///
    /// - Parameters:
    ///     - reminder: New reminder to be added.
    ///
    func addReminder(_ reminder: Reminder)
    
    /// Update reminder.
    ///
    /// - Parameters:
    ///     - reminder: New reminder to be updated.
    ///
    func updateReminder(_ reminder: Reminder)
    
    /// Update reminder to be completed state.
    ///
    /// Toggles the complete state of the reminder if it's already completed.
    ///
    /// - Parameters:
    ///     - id: id of the reminder to be update to the complete state
    func completeReminder(withId id: Reminder.ID)
    
    /// Update reminder to be flagged state.
    ///
    /// Toggles the flag state of the reminder if it's already flagged.
    ///
    /// - Parameters:
    ///     - id: id of the reminder to be update to the flag.
    ///
    func flagReminder(withId id: Reminder.ID)
    
    /// Delete reminder.
    ///
    /// - Parameters:
    ///     - id: id of the reminder.
    ///
    func deleteReminder(withId id: Reminder.ID)
    
    /// Deletes all reminders with a specific reminder type associated with the given reminder list.
    ///
    /// - Parameters:
    ///   - reminderList: The reminder list for which reminders with a specific type should be deleted.
    ///
    func deleteReminder(withReminderList reminderList: ReminderList)
}
