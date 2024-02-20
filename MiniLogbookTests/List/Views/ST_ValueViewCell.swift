import SnapshotTesting
import XCTest
@testable import MiniLogbook

class ST_ValueViewCell: XCTestCase {
   private var sut: ValueViewCell!
   
   override func setUp() {
      sut = ValueViewCell(frame: CGRect(x: 0, y: 0, width: 320, height: 100))
   }
   
   override func tearDown() {
      sut = nil
   }
   
   func test_with_title() {
      sut.apply(viewModel: ValueCellViewModel(title: Constants.title))
      assertSnapshot(matching: sut, as: .image)
   }
   
   private enum Constants {
      static let title = "LoremIpsum"
   }
}
