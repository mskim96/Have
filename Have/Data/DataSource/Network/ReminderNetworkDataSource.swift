/**
 * Abstract:
 *
 */

import Foundation

protocol ReminderNetworkDataSource {
    
    func getReminders() async throws -> [NetworkReminder]
    
    func getReminder(withId id: NetworkReminder.ID) async throws -> NetworkReminder
    
    func insertReminder(_ reminder: NetworkReminder) async throws
    
    func updateReminder(_ reminder: NetworkReminder) async throws
    
    func updateCompleted(withId id: NetworkReminder.ID) async throws
    
    func updateFlagged(withId id: NetworkReminder.ID) async throws
    
    func deleteReminder(withId id: NetworkReminder.ID) async throws
    
    func deleteReminder(withReminderListRef refId: NetworkReminderList.ID) async throws
}
