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
///
struct Reminder: Equatable, Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var notes: String?
    var dueDate: Date?
    var dueTime: Date?
    var isCompleted: Bool = false
    var isFlagged: Bool = false
}

// TODO: - Delete below code after connecting with Core Data.

#if DEBUG
extension Reminder {
    static var sampleData = [
        Reminder(
            title: "Book Flight Tickets",
            notes: "Check for the best deals and book tickets for the upcoming vacation.",
            dueDate: Date().addingTimeInterval(800.0),
            dueTime: Date().addingTimeInterval(2 * 60 * 60)
        ),
        Reminder(
            title: "Write Blog Post",
            notes: "Draft a blog post on the latest technology trends and innovations.",
            dueDate: Date().addingTimeInterval(14000.0),
            isCompleted: true,
            isFlagged: true
        ),
        Reminder(
            title: "Visit Art Gallery Exhibition",
            notes: "Explore the latest art installations and get inspired by local artists.",
            dueDate: Date().addingTimeInterval(83000.0)
        ),
        Reminder(
            title: "Practice Guitar",
            notes: "Spend at least 30 minutes practicing guitar to improve playing skills.",
            isCompleted: true
        ),
        Reminder(
            title: "Cook New Recipe",
            notes: "Try cooking a new recipe from the recently bought cookbook.",
            dueDate: Date().addingTimeInterval(60000.0),
            dueTime: Date().addingTimeInterval(1 * 60 * 60),
            isFlagged: true
        ),
        Reminder(
            title: "Explore Hiking Trail",
            notes: "Plan a day for hiking and exploring a scenic trail in the nearby national park.",
            dueDate: Date().addingTimeInterval(72000.0),
            isFlagged: true
        ),
        Reminder(
            title: "Learn a Magic Trick",
            notes: "Watch online tutorials and practice a magic trick to surprise friends.",
            isCompleted: true
        ),
        Reminder(
            title: "Stargazing Night",
            notes: "Head to a dark spot away from city lights and enjoy a night of stargazing.",
            dueDate: Date().addingTimeInterval(492500.0),
            dueTime: Date().addingTimeInterval(4 * 60 * 60)
        )
    ]
}

extension [Reminder] {
    func getReminder(withId id: Reminder.ID) -> Reminder {
        guard let index = firstIndex(where: { $0.id == id }) else { fatalError() }
        return self[index]
    }
    
    func getIndex(withId id: Reminder.ID) -> Int {
        guard let index = firstIndex(where: { $0.id == id }) else { fatalError() }
        return index
    }
}
#endif
