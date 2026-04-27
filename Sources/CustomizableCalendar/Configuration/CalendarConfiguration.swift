import SwiftUI

/// The single configuration value passed to `CalendarView`.
///
/// Start from `.default` and mutate only what you need:
/// ```swift
/// var config = CalendarConfiguration.default
/// config.colors.primary        = Color(hex: "#6B21A8")
/// config.colors.todayHighlight = Color(hex: "#6B21A8")
/// config.typography.fontFamily = "Avenir Next"
/// config.appearance.dimWeekends = false
///
/// CalendarView(selectedDate: $date, configuration: config)
/// ```
public struct CalendarConfiguration: Equatable {

    /// Color tokens.
    public var colors: CalendarColors

    /// Font family and size scale.
    public var typography: CalendarTypography

    /// Padding and corner-radius tokens.
    public var spacing: CalendarSpacing

    /// Visual behaviour (dimming, weekday symbol override).
    public var appearance: CalendarAppearance

    public init(
        colors:     CalendarColors     = CalendarColors(),
        typography: CalendarTypography = CalendarTypography(),
        spacing:    CalendarSpacing    = CalendarSpacing(),
        appearance: CalendarAppearance = CalendarAppearance()
    ) {
        self.colors     = colors
        self.typography = typography
        self.spacing    = spacing
        self.appearance = appearance
    }

    /// The built-in default theme.
    public static let `default` = CalendarConfiguration()
}
