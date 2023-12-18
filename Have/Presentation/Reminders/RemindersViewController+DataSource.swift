/**
 * Abstract:
 * Configure the DiffableDataSource for the Reminders view controller.
 */

import UIKit

extension RemindersViewController {
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Reminder.ID) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        updateSnapshot()
    }
    
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map { $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    
    func changeReminderListSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders.map { $0.id })
        dataSource.apply(snapshot)
    }
    
    // TODO: Editable 에 Cell registration 분기 및 event 정의
    // TODO: ** 이후 Custom cell 처리 **
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminderRepository.getReminder(withId: id)
        
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
        
        cell.contentConfiguration = contentConfiguration
    }
    
    func updateReminder(_ reminder: Reminder) {
        reminderRepository.updateReminder(reminder)
    }
    
    func completedReminder(withId id: Reminder.ID) {
        reminderRepository.completeReminder(withId: id)
        updateSnapshot(reloading: [id])
    }
    
    func flagReminder(withId id: Reminder.ID) {
        reminderRepository.flagReminder(withId: id)
        updateSnapshot()
    }
    
    func addReminder(_ reminder: Reminder) {
        reminderRepository.addReminder(reminder)
    }
    
    func deleteReminder(withId id: Reminder.ID) {
        reminderRepository.deleteReminder(withId: id)
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
