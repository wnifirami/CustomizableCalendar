extension Array {
    /// Returns the element at `index` if it exists, otherwise `nil`.
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
