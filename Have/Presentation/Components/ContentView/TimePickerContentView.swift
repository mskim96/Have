/**
 * Abstract:
 * Time Picker content view.
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
    
    let timePicker = UIDatePicker()
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        addSubview(timePicker)
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                timePicker.leadingAnchor.constraint(equalTo: self.leadingAnchor),
                timePicker.trailingAnchor.constraint(equalTo: self.trailingAnchor),
                timePicker.topAnchor.constraint(equalTo: self.topAnchor),
                timePicker.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
        
        timePicker.addTarget(self, action: #selector(didPick(_:)), for: .valueChanged)
        timePicker.preferredDatePickerStyle = .wheels
        timePicker.datePickerMode = .time
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        timePicker.date = configuration.time
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
