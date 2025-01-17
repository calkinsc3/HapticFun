//
//  ContentView.swift
//  HapticFun
//
//  Created by Bill Calkins on 1/15/25.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    
    @State private var value1 = false
    @State private var value2 = false
    @State private var value3 = false
    @State private var value4 = false
    
    @State var hapticEngine: CHHapticEngine?
    
    var body: some View {
        Form {
            Section(header: Text("Heptic Fun!")) {
                Button("Heavy and High Impact") {
                    value1.toggle()
                }
                .sensoryFeedback(.impact(weight: .heavy, intensity: 1), trigger: value1)
                Button("Increase") {
                    value2.toggle()
                }
                .sensoryFeedback(.increase, trigger: value2)
                
                Button("Success") {
                    value3.toggle()
                }
                .sensoryFeedback(.success, trigger: value3)
                
                Button("Error") {
                    value4.toggle()
                }
                .sensoryFeedback(.error, trigger: value4)
            }
            Section(header: Text("Custom Haptic")) {
                Button("Play custom haptic") {
                    playCustomHaptic()
                }
            }
        }
        .task {
            self.prepareHapticEngine()
        }
    }
    
    private func prepareHapticEngine() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            hapticEngine = try CHHapticEngine()
            try hapticEngine?.start()
        } catch {
            print("There was an error starting the haptic engine: \(error.localizedDescription)")
        }
    }
    
    private func playCustomHaptic() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        var events = [CHHapticEvent]()
        
        for i in stride(from: 0, to: 1, by: 0.3) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            
            events.append(event)
        }
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try hapticEngine?.makePlayer(with: pattern)
            try player?.start(atTime: .zero)
        } catch {
            print("There was an error playing the haptic pattern: \(error.localizedDescription)")
        }
    }
}

#Preview {
    ContentView()
}
