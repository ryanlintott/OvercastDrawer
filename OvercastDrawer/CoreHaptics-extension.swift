//
//  CoreHaptics-extension.swift
//  Wordhord
//
//  Created by Ryan Lintott on 2020-12-09.
//

import CoreHaptics

extension CHHapticEngine {
    static func prepareHaptics(engine: inout CHHapticEngine?) throws {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            throw error
        }
    }
}
