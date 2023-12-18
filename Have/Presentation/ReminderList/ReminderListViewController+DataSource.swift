/**
 * Abstract:
 * Configuration of the DataSource for the ReminderListViewController.
 */

import UIKit

extension ReminderListViewController {
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration {
            (cell: UICollectionViewListCell, indexPath: IndexPath, row: Row) in
            cell.contentConfiguration = self.listNameContentConfiguration(cell: cell, with: self.workingReminderList)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        updateSnapshot()
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Row>()
        snapshot.appendSections([.listName])
        snapshot.appendItems([.listName])
        dataSource.apply(snapshot)
    }
    
    /// Configuration for the list name cell.
    func listNameContentConfiguration(cell: UICollectionViewListCell, with reminderList: ReminderList)
    -> ReminderListNameContentView.Configuration {
        var contentConfiguration = cell.reminderListNameConfiguration()
        contentConfiguration.reminderList = reminderList
        contentConfiguration.onChangeName = { [weak self] reminderName in
            self?.workingReminderList.name = reminderName
        }
        return contentConfiguration
    }
}
