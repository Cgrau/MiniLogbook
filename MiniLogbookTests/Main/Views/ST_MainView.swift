import SnapshotTesting
import XCTest
@testable import MiniLogbook

class ST_MainView: XCTestCase {
   
   private var sut: MainView!
   
   override func setUp() {
      sut = MainView(frame: .init(origin: .zero, size: CGSize(width: 375, height: 667)))
   }
   
   func test_selected_view_state() {
      let viewModel = givenSelectedState()
      sut.apply(viewModel: viewModel)
      assertSnapshot(matching: sut, as: .image)
   }
   
   override func tearDown() {
      sut = nil
   }
   
   private func givenSelectedState() -> ScreenViewModel {
      .init(result: Constants.result,
            description: Constants.description,
            options: Constants.Options.viewModels,
            textFieldText: "",
            textFieldTitle: Constants.Options.mgDLTitle, 
            buttonTitle: Constants.buttonTitle)
   }
   
   private enum Constants {
      static let result = "Your average is 122 mg/dL"
      static let description = "Add measurement:"
      enum Options {
         static let mgDLTitle = "mg/dL"
         static let mmolLTitle = "mg/dL"
         static let selectedImage = UIImage(named: "selected")!
         static let unselectedImage = UIImage(named: "unselected")!
         static let viewModels: [SelectionViewModel] = [
            .init(image: Constants.Options.selectedImage,
                  text: Constants.Options.mgDLTitle),
            .init(image: Constants.Options.unselectedImage,
                  text: Constants.Options.mmolLTitle)
         ]
      }
      static let buttonTitle = "Save"
   }
}
