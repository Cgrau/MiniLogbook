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
      updateOptions(by: selectedOption, viewModel: &expectedViewModel)
      updateTextFieldText(viewModel: &expectedViewModel)
      
      expectedViewModel.errorText = nil
      expectedViewModel.textFieldTitle = expectedViewModel.selectedType.rawValue
      
      let averageValue = self.getAverageValue(expectedViewModel.selectedType)
      expectedViewModel.result = String(format: Constants.result,
                                        formatValue(averageValue),
                                        expectedViewModel.selectedType.rawValue)
      return expectedViewModel
   }
   
   private func updateOptions(by selectedOption: String, viewModel: inout ScreenViewModel) {
      viewModel.options = viewModel.options.map {
         if $0.type.rawValue == selectedOption {
            viewModel.selectedType = $0.type
            return .init(image: .selected, type: $0.type)
         } else {
            return .init(image: .unselected, type: $0.type)
         }
      }
   }
   
   private func updateTextFieldText(viewModel: inout ScreenViewModel) {
      if let expectedValue = Double(viewModel.textFieldText.replacingOccurrences(of: ",", with: ".")) {
         let convertedValue = convert(value: expectedValue, by: viewModel.selectedType)
         viewModel.textFieldText = formatValue(convertedValue)
      }
   }
   
   private func convert(value: Double, by type: SelectedType) -> Double {
      switch type {
      case .mgDL:
         return value * Constants.conversionRate
      case .mmolL:
         return value / Constants.conversionRate
      }
   }
   
   private func formatValue(_ value: Double) -> String {
      return String(value).replacingOccurrences(of: ".", with: ",")
   }
}
