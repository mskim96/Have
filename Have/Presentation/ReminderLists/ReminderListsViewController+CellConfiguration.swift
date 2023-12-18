/**
 * Abstract:
 * Configuration of the cell for the ReminderListsViewController
 */

import UIKit

extension ReminderListsViewController {
    
    /// Configuration for the built-in ReminderList.
    func builtInReminderListsConfiguration(for cell: UICollectionViewListCell, with reminderList: ReminderList)
    -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminderList.name
        contentConfiguration.image = reminderList.image
        
        let reminderCount = reminderList.type.numberOfFilteredReminders(
            reminders: reminderRepository.getReminders(),
            reminderList: reminderList
        )
        cell.accessories = [
            .multiselect(displayed: .whenEditing),
            .reorder(displayed: .whenEditing),
            .label(text: "\(reminderCount)", displayed: .whenNotEditing),
            .disclosureIndicator(displayed: .whenNotEditing)
        ]
        
        return contentConfiguration
    }
    
    /// Configuration for the user-created ReminderList.
    func userCreatedReminderListsConfiguration(for cell: UICollectionViewListCell, with reminderList: ReminderList)
    -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminderList.name
        contentConfiguration.image = reminderList.image
        
        let reminderCount = reminderList.type.numberOfFilteredReminders(
            reminders: reminderRepository.getReminders(),
            reminderList: reminderList
        )
        cell.accessories = [
            .delete(displayed: .whenEditing),
            .detail(displayed: .whenEditing) {
                self.navigateToReminderListViewController(with: reminderList)
            },
            .reorder(displayed: .whenEditing),
            .label(text: "\(reminderCount)", displayed: .whenNotEditing),
            .disclosureIndicator(displayed: .whenNotEditing)
        ]
        
        return contentConfiguration
    }
}
