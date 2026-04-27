import Foundation

struct CalendarDay: Identifiable, Equatable {
    var id: Date { date }
    let date: Date
    let isCurrentMonth: Bool

    var isToday: Bool { Calendar.current.isDateInToday(date) }

    var dayNumber: String { DateFormatter.calendarDayNumber.string(from: date) }
}
