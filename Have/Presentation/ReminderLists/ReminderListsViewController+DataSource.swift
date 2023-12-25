/**
 * Abstract:
 * Configuration of the DataSource for the ReminderListsViewController.
 */

import UIKit

extension ReminderListsViewController {
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, reminderList: ReminderList) in
            switch reminderList.type {
            case .builtInToday, .builtInAll, .builtInFlag, .builtInCompleted:
                cell.contentConfiguration = self.builtInReminderListsConfiguration(for: cell, with: reminderList)
            case .userCreated:
                cell.contentConfiguration = self.userCreatedReminderListsConfiguration(for: cell, with: reminderList)
            }
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView, indexPath, reminderList) in
            return collectionView.dequeueConfiguredReusableCell(
                using: cellRegistration,
                for: indexPath,
                item: reminderList
            )
        }
        initialSnapshot()
    }
    
    /// Initial snapshot.
    func initialSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ReminderList>()
        snapshot.appendSections([.builtIn, .userCreated])
        let (builtIn, userCreated) = reminderLists.partition { $0.type != .userCreated }
        snapshot.appendItems(builtIn, toSection: .builtIn)
        snapshot.appendItems(userCreated, toSection: .userCreated)
        snapshot.reloadSections([.builtIn, .userCreated])
        dataSource.apply(snapshot)
    }
    
    /// Add the specified reminderList from the snapshot.
    func addReminderListSnapshot(_ reminderList: ReminderList) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([reminderList])
        dataSource.apply(snapshot)
    }
    
    /// Delete the specified reminderList from the snapshot.
    func deleteReminderListSnapshot(_ reminderList: ReminderList) {
        var snapshot = dataSource.snapshot()
        snapshot.deleteItems([reminderList])
        dataSource.apply(snapshot)
    }
    
    /// Reconfigure the snapshot for reminder lists.
    ///
    /// e.g. required for update reminder count of reminder list.
    ///
    func reconfigureReminderListsSnapshot() {
        var snapshot = dataSource.snapshot()
        snapshot.reloadSections([.builtIn, .userCreated])
        dataSource.apply(snapshot)
    }
}

// MARK: - Fetch data and tasks

extension ReminderListsViewController {
    
    func updateUIAfterAllDataFetched() {
        Task {
            do {
                try await fetchAllData()
                await MainActor.run {
                    self.initialSnapshot()
                    updateAddReminderButtonItemEnabledState()
                }
            } catch {
                print("ReminderListsViewController: Initial data fetch error \(error)")
            }
        }
    }
    
    func updateUIAfterAddReminderList(_ reminderList: ReminderList) async throws {
        try await fetchReminderLists()
        await MainActor.run {
            addReminderListSnapshot(reminderList)
            updateAddReminderButtonItemEnabledState()
        }
    }
    
    func updateUIAfterUpdateReminderList() async throws {
        try await fetchReminderLists()
        await MainActor.run {
            self.initialSnapshot()
        }
    }
    
    func updateUIAfterDeleteReminderList(_ reminderList: ReminderList) async throws {
        try await fetchReminderLists()
        await MainActor.run {
            deleteReminderListSnapshot(reminderList)
            updateAddReminderButtonItemEnabledState()
        }
    }
    
    func updateUIAfterDeleteReminderListIfHaveReminder(_ reminderList: ReminderList) async throws {
        try await fetchReminders()
        await MainActor.run {
            deleteReminderListSnapshot(reminderList)
            reconfigureReminderListsSnapshot()
            updateAddReminderButtonItemEnabledState()
        }
    }
    
    /// Fetches all data asynchronously and update the local `reminderLists` and `reminder` property.
    private func fetchAllData() async throws {
        let fetchedLists = try await fetchReminderListsTask().value
        let fetchedReminders = try await fetchRemindersTask().value
        self.reminderLists = fetchedLists
        self.reminders = fetchedReminders
    }
    
    /// Fetches reminder lists asynchronously and updates the local `reminderLists` property.
    private func fetchReminderLists() async throws {
        let fetchedLists = try await fetchReminderListsTask().value
        self.reminderLists = fetchedLists
    }
    
    /// Fetches reminders asynchronously and updates the local `reminders` property.
    private func fetchReminders() async throws {
        let fetchedReminders = try await fetchRemindersTask().value
        self.reminders = fetchedReminders
    }
    
    /// Asynchronous task to fetch reminder lists concurrently.
    private func fetchReminderListsTask() async throws -> Task<[ReminderList], Error> {
        return Task { try await self.reminderListRepository.getReminderLists() }
    }
    
    /// Asynchronous task to fetch reminders concurrently.
    private func fetchRemindersTask() async throws -> Task<[Reminder], Error> {
        return Task { try await self.reminderRepository.getReminders() }
    }
    
    private func deleteReminderListTask(_ reminderList: ReminderList) async
    -> Task<Void, Error> {
        return Task { try await self.reminderListRepository.deleteReminderList(withId: reminderList.id) }
    }
    
    private func deleteRemindersWithRefIdTask(_ reminderList: ReminderList) async
    -> Task<Void, Error> {
        return Task { try await self.reminderRepository.deleteReminders(withReminderListRef: reminderList.id) }
    }
}


// MARK: - Action methods with datasource.

extension ReminderListsViewController {
    
    /// Add new reminder list.
    func addReminderList(_ reminderList: ReminderList) {
        Task {
            do {
                try await reminderListRepository.addReminderList(reminderList)
                try await updateUIAfterAddReminderList(reminderList)
            } catch {
                print("ReminderListsViewController: Add reminder list \(error)")
            }
        }
    }
    
    /// Update reminder list.
    func updateReminderList(_ reminderList: ReminderList) {
        Task {
            do {
                try await reminderListRepository.updateReminderList(reminderList)
                try await updateUIAfterUpdateReminderList()
            } catch {
                print("ReminderListsViewController: Edit reminder list \(error)")
            }
        }
    }
    
    /// Delete the reminder list.
    func deleteReminderList(_ reminderList: ReminderList) {
        Task {
            do {
                try await reminderListRepository.deleteReminderList(withId: reminderList.id)
                try await updateUIAfterDeleteReminderList(reminderList)
            } catch {
                print("ReminderListsViewController: Delete reminder list \(error)")
            }
        }
    }
    
    /// Delete the reminder list and related reminders.
    func deleteReminderListAndRelatedReminder(_ reminderList: ReminderList) {
        Task {
            do {
                try await deleteReminderListTask(reminderList).value
                try await deleteRemindersWithRefIdTask(reminderList).value
                try await updateUIAfterDeleteReminderListIfHaveReminder(reminderList)
            } catch {
                print("ReminderListsViewController: Delete reminder list \(error)")
            }
        }
    }
    
    /// Add new reminder.
    func addReminder(_ reminder: Reminder) {
        Task {
            do {
                try await reminderRepository.addReminder(reminder)
                let fetchedReminders = try await fetchRemindersTask().value
                self.reminders = fetchedReminders
                reconfigureReminderListsSnapshot()
            } catch {
                print("ReminderListsViewController: Add reminder \(error)")
            }
        }
    }
    
    /// Updates the enabled state of the "Add reminder" button based on the presence of user-created reminder lists.
    ///
    /// If there are no user-created reminder lists, the button is disabled; otherwise, it is enabled.
    ///
    private func updateAddReminderButtonItemEnabledState() {
        if !reminderLists.contains(where: { $0.type == .userCreated }) {
            toolbarItems?.first?.isEnabled = false
        } else {
            toolbarItems?.first?.isEnabled = true
        }
    }
}
