import UIKit

extension RemindersViewController {
    @objc func didPressCompletedButton(_ sender: ReminderCompleteButton) {
        guard let id = sender.id else { return }
        completedReminder(withId: id)
    }
}
