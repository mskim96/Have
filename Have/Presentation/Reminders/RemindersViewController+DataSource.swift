/**
 * Abstract:
 * Configure the DiffableDataSource for the Reminders view controller.
 */

import UIKit

extension RemindersViewController {
    
    enum Section: Int, Hashable {
        case main
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, reminder: Reminder) in
            cell.contentConfiguration = self.reminderConfiguration(for: cell, with: reminder)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, reminder: Reminder) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: reminder)
        }
        
        updateSnapshot()
    }
    
    func updateSnapshot(reloading reminders: [Reminder] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Reminder>()
        snapshot.appendSections([.main])
        snapshot.appendItems(filteredReminders)
        if !reminders.isEmpty && reminderList.type != .builtInCompleted {
            snapshot.reloadItems(reminders)
        }
        dataSource.apply(snapshot)
    }
}

// MARK: - Fetch data

extension RemindersViewController {
    
    func updateUIAfterFetchData() {
        Task {
            do {
                try await fetchReminders()
                self.updateSnapshot()
            } catch {
                print("RemindersViewController: fetch data error")
            }
        }
    }
    
    private func fetchReminders() async throws {
        let fetchReminders = try await fetchRemindersTask().value
        filteredReminders = fetchReminders.filter {
            reminderList.type.shouldInclude(reminder: $0, reminderList: reminderList)
        }
    }
    
    /// Asynchronous task to fetch reminders concurrently.
    private func fetchRemindersTask() async throws -> Task<[Reminder], Error> {
        return Task { try await self.reminderRepository.getReminders() }
    }
}

// MARK: - Action methods with datasource

extension RemindersViewController {
    
    func updateReminder(_ reminder: Reminder) {
        Task {
            do {
                try await reminderRepository.updateReminder(reminder)
                updateUIAfterFetchData()
            }
        }
    }
    
    func completedReminder(withId id: Reminder.ID) {
        Task {
            do {
                try await reminderRepository.completeReminder(withId: id)
                updateUIAfterFetchData()
            }
        }
    }
    
    func flagReminder(_ reminder: Reminder) {
        Task {
            do {
                try await reminderRepository.flagReminder(withId: reminder.id)
                updateUIAfterFetchData()
            }
        }
    }
    
    func addReminder(_ reminder: Reminder) {
        Task {
            do {
                try await reminderRepository.addReminder(reminder)
                updateUIAfterFetchData()
            }
        }
    }
    
    func deleteReminder(_ reminder: Reminder) {
        Task{
            do {
                try await reminderRepository.deleteReminder(withId: reminder.id)
                updateUIAfterFetchData()
            }
        }
    }
}
