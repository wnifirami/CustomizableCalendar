import SwiftUI

/// A single day cell in the month or week grid.
///
/// All data arrives as value-type parameters. Combined with `Equatable` and
/// `.equatable()` at the call site, SwiftUI skips re-rendering cells whose
/// inputs are unchanged — only the tapped-away and newly-selected cells redraw.
struct DayCellView: View {

    let day: CalendarDay
    let isSelected: Bool
    let hasEvent: Bool
    let configuration: CalendarConfiguration
    let onTap: () -> Void

    private var isWeekend: Bool { Calendar.current.isDateInWeekend(day.date) }
    private var isPast: Bool    { day.date < Calendar.current.startOfDay(for: Date()) }

    private var textColor: Color {
        let appearance = configuration.appearance
        let colors     = configuration.colors
        if day.isToday                              { return .white }
        if !day.isCurrentMonth                      { return colors.mutedText }
        if appearance.dimPastDays && isPast         { return colors.mutedText }
        if appearance.dimWeekends && isWeekend      { return colors.secondaryText }
        return colors.primaryText
    }

    var body: some View {
        let colors     = configuration.colors
        let typography = configuration.typography
        let spacing    = configuration.spacing

        Button(action: onTap) {
            VStack(spacing: spacing.extraSmall) {
                ZStack {
                    if day.isToday {
                        Circle().fill(colors.todayHighlight).frame(width: 34, height: 34)
                    } else if isSelected {
                        Circle().stroke(colors.primary, lineWidth: 1.5).frame(width: 34, height: 34)
                    }
                    Text(day.dayNumber)
                        .font(typography.font(typography.medium, weight: day.isToday ? .bold : .regular))
                        .foregroundStyle(textColor)
                }

                Circle()
                    .fill(hasEvent ? colors.primary : .clear)
                    .frame(width: 5, height: 5)
                    .opacity(configuration.appearance.dimPastDays && isPast ? 0.4 : 1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, spacing.extraSmall)
        }
        .buttonStyle(.plain)
    }
}

extension DayCellView: Equatable {
    static func == (lhs: DayCellView, rhs: DayCellView) -> Bool {
        lhs.day        == rhs.day        &&
        lhs.isSelected == rhs.isSelected &&
        lhs.hasEvent   == rhs.hasEvent   &&
        lhs.configuration == rhs.configuration
    }
}
