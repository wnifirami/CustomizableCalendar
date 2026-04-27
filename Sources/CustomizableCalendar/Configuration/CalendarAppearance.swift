import Foundation

/// Visual behaviour options for the calendar.
public struct CalendarAppearance: Equatable {

    /// When `true`, Saturday and Sunday day numbers and weekday headers render in `colors.mutedText`.
    public var dimWeekends: Bool = true

    /// When `true`, dates before today render in `colors.mutedText`.
    public var dimPastDays: Bool = true

    /// Overrides the 7 weekday-header symbols (Monday → Sunday).
    ///
    /// Set to `nil` to derive symbols automatically from `Locale.current`.
    /// When non-nil the array **must** contain exactly 7 strings; an invalid
    /// count falls back to the device locale.
    public var weekdaySymbolOverride: [String]? = nil

    public init() {}
}
