/**
 * Abstract:
 * UIView extension for configure view hierarchy.
 */

import UIKit

extension UIView {
    
    func addFullScreenSubview(_ subView: UIView) {
        addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                subView.leadingAnchor.constraint(equalTo: leadingAnchor),
                subView.trailingAnchor.constraint(equalTo: trailingAnchor),
                subView.topAnchor.constraint(equalTo: topAnchor),
                subView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ]
        )
    }
}
