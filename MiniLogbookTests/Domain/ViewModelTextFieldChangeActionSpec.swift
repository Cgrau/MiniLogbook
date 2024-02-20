import XCTest
@testable import MiniLogbook

final class ViewModelTextFieldChangeActionSpec: XCTestCase {
   private var sut: ViewModelTextFieldChangeAction!
   
   override func setUp() {
      super.setUp()
      sut = ViewModelTextFieldChangeAction.buildDefault()
   }
   
   override func tearDown() {
      sut = nil
      super.tearDown()
   }
   
   func testExecute_validText() {
      let viewModel = ScreenViewModel(
         result: "result",
         description: "description",
         options: [
            .init(image: .unselected, type: .mgDL),
            .init(image: .unselected, type: .mmolL)
         ],
         textFieldText: "12.34",
         textFieldTitle: "mgDL",
         buttonTitle: "Save",
         selectedType: .mgDL
      )
      
      let result = sut.execute(text: "56.78", viewModel: viewModel)
      
      XCTAssertEqual(result.textFieldText, "56.78")
      XCTAssertEqual(result.errorText, "")
   }
   
   func testExecute_invalidText() {
      let viewModel = ScreenViewModel(
         result: "result",
         description: "description",
         options: [
            .init(image: .unselected, type: .mgDL),
            .init(image: .unselected, type: .mmolL)
         ],
         textFieldText: "0",
         textFieldTitle: "mgDL",
         buttonTitle: "Save",
         selectedType: .mgDL
      )
      
      let result = sut.execute(text: "0", viewModel: viewModel)
      
      XCTAssertEqual(result.textFieldText, "0")
      XCTAssertEqual(result.errorText, "Number should be greater than 0")
   }
}
