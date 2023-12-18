/**
 * Abstract:
 * Configure cells for rows in the Reminder View Controller.
 */

import UIKit

extension ReminderViewController {
    
    /// Configuration for the title of the reminder.
    func titleConfiguration(for cell: UICollectionViewListCell, with title: String?)
    -> TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = title
        contentConfiguration.placeholder = NSLocalizedString("Title", comment: "Reminder title placeholder")
        contentConfiguration.onChange = { [weak self] title in
            self?.workingReminder.title = title
            self?.updateSaveButtonItemEnabledState()
        }
        return contentConfiguration
    }
    
    /// Configuration for the notes of the reminder.
    func notesConfiguration(for cell: UICollectionViewListCell, with notes: String?)
    -> TextViewContentView.Configuration {
        var contentConfiguration = cell.textViewConfiguration()
        contentConfiguration.text = notes
        contentConfiguration.placeholder = NSLocalizedString("Notes", comment: "Reminder notes placeholder")
        contentConfiguration.onChange = { [weak self] notes in
            self?.workingReminder.notes = notes
        }
        return contentConfiguration
    }
    
    /// Configuration for the date and time of the reminder.
    func dateTimeTitleConfiguration(for cell: UICollectionViewListCell, at row: Row)
    -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
        contentConfiguration.secondaryText = dateTimeText(for: row)
        contentConfiguration.secondaryTextProperties.color = .systemBlue
        contentConfiguration.image = row.image
        
        let switchConfiguration = switchConfiguration(at: row)
        cell.accessories = [
            .customView(configuration: switchConfiguration),
        ]
        
        return contentConfiguration
    }
    
    /// Configuration for the date of the reminder with Date Picker content view.
    func dateConfiguration(for cell: UICollectionViewListCell, with date: Date?)
    -> DatePickerContentView.Configuration {
        // cell 의 contentConfiguration 초기화.
        // 안하면 warningMessage 점등 (expand collapse 효과 사용 위해)
        cell.contentConfiguration = nil
        var contentConfiguration = cell.datePickerConfiguration()
        if let date = date { contentConfiguration.date = date }
        contentConfiguration.onChangeDate = { [weak self] dueDate in
            self?.updateDate(to: dueDate)
        }
        return contentConfiguration
    }
    
    /// Configuration for the time of the reminder with Time Picker content view.
    func timeConfiguration(for cell: UICollectionViewListCell, with time: Date?)
    -> TimePickerContentView.Configuration {
        // cell 의 contentConfiguration 초기화.
        // 안하면 warningMessage 점등 (expand collapse 효과 사용 위해)
        cell.contentConfiguration = nil
        var contentConfiguration = cell.timePickerConfiguration()
        if let time = time { contentConfiguration.time = time }
        contentConfiguration.onChangeTime = { [weak self] dueTime in
            self?.updateTime(to: dueTime)
        }
        return contentConfiguration
    }
    
    /// Configuration for the flag of the reminder.
    func flagConfiguration(for cell: UICollectionViewListCell, at row: Row)
    -> UIListContentConfiguration {
        var contentConfiguration = cell.defaultContentConfiguration()
        contentConfiguration.text = text(for: row)
        contentConfiguration.textProperties.font = .preferredFont(forTextStyle: .subheadline)
        contentConfiguration.image = row.image
        
        let switchConfiguration = switchConfiguration(at: row)
        cell.accessories = [
            .customView(configuration: switchConfiguration),
        ]
        
        return contentConfiguration
    }
    
    /// Configuration for the reminder list of the reminder.
    func reminderListConfiguration(for cell: UICollectionViewListCell, with reminderList: ReminderList)
    -> UIListContentConfiguration {
        var contentConfiguration = UIListContentConfiguration.valueCell()
        contentConfiguration.text = NSLocalizedString("List", comment: "Reminder list row text")
        if reminderList.type != .userCreated {
            let firstUserCreatedReminderList = reminderListRepository.getUserCreatedReminderList()
            contentConfiguration.secondaryText = firstUserCreatedReminderList.name
            contentConfiguration.image = firstUserCreatedReminderList.image
        } else {
            contentConfiguration.secondaryText = reminderList.name
            contentConfiguration.image = reminderList.image
        }
        
        cell.accessories = [
            .disclosureIndicator()
        ]
        
        return contentConfiguration
    }
    
    /// Configuration for switches in date and time rows.
    func switchConfiguration(at row: Row) -> UICellAccessory.CustomViewConfiguration {
        let toggleSwitch = UISwitch()
        switch row {
        case .date:
            dateSwitch = toggleSwitch
            toggleSwitch.isOn = workingReminder.dueDate != nil
            toggleSwitch.addTarget(self, action: #selector(didToggleDateSwitch(_:)), for: .valueChanged)
        case .time:
            timeSwitch = toggleSwitch
            toggleSwitch.isOn = workingReminder.dueTime != nil
            toggleSwitch.addTarget(self, action: #selector(didToggleTimeSwitch(_:)), for: .valueChanged)
        case .flag:
            toggleSwitch.isOn = workingReminder.isFlagged
            toggleSwitch.addTarget(self, action: #selector(didToggleFlagSwitch(_:)), for: .valueChanged)
        default: break
        }
        return UICellAccessory.CustomViewConfiguration(
            customView: toggleSwitch,
            placement: .trailing(displayed: .always)
        )
    }
    
    /// Update secondaryText in date or time rows.
    ///
    /// If reconfigure is used in the snapshot, it causes a global reconfiguration of the entire row,
    /// potentially leading to bugs in the Switch. use this function to update the secondaryText instead.
    ///
    /// - Parameters:
    ///     - row: date row or time row.
    ///     - secondaryText: closure for represent secondaryText.
    ///
    func updateSecondaryText(for row: Row, secondaryText: (Reminder) -> String?) {
        guard row == .date || row == .time else { return }
        guard let indexPath = self.dataSource.indexPath(for: row) else { return }
        guard let cell = self.collectionView.cellForItem(at: indexPath) as? UICollectionViewListCell else { return }
        var contentConfiguration = cell.contentConfiguration as? UIListContentConfiguration
        contentConfiguration?.secondaryText = secondaryText(self.workingReminder)
        cell.contentConfiguration = contentConfiguration
    }
    
    /// Update save button enabled state.
    ///
    /// Enabled the save button if the working reminder's title exists.
    /// otherwise, set it to disabled.
    ///
    private func updateSaveButtonItemEnabledState() {
        navigationItem.rightBarButtonItem?.isEnabled = !workingReminder.title.isEmpty
    }
}
