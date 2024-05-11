import Combine
import Foundation
import LightMeterFeature

class MockReviewRequestValidator: ReviewRequestValidatable {
    var shouldRequestReviewPublisher: AnyPublisher<Bool, Never> { Just(false).eraseToAnyPublisher() }
}
