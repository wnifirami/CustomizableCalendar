import Foundation

// MARK: - Public API type

/// Controls whether the calendar renders a full month grid or a single-week strip.
public enum CalendarViewMode: String, CaseIterable {
    case month = "Month"
    case week  = "Week"
}

// MARK: - Internal view model

@MainActor
@Observable
final class CalendarViewModel {

    var viewMode: CalendarViewMode
    var displayedMonth: Date
    var currentWeekOffset: Int = 0

    private let calendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 2  // Monday
        return calendar
    }()

    init(initialViewMode: CalendarViewMode = .month) {
        self.viewMode      = initialViewMode
        self.displayedMonth = Date()
    }

    // MARK: - Navigation

    func goToPreviousPeriod() {
        let component: Calendar.Component = viewMode == .month ? .month : .weekOfYear
        displayedMonth = calendar.date(byAdding: component, value: -1, to: displayedMonth) ?? displayedMonth
    }

    func goToNextPeriod() {
        let component: Calendar.Component = viewMode == .month ? .month : .weekOfYear
        displayedMonth = calendar.date(byAdding: component, value: 1, to: displayedMonth) ?? displayedMonth
    }

    // MARK: - Month grid

    var monthDays: [CalendarDay] {
        guard
            let monthInterval = calendar.dateInterval(of: .month,       for: displayedMonth),
            let firstWeek     = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.start),
            let lastWeek      = calendar.dateInterval(of: .weekOfMonth, for: monthInterval.end - 1)
        else { return [] }

        var days: [CalendarDay] = []
        var current = firstWeek.start
        while current < lastWeek.end {
            days.append(CalendarDay(
                date: current,
                isCurrentMonth: calendar.isDate(current, equalTo: displayedMonth, toGranularity: .month)
            ))
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? lastWeek.end
        }
        return days
    }

    // MARK: - Week grid

    func weekDays(for offset: Int) -> [CalendarDay] {
        let today = calendar.startOfDay(for: Date())
        guard
            let targetDate   = calendar.date(byAdding: .weekOfYear, value: offset, to: today),
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: targetDate)
        else { return [] }

        var days: [CalendarDay] = []
        var current = weekInterval.start
        for _ in 0..<7 {
            days.append(CalendarDay(
                date: current,
                isCurrentMonth: calendar.isDate(current, equalTo: targetDate, toGranularity: .month)
            ))
            current = calendar.date(byAdding: .day, value: 1, to: current) ?? current
        }
        return days
    }

    // MARK: - Sync week selection

    /// Updates `displayedMonth` to match the new week offset and returns the
    /// updated selected date (preserving the same weekday position).
    func syncSelection(toWeekOffset offset: Int, currentSelectedDate: Date) -> Date {
        let today = calendar.startOfDay(for: Date())
        guard
            let targetDate   = calendar.date(byAdding: .weekOfYear, value: offset, to: today),
            let weekInterval = calendar.dateInterval(of: .weekOfYear, for: targetDate)
        else { return currentSelectedDate }

        displayedMonth = targetDate

        let currentWeekday = calendar.component(.weekday, from: currentSelectedDate)
        let weekdayOffset  = (currentWeekday - calendar.firstWeekday + 7) % 7
        let candidate      = calendar.date(byAdding: .day, value: weekdayOffset, to: weekInterval.start) ?? weekInterval.start
        return candidate < weekInterval.end ? candidate : weekInterval.start
    }

    // MARK: - Display strings

    var displayedMonthTitle: String {
        DateFormatter.calendarMonthYear.string(from: displayedMonth)
    }

    func weekTitle(for offset: Int) -> String {
        let today = calendar.startOfDay(for: Date())
        guard let target = calendar.date(byAdding: .weekOfYear, value: offset, to: today) else { return "" }
        return DateFormatter.calendarMonthYear.string(from: target)
    }
}
