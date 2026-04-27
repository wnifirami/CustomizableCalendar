import SwiftUI

/// A reusable, fully-customisable calendar view.
///
/// `CalendarView` handles layout, navigation, and date selection.
/// Everything else — events, agenda, settings — lives in your app.
///
/// **Minimal**
/// ```swift
/// CalendarView(selectedDate: $selectedDate)
/// ```
///
/// **With configuration and event indicators**
/// ```swift
/// var config = CalendarConfiguration.default
/// config.colors.primary = .indigo
///
/// CalendarView(
///     selectedDate: $selectedDate,
///     configuration: config,
///     highlightedDates: Set(events.keys)   // dates that show a dot
/// )
/// ```
///
/// The `highlightedDates` set should contain `Calendar.current.startOfDay(for:)` dates
/// so they align with the day cells rendered by the grid.
public struct CalendarView: View {

    @Binding var selectedDate: Date
    var configuration: CalendarConfiguration
    var highlightedDates: Set<Date>

    @State private var viewModel: CalendarViewModel

    /// Creates a `CalendarView`.
    ///
    /// - Parameters:
    ///   - selectedDate: Two-way binding to the currently selected date.
    ///   - configuration: Visual configuration. Defaults to `CalendarConfiguration.default`.
    ///   - highlightedDates: Start-of-day dates that display an indicator dot. Defaults to empty.
    ///   - initialViewMode: Whether to open in month or week mode. Defaults to `.month`.
    public init(
        selectedDate: Binding<Date>,
        configuration: CalendarConfiguration = .default,
        highlightedDates: Set<Date> = [],
        initialViewMode: CalendarViewMode = .month
    ) {
        _selectedDate         = selectedDate
        self.configuration    = configuration
        self.highlightedDates = highlightedDates
        _viewModel = State(initialValue: CalendarViewModel(initialViewMode: initialViewMode))
    }

    public var body: some View {
        let colors  = configuration.colors
        let spacing = configuration.spacing

        VStack(spacing: spacing.medium) {
            navigationHeader

            if viewModel.viewMode == .month {
                MonthCalendarView(
                    viewModel: viewModel,
                    selectedDate: $selectedDate,
                    configuration: configuration,
                    highlightedDates: highlightedDates
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal:   .move(edge: .top).combined(with: .opacity)
                ))
            } else {
                WeekCalendarView(
                    viewModel: viewModel,
                    selectedDate: $selectedDate,
                    configuration: configuration,
                    highlightedDates: highlightedDates
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .top).combined(with: .opacity),
                    removal:   .move(edge: .top).combined(with: .opacity)
                ))
            }
        }
        .padding(spacing.medium)
        .background(colors.background.ignoresSafeArea())
        .animation(.spring(response: 0.38, dampingFraction: 0.82), value: viewModel.viewMode)
    }

    // MARK: - Navigation header

    private var navigationHeader: some View {
        let colors     = configuration.colors
        let typography = configuration.typography
        let spacing    = configuration.spacing

        return HStack {
            HStack(spacing: spacing.small) {
                navButton("chevron.left", colors: colors, spacing: spacing) {
                    viewModel.goToPreviousPeriod()
                }
                Text(viewModel.viewMode == .month
                     ? viewModel.displayedMonthTitle
                     : viewModel.weekTitle(for: viewModel.currentWeekOffset))
                    .font(typography.font(typography.title, weight: .bold))
                    .foregroundStyle(colors.primaryText)
                    .animation(.none, value: viewModel.displayedMonthTitle)
                    .frame(minWidth: 180, alignment: .leading)
                navButton("chevron.right", colors: colors, spacing: spacing) {
                    viewModel.goToNextPeriod()
                }
            }

            Spacer()

            // Expand / collapse toggle — rotates 180° between states
            Button {
                withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                    viewModel.viewMode = viewModel.viewMode == .month ? .week : .month
                }
            } label: {
                Image(systemName: "chevron.down")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(colors.secondaryText)
                    .rotationEffect(.degrees(viewModel.viewMode == .month ? 180 : 0))
                    .frame(width: 32, height: 32)
                    .background(
                        RoundedRectangle(cornerRadius: spacing.cornerSmall)
                            .fill(colors.surface)
                    )
            }
        }
    }

    // MARK: - Helpers

    private func navButton(
        _ icon: String,
        colors: CalendarColors,
        spacing: CalendarSpacing,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(colors.secondaryText)
                .frame(width: 32, height: 32)
                .background(RoundedRectangle(cornerRadius: spacing.cornerSmall).fill(colors.surface))
        }
    }
}

#Preview {
    @Previewable @State var date = Date()
    CalendarView(selectedDate: $date)
}
