import XCTest
@testable import MiniLogbook

final class GetLaunchDataSpec: XCTestCase {
   private var sut: GetLaunchData!
   private var getAverageValue: GetAverageValue!
   
   override func tearDown() {
      sut = nil
      getAverageValue = nil
      super.tearDown()
   }
   
   func test_execute_value1() {
      givenSUT(getAverageValueResponse: Constants.Average.value1)
      let result = sut.execute()
      XCTAssertEqual(result.result, Constants.ExpectedValues.Result.value1)
      XCTAssertEqual(result.description, Constants.ExpectedValues.description)
      XCTAssertEqual(result.options.first?.type, Constants.ExpectedValues.Options.viewModels.first?.type)
      XCTAssertEqual(result.options.last?.type, Constants.ExpectedValues.Options.viewModels.last?.type)
      XCTAssertEqual(result.textFieldText, "")
      XCTAssertEqual(result.textFieldTitle, Constants.ExpectedValues.Options.mgDLTitle)
      XCTAssertEqual(result.buttonTitle, Constants.ExpectedValues.buttonTitle)
      XCTAssertEqual(result.errorText, nil)
      XCTAssertEqual(result.selectedType, .mgDL)
   }
   
   func test_execute_value2() {
      givenSUT(getAverageValueResponse: Constants.Average.value2)
      let result = sut.execute()
      XCTAssertEqual(result.result, Constants.ExpectedValues.Result.value2)
      XCTAssertEqual(result.description, Constants.ExpectedValues.description)
      XCTAssertEqual(result.options.first?.type, Constants.ExpectedValues.Options.viewModels.first?.type)
      XCTAssertEqual(result.options.last?.type, Constants.ExpectedValues.Options.viewModels.last?.type)
      XCTAssertEqual(result.textFieldText, "")
      XCTAssertEqual(result.textFieldTitle, Constants.ExpectedValues.Options.mgDLTitle)
      XCTAssertEqual(result.buttonTitle, Constants.ExpectedValues.buttonTitle)
      XCTAssertEqual(result.errorText, nil)
      XCTAssertEqual(result.selectedType, .mgDL)
   }
   
   private func givenSUT(getAverageValueResponse: Double) {
      sut = GetLaunchData(getAverageValue: { _ in getAverageValueResponse })
   }
   
   enum Constants {
      enum Average {
         static let value1: Double = 0
         static let value2: Double = 1.20
      }
      enum ExpectedValues {
         enum Result {
            static let value1 = "Your average is 0 mg/dL"
            static let value2 = "Your average is 1,2 mg/dL"
         }
         static let description = "Add measurement:"
         
         enum Options {
            static let mgDLTitle = SelectedType.mgDL.rawValue
            static let mmolLTitle = SelectedType.mmolL.rawValue
            static let viewModels: [SelectionViewModel] = [
               .init(image: .selected,
                     type: .mgDL),
               .init(image: .unselected,
                     type: .mmolL)
            ]
         }
         static let buttonTitle = "Save"
      }
   }
}
