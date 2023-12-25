/**
 * Abstract:
 * Implementation of ReminderListRepository.
 */

import Foundation

class DefaultReminderListRepository: ReminderListRepository {
    
    private let reminderListDataSource: ReminderListNetworkDataSource = DefaultReminderListNetworkDataSource()
    
    func getReminderLists() async throws -> [ReminderList] {
        let getReminderLists = try await reminderListDataSource.getReminderLists().toExternalModel()
        return ReminderList.builtInReminderLists + getReminderLists
    }
    
    func getReminderList(withId id: ReminderList.ID) async throws -> ReminderList {
        return try await reminderListDataSource.getReminderList(withId: id).toExternalModel()
    }
    
    func addReminderList(_ reminderList: ReminderList) async throws {
        try await reminderListDataSource.insertReminderList(reminderList.toNetworkModel())
    }
    
    func deleteReminderList(withId id: ReminderList.ID) async throws {
        try await reminderListDataSource.deleteReminderList(withId: id)
    }
    
    func updateReminderList(_ reminderList: ReminderList) async throws {
        try await reminderListDataSource.updateReminderList(reminderList.toNetworkModel())
    }
    
    func getUserCreatedReminderList() async throws -> ReminderList {
        let userCreatedReminderList = try await getReminderLists().first(where: { $0.type == .userCreated })
        if let userCreatedReminderList = userCreatedReminderList {
            return userCreatedReminderList
        } else {
            let newReminderList = ReminderList(
                name: NSLocalizedString("Reminders", comment: "Default user-created reminder list name")
            )
            try await addReminderList(newReminderList)
            return newReminderList
        }
    }
}
