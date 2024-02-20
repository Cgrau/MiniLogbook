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
      handleOptions(by: selectedOption, viewModel: &expectedViewModel)
      handleTextFieldText(viewModel: &expectedViewModel)
      expectedViewModel.errorText = nil
      expectedViewModel.textFieldTitle = expectedViewModel.selectedType.rawValue
      expectedViewModel.result = String(format: Constants.result,
                                        String(self.getAverageValue(expectedViewModel.selectedType)).replacingOccurrences(of: ".", with: ","),
                                        expectedViewModel.selectedType.rawValue)
      return expectedViewModel
   }
   
   private func handleOptions(by selectedOption: String, viewModel: inout ScreenViewModel) {
      viewModel.options = viewModel.options.map {
         if $0.type.rawValue == selectedOption {
            viewModel.selectedType = $0.type
            return .init(image: .selected, type: $0.type)
         } else {
            return .init(image: .unselected, type: $0.type)
         }
      }
   }
   
   private func handleTextFieldText(viewModel: inout ScreenViewModel) {
      if let expectedValue = Double(viewModel.textFieldText.replacingOccurrences(of: ",", with: ".")) {
         let convertedValue = convert(value: expectedValue, by: viewModel.selectedType)
         let updatedConversion = convertedValue.replacingOccurrences(of: ".", with: ",")
         viewModel.textFieldText = updatedConversion
      }
   }
   
   private func convert(value: Double, by type: SelectedType) -> String {
      switch type {
      case .mgDL:
         return String(value * Constants.conversionRate)
      case .mmolL:
         return String(value / Constants.conversionRate)
      }
   }
}
