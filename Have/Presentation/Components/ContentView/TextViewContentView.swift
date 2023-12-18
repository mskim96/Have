/**
 * Abstract:
 * Text view content view.
 */

import UIKit

class TextViewContentView: UIView, UIContentView {
    
    struct Configuration: UIContentConfiguration {
        var text: String? = ""
        var placeholder: String?
        var onChange : (String) -> Void = { _ in }
        
        func makeContentView() -> UIView & UIContentView {
            return TextViewContentView(self)
        }
        
        func updated(for state: UIConfigurationState) -> Self {
            return self
        }
    }
    
    let textView = PlaceholderTextView()
    private var maxHeight: CGFloat = 100
    
    var configuration: UIContentConfiguration {
        didSet {
            configure(configuration: configuration)
        }
    }
    
    init(_ configuration: UIContentConfiguration) {
        self.configuration = configuration
        super.init(frame: .zero)
        
        textView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textView)
        
        NSLayoutConstraint.activate(
            [
                textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
                textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8),
                textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 4),
                textView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ]
        )
        
        textView.delegate = self
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.font = .preferredFont(forTextStyle: .body)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(configuration: UIContentConfiguration) {
        guard let configuration = configuration as? Configuration else { return }
        textView.setText(configuration.text)
        textView.placeholder = configuration.placeholder
    }
}

extension UICollectionViewListCell {
    func textViewConfiguration() -> TextViewContentView.Configuration {
        return TextViewContentView.Configuration()
    }
}

// MARK: - UITextViewDelegate

extension TextViewContentView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let configuration = configuration as? TextViewContentView.Configuration else { return }
        configuration.onChange(textView.text)
        updateTextViewHeight()
        self.textView.changeVisiblity()
    }
    
    private func updateTextViewHeight() {
        let size = textView.frame.size
        let newSize = textView.sizeThatFits(CGSize(width: size.width, height: .greatestFiniteMagnitude))
        
        if newSize.height < maxHeight {
            textView.frame.size = newSize
            invalidateIntrinsicContentSize()
        } else {
            self.textView.isScrollEnabled = true
        }
    }
}
