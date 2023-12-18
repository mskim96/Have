/**
 * Abstract:
 * Protocol for the Reminder list in the data layer.
 */

import Foundation

protocol ReminderListRepository {
    
    /// Retrieves the available reminder lists.
    ///
    /// - Returns: available all reminder lists.
    ///
    func getReminderLists() -> [ReminderList]
    
    /// Retrieves reminder list for a specific reminder list.
    ///
    /// - Parameters:
    ///     - id: id of the reminder list.
    ///
    /// - Returns: specific reminder list found by id.
    ///
    func getReminderList(withId id: ReminderList.ID) -> ReminderList
    
    /// Add new reminder list.
    ///
    /// - Parameters:
    ///     - reminderList: New reminder list to be added.
    ///
    func addReminderList(_ reminderList: ReminderList)
    
    /// Update reminder list.
    ///
    ///  - Parameters:
    ///     - reminderList: New reminder list to be updated.
    ///
    func updateReminderList(_ reminderList: ReminderList)
    
    /// Delete reminder list.
    ///
    /// - Parameters:
    ///     - id: id of the reminder list.
    ///
    func deleteReminderList(withId: ReminderList.ID)
    
    /// Retrieves the first user-created reminder list, creating a new one if none exists.
    ///
    /// - Returns: The first user-created reminder list.
    ///
    func getUserCreatedReminderList() -> ReminderList
}
