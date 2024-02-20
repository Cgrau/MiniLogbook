import XCTest
@testable import MiniLogbook

final class ViewModelSelectedActionSpec: XCTestCase {
   private var sut: ViewModelSelectedAction!
   
   override func tearDown() {
      sut = nil
      super.tearDown()
   }
   
   func test_execute_whenSelecting_mmolL_updatesViewModelCorrectly() {
      let initialSelection = SelectedType.mgDL
      let newSelection = SelectedType.mmolL
      let initialViewModel = getViewModel(selectedOption: initialSelection)
      givenSUT(getAverageValueResponse: 12)
      let result = sut.execute(selectedOption: newSelection.rawValue,
                               viewModel: initialViewModel)
      XCTAssertEqual(result.textFieldTitle, newSelection.rawValue)
      XCTAssertEqual(result.selectedType, newSelection)
   }
   
   func test_execute_whenSelecting_mgDL_updatesViewModelCorrectly() {
      let initialSelection = SelectedType.mmolL
      let newSelection = SelectedType.mgDL
      givenSUT(getAverageValueResponse: 12)
      let result = sut.execute(selectedOption: newSelection.rawValue,
                               viewModel: getViewModel(selectedOption: initialSelection))
      XCTAssertEqual(result.textFieldTitle, newSelection.rawValue)
      XCTAssertEqual(result.selectedType, newSelection)
   }
   
   func test_execute_same_selected_option() {
      let initialSelection = SelectedType.mgDL
      givenSUT(getAverageValueResponse: 12)
      let initialViewModel = getViewModel(selectedOption: initialSelection)
      
      let result = sut.execute(selectedOption: initialSelection.rawValue,
                               viewModel: initialViewModel)
      
      XCTAssertEqual(result, initialViewModel)
   }
   
   func test_updateOptions_invalid_selected_option() {
      let initialSelection = SelectedType.mgDL
      var initialViewModel = getViewModel(selectedOption: initialSelection)
      let initialOptions = initialViewModel.options
      givenSUT(getAverageValueResponse: 12)
      
      let result = sut.execute(selectedOption: "invalidOption",
                               viewModel: initialViewModel)
      
      XCTAssertEqual(initialViewModel.options, initialOptions)
   }
   
   
   func test_updateTextFieldText_invalid_text() {
      let initialSelection = SelectedType.mgDL
      var initialViewModel = getViewModel(selectedOption: initialSelection)
      initialViewModel.textFieldText = "invalidText"
      let initialText = initialViewModel.textFieldText
      givenSUT(getAverageValueResponse: 12)
      
      let result = sut.execute(selectedOption: SelectedType.mmolL.rawValue,
                               viewModel: initialViewModel)
      
      XCTAssertEqual(result.textFieldText, initialText)
   }
   
   private func givenSUT(getAverageValueResponse: Double) {
      sut = ViewModelSelectedAction(getAverageValue: { _ in getAverageValueResponse })
   }
   
   private func getViewModel(selectedOption: SelectedType) -> ScreenViewModel {
      .init(
         result: "",
         description: "",
         options: [.init(image: .unselected, type: .mgDL),
                   .init(image: .unselected, type: .mmolL)],
         textFieldText: "12,4",
         textFieldTitle: selectedOption.rawValue,
         buttonTitle: "",
         selectedType: selectedOption
      )
   }
}
