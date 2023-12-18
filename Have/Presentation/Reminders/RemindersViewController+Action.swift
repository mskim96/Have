/**
 * Abstract:
 * Actions related to Reminders.
 */

import UIKit

extension RemindersViewController {
    
    /// Called when the user click the complete button.
    @objc func didPressCompletedButton(_ sender: ReminderCompleteButton) {
        guard let id = sender.id else { return }
        completedReminder(withId: id)
    }
    
    /// Called when the user clicks the complete button.
    @objc func didPressAddReminderButton(_ sender: AddReminderButton) {
        let setReminderList = reminderListRepository.getUserCreatedReminderList()
        let reminder = Reminder(title: "", reminderList: setReminderList)
        let viewController = ReminderViewController(reminder: reminder) { [weak self] reminder in
            self?.addReminder(reminder)
            self?.updateSnapshot()
        }
        viewController.isAddingNewReminder = true
        viewController.fromReminderListType = reminderList.type
        
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    /// Present the reminder detail view controller modally.
    ///
    /// - Parameters:
    ///     - id: Reminder id for navigate reminder detail view controller.
    ///
    func navigateToReminderViewController(withId id: Reminder.ID) {
        let currentReminder = reminderRepository.getReminder(withId: id)
        let viewController = ReminderViewController(reminder: currentReminder) { [weak self] reminder in
            guard let self = self else { return }
            self.updateReminder(reminder)
            // Compare the `id` of the current reminder's reminder list with
            // the `id` of the callback reminder's reminder list.
            if currentReminder.reminderList.id != reminder.reminderList.id {
                // If the list changed, attempting to reload when the current reminder is no longer
                // preset in Reminders will result in a snapshot error.
                self.changeReminderListSnapshot()
            } else {
                self.updateSnapshot(reloading: [reminder.id])
            }
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
