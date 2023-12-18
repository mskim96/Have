/**
 * Abstract:
 * User selects the ReminderList for a Reminder screen.
 */

import UIKit

class SelectReminderListViewController: UIViewController {
    
    let reminderListRepository: ReminderListRepository = ReminderListMockRepository.mock
    
    /// Current selected reminder list.
    var selectedReminderList: ReminderList {
        didSet {
            onChangeReminderList(selectedReminderList)
        }
    }
    
    /// Get reminder lists from the repository and filter them by user-created.
    var reminderLists: [ReminderList] {
        return reminderListRepository.getReminderLists().filter { $0.type == .userCreated }
    }
    /// Closure for saving changes to the reminder list.
    var onChangeReminderList: (ReminderList) -> Void
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, ReminderList>! = nil
    
    init(selectedReminderList: ReminderList, onChangeReminderList: @escaping (ReminderList) -> Void) {
        self.selectedReminderList = selectedReminderList
        self.onChangeReminderList = onChangeReminderList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        configureHierarchy()
        configureDataSource()
    }
}

// MARK: - Set up the view hierarchy and establish the layout.

extension SelectReminderListViewController {
    
    func configureHierarchy() {
        view.backgroundColor = .systemBackground
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        view.addFullScreenSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
        var seperatorConfiguration = UIListSeparatorConfiguration(listAppearance: .plain)
        seperatorConfiguration.topSeparatorVisibility = .hidden
        listConfiguration.separatorConfiguration = seperatorConfiguration
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func setupNavigationBar() {
        let standardAppearance = UINavigationBarAppearance()
        standardAppearance.configureWithDefaultBackground()
        standardAppearance.shadowImage = nil
        standardAppearance.backgroundColor = .systemBackground
        
        navigationItem.title = NSLocalizedString("List", comment: "Select Reminder navigation title")
        navigationController?.navigationBar.standardAppearance = standardAppearance
    }
}

// MARK: - Configure the DiffableDataSource and Snapshot.

extension SelectReminderListViewController {
    
    func configureDataSource() {
        let cellConfiguration = UICollectionView.CellRegistration<UICollectionViewListCell, ReminderList> { cell, indexPath, reminderList in
            var contentConfiguration = cell.defaultContentConfiguration()
            contentConfiguration.text = reminderList.name
            contentConfiguration.image = reminderList.image
            // Show a checkmark accessory if the cell corresponds to the currently selected reminder list.
            cell.accessories = reminderList == self.selectedReminderList ? [.checkmark(displayed: .always)] : []
            cell.contentConfiguration = contentConfiguration
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, ReminderList>(collectionView: collectionView) {
            collectionView, indexPath, reminderList in
            collectionView.dequeueConfiguredReusableCell(using: cellConfiguration, for: indexPath, item: reminderList)
        }
        
        updateSnapshot()
    }
    
    func updateSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ReminderList>()
        snapshot.appendSections([0])
        snapshot.appendItems(reminderListRepository.getReminderLists().filter { $0.type == .userCreated })
        dataSource.apply(snapshot)
    }
    
    /// Update the selected reminder list with new reminder list.
    func updateCurrentReminderList(_ reminderList: ReminderList) {
        selectedReminderList = reminderList
    }
}

// MARK: - UICollectionViewDelegate

extension SelectReminderListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        guard let reminderList = dataSource.itemIdentifier(for: indexPath) else { return false }
        updateCurrentReminderList(reminderList)
        navigationController?.popViewController(animated: true)
        return false
    }
}
