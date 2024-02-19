import Combine
import UIKit

enum ScreenState: Equatable {
   case initial
   case error
   case loaded(ScreenViewModel)
}

typealias MainViewModelOutput = AnyPublisher<MainViewState, Never>

public struct MainViewModelInput {
   let onAppear: AnyPublisher<Void, Never>
   let onOptionTapped: AnyPublisher<String, Never>
   let onSaveTapped: AnyPublisher<String?, Never>
}

protocol MainViewModelable: AnyObject {
   func transform(input: MainViewModelInput) -> MainViewModelOutput
}

public class MainViewModel: ObservableObject, MainViewModelable {
   private enum Constants {
      static let result = "Your average is %@ %@"
      static let description = "Add measurement:"
      
      enum Options {
         static let conversionRate: Double = 18.0182
         static let mgDLTitle = "mg/dL"
         static let mmolLTitle = "mmol/L"
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
   
   private var cancellableBag = Set<AnyCancellable>()
   private var currentOptions = [String]()
   private var saveValue: SaveValue.UseCase
   private var getAverageValue: GetAverageValue.UseCase
   
   required init(saveValue: @escaping SaveValue.UseCase,
                 getAverageValue: @escaping GetAverageValue.UseCase) {
      self.saveValue = saveValue
      self.getAverageValue = getAverageValue
   }
   
   static func buildDefault() -> Self {
      .init(saveValue: SaveValue.buildDefault().execute,
            getAverageValue: GetAverageValue.buildDefault().execute)
   }
   
   func transform(input: MainViewModelInput) -> MainViewModelOutput {
      cancellableBag.removeAll()
      
      // MARK: - on View Appear
      let onAppearAction = input.onAppear
         .map { [weak self] result -> MainViewState in
            guard let self else { return .error("this should not happen") }
            let selectedOption = Constants.Options.viewModels.first?.text ?? ""
            return .loaded(.init(
               result: String(format: Constants.result, String(self.getAverageValue()), selectedOption),
               description: Constants.description,
               options: Constants.Options.viewModels,
               textFieldText: "",
               textFieldTitle: Constants.Options.mgDLTitle,
               buttonTitle: Constants.buttonTitle)
            )
         }.eraseToAnyPublisher()
      
      // MARK: - on Option Selected Action
      let selectedAction = input.onOptionTapped.map { [weak self] (text) -> MainViewState in
         guard let self = self, case .loaded(var viewModel) = self.state else { return .loading }
         viewModel.options = viewModel.options.map {
            if $0.text == text {
               return .init(image: .selected, text: text)
            } else {
               return .init(image: .unselected, text: $0.text)
            }
         }
         viewModel.textFieldTitle = text
         viewModel.result = String(format: Constants.result, String(self.getAverageValue()), text)
         return .loaded(viewModel)
      }.eraseToAnyPublisher()
      
      // MARK: - on Save Action
      let saveAction = input.onSaveTapped.map { [weak self] (text) -> MainViewState in
         guard let self, let text, case .loaded(var viewModel) = self.state else { return .loading }
         self.saveValue(text)
         let average = self.getAverageValue()
         viewModel.textFieldText = ""
         viewModel.result = String(format: Constants.result, String(average), viewModel.textFieldTitle)
         return .loaded(viewModel)
      }.eraseToAnyPublisher()
      
      return Publishers.Merge3(onAppearAction, saveAction, selectedAction)
         .removeDuplicates()
         .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
         .eraseToAnyPublisher()
   }
}
