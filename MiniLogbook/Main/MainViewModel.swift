import Combine
import UIKit

public class MainViewModel: ObservableObject {
   private enum Constants {
      static let result = "Your average is 122 mg/dL"
      static let description = "Add measurement:"
      enum Options {
         static let mgDLTitle = "mg/dL"
         static let mmolLTitle = "mg/dL"
         static let selectedImage = UIImage(named: "selected")!
         static let unselectedImage = UIImage(named: "unselected")!
         static let viewModels: [SelectionViewModel] = [
            .init(image: Constants.Options.selectedImage,
                  text: Constants.Options.mgDLTitle),
            .init(image: Constants.Options.unselectedImage,
                  text: Constants.Options.mmolLTitle)
         ]
      }
      static let buttonTitle = "Save"
   }
   
   @Published private(set) var state: MainViewState = .loading
   
   let result: String
   let description: String
   let options: [View]
   let textFieldText: String
   let textFieldTitle: String
   let buttonTitle: String
   
   public init(result: String, description: String, options: [View], textFieldText: String, textFieldTitle: String, buttonTitle: String) {
      self.result = result
      self.description = description
      self.options = options
      self.textFieldText = textFieldText
      self.textFieldTitle = textFieldTitle
      self.buttonTitle = buttonTitle
   }
   
   public static func empty() -> MainViewModel {
      .init(result: "", description: "", options: [], textFieldText: "", textFieldTitle: "", buttonTitle: "")
   }
   
   func loadUserData() {
      self.state = .loaded(.init(
         result: Constants.result,
         description: Constants.description,
         options: Constants.Options.viewModels.map {
            let view = SelectionView()
            view.apply(viewModel: $0)
            return view
         },
         textFieldText: "",
         textFieldTitle: Constants.Options.mgDLTitle,
         buttonTitle: Constants.buttonTitle))
   }
   
   func save(value: String) {
      // 
   }
}
