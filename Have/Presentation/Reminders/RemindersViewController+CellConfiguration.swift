/**
 * Abstract:
 * Configuration of the cell for the RemindersViewController
 */

import UIKit

extension RemindersViewController {
    
    func reminderConfiguration(for cell: UICollectionViewListCell, with reminder: Reminder)
    -> ReminderContentView.Configuration {
        var contentConfiguration = cell.reminderConfiguration()
        contentConfiguration.reminder = reminder
        contentConfiguration.onClickComplete = { [weak self] id in
            self?.completedReminder(withId: id)
        }
        return contentConfiguration
    }
}
