/**
 * Abstract:
 * The type of reminder list
 */

import Foundation

enum ReminderListType: String, Codable {
    case builtInToday
    case builtInFlag
    case builtInAll
    case builtInCompleted
    case userCreated
    
    /// Determines whether a given reminder should be included based on the type of the target reminder list.
    ///
    /// - Parameters:
    ///     - reminder: The reminder to evaluate.
    ///     - reminderList: The target reminder list for comparison.
    ///
    /// - Returns: A boolean indicating whether the reminder should be included in the specific reminder list type.
    ///
    func shouldInclude(reminder: Reminder, reminderList: ReminderList) -> Bool {
        switch self {
        case .builtInToday:
            guard let dueDate = reminder.dueDate else { return false }
            return Locale.current.calendar.isDateInToday(dueDate)
        case .builtInFlag:
            return reminder.isFlagged
        case .builtInAll:
            return true
        case .builtInCompleted:
            return reminder.isCompleted
        case .userCreated:
            return reminder.reminderListRefId == reminderList.id
        }
    }
    
    /// Determines whether a given reminder should be included based on the type of the target reminder list.
    ///
    /// - Parameters:
    ///     - reminder: The reminder to evaluate.
    ///     - reminderList: The target reminder list for comparison.
    ///
    /// - Returns: The count indicating the number of reminders that
    ///            should be included in the specific reminder list type.
    ///
    func numberOfFilteredReminders(reminders: [Reminder], reminderList: ReminderList) -> Int {
        reminders.filter { shouldInclude(reminder: $0, reminderList: reminderList) }.count
    }
}
