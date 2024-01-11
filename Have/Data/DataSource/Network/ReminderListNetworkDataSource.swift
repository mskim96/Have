/**
 * Abstract:
 * Protocol for Reminder List Network datasource.
 */

import Foundation

protocol ReminderListNetworkDataSource {
    
    func getReminderLists() async throws -> [NetworkReminderList]
    
    func getReminderList(withId id: NetworkReminder.ID) async throws -> NetworkReminderList
    
    func insertReminderList(_ reminderList: NetworkReminderList) async throws
    
    func updateReminderList(_ reminderList: NetworkReminderList) async throws
    
    func deleteReminderList(withId id: NetworkReminder.ID) async throws
}
