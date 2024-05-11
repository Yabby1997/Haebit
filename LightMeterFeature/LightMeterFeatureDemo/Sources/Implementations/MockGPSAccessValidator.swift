import Combine
import Foundation
import LightMeterFeature

class MockGPSAccessValidator: GPSAccessValidatable {
    var isAccessAuthorized: Bool = false
    var shouldAskGPSAccessPublisher: AnyPublisher<Bool, Never> { Just(false).eraseToAnyPublisher() }
    func requestDoNotAsk() {}
}
