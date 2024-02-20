import Combine
import UIKit

typealias MainViewModelOutput = AnyPublisher<MainViewState, Never>

public struct MainViewModelInput {
   let onAppear: AnyPublisher<Void, Never>
   let onOptionTapped: AnyPublisher<String, Never>
   let onSaveTapped: AnyPublisher<String?, Never>
   let onTextFieldTextChanged: AnyPublisher<String?, Never>
}

protocol MainViewModelable: AnyObject {
   func transform(input: MainViewModelInput) -> MainViewModelOutput
}

public class MainViewModel: ObservableObject, MainViewModelable {
   @Published private(set) var state: MainViewState = .loading
   
   private var cancellableBag = Set<AnyCancellable>()
   private var currentOptions = [String]()
   private let getLaunchData: ViewModelGetLaunchData.UseCase
   private let selectedAction: ViewModelSelectedAction.UseCase
   private let saveAction: ViewModelSaveAction.UseCase
   private let textFieldChangeAction: ViewModelTextFieldChangeAction.UseCase
   
   required init(getLaunchData: @escaping ViewModelGetLaunchData.UseCase,
                 selectedAction: @escaping ViewModelSelectedAction.UseCase,
                 saveAction: @escaping ViewModelSaveAction.UseCase,
                 textFieldChangeAction: @escaping ViewModelTextFieldChangeAction.UseCase) {
      self.getLaunchData = getLaunchData
      self.selectedAction = selectedAction
      self.saveAction = saveAction
      self.textFieldChangeAction = textFieldChangeAction
   }
   
   static func buildDefault() -> Self {
      .init(getLaunchData: ViewModelGetLaunchData.buildDefault().execute,
            selectedAction: ViewModelSelectedAction.buildDefault().execute,
            saveAction: ViewModelSaveAction.buildDefault().execute,
            textFieldChangeAction: ViewModelTextFieldChangeAction.buildDefault().execute)
   }
   
   func transform(input: MainViewModelInput) -> MainViewModelOutput {
      cancellableBag.removeAll()
      
      // MARK: - on View Appear
      let onAppearAction = input.onAppear.map { [weak self] result -> MainViewState in
         guard let self else { return .error("this should not happen") }
         let initialData = getLaunchData()
         return .loaded(initialData)
      }.eraseToAnyPublisher()
      
      // MARK: - on Option Selected Action
      let selectedAction = input.onOptionTapped.map { [weak self] (text) -> MainViewState in
         guard let self = self, case .loaded(var viewModel) = self.state else { return .error("this should not happen") }
         viewModel = self.selectedAction(text, viewModel)
         return .loaded(viewModel)
      }.eraseToAnyPublisher()
      
      // MARK: - on Save Action
      let saveAction = input.onSaveTapped.map { [weak self] (text) -> MainViewState in
         guard let self, let text, case .loaded(var viewModel) = self.state else { return .error("this should not happen") }
         viewModel = self.saveAction(text, viewModel)
         return .loaded(viewModel)
      }.eraseToAnyPublisher()
      
      // MARK: - on TextField Action
      let textfieldAction = input.onTextFieldTextChanged.map { [weak self] (text) -> MainViewState in
         guard let self, let text, case .loaded(var viewModel) = self.state else { return .error("this should not happen") }
         guard text != viewModel.textFieldText else { return .idle }
         viewModel = self.textFieldChangeAction(text, viewModel)
         return .loaded(viewModel)
      }.eraseToAnyPublisher()
      
      return Publishers.Merge4(onAppearAction, saveAction, selectedAction, textfieldAction)
         .removeDuplicates()
         .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
         .eraseToAnyPublisher()
   }
}
