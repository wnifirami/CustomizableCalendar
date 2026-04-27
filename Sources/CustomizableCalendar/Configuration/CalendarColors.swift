import SwiftUI

/// Color tokens used throughout the calendar UI.
///
/// Start from `CalendarConfiguration.default` and mutate only what you need:
/// ```swift
/// var config = CalendarConfiguration.default
/// config.colors.primary        = .indigo
/// config.colors.todayHighlight = .indigo
/// ```
public struct CalendarColors: Equatable {
    /// Today's date circle fill and selected-day ring.
    public var primary: Color = Color(hex: "#1B2A4A")

    /// Secondary accent used for section labels.
    public var accent: Color = Color(hex: "#4A7C59")

    /// Full-screen background.
    public var background: Color = Color(hex: "#F5F5F7")

    /// Card / panel background.
    public var surface: Color = .white

    /// High-contrast text for titles and day numbers.
    public var primaryText: Color = Color(hex: "#1A1A2E")

    /// Medium-contrast text for subtitles.
    public var secondaryText: Color = Color(hex: "#6B7280")

    /// Low-contrast text for out-of-month days and weekday headers.
    public var mutedText: Color = Color(hex: "#9CA3AF")

    /// Fill of the circle drawn behind today's date number. Mirrors `primary` by default.
    public var todayHighlight: Color = Color(hex: "#1B2A4A")

    public init() {}
}
