/**
 * Abstract:
 * Reminder model class for unit of task.
 */

import Foundation

/// Model class for a Reminder.
///
/// - Parameters:
///     - id: id of the reminder
///     - title: title of the reminder
///     - notes: note of the reminder
///     - dueDate: due date of the reminder
///     - dueTime: due time of the reminder
///     - isCompleted: whether or not the reminder is completed
///     - isFlagged: whether or not the reminder is flagged.
///     - reminderListRefID: reference id of the ReminderList to which the reminder belongs
struct Reminder: Equatable, Identifiable, Hashable {
    var id: String = UUID().uuidString
    var title: String
    var notes: String?
    var dueDate: Date?
    var dueTime: Date?
    var isCompleted: Bool = false
    var isFlagged: Bool = false
    var reminderListRefId: String
}
