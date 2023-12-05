import Foundation
import UIKit

extension Date {
    ///
    /// The day text for the task only includes the date.
    ///
    /// if the date falls within the range of (yesterday, today, tomorrow), it returns the
    /// corresponding string. otherwise, it returns value in the format.
    ///
    /// e.g.`Today` or `2023/12/30`
    ///
    var dayText: String {
        switch self {
        case _ where Locale.current.calendar.isDateInToday(self):
            return NSLocalizedString("Today", comment: "Today date description")
        case _ where Locale.current.calendar.isDateInTomorrow(self):
            return NSLocalizedString("Tomorrow", comment: "Tomorrow date description")
        case _ where Locale.current.calendar.isDateInYesterday(self):
            return NSLocalizedString("Yesterday", comment: "Yesterday date description")
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            return dateFormatter.string(from: self)
        }
    }
    
    ///
    /// The day with time text for the task.
    ///
    /// if the date falls within the range of (yesterday, today, tomorrow), it returns the
    /// corresponding date string with time string. otherwise, it returns value in the format.
    ///
    /// e.g.`Today 12:00` or `2023/12/30 12:00`
    ///
    var dayTimeText: String {
        let timeText = formatted(date: .omitted, time: .shortened)
        switch self {
        case _ where Locale.current.calendar.isDateInToday(self):
            let timeFormat = NSLocalizedString("Today %@", comment: "Today date description")
            return String(format: timeFormat, timeText)
        case _ where Locale.current.calendar.isDateInTomorrow(self):
            let timeFormat = NSLocalizedString("Tomorrow %@", comment: "Tomorrow date description")
            return String(format: timeFormat, timeText)
        case _ where Locale.current.calendar.isDateInYesterday(self):
            let timeFormat =  NSLocalizedString("Yesterday %@", comment: "Yesterday date description")
            return String(format: timeFormat, timeText)
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.locale = .current
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .short
            return dateFormatter.string(from: self)
        }
    }
}
