import SwiftUI

struct WeekCalendarView: View {
    @Bindable var viewModel: CalendarViewModel
    @Binding var selectedDate: Date
    var configuration: CalendarConfiguration
    var highlightedDates: Set<Date>

    private let weekRange: ClosedRange<Int> = -104...104
    private let stripHeight: CGFloat = 96

    var body: some View {
        let colors  = configuration.colors
        let spacing = configuration.spacing

        TabView(selection: $viewModel.currentWeekOffset) {
            ForEach(weekRange, id: \.self) { offset in
                WeekStripPage(
                    viewModel: viewModel,
                    selectedDate: $selectedDate,
                    weekOffset: offset,
                    configuration: configuration,
                    highlightedDates: highlightedDates
                )
                .tag(offset)
                .padding(.horizontal, spacing.medium)
            }
        }
        #if os(iOS)
        .tabViewStyle(.page(indexDisplayMode: .never))
        #endif
        .frame(height: stripHeight)
        .padding(spacing.medium)
        .background(
            RoundedRectangle(cornerRadius: spacing.cornerLarge)
                .fill(colors.surface)
                .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
        )
        .onChange(of: viewModel.currentWeekOffset) { _, newOffset in
            selectedDate = viewModel.syncSelection(
                toWeekOffset: newOffset,
                currentSelectedDate: selectedDate
            )
        }
    }
}

// MARK: - WeekStripPage

private struct WeekStripPage: View {
    var viewModel: CalendarViewModel
    @Binding var selectedDate: Date
    let weekOffset: Int
    var configuration: CalendarConfiguration
    var highlightedDates: Set<Date>

    var body: some View {
        let days       = viewModel.weekDays(for: weekOffset)
        let symbols    = WeekdaySymbolResolver.resolve(
            override: configuration.appearance.weekdaySymbolOverride
        )
        let colors     = configuration.colors
        let typography = configuration.typography
        let spacing    = configuration.spacing

        VStack(spacing: spacing.extraSmall) {
            HStack(spacing: 0) {
                ForEach(Array(days.enumerated()), id: \.offset) { index, day in
                    Text(symbols[index])
                        .font(typography.font(typography.extraSmall, weight: .medium))
                        .foregroundStyle(
                            configuration.appearance.dimWeekends && Calendar.current.isDateInWeekend(day.date)
                                ? colors.mutedText : colors.secondaryText
                        )
                        .frame(maxWidth: .infinity)
                }
            }
            HStack(spacing: 0) {
                ForEach(days) { day in
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
    }
}
