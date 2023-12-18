/**
 * Abstract:
 * Date picker content view.
 */

import UIKit

class DatePickerContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var date: Date = Date.now
        var onChangeDate: (Date) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return DatePickerContentView(self)
        }
        
        func updated(for state: UIConfigurationState) -> Self {
            return self
        }
    }
    
    let datePicker = UIDatePicker()
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
                datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
                datePicker.topAnchor.constraint(equalTo: self.topAnchor),
                datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
        
        datePicker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .inline
        datePicker.datePickerMode = .date
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePicker.date = configuration.date
    }
    
    @objc private func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? DatePickerContentView.Configuration else { return }
        configuration.onChangeDate(sender.date)
    }
}

extension UICollectionViewListCell {
    
    func datePickerConfiguration() -> DatePickerContentView.Configuration {
        DatePickerContentView.Configuration()
    }
}
