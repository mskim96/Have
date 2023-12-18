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
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: reminderList)
        }
    }
    
    func updateSnapshot(reloading reminderList: [ReminderList] = []) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ReminderList>()
        snapshot.appendSections([.builtIn, .userCreated])
        snapshot.appendItems(reminderListRepository.getReminderLists().filter({ $0.type != .userCreated }), toSection: .builtIn)
        snapshot.appendItems(reminderListRepository.getReminderLists().filter({ $0.type == .userCreated }), toSection: .userCreated)
        if !reminderList.isEmpty {
            snapshot.reloadItems(reminderList)
        }
        dataSource.apply(snapshot)
    }
    
    func addReminderList(_ reminderList: ReminderList) {
        reminderListRepository.addReminderList(reminderList)
        updateAddReminderButtonItemEnabledState()
    }
    
    func updateReminderList(_ reminderList: ReminderList) {
        reminderListRepository.updateReminderList(reminderList)
    }
    
    func deleteReminderLists(_ reminderList: ReminderList) {
        reminderListRepository.deleteReminderList(withId: reminderList.id)
        updateAddReminderButtonItemEnabledState()
    }
    
    func addReminder(_ reminder: Reminder) {
        reminderRepository.addReminder(reminder)
    }
    
    private func updateAddReminderButtonItemEnabledState() {
        if !reminderListRepository.getReminderLists().contains(where: { $0.type == .userCreated }) {
            toolbarItems?.first?.isEnabled = false
        } else {
            toolbarItems?.first?.isEnabled = true
        }
    }
}
