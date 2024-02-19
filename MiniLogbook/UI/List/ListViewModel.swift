import Combine
import UIKit

enum ListScreenState: Equatable {
   case initial
   case error
   case loaded(ListScreenViewModel)
}

typealias ListViewModelOutput = AnyPublisher<ListViewState, Never>

public struct ListViewModelInput {
   let onAppear: AnyPublisher<Void, Never>
}

protocol ListViewModelable: AnyObject {
   func transform(input: ListViewModelInput) -> ListViewModelOutput
}

public class ListViewModel: ObservableObject, ListViewModelable {
   @Published private(set) var state: ListViewState = .loading
   
   private var cancellableBag = Set<AnyCancellable>()
   private var currentOptions = [String]()
   private let getSavedData: GetSavedData.UseCase
   
   required init(getSavedData: @escaping GetSavedData.UseCase) {
      self.getSavedData = getSavedData
   }
   
   static func buildDefault() -> Self {
      .init(getSavedData: GetSavedData.buildDefault().execute)
   }
   
   func transform(input: ListViewModelInput) -> ListViewModelOutput {
      cancellableBag.removeAll()
      
      // MARK: - on View Appear
      return input.onAppear.map { [weak self] result -> ListViewState in
         guard let self else { return .error("this should not happen") }
         let initialData = getSavedData()
         return .loaded(ListScreenViewModel(values: initialData))
      }
      .handleEvents(receiveOutput: { [weak self] in self?.state = $0 })
      .eraseToAnyPublisher()
   }
}
