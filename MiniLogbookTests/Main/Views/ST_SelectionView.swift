import SnapshotTesting
import XCTest
@testable import MiniLogbook

class ST_SelectionView: XCTestCase {
   
   private var sut: SelectionView!
   
   override func setUp() {
      sut = SelectionView(frame: .init(x: 0, y: 0, width: 300, height: 50))
   }
   
   func test_selected_view_state() {
      let viewModel = givenSelectedState()
      sut.apply(viewModel: viewModel)
      assertSnapshot(matching: sut, as: .image)
   }
   
   func test_unselected_view_state() {
      let viewModel = givenUnselectedState()
      sut.apply(viewModel: viewModel)
      assertSnapshot(matching: sut, as: .image)
   }
   
   override func tearDown() {
      sut = nil
   }
   
   private func givenSelectedState() -> SelectionViewModel {
      .init(image: UIImage(named: "selected")!, text: Constants.title)
   }
   
   private func givenUnselectedState() -> SelectionViewModel {
      .init(image: UIImage(named: "unselected")!, text: Constants.title)
   }
   
   private enum Constants {
      static let title = "LoremIpsum"
   }
}
