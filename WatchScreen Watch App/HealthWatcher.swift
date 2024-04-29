import Foundation
import HealthKit

class HealthWatcher: NSObject, ObservableObject {
    private var healthStore: HKHealthStore?
    private var heartRateQuery: HKQuery?
    @Published var heartRate: Double = 0

    override init() {
        super.init()
        healthStore = HKHealthStore()
    }

    func requestAuthorization() {
        guard let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate) else {return}
        let healthKitTypesToRead: Set<HKObjectType> = [heartRateType]
        healthStore?.requestAuthorization(toShare: [], read: healthKitTypesToRead) { _, _ in }
    }
    func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])
        let query = HKAnchoredObjectQuery(
            type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!,
            predicate: devicePredicate,
            anchor: nil,
            limit: HKObjectQueryNoLimit
        ) { _, samples, _, _, _ in
            guard let samples = samples as? [HKQuantitySample] else { return }
            self.heartRate = samples.last?.quantity.doubleValue(for: HKUnit(from: "count/min")) ?? 0
        }
        healthStore?.execute(query)
        self.heartRateQuery = query
    }
    
    func stopHeartRateQuery() {
            if let query = heartRateQuery {
                healthStore?.stop(query)
            }
        }
    
}
