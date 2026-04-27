import SwiftUI

public extension Color {
    /// Creates a `Color` from a CSS-style hex string, e.g. `"#1B2A4A"` or `"1B2A4A"`.
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var value: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&value)
        let red   = Double((value >> 16) & 0xFF) / 255
        let green = Double((value >> 8)  & 0xFF) / 255
        let blue  = Double(value         & 0xFF) / 255
        self.init(red: red, green: green, blue: blue)
    }
}
