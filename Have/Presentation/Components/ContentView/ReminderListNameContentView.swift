/**
 * Abstract:
 * Add or Edit Reminder list name content view.
 */

import UIKit

class ReminderListNameContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var reminderList: ReminderList = ReminderList(name: "")
        var onChangeName : (String) -> Void = { _ in }

        func makeContentView() -> UIView & UIContentView {
            return ReminderListNameContentView(self)
        }
        
        func updated(for state: UIConfigurationState) -> Self {
            return self
        }
    }
    
    let textField = UITextField()
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textField)
        
        NSLayoutConstraint.activate(
            [
                textField.topAnchor.constraint(equalTo: topAnchor, constant: 16),
                textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
                textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
                textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
                textField.heightAnchor.constraint(equalToConstant: 54)
            ]
        )
        
        textField.addTarget(self, action: #selector(didChangeName(_:)), for: .editingChanged)
        textField.placeholder = NSLocalizedString("List name", comment: "Reminder List name placeholer")
        textField.font = .systemFont(ofSize: 24, weight: .semibold)
        textField.clearButtonMode = .whileEditing
        textField.layer.cornerRadius = 8
        textField.layer.backgroundColor = UIColor.systemGray5.cgColor
        textField.leftView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 16.0, height: 0.0))
        textField.leftViewMode = .always
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textField.text = configuration.reminderList.name
        textField.textColor = configuration.reminderList.color
    }
    
    @objc private func didChangeName(_ sender: UITextField) {
        guard let configuration = configuration as? ReminderListNameContentView.Configuration else { return }
        configuration.onChangeName(textField.text ?? "")
    }
}

extension UICollectionViewListCell {
    func reminderListNameConfiguration() -> ReminderListNameContentView.Configuration {
        return ReminderListNameContentView.Configuration()
    }
}
