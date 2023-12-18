/**
 * Abstract:
 * Add new reminder list.
 */

import UIKit

class ReminderListViewController: UIViewController {
    
    // TODO: Add a section to choose the color of ReminderList.
    enum Section: Hashable {
        case listName
    }
    
    // TODO: Add a row to choose the color of ReminderList.
    enum Row: Hashable {
        case listName
    }
    
    // Indicates whether it's a new reminder list or an edited reminder list.
    var isAddingNewReminderList = false
    
    // Initial reminder list selected from list of reminder list.
    var reminderList: ReminderList {
        didSet {
            onChangeReminderList(reminderList)
        }
    }
    
    // Working reminder list for when the if user edits a reminder list.
    var workingReminderList: ReminderList
    /// Closure for save reminder.
    var onChangeReminderList: (ReminderList) -> Void
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Row>! = nil
    
    init(reminderList: ReminderList, onChangeReminderList: @escaping (ReminderList) -> Void) {
        self.reminderList = reminderList
        self.workingReminderList = reminderList
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

// MARK: - Establish the view hierarchy and configure the associated layout.

extension ReminderListViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        view.addFullScreenSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func setupNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        let navigationTitle = isAddingNewReminderList ?
        NSLocalizedString("New List", comment: "Add New Reminder List title")
        : NSLocalizedString("List Info", comment: "Reminder List info title")
        
        navigationItem.title = navigationTitle
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didPressCancelButton)
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(didPressDoneButton)
        )
    }
}
