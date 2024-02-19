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
   @Published private(set) var state: MainViewState = .loading
   
   private var cancellableBag = Set<AnyCancellable>()
   private var currentOptions = [String]()
   private let getLaunchData: GetLaunchData.UseCase
   private let selectedAction: SelectedAction.UseCase
   private let saveAction: SaveAction.UseCase
   
   required init(getLaunchData: @escaping GetLaunchData.UseCase,
                 selectedAction: @escaping SelectedAction.UseCase,
                 saveAction: @escaping SaveAction.UseCase) {
      self.getLaunchData = getLaunchData
      self.selectedAction = selectedAction
      self.saveAction = saveAction
   }
   
   static func buildDefault() -> Self {
      .init(getLaunchData: GetLaunchData.buildDefault().execute,
            selectedAction: SelectedAction.buildDefault().execute,
            saveAction: SaveAction.buildDefault().execute)
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
         guard let self = self, case .loaded(var viewModel) = self.state else { return .loading }
         viewModel = self.selectedAction(text, viewModel)
         return .loaded(viewModel)
      }.eraseToAnyPublisher()
      
      // MARK: - on Save Action
      let saveAction = input.onSaveTapped.map { [weak self] (text) -> MainViewState in
         guard let self, let text, case .loaded(var viewModel) = self.state else { return .loading }
         viewModel = self.saveAction(text, viewModel)
         return .loaded(viewModel)
      }.eraseToAnyPublisher()
      
      return Publishers.Merge3(onAppearAction, saveAction, selectedAction)
         .removeDuplicates()
         .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
         .eraseToAnyPublisher()
   }
}
