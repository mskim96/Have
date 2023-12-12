import UIKit

extension RemindersViewController {
    
    /// Called when the user click the complete button.
    @objc func didPressCompletedButton(_ sender: ReminderCompleteButton) {
        guard let id = sender.id else { return }
        completedReminder(withId: id)
    }
    
    /// Present the reminder detail view controller modally.
    ///
    /// - Parameters:
    ///     - id: Reminder id for navigate reminder detail view controller.
    ///
    func navigateToReminderViewController(withId id: Reminder.ID) {
        let reminder = reminders.getReminder(withId: id)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.updateReminder(reminder)
            self?.updateSnapshot(reloading: [reminder.id])
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
}
