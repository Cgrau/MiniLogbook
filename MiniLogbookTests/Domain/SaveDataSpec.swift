import XCTest
@testable import MiniLogbook

final class SaveDataSpec: XCTestCase {
   private var sut: SaveData!
   private var repository: LocalStorageMock!
   
   override func setUp() {
      super.setUp()
      repository = LocalStorageMock()
      sut = SaveData(repository: repository)
   }
   
   override func tearDown() {
      sut = nil
      repository = nil
      super.tearDown()
   }
   
   func test_execute() {
      sut.execute(values: Constants.valuesToSave)
      XCTAssertTrue(repository._saveValues.called)
      XCTAssertEqual(repository._saveValues.receivedValues, Constants.valuesToSave)
      XCTAssertEqual(repository._saveValues.callsCount, 1)
   }
   
   enum Constants {
      static let valuesToSave = ["1.2", "2.3", "26.1"]
   }
}
