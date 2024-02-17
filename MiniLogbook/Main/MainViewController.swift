import UIKit

class MainViewController: UIViewController {
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
   private let mainView = MainView()
   
   override func loadView() {
      view = mainView
   }
   
   override func viewDidLoad() {
      // Do this in the mapper
      mainView.apply(viewModel: .init(
         result: Constants.result,
         description: Constants.description,
         options: Constants.Options.viewModels.map {
            let view = SelectionView()
            view.apply(viewModel: $0)
            return view
         },
         textFieldText: "",
         textFieldTitle: Constants.Options.mgDLTitle,
         buttonTitle: Constants.buttonTitle)
      )
   }
   
   override func viewWillAppear(_ animated: Bool) {
      navigationController?.navigationBar.isHidden = true
   }
}
