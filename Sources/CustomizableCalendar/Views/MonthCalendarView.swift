import SwiftUI

struct MonthCalendarView: View {
    var viewModel: CalendarViewModel
    @Binding var selectedDate: Date
    var configuration: CalendarConfiguration
    var highlightedDates: Set<Date>

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)

    var body: some View {
        let colors  = configuration.colors
        let spacing = configuration.spacing

        VStack(spacing: spacing.medium) {
            weekdayHeaderRow
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(viewModel.monthDays) { day in
                    let dayKey = Calendar.current.startOfDay(for: day.date)
                    DayCellView(
                        day: day,
                        isSelected: Calendar.current.isDate(day.date, inSameDayAs: selectedDate),
                        hasEvent: highlightedDates.contains(dayKey),
                        configuration: configuration
                    ) {
                        selectedDate = day.date
                    }
                    .equatable()
                }
            }
        }
        .padding(spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: spacing.cornerLarge)
                .fill(colors.surface)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        )
    }

    private var weekdayHeaderRow: some View {
        let colors     = configuration.colors
        let typography = configuration.typography
        let symbols    = WeekdaySymbolResolver.resolve(
            override: configuration.appearance.weekdaySymbolOverride
        )

        return HStack(spacing: 0) {
            ForEach(Array(symbols.enumerated()), id: \.offset) { index, symbol in
                let isWeekend = configuration.appearance.dimWeekends && (index == 5 || index == 6)
                Text(symbol)
                    .font(typography.font(typography.extraSmall, weight: .medium))
                    .foregroundStyle(isWeekend ? colors.mutedText : colors.secondaryText)
                    .frame(maxWidth: .infinity)
            }
        }
    }
}
