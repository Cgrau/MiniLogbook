import XCTest
@testable import MiniLogbook

final class GetSavedDataSpec: XCTestCase {
   private var sut: GetSavedData!
   private var repository: LocalStorageMock!
   
   override func setUp() {
      super.setUp()
      repository = LocalStorageMock()
      sut = GetSavedData(repository: repository)
   }
   
   override func tearDown() {
      sut = nil
      repository = nil
      super.tearDown()
   }
   
   func test_execute() {
      repository._retrieveValues.returnValue = Constants.retrievedValues
      let result = sut.execute()
      XCTAssertTrue(repository._retrieveValues.called)
      XCTAssertEqual(repository._retrieveValues.callsCount, 1)
      XCTAssertEqual(result, Constants.expectedReturnValues)
   }
   
   enum Constants {
      static let retrievedValues = ["1.2", "2.3", "26.1"]
      static let expectedReturnValues = ["1,2", "2,3", "26,1"]
   }
}
