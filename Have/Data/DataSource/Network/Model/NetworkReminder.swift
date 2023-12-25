/**
 * Abstract:
 * Reminder model for network layer.
 */

import Foundation
import FirebaseFirestore

/// Model class for a reminder on the network layer.
///
/// - Parameters:
///     - id: id of network reminder list.
///     - title: title of the reminder
///     - notes: note of the reminder
///     - dueDate: due date of the reminder
///     - dueTime: due time of the reminder
///     - isCompleted: whether or not the reminder is completed
///     - isFlagged: whether or not the reminder is flagged.
///     - reminderListRefId: reference id of the ReminderList to which the reminder belongs
///     - createdAt: the timestamp when network reminder was created.
///
struct NetworkReminder: Codable, Identifiable {
    var id: String
    var title: String
    @ExplicitNull var notes: String?
    @ExplicitNull var dueDate: Date?
    @ExplicitNull var dueTime: Date?
    var isCompleted: Bool
    var isFlagged: Bool
    var reminderListRefId: String
    @ServerTimestamp var createdAt: Date?
}
