/**
 * Abstract - Row for DiffableDataSource in Reminder view controller 
 */

import UIKit

extension ReminderViewController {
    
    enum Row: Hashable {
        case editableTitle
        case editableNotes
        case date
        case editableDate
        case time
        case editableTime
        case flag
        
        var image: UIImage? {
            guard let imageName = imageName else { return nil }
            let configuration = UIImage.SymbolConfiguration(textStyle: .headline)
            return UIImage(systemName: imageName, withConfiguration: configuration)
        }
        
        private var imageName: String? {
            switch self {
            case .date: return "calendar"
            case .time: return "clock"
            case .flag: return "flag.fill"
            default: return nil
            }
        }
    }
    
    func text(for row: Row) -> String? {
        switch row {
        case .date: return NSLocalizedString("Date", comment: "Reminder Date row text")
        case .time: return NSLocalizedString("Time", comment: "Reminder Time row text")
        case .flag: return NSLocalizedString("Flag", comment: "Reminder Flag row text")
        default: return nil
        }
    }
    
    func dateTimeText(for row: Row) -> String? {
        switch row {
        case .date: return workingReminder.dueDate?.detailDayText()
        case .time: return workingReminder.dueTime?.timeText()
        default: return nil
        }
    }
}
