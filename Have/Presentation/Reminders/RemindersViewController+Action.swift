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
    
    /// Called when the user clicks the Add Reminder button.
    @objc func didPressAddReminderButton(_ sender: AddReminderButton) {
        Task {
            let userCreatedReminderListOrNew = reminderList.type == .userCreated ?
            reminderList : try await reminderListRepository.getUserCreatedReminderList()
            
            let reminder = Reminder(title: "", reminderListRefId: userCreatedReminderListOrNew.id)
            await MainActor.run {
                let viewController = ReminderViewController(
                    fromReminderListType: reminderList.type,
                    reminder: reminder
                ) { [weak self] reminder in
                    self?.addReminder(reminder)
                }
                viewController.isAddingNewReminder = true
                
                let navigationController = UINavigationController(rootViewController: viewController)
                present(navigationController, animated: true)
            }
        }
    }
    
    /// Present the reminder detail view controller modally.
    ///
    /// - Parameters:
    ///     - reminder: Reminder for navigate reminder detail view controller.
    func navigateToReminderViewController(with reminder: Reminder) {
        Task {
            let viewController = ReminderViewController(
                fromReminderListType: reminderList.type,
                reminder: reminder
            ) { [weak self] reminderResult in
                guard let self = self else { return }
                self.updateReminder(reminderResult)
                // Compare the `id` of the current reminder's reminder list with
                // the `id` of the callback reminder's reminder list.
                if reminder.reminderListRefId != reminderResult.reminderListRefId {
                    // If the list changed, attempting to reload when the current reminder is no longer
                    // preset in Reminders will result in a snapshot error.
                    self.updateSnapshot()
                } else {
                    self.updateSnapshot(reloading: [reminder])
                }
            }
            let navigationController = UINavigationController(rootViewController: viewController)
            present(navigationController, animated: true)
        }
    }
}

// MARK: - Swipe actions

extension RemindersViewController {
    
    /// Configure a swipe action for delete a reminder.
    ///
    /// - Parameters:
    ///     - id: The identifier of the reminder
    func configureDeleteAction(with reminder: Reminder) -> UIContextualAction {
        let deleteActionTitle = NSLocalizedString("Delete", comment: "Delete action button title")
        let deleteAction = UIContextualAction(style: .destructive, title: deleteActionTitle) {
            [weak self] _, _, completion in
            guard let self = self else { return }
            self.deleteReminder(reminder)
            completion(false)
        }
        return deleteAction
    }
    
    /// Configure a swipe action for navigate to the reminder view controller.
    ///
    /// - Parameters:
    ///     - id: The identifier of the reminder
    func configurDetailAction(with reminder: Reminder) -> UIContextualAction {
        let detailActionTitle = NSLocalizedString("Detail", comment: "Detail action button title")
        return UIContextualAction(style: .normal, title: detailActionTitle) {
            [weak self] _, _, completion in
            self?.navigateToReminderViewController(with: reminder)
            completion(false)
        }
    }
    
    /// Configure a swipe action for flagging a reminder.
    ///
    /// - Parameters:
    ///     - id: The identifier of the reminder
    func configureFlagAction(with reminder: Reminder) -> UIContextualAction {
        let flagActionTitle = NSLocalizedString("Flag", comment: "Flag action button title")
        let flagAction = UIContextualAction(style: .normal, title: flagActionTitle) {
            [weak self] _, _, completion in
            self?.flagReminder(reminder)
            // Using ** completion(true) ** indicates that we want to trigger the collapse animation
            // when the user clicks complete.
            completion(true)
        }
        flagAction.backgroundColor = .systemOrange
        
        return flagAction
    }
}
