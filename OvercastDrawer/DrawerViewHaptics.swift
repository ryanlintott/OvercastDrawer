//
//  CoverViewHaptics.swift
//  Wordhord
//
//  Created by Ryan Lintott on 2020-12-09.
//

import CoreHaptics

class DrawerViewHaptics {
    static let shared = DrawerViewHaptics()
    
    private init() { }
    
    private var engine: CHHapticEngine?
    
    func prepareHaptics() {
        do {
            try CHHapticEngine.prepareHaptics(engine: &engine)
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    func playClaspHaptic(after relativeTime: TimeInterval? = nil) {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.75)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 1)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: relativeTime ?? 0)
        events.append(event)

        // convert those events into a pattern and play it immediately
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}
