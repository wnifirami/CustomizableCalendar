import SwiftUI

/// Font family and size scale for the calendar.
///
/// All text in the calendar is rendered via `typography.font(_:weight:)`,
/// so changing `fontFamily` affects every label at once.
///
/// ```swift
/// var config = CalendarConfiguration.default
/// config.typography.fontFamily = "Avenir Next"
/// config.typography.title = 30
/// ```
public struct CalendarTypography: Equatable {

    /// PostScript name of the font applied to all calendar text. Defaults to `"Georgia"`.
    public var fontFamily: String = "Georgia"

    /// 10 pt — used for weekday headers, event dot labels, and section tags.
    public var extraSmall: CGFloat = 10

    /// 12 pt — used for time ranges and secondary metadata.
    public var small: CGFloat = 12

    /// 14 pt — used for day numbers and body text.
    public var medium: CGFloat = 14

    /// 16 pt — used for event titles and toggle labels.
    public var large: CGFloat = 16

    /// 20 pt — used for agenda headers and week/month titles in cards.
    public var extraLarge: CGFloat = 20

    /// 28 pt — used for the displayed month/year headline.
    public var title: CGFloat = 28

    public init() {}

    /// Returns a `Font` using `fontFamily` at the given `size` and `weight`.
    ///
    /// - Parameters:
    ///   - size: Point size, typically one of the scale constants on this type.
    ///   - weight: SwiftUI font weight. Defaults to `.regular`.
    public func font(_ size: CGFloat, weight: Font.Weight = .regular) -> Font {
        Font.custom(fontFamily, size: size).weight(weight)
    }
}
