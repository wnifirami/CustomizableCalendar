import Foundation

/// Resolves the 7 weekday symbol strings used in calendar column headers.
///
/// Symbols are always returned in **Monday-first** order to match the calendar grid,
/// regardless of the locale's native week start day.
///
/// The resolver respects `CalendarAppearance.weekdaySymbolOverride`:
/// - `nil` → uses `Locale.current`, honouring the device language automatically.
/// - a 7-element array → uses those strings verbatim.
/// - any other count → falls back to `Locale.current` (invalid override is silently ignored).
enum WeekdaySymbolResolver {

    /// Returns the appropriate symbols based on an optional override array.
    ///
    /// - Parameter override: 7 custom strings, or `nil` to use the device locale.
    /// - Returns: 7 uppercased strings in Monday-first order.
    static func resolve(override: [String]?) -> [String] {
        if let override, override.count == 7 {
            return override
        }
        return symbols(for: .current)
    }

    /// Derives short weekday names from a `Locale` and rotates them to Monday-first.
    ///
    /// `DateFormatter.shortWeekdaySymbols` returns symbols Sunday-first (index 0 = Sunday).
    /// This method rotates the array so Monday sits at index 0.
    ///
    /// - Parameter locale: The locale to use for symbol names.
    /// - Returns: 7 uppercased strings starting from Monday.
    static func symbols(for locale: Locale) -> [String] {
        let formatter = DateFormatter()
        formatter.locale = locale
        guard let all = formatter.shortWeekdaySymbols, all.count == 7 else {
            return englishFallback
        }
        // Rotate: [Sun, Mon, Tue, Wed, Thu, Fri, Sat] → [Mon, Tue, Wed, Thu, Fri, Sat, Sun]
        return (Array(all[1...]) + [all[0]]).map { $0.uppercased() }
    }

    // Used when DateFormatter returns unexpected results (shouldn't occur in practice).
    static let englishFallback = ["MON", "TUE", "WED", "THU", "FRI", "SAT", "SUN"]
}
