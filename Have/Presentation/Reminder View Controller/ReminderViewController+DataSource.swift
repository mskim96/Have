/**
 * Configure the DiffableDataSource for the Reminder view controller.
 */
import UIKit

extension ReminderViewController {
    
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Row>
   
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Row> { (cell, indexPath, row) in
            switch row {
            case .editableTitle:
                cell.contentConfiguration = self.titleConfiguration(for: cell, with: self.workingReminder.title)
            case .editableNotes:
                cell.contentConfiguration = self.notesConfiguration(for: cell, with: self.workingReminder.notes)
            case .date:
                cell.contentConfiguration = self.dateTimeTitleConfiguration(for: cell, at: row)
            case .editableDate:
                cell.contentConfiguration = self.dateConfiguration(for: cell, with: self.workingReminder.dueDate)
            case .time:
                cell.contentConfiguration = self.dateTimeTitleConfiguration(for: cell, at: row)
            case .editableTime:
                cell.contentConfiguration = self.timeConfiguration(for: cell, with: self.workingReminder.dueTime)
            case .flag:
                cell.contentConfiguration = self.flagConfiguration(for: cell, at: row)
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Row) in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        initialSnapshot()
    }
    
    private func initialSnapshot() {
        var snapshot = Snapshot()
        snapshot.appendSections([.titleAndNotes, .dateAndTime, .flag])
        snapshot.appendItems([.editableTitle, .editableNotes], toSection: .titleAndNotes)
        snapshot.appendItems(
            [.date, .time ],
            toSection: .dateAndTime
        )
        snapshot.appendItems([.flag], toSection: .flag)
        dataSource.apply(snapshot)
    }
    
    /// Expand or collapse the row when user clicks.
    func toggleExpandableRowSnapshot(at row: Row) {
        var snapshot = dataSource.snapshot()
        switch row {
        case .date: 
            toggleExpandableSnapshotIfNeeded(&snapshot, expandRow: .editableDate, collapseRow: .editableTime, afterRow: .date)
        case .time: 
            toggleExpandableSnapshotIfNeeded(&snapshot, expandRow: .editableTime, collapseRow: .editableDate, afterRow: .time)
        default: break
        }
        dataSource.apply(snapshot)
    }
    
    /// Expand or collapse the row when user clickes the switch.
    ///
    /// - Parameters:
    ///     - row: date or time row
    ///     - isOn: value of the switch.
    ///
    func toggleSwitchSnapshot(for row: Row, isOn: Bool) {
        var snapshot = dataSource.snapshot()
        switch row {
        case .date: 
            toggleExpandableSnapshot(&snapshot, expand: isOn, expandRow: .editableDate, collapseRow: .editableTime, afterRow: .date)
        case .time: 
            toggleExpandableSnapshot(&snapshot, expand: isOn, expandRow: .editableTime, collapseRow: .editableDate, afterRow: .time)
        default: break
        }
        updateSecondaryText(for: .date) { workingReminder in workingReminder.dueDate?.detailDayText() }
        updateSecondaryText(for: .time) { workingReminder in workingReminder.dueTime?.timeText() }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateDate(to newDate: Date?) {
        var newWorkingReminder = workingReminder
        newWorkingReminder.dueDate = newDate
        workingReminder = newWorkingReminder
        updateSecondaryText(for: .date) { workingReminder in
            workingReminder.dueDate?.detailDayText()
        }
    }
    
    func updateTime(to newTime: Date?) {
        var newWorkingReminder = workingReminder
        newWorkingReminder.dueTime = newTime
        workingReminder = newWorkingReminder
        updateSecondaryText(for: .time) {
            workingReminder in workingReminder.dueTime?.timeText()
        }
    }
    
    func updateFlagged(to newFlag: Bool) {
        var newWorkingReminder = workingReminder
        newWorkingReminder.isFlagged.toggle()
        workingReminder = newWorkingReminder
    }
    
    /// Toggle expand or collapse the row.
    ///
    /// Our toggle behavior have only one expand row, and the rest should collapse.
    ///
    /// - Parameters:
    ///     - snapshot: the current snapshot.
    ///     - expandRow: you want to expand row.
    ///     - collapseRow: you want to collapse row.
    ///     - afterRow: expand row insert after this row.
    ///
    private func toggleExpandableSnapshotIfNeeded(
        _ snapshot: inout Snapshot,
        expandRow: Row,
        collapseRow: Row,
        afterRow: Row
    ) {
        // check expand row and collapse if it exists. -> expand to collapse.
        if snapshot.itemIdentifiers.contains(expandRow) {
            snapshot.deleteItems([expandRow])
        } else {
            // collapse the collapseRow.
            if snapshot.itemIdentifiers.contains(collapseRow) {
                snapshot.deleteItems([collapseRow])
            }
            // expand the expandRow.
            snapshot.insertItems([expandRow], afterItem: afterRow)
        }
    }
    
    /// Expand or collapse the row based on the value of the `expand`.
    ///
    /// - Parameters:
    ///     - snapshot: the current snapshot.
    ///     - expand: expand value.
    ///     - expandRow: you want to expand row.
    ///     - collapseRow: you want to collapse row.
    ///     - afterRow: expand row insert after this row.
    ///
    private func toggleExpandableSnapshot(
        _ snapshot: inout Snapshot,
        expand: Bool,
        expandRow: Row,
        collapseRow: Row,
        afterRow: Row
    ) {
        if expand {
            // collapse the other row exists.
            if snapshot.itemIdentifiers.contains(collapseRow) {
                snapshot.deleteItems([collapseRow])
            }
            snapshot.insertItems([expandRow], afterItem: afterRow)
        } else {
            // collapse the expand row.
            if snapshot.itemIdentifiers.contains(expandRow) {
                snapshot.deleteItems([expandRow])
            }
            // 해당 값에 collapseRow 를 넣으면
            // 1. Date Switch, Time Switch 가 전부 켜져있고 dateRow expand state 일 경우 Time switch 를 끄면
            //    dateRow 가 collapse 상태로 변해버림. 따라서 고정값을 임시로 넣어 처리.
            if snapshot.itemIdentifiers.contains(.editableTime) {
                snapshot.deleteItems([.editableTime])
            }
        }
    }
}
