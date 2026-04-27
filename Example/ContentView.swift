import SwiftUI
// import CustomizableCalendar  ← uncomment when adding via Swift Package Manager

// MARK: - App entry point

struct ContentView: View {
    @State private var selectedDate = Date()
    @State private var configuration = CalendarConfiguration.default
    @State private var showSettings = false

    private var highlightedDates: Set<Date> {
        Set(AppEvent.sampleData.keys)
    }

    private var eventsForSelectedDay: [AppEvent] {
        AppEvent.sampleData[Calendar.current.startOfDay(for: selectedDate)] ?? []
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── Library component ──────────────────────────────────────────
                CalendarView(
                    selectedDate: $selectedDate,
                    configuration: configuration,
                    highlightedDates: highlightedDates
                )

                Divider()

                // ── App-level event list ───────────────────────────────────────
                eventList
            }
            .navigationTitle("Chronicle")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                            .foregroundStyle(configuration.colors.primary)
                    }
                }
            }
        }
        .tint(configuration.colors.primary)
        .sheet(isPresented: $showSettings) {
            ConfigurationSheet(configuration: $configuration)
        }
    }

    // MARK: - Event list

    private var eventList: some View {
        let colors     = configuration.colors
        let typography = configuration.typography
        let spacing    = configuration.spacing

        return Group {
            if eventsForSelectedDay.isEmpty {
                Text("No events")
                    .font(typography.font(typography.medium))
                    .foregroundStyle(colors.mutedText)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    VStack(spacing: spacing.small) {
                        ForEach(eventsForSelectedDay) { event in
                            EventRow(event: event, configuration: configuration)
                        }
                    }
                    .padding(spacing.medium)
                }
            }
        }
        .background(colors.background)
    }
}

// MARK: - Event row (app-level UI, not part of the library)

private struct EventRow: View {
    let event: AppEvent
    let configuration: CalendarConfiguration

    var body: some View {
        let colors     = configuration.colors
        let typography = configuration.typography
        let spacing    = configuration.spacing

        HStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 2)
                .fill(event.color)
                .frame(width: 3)
                .padding(.vertical, spacing.small)

            VStack(alignment: .leading, spacing: spacing.extraSmall) {
                Text(timeRange)
                    .font(typography.font(typography.small, weight: .medium))
                    .foregroundStyle(colors.secondaryText)
                Text(event.title)
                    .font(typography.font(typography.large, weight: .semibold))
                    .foregroundStyle(colors.primaryText)
            }
            .padding(.leading, spacing.medium)

            Spacer()
        }
        .padding(.horizontal, spacing.medium)
        .padding(.vertical, spacing.small)
        .background(
            RoundedRectangle(cornerRadius: configuration.spacing.cornerMedium)
                .fill(event.color.opacity(0.06))
        )
    }

    private var timeRange: String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return "\(formatter.string(from: event.startTime)) – \(formatter.string(from: event.endTime))"
    }
}

// MARK: - Configuration sheet (demonstrates live config editing)

private struct ConfigurationSheet: View {
    @Binding var configuration: CalendarConfiguration
    @Environment(\.dismiss) private var dismiss

    private let presets: [(name: String, config: CalendarConfiguration)] = [
        ("Default",  .default),
        ("Ocean",    .ocean),
        ("Forest",   .forest),
        ("Rose",     .rose),
    ]

    private let fonts = ["Georgia", "Helvetica Neue", "Avenir Next", "Palatino", "Menlo"]

    var body: some View {
        NavigationStack {
            Form {
                // Theme presets
                Section("Theme") {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(presets, id: \.name) { preset in
                                Button {
                                    configuration = preset.config
                                } label: {
                                    VStack(spacing: 6) {
                                        Circle()
                                            .fill(preset.config.colors.primary)
                                            .frame(width: 36, height: 36)
                                            .overlay(
                                                Circle()
                                                    .stroke(Color.primary, lineWidth: configuration.colors.primary == preset.config.colors.primary ? 2 : 0)
                                                    .padding(3)
                                            )
                                        Text(preset.name)
                                            .font(.caption)
                                            .foregroundStyle(.primary)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                // Font family
                Section("Font") {
                    Picker("Family", selection: $configuration.typography.fontFamily) {
                        ForEach(fonts, id: \.self) { Text($0).tag($0) }
                    }
                    .pickerStyle(.menu)
                }

                // Day appearance
                Section("Day appearance") {
                    Toggle("Dim weekends",  isOn: $configuration.appearance.dimWeekends)
                    Toggle("Dim past days", isOn: $configuration.appearance.dimPastDays)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

// MARK: - App event model (your own model, nothing to do with the library)

struct AppEvent: Identifiable {
    let id = UUID()
    var title: String
    var startTime: Date
    var endTime: Date
    var color: Color

    static var sampleData: [Date: [AppEvent]] {
        let calendar = Calendar.current
        let today    = Date()

        func makeEvent(
            offset: Int,
            startHour: Int,
            endHour: Int,
            title: String,
            hex: String
        ) -> (dayKey: Date, event: AppEvent) {
            let base     = calendar.date(byAdding: .day, value: offset, to: today) ?? today
            let start    = calendar.date(bySettingHour: startHour, minute: 0, second: 0, of: base) ?? base
            let end      = calendar.date(bySettingHour: endHour,   minute: 0, second: 0, of: base) ?? base
            let dayKey   = calendar.startOfDay(for: base)
            return (dayKey, AppEvent(title: title, startTime: start, endTime: end, color: Color(hex: hex)))
        }

        let pairs = [
            makeEvent(offset: 0, startHour: 9,  endHour: 10, title: "Editorial Strategy",  hex: "#1B2A4A"),
            makeEvent(offset: 0, startHour: 14, endHour: 15, title: "Garden Design Review", hex: "#4A7C59"),
            makeEvent(offset: 2, startHour: 10, endHour: 11, title: "Team Standup",         hex: "#4A7C59"),
            makeEvent(offset: 4, startHour: 15, endHour: 17, title: "Client Presentation",  hex: "#C0392B"),
            makeEvent(offset: 7, startHour: 11, endHour: 12, title: "Weekly Review",        hex: "#1B2A4A"),
            makeEvent(offset: 9, startHour: 9,  endHour: 10, title: "Morning Briefing",     hex: "#4A7C59"),
        ]

        return pairs.reduce(into: [:]) { map, pair in
            map[pair.dayKey, default: []].append(pair.event)
        }
    }
}

// MARK: - Configuration presets

extension CalendarConfiguration {
    static var ocean: CalendarConfiguration {
        var config = CalendarConfiguration.default
        config.colors.primary        = Color(hex: "#0EA5E9")
        config.colors.accent         = Color(hex: "#38BDF8")
        config.colors.todayHighlight = Color(hex: "#0EA5E9")
        config.typography.fontFamily = "Avenir Next"
        return config
    }

    static var forest: CalendarConfiguration {
        var config = CalendarConfiguration.default
        config.colors.primary        = Color(hex: "#16A34A")
        config.colors.accent         = Color(hex: "#4ADE80")
        config.colors.todayHighlight = Color(hex: "#16A34A")
        config.appearance.dimWeekends = true
        return config
    }

    static var rose: CalendarConfiguration {
        var config = CalendarConfiguration.default
        config.colors.primary        = Color(hex: "#E11D48")
        config.colors.accent         = Color(hex: "#FB7185")
        config.colors.todayHighlight = Color(hex: "#E11D48")
        config.typography.fontFamily = "Georgia"
        config.appearance.dimPastDays = true
        return config
    }
}

#Preview { ContentView() }
