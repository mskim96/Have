/**
 * Abstract - Actions related to Reminders.
 */

import UIKit

extension RemindersViewController {
    
    /// Called when the user click the complete button.
    @objc func didPressCompletedButton(_ sender: ReminderCompleteButton) {
        guard let id = sender.id else { return }
        completedReminder(withId: id)
    }
    
    /// called when the user clicks the complete button.
    @objc func didPressAddReminderButton(_ sender: AddReminderButton) {
        let reminder = Reminder(title: "")
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.addReminder(reminder)
            self?.updateSnapshot()
        }
        viewController.isAddingNewReminder = true
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
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

// MARK: - Swipe actions

extension RemindersViewController {
    
    /// Configure a swipe action for delete a reminder.
    ///
    /// - Parameters:
    ///     - id: The identifier of the reminder
    ///
    func configureDeleteAction(withId id: Reminder.ID) -> UIContextualAction {
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action button title")
        
        return UIContextualAction(style: .destructive, title: deleteActionTitle) {
            [weak self] _, _, completion in
            self?.deleteReminder(withId: id)
            self?.updateSnapshot()
            completion(false)
        }
    }
    
    /// Configure a swipe action for navigate to the reminder view controller.
    ///
    /// - Parameters:
    ///     - id: The identifier of the reminder
    ///
    func configurDetailAction(withId id: Reminder.ID) -> UIContextualAction {
        let detailActionTitle = NSLocalizedString("Detail", comment: "Detail action button title")
        
        return UIContextualAction(style: .normal, title: detailActionTitle) {
            [weak self] _, _, completion in
            self?.navigateToReminderViewController(withId: id)
            completion(false)
        }
    }
    
    /// Configure a swipe action for flagging a reminder.
    ///
    /// - Parameters:
    ///     - id: The identifier of the reminder
    ///
    func configureFlagAction(withId id: Reminder.ID) -> UIContextualAction {
        let flagActionTitle = NSLocalizedString("Flag", comment: "Flag action button title")
        
        let flagAction = UIContextualAction(style: .normal, title: flagActionTitle) {
            [weak self] _, _, completion in
            self?.flagReminder(withId: id)
            // Using ** completion(true) ** indicates that we want to trigger the collapse animation
            // when the user clicks complete.
            completion(true)
        }
        flagAction.backgroundColor = .systemOrange
        
        return flagAction
    }
}
