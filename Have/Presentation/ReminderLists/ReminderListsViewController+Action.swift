/**
 * Abstract:
 * Actions of the ReminderListsViewController.
 */

import UIKit

extension ReminderListsViewController {
    
    /// Navigate to ReminderListViewController with new reminder list.
    @objc func didPressAddReminderListButton(_ sender: UIBarButtonItem) {
        let reminderList = ReminderList(name: "")
        let viewController = ReminderListViewController(reminderList: reminderList) { [weak self] reminderList in
            self?.addReminderList(reminderList)
        }
        viewController.isAddingNewReminderList = true
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    /// Navigate to ReminderViewController with new reminder.
    @objc func didPressAddReminderButton(_ sender: UIBarButtonItem) {
        Task {
            let firstOrCreateReminderList = try await reminderListRepository.getUserCreatedReminderList()
            let reminder = Reminder(title: "", reminderListRefId: firstOrCreateReminderList.id)
            await MainActor.run {
                let viewController = ReminderViewController(
                    fromReminderListType: .userCreated,
                    reminder: reminder
                ) { [weak self] reminder in
                    guard let self = self else { return }
                    self.addReminder(reminder)
                }
                viewController.isAddingNewReminder = true
                let navigationController = UINavigationController(rootViewController: viewController)
                present(navigationController, animated: true)
            }
        }
    }
    
    /// Navigate to ReminderListViewController with current reminder list.
    ///
    /// - Parameters:
    ///     - reminderList: selected reminderList.
    ///
    func navigateToReminderListViewController(with reminderList: ReminderList) {
        let viewController = ReminderListViewController(reminderList: reminderList) { [weak self] reminderList in
            self?.updateReminderList(reminderList)
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        present(navigationController, animated: true)
    }
    
    /// Navigate to reminders view controller with selected reminderList.
    ///
    /// - Parameters:
    ///     - reminderList: selected reminderList.
    ///
    func navigateToRemindersViewController(with reminderList: ReminderList) {
        let viewController = RemindersViewController(reminderList: reminderList)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    /// Show delete reminder list alert.
    ///
    /// - Parameters:
    ///     - reminderListName: the reminder list name for alert title.
    ///     - confirm: closure for delete action.
    ///
    func deleteReminderListAlert(
        reminderListName: String,
        confirm: @escaping () -> Void
    ) {
        let title = NSLocalizedString("Delete list \"\(reminderListName)\"? ", comment: "Delete reminder list alert title")
        let message = NSLocalizedString("This will delete all reminders in this list.", comment: "Delete reminder list alert message")
        let cancelButtonTitle = NSLocalizedString("Cancel", comment: "Delete reminder list alert cancel button")
        let deleteButtonTitle = NSLocalizedString("Delete", comment: "Delete reminder list alert delete button")
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: cancelButtonTitle, style: .cancel)
        let deleteAction = UIAlertAction(title: deleteButtonTitle, style: .destructive) { _ in
            confirm()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - Swipe actions

extension ReminderListsViewController {
    
    /// Action of delete the reminder list.
    ///
    /// - Parameters:
    ///     - reminderList: Used a swipe gesture on the reminder list.
    ///
    func configureDeleteAction(with reminderList: ReminderList) -> UIContextualAction {
        // TAG: action 의 style 을 destructive 으로 사용안하는 이유는, 버튼이 collapse 될 때 셀자체가 튀는 애니메이션 발생.
        let deleteAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            guard let self = self else { return }
            if reminders.contains(where: { $0.reminderListRefId == reminderList.id }) {
                deleteReminderListAlert(reminderListName: reminderList.name) {
                    self.deleteReminderListAndRelatedReminder(reminderList)
                }
            } else {
                self.deleteReminderList(reminderList)
            }
            completion(true)
        }
        let deleteImageConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        let deleteImage = UIImage(systemName: "trash.fill", withConfiguration: deleteImageConfiguration)
        deleteAction.image = deleteImage
        deleteAction.backgroundColor = .systemRed
        return deleteAction
    }
    
    /// Action of Navigate to ReminderListViewContoller.
    ///
    /// - Parameters:
    ///     - reminderList: Used a swipe gesture on the reminder list
    ///
    func configureDetailAction(with reminderList: ReminderList) -> UIContextualAction {
        let detailAction = UIContextualAction(style: .normal, title: "") { [weak self] _, _, completion in
            self?.navigateToReminderListViewController(with: reminderList)
            completion(false)
        }
        
        let detailImageConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        let detailImage = UIImage(systemName: "info.circle.fill", withConfiguration: detailImageConfiguration)
        detailAction.image = detailImage
        return detailAction
    }
}
