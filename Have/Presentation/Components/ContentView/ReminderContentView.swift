/**
 * Abstract:
 * Content view for reminders.
 */

import UIKit

class ReminderContentView: UIView, UIContentView {
    
    /// Configuration for Reminder content view.
    struct Configuration: UIContentConfiguration {
        var reminder: Reminder?
        var onClickComplete: (Reminder.ID) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return ReminderContentView(self)
        }
        
        func updated(for state: UIConfigurationState) -> Self {
            return self
        }
    }
    
    // UI elements
    let completeButton = ReminderCompleteButton()
    let flagButton = UIButton()
    let titleLabel = UILabel()
    let notesLabel = UILabel()
    let dateLabel = UILabel()
    
    var basicReminderRow = UIStackView()
    var notesRow = UIStackView()
    var dateRow = UIStackView()
    var rootColumn = UIStackView()
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        prepareSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration,
              let reminder = configuration.reminder else { return }
        let symbolConfiguration = UIImage.SymbolConfiguration(textStyle: .title3)
        let completeButtonSymbolName = reminder.isCompleted ? "circle.fill" : "circle"
        let completeButtonSymbol = UIImage(systemName: completeButtonSymbolName, withConfiguration: symbolConfiguration)
        completeButton.setImage(completeButtonSymbol, for: .normal)
        completeButton.id = reminder.id
        completeButton.tintColor = reminder.isCompleted ? .systemBlue : .systemGray
        
        if reminder.isFlagged {
            let flagButtonSymbolName = "flag.fill"
            let flagButtonSymbol = UIImage(systemName: flagButtonSymbolName, withConfiguration: symbolConfiguration)
            flagButton.setImage(flagButtonSymbol, for: .normal)
            flagButton.tintColor = .systemOrange
        }
        flagButton.isHidden = !reminder.isFlagged
        
        titleLabel.text = reminder.title
        notesLabel.text = reminder.notes
        dateLabel.text = reminder.dueDate?.dateText(with: reminder.dueTime)
        dateLabel.textColor = reminder.dueDate?.isDateBeforeTodayColor()
        
        if reminder.isCompleted {
            titleLabel.textColor = .secondaryLabel
            notesLabel.textColor = .secondaryLabel
            dateLabel.textColor = .secondaryLabel
        }
    }
    
    func prepareSubViews() {
        titleLabel.font = .preferredFont(forTextStyle: .body)
        titleLabel.numberOfLines = 6
        
        notesLabel.font = .preferredFont(forTextStyle: .subheadline)
        notesLabel.textColor = .secondaryLabel
        notesLabel.numberOfLines = 6
        
        dateLabel.font = .preferredFont(forTextStyle: .subheadline)
        
        basicReminderRow = UIStackView(arrangedSubviews: [completeButton, titleLabel, flagButton])
        basicReminderRow.axis = .horizontal
        basicReminderRow.alignment = .top
        basicReminderRow.spacing = 8
        basicReminderRow.setCustomSpacing(16, after: flagButton)
        
        notesRow = UIStackView(arrangedSubviews: [notesLabel])
        notesRow.axis = .horizontal
        notesRow.layoutMargins = .init(top: 0, left: 32, bottom: 0, right: 0)
        notesRow.isLayoutMarginsRelativeArrangement = true
        
        dateRow = UIStackView(arrangedSubviews: [dateLabel])
        dateRow.axis = .horizontal
        dateRow.layoutMargins = .init(top: 0, left: 32, bottom: 0, right: 0)
        dateRow.isLayoutMarginsRelativeArrangement = true
        
        rootColumn = UIStackView(arrangedSubviews: [basicReminderRow, notesRow, dateRow])
        rootColumn.axis = .vertical
        self.addSubview(rootColumn)
        
        rootColumn.translatesAutoresizingMaskIntoConstraints = false
        
        titleLabel.setContentHuggingPriority(.init(249), for: .horizontal)
        completeButton.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        flagButton.setContentCompressionResistancePriority(.init(751), for: .horizontal)
        
        NSLayoutConstraint.activate(
            [
                rootColumn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                rootColumn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                rootColumn.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                rootColumn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
            ]
        )
        
        completeButton.addTarget(self, action: #selector(didPressCompleteButton(_:)), for: .touchUpInside)
    }
    
    @objc private func didPressCompleteButton(_ sender: ReminderCompleteButton) {
        guard let configuration = configuration as? ReminderContentView.Configuration,
              let id = sender.id else { return }
        configuration.onClickComplete(id)
    }
}

extension UICollectionViewListCell {
    
    func reminderConfiguration() -> ReminderContentView.Configuration {
        return ReminderContentView.Configuration()
    }
}
