/**
 * Abstract - Section for DiffableDataSource in Reminder view controller.
 */

import UIKit

extension ReminderViewController {
    
    enum Section: Int, Hashable {
        case titleAndNotes
        case dateAndTime
        case flag
    }
}
