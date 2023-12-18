/**
 * Abstract:
 * Actions of the ReminderListViewController.
 */

import UIKit

extension ReminderListViewController {
    
    /// Save the changes to the list.
    @objc func didPressDoneButton(_ sender: UIBarButtonItem) {
        if workingReminderList != reminderList {
            reminderList = workingReminderList
        }
        dismiss(animated: true)
    }
    
    /// Discard changes to the list and cancel.
    @objc func didPressCancelButton(_ sender: UIBarButtonItem) {
        workingReminderList = reminderList
        dismiss(animated: true)
    }
}
