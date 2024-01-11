/**
 * Abstract:
 * Placeholder Text view.
 */

import UIKit

class PlaceholderTextView: UITextView {
    
    var placeholder: String? {
        willSet {
            self.placeholderLabel.text = newValue
        }
    }
    
    let placeholderLabel = UILabel()
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setText(_ text: String?) {
        self.text = text
        changeVisiblity()
    }
    
    private func configure() {
        placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(placeholderLabel)
        
        NSLayoutConstraint.activate(
            [
                placeholderLabel.topAnchor.constraint(
                    equalTo: self.topAnchor,
                    constant: 7
                ),
                placeholderLabel.bottomAnchor.constraint(
                    equalTo: self.bottomAnchor,
                    constant: 7
                ),
                placeholderLabel.leadingAnchor.constraint(
                    equalTo: self.leadingAnchor,
                    constant: 5
                ),
                placeholderLabel.trailingAnchor.constraint(
                    equalTo: self.trailingAnchor,
                    constant: 5
                )
            ]
        )
        
        self.isScrollEnabled = false
        placeholderLabel.lineBreakMode = .byWordWrapping
        placeholderLabel.numberOfLines = 0
        placeholderLabel.font = self.font
        placeholderLabel.textColor = .secondaryLabel
        placeholderLabel.backgroundColor = .clear
    }
    
    func changeVisiblity() {
        if self.text.isEmpty {
            placeholderLabel.isHidden = false
        } else {
            placeholderLabel.isHidden = true
        }
    }
}
