/**
 * Abstract:
 * Implement ReminderListRepository for mock test.
 */

import UIKit

class ReminderListMockRepository {
    
    static let mock = ReminderListMockRepository()
    
    func getReminderLists() -> [ReminderList] {
        return sampleReminderLists
    }
    
    func getReminderList(withId id: ReminderList.ID) -> ReminderList {
        let index = sampleReminderLists.firstIndex(where: { $0.id == id })
        if let index = index {
            return sampleReminderLists[index]
        } else {
            fatalError()
        }
    }
    
    func addReminderList(_ reminderList: ReminderList) {
        sampleReminderLists.append(reminderList)
    }
    
    func updateReminderList(_ reminderList: ReminderList) {
        let index = sampleReminderLists.firstIndex(where: { $0.id == reminderList.id })
        if let index = index {
            sampleReminderLists[index] = reminderList
        } else {
            fatalError()
        }
    }
    
    func deleteReminderList(withId id: ReminderList.ID) {
        let index = sampleReminderLists.firstIndex(where: { $0.id == id })
        if let index = index {
            sampleReminderLists.remove(at: index)
        } else {
            fatalError()
        }
    }
    
    func getUserCreatedReminderList() -> ReminderList {
        let firstUserCreateReminderList = getReminderLists().first(where: { $0.type == .userCreated})
        if let reminderList = firstUserCreateReminderList {
            return reminderList
        } else {
            let newUserCreatedReminderList =
            ReminderList(name: NSLocalizedString("Reminders", comment: "Default user-created reminder list name"))
            addReminderList(newUserCreatedReminderList)
            return newUserCreatedReminderList
        }
    }
    
    var sampleDefaultReminderList = ReminderList(name: "Reminders")
    private var sampleReminderLists: [ReminderList]
    
    private init() {
        sampleReminderLists = [
            ReminderList(
                name: NSLocalizedString("Today", comment: "Builtin reminder list Today"),
                imageName: "calendar",
                type: .builtInToday
            ),
            ReminderList(
                name: NSLocalizedString("Flag", comment: "Flag reminder list All"),
                imageName: "flag.fill",
                type: .builtInFlag,
                color: UIColor.systemOrange
            ),
            ReminderList(
                name: NSLocalizedString("All", comment: "Builtin reminder list All"),
                imageName: "tray.fill",
                type: .builtInAll,
                color: UIColor.label
            ),
            ReminderList(
                name: NSLocalizedString("Completed", comment: "Builtin reminder list Completed"),
                imageName: "checkmark",
                type: .builtInCompleted,
                color: UIColor.darkGray
            ),
            self.sampleDefaultReminderList
        ]
    }
}
