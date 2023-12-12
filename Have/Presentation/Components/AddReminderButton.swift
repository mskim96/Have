/**
 * Abstract - Add Reminder button that includes both icon and text.
 */

import UIKit

class AddReminderButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        let imageConfiguration = UIImage.SymbolConfiguration(weight: .heavy)
        let image = UIImage(systemName: "plus.circle.fill", withConfiguration: imageConfiguration)
        let label = NSLocalizedString("Add Reminder", comment: "Add reminder toolbar button")
        let title = NSAttributedString(
            string: label,
            attributes: [
                .font: UIFont.systemFont(ofSize: 16.0, weight: .medium)
            ]
        )
        
        var buttonConfiguration = UIButton.Configuration.plain()
        buttonConfiguration.image = image
        buttonConfiguration.imagePadding = 8
        buttonConfiguration.contentInsets = .zero
        
        self.configuration = buttonConfiguration
        self.setAttributedTitle(title, for: .normal)
    }
}
