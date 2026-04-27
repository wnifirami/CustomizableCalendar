import XCTest
@testable import CustomizableCalendar

@MainActor
final class CalendarViewModelTests: XCTestCase {

    // MARK: - Month grid

    func testMonthGridCountIsMultipleOfSeven() {
        XCTAssertTrue(CalendarViewModel().monthDays.count.isMultiple(of: 7))
    }

    func testMonthGridContainsBetween28And42Days() {
        let count = CalendarViewModel().monthDays.count
        XCTAssertTrue((28...42).contains(count), "Got \(count), expected 28–42")
    }

    func testMonthGridFirstDayIsMonday() {
        guard let first = CalendarViewModel().monthDays.first else { return XCTFail("Empty grid") }
        XCTAssertEqual(Calendar.current.component(.weekday, from: first.date), 2, "Grid must start on Monday")
    }

    func testMonthGridLastDayIsSunday() {
        guard let last = CalendarViewModel().monthDays.last else { return XCTFail("Empty grid") }
        XCTAssertEqual(Calendar.current.component(.weekday, from: last.date), 1, "Grid must end on Sunday")
    }

    func testMonthGridContainsTodaysDate() {
        XCTAssertTrue(CalendarViewModel().monthDays.contains { $0.isToday })
    }

    func testOutOfMonthDaysHaveIsCurrentMonthFalse() {
        let vm = CalendarViewModel()
        for day in vm.monthDays.filter({ !$0.isCurrentMonth }) {
            XCTAssertFalse(
                Calendar.current.isDate(day.date, equalTo: vm.displayedMonth, toGranularity: .month),
                "\(day.date) should not be in current month"
            )
        }
    }

    // MARK: - Week grid

    func testWeekGridAlwaysContainsSevenDays() {
        let vm = CalendarViewModel()
        XCTAssertEqual(vm.weekDays(for:  0).count, 7)
        XCTAssertEqual(vm.weekDays(for: -5).count, 7)
        XCTAssertEqual(vm.weekDays(for:  5).count, 7)
    }

    func testWeekGridFirstDayIsMonday() {
        guard let first = CalendarViewModel().weekDays(for: 0).first else { return XCTFail("Empty week") }
        XCTAssertEqual(Calendar.current.component(.weekday, from: first.date), 2, "Week must start on Monday")
    }

    func testCurrentWeekContainsToday() {
        XCTAssertTrue(CalendarViewModel().weekDays(for: 0).contains { $0.isToday })
    }

    func testFutureWeekDoesNotContainToday() {
        XCTAssertFalse(CalendarViewModel().weekDays(for: 4).contains { $0.isToday })
    }

    // MARK: - Navigation

    func testGoToPreviousPeriodMovesDisplayedMonthBack() {
        let vm = CalendarViewModel()
        let before = vm.displayedMonth
        vm.goToPreviousPeriod()
        XCTAssertLessThan(vm.displayedMonth, before)
    }

    func testGoToNextPeriodMovesDisplayedMonthForward() {
        let vm = CalendarViewModel()
        let before = vm.displayedMonth
        vm.goToNextPeriod()
        XCTAssertGreaterThan(vm.displayedMonth, before)
    }

    func testNavigatingBackThenForwardRestoresDisplayedMonth() {
        let vm = CalendarViewModel()
        let original = vm.displayedMonth
        vm.goToPreviousPeriod()
        vm.goToNextPeriod()
        XCTAssertEqual(
            Calendar.current.component(.month, from: vm.displayedMonth),
            Calendar.current.component(.month, from: original)
        )
    }

    func testGoToPreviousPeriodInWeekModeMovesOneWeek() {
        let vm = CalendarViewModel(initialViewMode: .week)
        let before = vm.displayedMonth
        vm.goToPreviousPeriod()
        let diff = Calendar.current.dateComponents([.day], from: vm.displayedMonth, to: before).day ?? 0
        XCTAssertTrue((6...8).contains(diff), "Week nav should shift ~7 days, got \(diff)")
    }

    // MARK: - Sync selection

    func testSyncSelectionUpdatesDisplayedMonth() {
        let vm = CalendarViewModel()
        let before = vm.displayedMonth
        _ = vm.syncSelection(toWeekOffset: 4, currentSelectedDate: Date())
        XCTAssertGreaterThanOrEqual(vm.displayedMonth, before)
    }

    func testSyncSelectionPreservesWeekdayPosition() {
        let vm = CalendarViewModel()
        let wednesday = nearestWeekday(4)
        let result = vm.syncSelection(toWeekOffset: 1, currentSelectedDate: wednesday)
        XCTAssertEqual(Calendar.current.component(.weekday, from: result), 4)
    }

    // MARK: - Display strings

    func testDisplayedMonthTitleIsNotEmpty() {
        XCTAssertFalse(CalendarViewModel().displayedMonthTitle.isEmpty)
    }

    func testWeekTitleForCurrentWeekIsNotEmpty() {
        XCTAssertFalse(CalendarViewModel().weekTitle(for: 0).isEmpty)
    }

    // MARK: - CalendarDay (internal model)

    func testCalendarDayIsTodayForTodaysDate() {
        XCTAssertTrue(CalendarDay(date: Date(), isCurrentMonth: true).isToday)
    }

    func testCalendarDayIsNotTodayForYesterdaysDate() {
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: Date()) ?? Date()
        XCTAssertFalse(CalendarDay(date: yesterday, isCurrentMonth: true).isToday)
    }

    func testDayNumberMatchesCalendarDayOfMonth() {
        let date = Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 5)) ?? Date()
        XCTAssertEqual(CalendarDay(date: date, isCurrentMonth: true).dayNumber, "5")
    }

    func testDayNumberNoLeadingZero() {
        let date = Calendar.current.date(from: DateComponents(year: 2024, month: 10, day: 3)) ?? Date()
        XCTAssertEqual(CalendarDay(date: date, isCurrentMonth: true).dayNumber, "3")
    }

    // MARK: - Helpers

    private func nearestWeekday(_ weekday: Int) -> Date {
        var components = DateComponents()
        components.weekday = weekday
        return Calendar.current.nextDate(
            after: Calendar.current.startOfDay(for: Date()),
            matching: components,
            matchingPolicy: .nextTime
        ) ?? Date()
    }
}
