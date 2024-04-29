import SwiftUI

struct ContentView: View {
    @State private var isOn = false
    @ObservedObject private var healthKitManager = HealthWatcher()
    
    var body: some View {
        VStack {
            Toggle("Heart Rate", isOn: $isOn)
                .onChange(of: isOn) { newValue, newValue2 in
                    if newValue {
                        healthKitManager.requestAuthorization()
                        healthKitManager.startHeartRateQuery(quantityTypeIdentifier: .heartRate)
                    } else {
                        healthKitManager.stopHeartRateQuery()
                    }
                }
            
            if isOn {
                Text("Heart Rate: \(healthKitManager.heartRate, specifier: "%.0f") BPM")
            }
        }
        .padding()
    }
}
