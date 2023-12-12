/**
 * Abstract - Date extenstion for Reminder.
 */

import Foundation
import UIKit

extension Date {
    
    /// Default date formatter.
    private func defaultDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
    
    /// Detail date formatter.
    private func detailDateFormatter() -> DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = .current
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .none
        return dateFormatter
    }
    
    /// The date text for the reminder.
    ///
    /// - Parameters:
    ///     - time: time for represent string
    ///
    /// - Returns:
    ///     A String represent the date only if the time value is nil.
    ///     if the time value is not nil, it returns a string that includues both date and time.
    ///
    func dateText(with time: Date? = nil) -> String {
        return time != nil ? dayAndTimeText(with: time!) : onlyDayText()
    }
    
    /// The date text for the reminder detail.
    func detailDayText() -> String {
        return onlyDayText(detail: true)
    }
    
    // The time text for the reminder detail.
    func timeText() -> String {
        return self.formatted(date: .omitted, time: .shortened)
    }
    
    ///
    /// The day text for the reminder only includes the date.
    ///
    /// if the date falls within the range of (yesterday, today, tomorrow), it returns the
    /// corresponding string. otherwise, it returns value in the format.
    ///
    /// - Parameters:
    ///     - detail: flag to receive a string in a detailed format.
    ///
    ///  - Returns:
    ///     - default: e.g.`Today` or `2023/12/30`
    ///     - detail: e.g. `Today` or `Saturday, December 13, 2023`
    ///
    private func onlyDayText(detail: Bool = false) -> String {
        switch self {
        case _ where Locale.current.calendar.isDateInToday(self):
            return NSLocalizedString("Today", comment: "Today date description")
        case _ where Locale.current.calendar.isDateInTomorrow(self):
            return NSLocalizedString("Tomorrow", comment: "Tomorrow date description")
        case _ where Locale.current.calendar.isDateInYesterday(self):
            return NSLocalizedString("Yesterday", comment: "Yesterday date description")
        default:
            return detail ? detailDateFormatter().string(from: self) : defaultDateFormatter().string(from: self)
        }
    }
    
    ///
    /// The day with time text for the reminder.
    ///
    /// if the date falls within the range of (yesterday, today, tomorrow), it returns the
    /// corresponding date string with time string. otherwise, it returns value in the format.
    ///
    /// e.g.`Today 12:00` or `2023/12/30 12:00`
    ///
    private func dayAndTimeText(with time: Date) -> String {
        let timeText = time.formatted(date: .omitted, time: .shortened)
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
            return defaultDateFormatter().string(from: self) + " " + timeText
        }
    }
}
