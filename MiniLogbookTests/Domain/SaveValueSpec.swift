import XCTest
@testable import MiniLogbook

final class SaveValueSpec: XCTestCase {
   private var sut: SaveValue!
   private var getSavedData: GetSavedData!
   private var saveData: SaveData!
   private var getSavedDataRespones: [String] = []
   private var savedValues: [String] = []
   
   override func tearDown() {
      sut = nil
      getSavedData = nil
      saveData = nil
      savedValues = []
      super.tearDown()
   }
   
   func test_execute_mgDL_test1() {
      givenSUT(savedData: getSavedDataRespones)
      sut.execute(value: Constants.MgdL.value1, selectedType: .mgDL)
      XCTAssertEqual(savedValues.count, getSavedDataRespones.count + 1)
      XCTAssertEqual(savedValues.last, Constants.ExpectedValues.value1)
   }
   
   func test_execute_mmolL_test1() {
      givenSUT(savedData: getSavedDataRespones)
      sut.execute(value: Constants.MmolL.value1, selectedType: .mmolL)
      XCTAssertEqual(savedValues.count, getSavedDataRespones.count + 1)
      XCTAssertEqual(savedValues.last, Constants.ExpectedValues.value1)
   }
   
   func test_execute_mgDL_test2() {
      givenSUT(savedData: getSavedDataRespones)
      sut.execute(value: Constants.MgdL.value2, selectedType: .mgDL)
      XCTAssertEqual(savedValues.count, getSavedDataRespones.count + 1)
      XCTAssertEqual(savedValues.last, Constants.ExpectedValues.value2)
   }
   
   func test_execute_mmolL_test2() {
      givenSUT(savedData: getSavedDataRespones)
      sut.execute(value: Constants.MmolL.value2, selectedType: .mmolL)
      XCTAssertEqual(savedValues.count, getSavedDataRespones.count + 1)
      XCTAssertEqual(savedValues.last, Constants.ExpectedValues.value2)
   }
   
   func test_execute_emptyValue() {
       givenSUT(savedData: getSavedDataRespones)
       sut.execute(value: "", selectedType: .mgDL)
       XCTAssertEqual(savedValues.count, getSavedDataRespones.count)
   }

   func test_execute_nonNumericValue() {
       givenSUT(savedData: getSavedDataRespones)
       sut.execute(value: "abc", selectedType: .mmolL)
       XCTAssertEqual(savedValues.count, getSavedDataRespones.count)
   }
   
   private func givenSUT(savedData: [String] = []) {
      sut = SaveValue(getSavedData: { savedData },
                      saveData: { savedValues in self.savedValues = savedValues }
      )
   }
   
   enum Constants {
      enum MgdL {
         static let value1 = "18,0182"
         static let value2 = "720,728"
      }
      enum MmolL {
         static let value1 = "1"
         static let value2 = "40"
      }
      enum ExpectedValues {
         static let value1 = "18.0182"
         static let value2 = "720.728"
      }
      static let retrievedData = ["1.2", "2.3", "26.1"]
   }
}
