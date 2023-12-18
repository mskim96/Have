/**
 * Abstract:
 * Implement ReminderRepository for mock test.
 */

import Foundation

class ReminderMockRepository: ReminderRepository {
    
    static let mock = ReminderMockRepository()
    
    func getReminders() -> [Reminder] {
        return sampleData
    }
    
    func getReminder(withId id: Reminder.ID) -> Reminder {
        return sampleData.getReminder(withId: id)
    }
    
    func addReminder(_ reminder: Reminder) {
        sampleData.append(reminder)
    }
    
    func updateReminder(_ reminder: Reminder) {
        let index = sampleData.getIndex(withId: reminder.id)
        sampleData[index] = reminder
    }
    
    func completeReminder(withId id: Reminder.ID) {
        var reminder = sampleData.getReminder(withId: id)
        reminder.isCompleted.toggle()
        updateReminder(reminder)
    }
    
    func flagReminder(withId id: Reminder.ID) {
        var reminder = sampleData.getReminder(withId: id)
        reminder.isFlagged.toggle()
        updateReminder(reminder)
    }
    
    func deleteReminder(withId id: Reminder.ID) {
        let index = sampleData.getIndex(withId: id)
        sampleData.remove(at: index)
    }
    
    func deleteReminder(withReminderList reminderList: ReminderList) {
        sampleData = sampleData.filter { $0.reminderList.id != reminderList.id }
    }
    
    private var sampleData = [
        Reminder(
            title: "Book Flight Tickets",
            notes: "Check for the best deals and book tickets for the upcoming vacation.",
            dueDate: Date().addingTimeInterval(800.0),
            dueTime: Date().addingTimeInterval(2 * 60 * 60),
            reminderList: ReminderListMockRepository.mock.sampleDefaultReminderList
        ),
        Reminder(
            title: "Write Blog Post",
            notes: "Draft a blog post on the latest technology trends and innovations.",
            dueDate: Date().addingTimeInterval(14000.0),
            isCompleted: true,
            isFlagged: true,
            reminderList: ReminderListMockRepository.mock.sampleDefaultReminderList
        ),
        Reminder(
            title: "Visit Art Gallery Exhibition",
            notes: "Explore the latest art installations and get inspired by local artists.",
            dueDate: Date().addingTimeInterval(83000.0),
            reminderList: ReminderListMockRepository.mock.sampleDefaultReminderList
        ),
        Reminder(
            title: "Practice Guitar",
            notes: "Spend at least 30 minutes practicing guitar to improve playing skills.",
            isCompleted: true,
            reminderList: ReminderListMockRepository.mock.sampleDefaultReminderList
        ),
        Reminder(
            title: "Cook New Recipe",
            notes: "Try cooking a new recipe from the recently bought cookbook.",
            dueDate: Date().addingTimeInterval(60000.0),
            dueTime: Date().addingTimeInterval(1 * 60 * 60),
            isFlagged: true,
            reminderList: ReminderListMockRepository.mock.sampleDefaultReminderList
        ),
        Reminder(
            title: "Explore Hiking Trail",
            notes: "Plan a day for hiking and exploring a scenic trail in the nearby national park.",
            dueDate: Date().addingTimeInterval(72000.0),
            isFlagged: true,
            reminderList: ReminderListMockRepository.mock.sampleDefaultReminderList
        ),
        Reminder(
            title: "Learn a Magic Trick",
            notes: "Watch online tutorials and practice a magic trick to surprise friends.",
            isCompleted: true,
            reminderList: ReminderListMockRepository.mock.sampleDefaultReminderList
        ),
        Reminder(
            title: "Stargazing Night",
            notes: "Head to a dark spot away from city lights and enjoy a night of stargazing.",
            dueDate: Date().addingTimeInterval(492500.0),
            dueTime: Date().addingTimeInterval(4 * 60 * 60),
            reminderList: ReminderListMockRepository.mock.sampleDefaultReminderList
        )
    ]
    
    private init() { }
}
