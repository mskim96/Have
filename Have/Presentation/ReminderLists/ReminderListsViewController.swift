/**
 * Abstract:
 * Represent All reminder lists.
 */

import UIKit

class ReminderListsViewController: UIViewController {
    
    var reminderListRepository = ReminderListMockRepository.mock
    var reminderRepository = ReminderMockRepository.mock
    
    enum Section {
        case builtIn, userCreated
    }
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, ReminderList>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupToolbar()
        configureHierarchy()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSnapshot(reloading: reminderListRepository.getReminderLists())
    }
}

// MARK: - Establish the view hierarchy and configure the associated layout.

extension ReminderListsViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        view.addFullScreenSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        listConfiguration.trailingSwipeActionsConfigurationProvider = configureSwipeAction
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = editButtonItem
        let backButtonTitle = NSLocalizedString("Lists", comment: "Back buton title for RemindersViewController")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: backButtonTitle, style: .plain, target: self, action: nil)
    }
    
    private func setupToolbar() {
        // Standard edge appearance of toolbar
        let standardToobarAppearance = UIToolbarAppearance()
        standardToobarAppearance.configureWithTransparentBackground()
        standardToobarAppearance.shadowColor = nil
        
        // Scroll edge appearance of toolbar.
        let scrollEdgeToolbarAppearance = UIToolbarAppearance()
        scrollEdgeToolbarAppearance.configureWithOpaqueBackground()
        scrollEdgeToolbarAppearance.shadowColor = nil
        scrollEdgeToolbarAppearance.backgroundColor = .clear
        
        let addReminderButton = AddReminderButton()
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let addReminderButtonItem = UIBarButtonItem(customView: addReminderButton)
        let addReminderListButtonItem = UIBarButtonItem(
            title: NSLocalizedString("Add List", comment: "Add new reminderl list button title"),
            style: .plain,
            target: self,
            action: #selector(didPressAddReminderListButton)
        )
        addReminderButton.addTarget(self, action: #selector(didPressAddReminderButton), for: .touchUpInside)
        
        self.toolbarItems = [addReminderButtonItem, flexibleSpace, addReminderListButtonItem]
        self.navigationController?.isToolbarHidden = false
        
        self.navigationController?.toolbar.standardAppearance = standardToobarAppearance
        self.navigationController?.toolbar.scrollEdgeAppearance = scrollEdgeToolbarAppearance
    }
    
    /// Configure reminder lists swipe actions.
    private func configureSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath, let reminderList = dataSource.itemIdentifier(for: indexPath) else { return nil }
        // Disable swipe if the reminder list's type is built-in.
        if reminderList.type != .userCreated { return nil }
        
        let deleteAction = configureDeleteAction(with: reminderList)
        let detailAction = configureDetailAction(with: reminderList)
        // Display only the delete action if in `Editmode`, otherwise display both delete and detail actions.
        let actions: [UIContextualAction] = isEditing ? [deleteAction] : [deleteAction, detailAction]
        let configuration = UISwipeActionsConfiguration(actions: actions)
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension ReminderListsViewController: UICollectionViewDelegate {
    
    /// Set ReminderListsViewController to `Editmode`.
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        collectionView.isEditing = editing
        // Update the snapshot to reflect changes in the appearance of lists.
        updateSnapshot()
    }
    
    /// Called when the user clicks the switch button in Date row.
    ///
    /// Navigate reminders view controller.
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        let reminderList = reminderListRepository.getReminderLists()[section * 4 + row]
        navigateToRemindersViewController(with: reminderList)
        return false
    }
}
