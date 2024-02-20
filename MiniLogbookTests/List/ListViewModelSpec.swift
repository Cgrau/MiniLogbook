import XCTest
import Combine
@testable import MiniLogbook

final class ListViewModelSpec: XCTestCase {
   private var sut: ListViewModelable!
   private var getSavedData: GetSavedData!
   
   override func tearDown() {
      sut = nil
      getSavedData = nil
   }
   
   func testListViewModel_onAppear() {
      givenSUT(savedData: Constants.savedData)
      let input = ListViewModelInput(onAppear: Just(()).eraseToAnyPublisher())
      var receivedStates: [ListViewState] = []
      
      let cancellable = sut.transform(input: input)
         .sink { receivedStates.append($0) }
      
      XCTAssertEqual(receivedStates, [.loaded(ListScreenViewModel(values: Constants.expectedData))])
      cancellable.cancel()
   }
   
   private func givenSUT(savedData: [String] = []) {
      sut = ListViewModel(getSavedData: { savedData })
   }
   
   enum Constants {
      static let savedData = ["Value1", "Value2", "Value3"]
      static let expectedData = ["Value1 mg/dL", "Value2 mg/dL", "Value3 mg/dL"]
   }
}
