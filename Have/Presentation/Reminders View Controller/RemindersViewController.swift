/**
 * Abstract - Reminders view controller.
 */

import UIKit

class RemindersViewController: UIViewController {
    // TODO: Core Data 구현 완료 시 update 필요
    var reminders: [Reminder] = Reminder.sampleData
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Int, Reminder.ID>! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupToolbar()
        configureHierarchy()
        configureDataSource()
    }
}

// MARK: - Configure view hierarchy and layout.

extension RemindersViewController {
    
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        collectionView.delegate = self
        
        NSLayoutConstraint.activate(
            [
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
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
        // TODO: Category 기능 생기면, Category title 로 교체.
        navigationItem.title = NSLocalizedString("All", comment: "Reminders view controller title")
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupToolbar() {
        // Scroll edge appearance of toolbar.
        let scrollEdgeToolbarAppearance = UIToolbarAppearance()
        scrollEdgeToolbarAppearance.configureWithOpaqueBackground()
        scrollEdgeToolbarAppearance.shadowColor = nil

        let button = AddReminderButton()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        button.addTarget(self, action: #selector(didPressAddReminderButton(_:)), for: .touchUpInside)
        
        let addButton = UIBarButtonItem(customView: button)
        
        self.toolbarItems = [addButton, flexibleSpace]
        self.navigationController?.isToolbarHidden = false
        self.navigationController?.toolbar.scrollEdgeAppearance = scrollEdgeToolbarAppearance
    }
    
    /// Configure reminder swipe actions.
    private func configureSwipeAction(for indexPath: IndexPath?) -> UISwipeActionsConfiguration? {
        guard let indexPath, let id = dataSource.itemIdentifier(for: indexPath) else { return nil }
        let configuration = UISwipeActionsConfiguration(
            actions: [
                configureDeleteAction(withId: id),
                configureFlagAction(withId: id),
                configurDetailAction(withId: id)
            ]
        )
        // Set to disabled full swipe action.
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}

extension RemindersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let id = reminders[indexPath.item].id
        navigateToReminderViewController(withId: id)
        return false
    }
}
