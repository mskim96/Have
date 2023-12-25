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
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }
}

extension ReminderList {
    var image: UIImage? {
        let configuration = UIImage.SymbolConfiguration(textStyle: .body)
        return UIImage(systemName: imageName, withConfiguration: configuration)
    }
}

// MARK: - Built in reminder lists.

extension ReminderList {
    
    /// Static built in reminder lists.
    static let builtInReminderLists = [
        ReminderList(
            id: UUID().uuidString,
            name: NSLocalizedString("Today", comment: "Builtin reminder list Today"),
            imageName: "calendar",
            type: .builtInToday
        ),
        ReminderList(
            id: UUID().uuidString,
            name: NSLocalizedString("Flag", comment: "Flag reminder list All"),
            imageName: "flag.fill",
            type: .builtInFlag,
            color: UIColor.systemOrange
        ),
        ReminderList(
            id: UUID().uuidString,
            name: NSLocalizedString("All", comment: "Builtin reminder list All"),
            imageName: "tray.fill",
            type: .builtInAll,
            color: UIColor.label
        ),
        ReminderList(
            id: UUID().uuidString,
            name: NSLocalizedString("Completed", comment: "Builtin reminder list Completed"),
            imageName: "checkmark",
            type: .builtInCompleted,
            color: UIColor.darkGray
        )
    ]
}
