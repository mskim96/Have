/**
 * Abstract:
 * An extension for converting between UIColor format and HexString.
 */

import UIKit

extension UIColor {
    
    convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        
        var rgb: UInt64 = 0
        
        guard Scanner(string: hexSanitized).scanHexInt64(&rgb) else {
            return nil
        }
        
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: 1.0  // Assuming alpha is always 1 for system colors
        )
    }
    
    func toHexString() -> String {
        guard let components = cgColor.components, components.count >= 3 else {
            return "#000000"
        }
        
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        
        return String(format: "#%02lX%02lX%02lX", red, green, blue)
    }
}

extension String {
    func toUIColor() -> UIColor {
        return UIColor(hex: self) ?? .black
    }
}
