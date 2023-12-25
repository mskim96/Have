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
    func getReminderLists() async throws -> [ReminderList]
    
    /// Retrieves reminder list for a specific reminder list.
    ///
    /// - Parameters:
    ///     - id: id of the reminder list.
    ///
    /// - Returns: specific reminder list found by id.
    ///
    func getReminderList(withId id: ReminderList.ID) async throws -> ReminderList
    
    /// Add new reminder list.
    ///
    /// - Parameters:
    ///     - reminderList: New reminder list to be added.
    ///
    /// - Returns: the added reminder list's id.
    ///
    func addReminderList(_ reminderList: ReminderList) async throws
    
    /// Update reminder list.
    ///
    ///  - Parameters:
    ///     - reminderList: New reminder list to be updated.
    ///
    func updateReminderList(_ reminderList: ReminderList) async throws
    
    /// Delete reminder list.
    ///
    /// - Parameters:
    ///     - id: id of the reminder list.
    ///
    func deleteReminderList(withId id: ReminderList.ID) async throws
    
    /// Retrieves the first user-created reminder list, creating a new one if none exists.
    ///
    /// - Returns: The first user-created reminder list.
    ///
    func getUserCreatedReminderList() async throws -> ReminderList
}
