/**
 * Abstract:
 * Configuration of the cell for the RemindersViewController
 */

import UIKit

extension RemindersViewController {
    
    func reminderConfiguration(for cell: UICollectionViewListCell, with reminder: Reminder)
    -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = reminder.title
        
        if reminder.isCompleted {
            contentConfiguration.textProperties.color = .secondaryLabel
        }
        
        if let date = reminder.dueDate {
            contentConfiguration.secondaryText = date.dateText(with: reminder.dueTime)
            contentConfiguration.secondaryTextProperties.font = UIFont.preferredFont(forTextStyle: .caption2)
            contentConfiguration.secondaryTextProperties.color = .secondaryLabel
        }
        
        let doneButtonConfiguration = completeButtonConfiguration(for: reminder)
        cell.accessories = [
            .customView(configuration: doneButtonConfiguration),
        ]
        
        return contentConfiguration
    }
    
    /// Complete button configuration.
    private func completeButtonConfiguration(for reminder: Reminder)
    -> UICellAccessory.CustomViewConfiguration {
        let symbolName = reminder.isCompleted ? "circle.fill" : "circle"
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title2)
        let image = UIImage(systemName: symbolName, withConfiguration: symbolConfiguration)
        let button = ReminderCompleteButton()
        
        button.addTarget(self, action: #selector(didPressCompletedButton(_:)), for: .touchUpInside)
        button.id = reminder.id
        button.tintColor = reminder.isCompleted ? .systemBlue : .systemGray
        button.setImage(image, for: .normal)
        return UICellAccessory.CustomViewConfiguration(customView: button, placement: .leading(displayed: .always))
    }
}
