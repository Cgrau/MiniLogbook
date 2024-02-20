import UIKit

final class ViewModelTextFieldChangeAction {
   typealias UseCase = (_ text: String, _ viewModel: ScreenViewModel) -> ScreenViewModel
   
   required init() {}
   
   static func buildDefault() -> Self {
      .init()
   }
   
   func execute(text: String, viewModel: ScreenViewModel) -> ScreenViewModel {
      var expectedViewModel = viewModel
      expectedViewModel.textFieldText = text
      if Double(viewModel.textFieldText.replacingOccurrences(of: ",", with: ".")) != 0 {
         expectedViewModel.errorText = ""
      } else {
         expectedViewModel.errorText = "Number should be greater than 0"
      }
      return expectedViewModel
   }
}
