/**
 * Abstract:
 * Extensions for array.
 */

import Foundation

extension Array {
    
    /// Splits the original array into tuple,
    /// where `first` array contains elements for which predicate yielded `true`
    /// while `second` list contains elements for which predicate yielded `false`
    ///
    func partition(predicate: (Element) -> Bool) -> ([Element], [Element]) {
        var first = Array<Element>()
        var second = Array<Element>()
        for element in self {
            if (predicate(element)) {
                first.append(element)
            } else {
                second.append(element)
            }
        }
        return (first, second)
    }
}
