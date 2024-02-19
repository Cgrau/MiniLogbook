import Combine
import UIKit

final class SelectedAction {
   typealias UseCase = (_ selectedOption: String, _ viewModel: ScreenViewModel) -> ScreenViewModel
   
   private enum Constants {
      static let result = "Your average is %@ %@"
      static let conversionRate: Double = 18.0182
   }
   
   private var getAverageValue: GetAverageValue.UseCase
   
   required init(getAverageValue: @escaping GetAverageValue.UseCase) {
      self.getAverageValue = getAverageValue
   }
   
   static func buildDefault() -> Self {
      .init(getAverageValue: GetAverageValue.buildDefault().execute)
   }
   
   func execute(selectedOption: String, viewModel: ScreenViewModel) -> ScreenViewModel {
      guard selectedOption != viewModel.selectedType.rawValue else { return viewModel }
      var expectedViewModel = viewModel
      expectedViewModel.options = expectedViewModel.options.map {
         if $0.type.rawValue == selectedOption {
            expectedViewModel.selectedType = $0.type
            return .init(image: .selected, type: $0.type)
         } else {
            return .init(image: .unselected, type: $0.type)
         }
      }
      
      if let expectedValue = Double(expectedViewModel.textFieldText) {
         switch expectedViewModel.selectedType {
         case .mgDL:
            expectedViewModel.textFieldText = String(expectedValue * Constants.conversionRate)
         case .mmolL:
            expectedViewModel.textFieldText = String(expectedValue / Constants.conversionRate)
         }
      }
      
      expectedViewModel.errorText = nil
      expectedViewModel.textFieldTitle = expectedViewModel.selectedType.rawValue
      expectedViewModel.result = String(format: Constants.result,
                                        String(format: "%.2f",
                                               self.getAverageValue(expectedViewModel.selectedType)),
                                        expectedViewModel.selectedType.rawValue)
      return expectedViewModel
   }
}
