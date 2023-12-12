/**
 * Abstract - Reminder detail view controller.
 */

import UIKit

class ReminderViewController: UIViewController {
    
    /// Reminder selected from the list of reminders.
    var reminder: Reminder {
        didSet {
            onChangeReminder(reminder)
        }
    }
    
    /// Working reminder for when the if user edits a reminder.
    var workingReminder: Reminder
    /// Closure for save reminder.
    var onChangeReminder: (Reminder) -> Void
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Row>! = nil
    
    /// Switches to control based on the state of the working reminder.
    var dateSwitch: UISwitch! = nil
    var timeSwitch: UISwitch! = nil
    
    init(reminder: Reminder, onChangeReminder: @escaping (Reminder) -> Void) {
        self.reminder = reminder
        self.workingReminder = reminder
        self.onChangeReminder = onChangeReminder
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureHierarachy()
        configureDataSource()
    }
}

// MARK: - Set up the view hierarchy and establish the layout.

extension ReminderViewController {
    
    func configureHierarachy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
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
        var listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func configureNavigationBar() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        navigationItem.title = NSLocalizedString("Detail", comment: "Reminder view controller title")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(didPressCancelButton(_:))
        )
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(didPressSaveButton(_:))
        )
    }
}

// MARK: - UICollecdtionViewDelegate

extension ReminderViewController: UICollectionViewDelegate {
    
    /// Enables expanding additional information when the user clicks.
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let row = dataSource.itemIdentifier(for: indexPath) else { return }
        switch row {
        case .date: toggleExpandableRowSnapshot(at: row)
        case .time: toggleExpandableRowSnapshot(at: row)
        default: break
        }
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    /// Only sets click events for the date row and time row.
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let row = dataSource.itemIdentifier(for: indexPath)
        // Enables clicking only when the corresponding value is not nil.
        switch row {
        case .date: return workingReminder.dueDate != nil
        case .time: return workingReminder.dueTime != nil
        default: return false
        }
    }
}
