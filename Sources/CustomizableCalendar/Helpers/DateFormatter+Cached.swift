import Foundation

/// Cached `DateFormatter` instances shared across the calendar.
///
/// `DateFormatter` initialisation is expensive (~1 ms). Creating one per render
/// — inside computed properties or `body` — accumulates quickly across 35+ day cells.
/// These static instances are created once and reused on the main thread.
///
/// - Note: All access occurs on `@MainActor` (CalendarViewModel + SwiftUI view bodies),
///   so a single shared instance per formatter is safe.
extension DateFormatter {

    /// Locale-aware month and year, e.g. `"October 2024"` or `"2024年10月"`.
    static let calendarMonthYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("MMMMy")
        return formatter
    }()

    /// Full weekday name, e.g. `"Monday"`.
    static let calendarWeekday: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        return formatter
    }()

    /// Day-of-month number without leading zero, e.g. `"5"`.
    static let calendarDayNumber: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter
    }()

    /// Short schedule header, e.g. `"Monday, Oct 5"`.
    static let calendarScheduleHeader: DateFormatter = {
        let formatter = DateFormatter()
        formatter.setLocalizedDateFormatFromTemplate("EEEEMMMd")
        return formatter
    }()

    /// 12-hour event time, e.g. `"09:00 AM"`.
    static let calendarEventTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter
    }()
}
