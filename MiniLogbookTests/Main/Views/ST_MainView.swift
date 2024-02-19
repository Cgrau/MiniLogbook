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
            textFieldTitle: SelectedType.mgDL.rawValue,
            buttonTitle: Constants.buttonTitle,
            selectedType: .mgDL)
   }
   
   private enum Constants {
      static let result = "Your average is 122 mg/dL"
      static let description = "Add measurement:"
      enum Options {
         static let selectedImage = UIImage(named: "selected")!
         static let unselectedImage = UIImage(named: "unselected")!
         static let viewModels: [SelectionViewModel] = [
            .init(image: Constants.Options.selectedImage,
                  type: .mgDL),
            .init(image: Constants.Options.unselectedImage,
                  type: .mmolL)
         ]
      }
      static let buttonTitle = "Save"
   }
}
