import UIKit

final class ViewModelSaveAction {
   typealias UseCase = (_ text: String, _ viewModel: ScreenViewModel) -> ScreenViewModel
   
   private enum Constants {
      static let result = "Your average is %@ %@"
   }
   
   private let saveValue: SaveValue.UseCase
   private let getAverageValue: GetAverageValue.UseCase
   
   required init(saveValue: @escaping SaveValue.UseCase,
                 getAverageValue: @escaping GetAverageValue.UseCase) {
      self.saveValue = saveValue
      self.getAverageValue = getAverageValue
   }
   
   static func buildDefault() -> Self {
      .init(saveValue: SaveValue.buildDefault().execute,
            getAverageValue: GetAverageValue.buildDefault().execute)
   }
   
   func execute(text: String, viewModel: ScreenViewModel) -> ScreenViewModel {
      var expectedViewModel = viewModel
      guard Double(text.replacingOccurrences(of: ",", with: ".")) ?? 0 > 0 else {
         expectedViewModel.errorText = "Number should be greater than 0"
         return expectedViewModel
      }
      self.saveValue(text, viewModel.selectedType)
      expectedViewModel.errorText = nil
      let average = self.getAverageValue(viewModel.selectedType)
      expectedViewModel.textFieldText = ""
      expectedViewModel.result = String(format: Constants.result, String(average), viewModel.textFieldTitle)
      return expectedViewModel
   }
}
