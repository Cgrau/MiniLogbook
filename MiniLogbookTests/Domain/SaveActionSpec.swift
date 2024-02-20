import XCTest
@testable import MiniLogbook

final class SaveActionSpec: XCTestCase {
   private var sut: SaveAction!
   private var saveValue: SaveValue!
   private var getAverageValue: GetAverageValue!
   private var saveValueCalled: Bool = false
   private var getAverageValueCalled: Bool = false
   
   override func tearDown() {
      sut = nil
      saveValue = nil
      getAverageValue = nil
      saveValueCalled = false
      getAverageValueCalled = false
   }
   
   func test_execute_save_value() {
      let textFieldValue = "123"
      let initialSelection = SelectedType.mgDL
      givenSUT(getAverageValueResponse: 12)
      let result = sut.execute(text: textFieldValue,
                               viewModel: getViewModel(selectedOption: initialSelection,
                                                       text: textFieldValue))
      XCTAssertEqual(result.textFieldText, "")
      XCTAssertNil(result.errorText)
      XCTAssertTrue(saveValueCalled)
      XCTAssertTrue(getAverageValueCalled)
   }
   
   func test_execute_save_value_zero() {
      let textFieldValue = "0"
      let initialSelection = SelectedType.mgDL
      givenSUT(getAverageValueResponse: 12)
      let result = sut.execute(text: textFieldValue,
                               viewModel: getViewModel(selectedOption: initialSelection,
                                                       text: textFieldValue))
      XCTAssertEqual(result.textFieldText, "0")
      XCTAssertNotNil(result.errorText)
      XCTAssertFalse(saveValueCalled)
      XCTAssertFalse(getAverageValueCalled)
   }
   
   private func givenSUT(getAverageValueResponse: Double) {
      sut = .init(saveValue: { [weak self] value, selectedType in
         self?.saveValueCalled = true
      }, getAverageValue: { [weak self] selectedType in
         self?.getAverageValueCalled = true
         return getAverageValueResponse
      })
   }
   
   private func getViewModel(selectedOption: SelectedType, text: String) -> ScreenViewModel {
      .init(
         result: "",
         description: "",
         options: [.init(image: .unselected, type: .mgDL),
                   .init(image: .unselected, type: .mmolL)],
         textFieldText: text,
         textFieldTitle: selectedOption.rawValue,
         buttonTitle: "",
         selectedType: selectedOption
      )
   }
}
