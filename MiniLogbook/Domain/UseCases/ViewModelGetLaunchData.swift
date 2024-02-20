import UIKit

final class ViewModelGetLaunchData {
   typealias UseCase = () -> ScreenViewModel
   
   private enum Constants {
      static let result = "Your average is %@ %@"
      static let description = "Add measurement:"
      
      enum Options {
         static let conversionRate: Double = 18.0182
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
   
   private var getAverageValue: GetAverageValue.UseCase
   
   required init(getAverageValue: @escaping GetAverageValue.UseCase) {
      self.getAverageValue = getAverageValue
   }
   
   static func buildDefault() -> Self {
      .init(getAverageValue: GetAverageValue.buildDefault().execute)
   }
   
   func execute() -> ScreenViewModel {
      let selectedOption = Constants.Options.viewModels.first?.type.rawValue ?? ""
      return .init(
         result: getAverageString(selectedOption: selectedOption),
         description: Constants.description,
         options: Constants.Options.viewModels,
         textFieldText: "",
         textFieldTitle: Constants.Options.mgDLTitle,
         buttonTitle: Constants.buttonTitle,
         errorText: nil,
         selectedType: .mgDL
      )
   }
   
   private func getAverageString(selectedOption: String) -> String {
      var averageString = String(getAverageValue(.mgDL).rounded(to: 6))
      if averageString == "0.0" {
         averageString = "0"
      }
      return String(format: Constants.result,
                    averageString,
                    selectedOption).replacingOccurrences(of: ".", with: ",")
   }
}
