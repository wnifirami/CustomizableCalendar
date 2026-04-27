import CoreGraphics

/// Spacing and corner-radius tokens used throughout the calendar.
///
/// Every `padding`, `spacing`, and `cornerRadius` call reads from this struct,
/// so adjusting a single token resizes the entire UI consistently.
///
/// ```swift
/// var config = CalendarConfiguration.default
/// config.spacing.medium = 20        // more breathing room in cards
/// config.spacing.cornerLarge = 24   // rounder cards
/// ```
public struct CalendarSpacing: Equatable {

    // MARK: Padding tokens

    /// 4 pt — tight inner padding (e.g. day-cell vertical inset, dot gaps).
    public var extraSmall: CGFloat = 4

    /// 8 pt — component-level padding (e.g. button hit areas, card inner rows).
    public var small: CGFloat = 8

    /// 16 pt — standard section padding (e.g. card insets, horizontal screen margins).
    public var medium: CGFloat = 16

    /// 24 pt — large gaps between major sections.
    public var large: CGFloat = 24

    /// 32 pt — extra-large gaps used sparingly for empty-state vertical insets.
    public var extraLarge: CGFloat = 32

    // MARK: Corner radii

    /// 8 pt — small elements: toggle pill segments, text field backgrounds.
    public var cornerSmall: CGFloat = 8

    /// 12 pt — medium elements: event cards, segmented controls.
    public var cornerMedium: CGFloat = 12

    /// 20 pt — large elements: main cards and panels.
    public var cornerLarge: CGFloat = 20

    public init() {}
}
