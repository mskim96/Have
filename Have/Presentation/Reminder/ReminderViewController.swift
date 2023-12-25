/**
 * Abstract:
 * Reminder detail view controller.
 */

import UIKit

class ReminderViewController: UIViewController {
    
    let reminderListRepository: ReminderListRepository = DefaultReminderListRepository()
    
    /// Indicates whether it's a new reminder or an edited reminder.
    var isAddingNewReminder = false
    /// Indicates user-selected reminder list type.
    var fromReminderListType: ReminderListType
    
    /// Reminder selected from the list of reminders.
    var reminder: Reminder {
        didSet {
            onChangeReminder(reminder)
        }
    }
    
    var currentReminderList: ReminderList? = nil
    
    /// Working reminder for when the if user edits a reminder.
    var workingReminder: Reminder
    /// Closure for save reminder.
    var onChangeReminder: (Reminder) -> Void
    
    var collectionView: UICollectionView! = nil
    var dataSource: UICollectionViewDiffableDataSource<Section, Row>! = nil
    
    /// Switches to control based on the state of the working reminder.
    var dateSwitch: UISwitch! = nil
    var timeSwitch: UISwitch! = nil
    var flagSwitch: UISwitch! = nil
    
    init(
        fromReminderListType: ReminderListType,
        reminder: Reminder,
        onChangeReminder: @escaping (Reminder) -> Void
    ) {
        self.fromReminderListType = fromReminderListType
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
        
        setupNavigationBar()
        configureHierarachy()
        configureDataSource()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateUIAfterDataFetched()
    }
}

// MARK: - Set up the view hierarchy and establish the layout.

extension ReminderViewController {
    
    func configureHierarachy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.delegate = self
        view.addFullScreenSubview(collectionView)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let listConfiguration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        return UICollectionViewCompositionalLayout.list(using: listConfiguration)
    }
    
    private func setupNavigationBar() {
        // Related Appereance.
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        let editReminderTitle = NSLocalizedString("Detail", comment: "Reminder view controller title")
        let addNewReminderTitle = NSLocalizedString("New Reminder", comment: "New Reminder view controller title")
        
        // title and button items.
        navigationItem.title = isAddingNewReminder ? addNewReminderTitle : editReminderTitle
        
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
        
        // Set the initial enabled state of the save button.
        navigationItem.rightBarButtonItem?.isEnabled = !workingReminder.title.isEmpty
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
        case .reminderList:
            navigateSelectReminderListViewController(with: workingReminder.reminderListRefId)
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
        case .reminderList: return true
        default: return false
        }
    }
}

// MARK: - ReminderViewController Section with Row for diffable datasource

extension ReminderViewController {
    
    enum Section: Int, Hashable {
        case titleAndNotes
        case dateAndTime
        case flag
        case reminderList
    }
    
    enum Row: Hashable {
        case editableTitle
        case editableNotes
        case date
        case editableDate
        case time
        case editableTime
        case flag
        case reminderList
        
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        private var imageName: String? {
            switch self {
            case .date: return "calendar"
            case .time: return "clock"
            case .flag: return "flag.fill"
            default: return nil
            }
        }
    }
    
    /// Get text for row's title.
    ///
    /// - Parameters:
    ///     - row: Row enum class
    ///
    /// - Returns: title text for each cell
    ///
    func text(for row: Row) -> String? {
        switch row {
        case .date: return NSLocalizedString("Date", comment: "Reminder Date row text")
        case .time: return NSLocalizedString("Time", comment: "Reminder Time row text")
        case .flag: return NSLocalizedString("Flag", comment: "Reminder Flag row text")
        default: return nil
        }
    }
    
    /// Get date or time text for date row and time row.
    ///
    /// - Parameters:
    ///     - row: Row enum class
    ///
    /// - Returns: formatted text for date or time row.
    ///
    func dateTimeText(for row: Row) -> String? {
        switch row {
        case .date: return workingReminder.dueDate?.detailDayText()
        case .time: return workingReminder.dueTime?.timeText()
        default: return nil
        }
    }
}
