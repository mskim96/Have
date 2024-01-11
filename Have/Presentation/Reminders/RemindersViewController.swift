/**
 * Abstract:
 * Reminders view controller.
 */

import UIKit

class RemindersViewController: UIViewController {
    
    let reminderListRepository: ReminderListRepository = DefaultReminderListRepository()
    let reminderRepository: ReminderRepository = DefaultReminderRepository()
    
    /// Current reminder list from ReminderListsViewController.
    var reminderList: ReminderList
    /// The Reminders filtered by the current reminder list.
    var filteredReminders = [Reminder]()
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Reminder>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupToolbar()
        configureHierarchy()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIAfterFetchData()
    }
    
    init(reminderList: ReminderList) {
        self.reminderList = reminderList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Configure view hierarchy and layout.

extension RemindersViewController {
    
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
        listConfiguration.trailingSwipeActionsConfigurationProvider = configureSwipeAction
        listConfiguration.separatorConfiguration = seperatorConfiguration
        listConfiguration.backgroundColor = .clear
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func setupNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [.foregroundColor: reminderList.color]
        navigationItem.title = reminderList.name
        navigationItem.standardAppearance = appearance
        navigationController?.navigationBar.prefersLargeTitles = true
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
        
        /// The Add reminder button appears when the currentReminderList is not `builtInCompleted`.
        let builtInCompletedType = reminderList.type == .builtInCompleted
        if !builtInCompletedType {
            let button = AddReminderButton()
            let addButton = UIBarButtonItem(customView: button)
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            button.addTarget(self, action: #selector(didPressAddReminderButton(_:)), for: .touchUpInside)
            self.toolbarItems = [addButton, flexibleSpace]
        }
        
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.standardAppearance = standardToobarAppearance
        self.navigationController?.toolbar.scrollEdgeAppearance = scrollEdgeToolbarAppearance
    }
    
    /// Configure reminder swipe actions.
    private func configureSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath, let reminder = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let configuration = UISwipeActionsConfiguration(
            actions: [
                configureDeleteAction(with: reminder),
                configureFlagAction(with: reminder),
                configurDetailAction(with: reminder)
            ]
        )
        // Set to disabled full swipe action.
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

// MARK: - UICollectionViewDelegate

extension RemindersViewController: UICollectionViewDelegate {
    
    /// Navigate to ReminderViewController with the reminder when the user clicked the cell.
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let reminder = filteredReminders[indexPath.item]
        navigateToReminderViewController(with: reminder)
        return false
    }
}
