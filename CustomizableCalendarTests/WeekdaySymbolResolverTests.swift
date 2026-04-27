import XCTest
@testable import CustomizableCalendar

final class WeekdaySymbolResolverTests: XCTestCase {

    // MARK: - resolve(override:)

    func testResolveWithNilOverrideUsesCurrentLocale() {
        let symbols = WeekdaySymbolResolver.resolve(override: nil)
        XCTAssertEqual(symbols.count, 7)
    }

    func testResolveWithValidSevenElementOverrideReturnsThatOverride() {
        let custom = ["L", "M", "M", "J", "V", "S", "D"]
        XCTAssertEqual(WeekdaySymbolResolver.resolve(override: custom), custom)
    }

    func testResolveIgnoresOverrideWithFewerThanSevenElements() {
        let tooShort = ["MON", "TUE"]
        let symbols  = WeekdaySymbolResolver.resolve(override: tooShort)
        // Falls back to locale — result differs from the invalid override
        XCTAssertNotEqual(symbols, tooShort)
        XCTAssertEqual(symbols.count, 7)
    }

    func testResolveIgnoresOverrideWithMoreThanSevenElements() {
        let tooLong = ["A","B","C","D","E","F","G","H"]
        let symbols = WeekdaySymbolResolver.resolve(override: tooLong)
        XCTAssertNotEqual(symbols, tooLong)
        XCTAssertEqual(symbols.count, 7)
    }

    // MARK: - symbols(for:)

    func testSymbolsForEnglishLocaleHasSevenElements() {
        let symbols = WeekdaySymbolResolver.symbols(for: Locale(identifier: "en"))
        XCTAssertEqual(symbols.count, 7)
    }

    func testSymbolsStartWithMondayForEnglish() {
        let symbols = WeekdaySymbolResolver.symbols(for: Locale(identifier: "en"))
        XCTAssertEqual(symbols.first, "MON", "First symbol must be Monday")
    }

    func testSymbolsEndWithSundayForEnglish() {
        let symbols = WeekdaySymbolResolver.symbols(for: Locale(identifier: "en"))
        XCTAssertEqual(symbols.last, "SUN", "Last symbol must be Sunday")
    }

    func testAllSymbolsAreUppercased() {
        let locales: [Locale] = [
            Locale(identifier: "en"),
            Locale(identifier: "fr"),
            Locale(identifier: "de"),
        ]
        for locale in locales {
            let symbols = WeekdaySymbolResolver.symbols(for: locale)
            for symbol in symbols {
                XCTAssertEqual(symbol, symbol.uppercased(), "Symbol '\(symbol)' in \(locale.identifier) is not uppercased")
            }
        }
    }

    func testFrenchSymbolsDifferFromEnglish() {
        let english = WeekdaySymbolResolver.symbols(for: Locale(identifier: "en"))
        let french  = WeekdaySymbolResolver.symbols(for: Locale(identifier: "fr"))
        // At least some symbols should differ between French and English
        XCTAssertNotEqual(english, french)
    }

    func testEnglishFallbackHasSevenElements() {
        XCTAssertEqual(WeekdaySymbolResolver.englishFallback.count, 7)
    }

    func testEnglishFallbackStartsWithMon() {
        XCTAssertEqual(WeekdaySymbolResolver.englishFallback.first, "MON")
    }
}
