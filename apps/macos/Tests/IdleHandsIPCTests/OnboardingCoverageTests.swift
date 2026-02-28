import Testing
@testable import IdleHands

@Suite(.serialized)
@MainActor
struct OnboardingCoverageTests {
    @Test func exerciseOnboardingPages() {
        OnboardingView.exerciseForTesting()
    }
}
