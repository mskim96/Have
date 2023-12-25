/**
 * Abstract:
 * Configure the DiffableDataSource for the Reminders view controller.
 */

import UIKit

extension RemindersViewController {
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration(handler: cellRegistrationHandler)
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, reminder: Reminder) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: reminder)
        }
        updateSnapshot()
    }
    
    func cellRegistrationHandler(cell: UICollectionViewListCell, indexPath: IndexPath, reminder: Reminder) {
        let reminder = filteredReminders[indexPath.item]
        cell.contentConfiguration = reminderConfiguration(for: cell, with: reminder)
    }
    
    func updateSnapshot(reloading reminders: [Reminder] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Reminder>()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders)
        if !reminders.isEmpty && reminderList.type != .builtInCompleted {
            snapshot.reloadItems(reminders)
        }
        dataSource.apply(snapshot)
    }
    
    func addReminderSnapshot(_ reminder: Reminder) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([reminder])
        dataSource.apply(snapshot)
    }
    
    func deleteReminderSnapshot(delete reminders: [Reminder]) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems(reminders)
        dataSource.apply(snapshot)
    }
    
    func changeReminderListSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, Reminder>()
        snapshot.appendSections([0])
        snapshot.appendItems(filteredReminders)
        dataSource.apply(snapshot)
    }
}

// MARK: - Fetch data

extension RemindersViewController {
    
    func updateUIAfterFetchData() {
        Task {
            do {
                try await fetchReminders()
                await MainActor.run {
                    self.updateSnapshot()
                }
            } catch {
                print("RemindersViewController: fetch data error")
            }
        }
    }
    
    func updateUIAfterAddReminder(_ reminder: Reminder) async throws {
        try await fetchReminders()
        await MainActor.run {
            addReminderSnapshot(reminder)
        }
    }
    
    func updateUIAfterUpdateReminder(_ reminder: Reminder) async throws {
        try await fetchReminders()
        await MainActor.run {
            updateSnapshot()
        }
    }
    
    private func fetchReminders() async throws {
        let fetchReminders = try await fetchRemindersTask().value
        self.filteredReminders = fetchReminders.filter {
            reminderList.type.shouldInclude(reminder: $0, reminderList: reminderList)
        }
    }
    
    /// Asynchronous task to fetch reminders concurrently.
    private func fetchRemindersTask() async throws -> Task<[Reminder], Error> {
        return Task { try await self.reminderRepository.getReminders() }
    }
    
    private func deleteReminder(_ reminder: Reminder) async
    -> Task<Void, Error> {
        return Task { try await self.reminderRepository.deleteReminder(withId: reminder.id) }
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
                guard let reminder = filteredReminders.first(where: { $0.id == id }) else { return }
                try await updateUIAfterUpdateReminder(reminder)
            }
        }
    }
    
    func flagReminder(_ reminder: Reminder) {
        Task {
            do {
                try await reminderRepository.flagReminder(withId: reminder.id)
                try await updateUIAfterUpdateReminder(reminder)
            }
        }
    }
    
    func addReminder(_ reminder: Reminder) {
        Task {
            do {
                try await reminderRepository.addReminder(reminder)
                try await updateUIAfterAddReminder(reminder)
            }
        }
    }
    
    func deleteReminder(_ reminder: Reminder) {
        Task{
            do {
                try await reminderRepository.deleteReminder(withId: reminder.id)
            }
        }
        deleteReminderSnapshot(delete: [reminder])
    }
}
