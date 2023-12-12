/**
 * Abstract - Time Picker content view.
 */

import UIKit

class TimePickerContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var time = Date.now
        var onChangeTime: (Date) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return TimePickerContentView(self)
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
                datePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                datePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                datePicker.topAnchor.constraint(equalTo: self.topAnchor),
                datePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
        
        datePicker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .time
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        datePicker.date = configuration.time
    }
    
    @objc private func didPick(_ sender: UIDatePicker) {
        guard let configuration = configuration as? TimePickerContentView.Configuration else { return }
        configuration.onChangeTime(sender.date)
    }
}

extension UICollectionViewListCell {
    
    func timePickerConfiguration() -> TimePickerContentView.Configuration {
        TimePickerContentView.Configuration()
    }
}
