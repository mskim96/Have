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
    
    // TODO: Core Data 구현 완료 시 update 필요
    func updateSnapshot(reloading ids: [Reminder.ID] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Reminder.ID>()
        snapshot.appendSections([0])
        snapshot.appendItems(reminders.map { $0.id })
        if !ids.isEmpty {
            snapshot.reloadItems(ids)
        }
        dataSource.apply(snapshot)
    }
    
    // TODO: Editable 에 Cell registration 분기 및 event 정의
    // TODO: ** 이후 Custom cell 처리 **
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, id: Reminder.ID) {
        let reminder = reminders.getReminder(withId: id)
        
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
            .customView(configuration: doneButtonConfiguration)
        ]
        
        cell.contentConfiguration = contentConfiguration
    }
    
    // TODO: Core Data 구현 완료 시 update 필요
    func updateReminder(_ reminder: Reminder) {
        let index = reminders.getIndex(withId: reminder.id)
        reminders[index] = reminder
    }
    
    // TODO: Core Data 구현 완료 시 update 필요
    func completedReminder(withId id: Reminder.ID) {
        var reminder = reminders.getReminder(withId: id)
        reminder.isCompleted.toggle()
        updateReminder(reminder)
        updateSnapshot(reloading: [id])
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
