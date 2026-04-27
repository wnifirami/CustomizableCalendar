import XCTest
import SwiftUI
@testable import CustomizableCalendar

final class CalendarConfigurationTests: XCTestCase {

    // MARK: - Value semantics

    func testMutatingColorsCopyDoesNotAffectOriginal() {
        let original = CalendarConfiguration.default
        var copy = original
        copy.colors.primary = Color(hex: "#FF0000")
        XCTAssertNotEqual(original.colors.primary, copy.colors.primary)
    }

    func testMutatingTypographyCopyDoesNotAffectOriginal() {
        let original = CalendarConfiguration.default
        var copy = original
        copy.typography.fontFamily = "Courier"
        XCTAssertNotEqual(original.typography.fontFamily, copy.typography.fontFamily)
    }

    func testMutatingSpacingCopyDoesNotAffectOriginal() {
        let original = CalendarConfiguration.default
        var copy = original
        copy.spacing.medium = 99
        XCTAssertEqual(original.spacing.medium, 16)
    }

    func testMutatingAppearanceCopyDoesNotAffectOriginal() {
        let original = CalendarConfiguration.default
        var copy = original
        copy.appearance.dimWeekends = false
        XCTAssertTrue(original.appearance.dimWeekends)
    }

    // MARK: - Default values

    func testDefaultDimWeekendsIsTrue() {
        XCTAssertTrue(CalendarConfiguration.default.appearance.dimWeekends)
    }

    func testDefaultDimPastDaysIsTrue() {
        XCTAssertTrue(CalendarConfiguration.default.appearance.dimPastDays)
    }

    func testDefaultWeekdaySymbolOverrideIsNil() {
        XCTAssertNil(CalendarConfiguration.default.appearance.weekdaySymbolOverride)
    }

    func testDefaultFontFamilyIsGeorgia() {
        XCTAssertEqual(CalendarConfiguration.default.typography.fontFamily, "Georgia")
    }

    func testDefaultSpacingMediumIs16() {
        XCTAssertEqual(CalendarConfiguration.default.spacing.medium, 16)
    }

    func testDefaultCornerLargeIs20() {
        XCTAssertEqual(CalendarConfiguration.default.spacing.cornerLarge, 20)
    }

    // MARK: - CalendarTypography.font

    func testFontReturnsNonNilResult() {
        let typography = CalendarTypography()
        XCTAssertNotNil(typography.font(typography.medium, weight: .bold))
    }

    // MARK: - WeekdaySymbolResolver (via CalendarAppearance)

    func testInvalidOverrideSixElementsFallsBackToLocale() {
        var appearance = CalendarAppearance()
        appearance.weekdaySymbolOverride = ["A", "B", "C", "D", "E", "F"]
        let result = WeekdaySymbolResolver.resolve(override: appearance.weekdaySymbolOverride)
        XCTAssertEqual(result.count, 7)
        XCTAssertNotEqual(result, appearance.weekdaySymbolOverride ?? [])
    }

    func testValidOverrideSevenElementsIsAccepted() {
        var appearance = CalendarAppearance()
        appearance.weekdaySymbolOverride = ["A", "B", "C", "D", "E", "F", "G"]
        let result = WeekdaySymbolResolver.resolve(override: appearance.weekdaySymbolOverride)
        XCTAssertEqual(result, ["A", "B", "C", "D", "E", "F", "G"])
    }
}
