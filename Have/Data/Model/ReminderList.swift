/**
 * Abstract:
 * Reminder list for grouping reminders.
 */

import UIKit

/// Model class for reminder list.
///
/// - Parameters:
///     - id: id of the reminder list.
///     - name: name of the reminder list.
///     - imageName: image name of the reminder list.
///     - type: Reminder type of the reminder list.
///     - color: color of the reminder list.
///
struct ReminderList: Equatable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var name: String
    var imageName: String = "list.bullet"
    var type: ReminderListType = .userCreated
    var color: UIColor = .systemBlue
    
    var image: UIImage? {
        let configuration = UIImage.SymbolConfiguration(textStyle: .body)
        return UIImage(systemName: imageName, withConfiguration: configuration)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

// MARK: - Reminder list type.

enum ReminderListType {
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
            return reminder.reminderList.id == reminderList.id
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

// TODO: Have to modify after connect the firebase server.

extension [ReminderList] {
    
    func getReminderList(withId id: ReminderList.ID) -> ReminderList {
        guard let index = firstIndex(where: { $0.id == id }) else { fatalError() }
        return self[index]
    }
    
    func getIndex(withId id: ReminderList.ID) -> Int {
        guard let index = firstIndex(where: { $0.id == id }) else { fatalError() }
        return index
    }
}
