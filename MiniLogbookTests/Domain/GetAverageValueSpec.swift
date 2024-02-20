import XCTest
@testable import MiniLogbook

final class GetAverageValueSpec: XCTestCase {
   private var sut: GetAverageValue!
   private var getSavedData: GetSavedData!
   private var getSavedDataRespones: [String] = []
   
   override func tearDown() {
      sut = nil
      getSavedData = nil
   }
   
   func test_execute_mgDL_test1() {
      getSavedDataRespones = Constants.RetrievedData.value1
      givenSUT(savedData: getSavedDataRespones)
      let result = sut.execute(selectedType: .mgDL)
      XCTAssertEqual(result, Constants.ExpectedValues.MgDL.value1)
   }
   
   func test_execute_mmolL_test1() {
      getSavedDataRespones = Constants.RetrievedData.value1
      givenSUT(savedData: getSavedDataRespones)
      let result = sut.execute(selectedType: .mmolL)
      XCTAssertEqual(result, Constants.ExpectedValues.MmolL.value1)
   }
   
   func test_execute_mgDL_test2() {
      getSavedDataRespones = Constants.RetrievedData.value2
      givenSUT(savedData: getSavedDataRespones)
      let result = sut.execute(selectedType: .mgDL)
      XCTAssertEqual(result, Constants.ExpectedValues.MgDL.value2)
   }
   
   func test_execute_mmolL_test2() {
      getSavedDataRespones = Constants.RetrievedData.value2
      givenSUT(savedData: getSavedDataRespones)
      let result = sut.execute(selectedType: .mmolL)
      XCTAssertEqual(result, Constants.ExpectedValues.MmolL.value2)
   }
   
   private func givenSUT(savedData: [String] = []) {
      sut = GetAverageValue(getSavedData: { savedData })
   }
   
   enum Constants {
      enum RetrievedData {
         static let value1 = ["1.2", "2.3", "26.1"]
         static let value2 = ["50", "13.5", "10"]
      }
      enum ExpectedValues {
         enum MgDL {
            static let value1: Double = 9.866667
            static let value2: Double = 24.5
         }
         enum MmolL {
            static let value1: Double = 0.547594
            static let value2: Double = 1.359736
         }
      }
   }
}
