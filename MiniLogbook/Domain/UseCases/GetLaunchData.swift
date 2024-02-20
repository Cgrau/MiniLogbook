import UIKit

final class GetLaunchData {
   typealias UseCase = () -> ScreenViewModel
   
   private enum Constants {
      static let result = "Your average is %@ %@"
      static let description = "Add measurement:"
      
      enum Options {
         static let conversionRate: Double = 18.0182
         static let mgDLTitle = SelectedType.mgDL.rawValue
         static let mmolLTitle = SelectedType.mmolL.rawValue
         static let selectedImage: UIImage = .selected
         static let unselectedImage: UIImage = .unselected
         static let viewModels: [SelectionViewModel] = [
            .init(image: Constants.Options.selectedImage,
                  type: .mgDL),
            .init(image: Constants.Options.unselectedImage,
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
         result: String(format: Constants.result, String(format: "%.2f", getAverageValue(.mgDL)), selectedOption).replacingOccurrences(of: ".", with: ","),
         description: Constants.description,
         options: Constants.Options.viewModels,
         textFieldText: "",
         textFieldTitle: Constants.Options.mgDLTitle,
         buttonTitle: Constants.buttonTitle,
         errorText: nil,
         selectedType: .mgDL
      )
   }
}
