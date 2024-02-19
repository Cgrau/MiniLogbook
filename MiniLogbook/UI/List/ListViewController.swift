import Combine
import UIKit

class ListViewController: UIViewController {
   private let listView = ListView()
   private var cancellables: Set<AnyCancellable> = []
   private var viewModel: ListViewModelable
   private var onAppearPublisher = PassthroughSubject<Void, Never>()
   private lazy var adapter = ListTableViewAdapter.buildDefault(tableView: listView.tableView)
   
   required init(viewModel: ListViewModelable) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   static func buildDefault() -> Self {
      .init(viewModel: ListViewModel.buildDefault())
   }
   
   override func loadView() {
      view = listView
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      bundToViewModel()
   }
   
   override func viewDidAppear(_ animated: Bool) {
      onAppearPublisher.send(())
   }
   
   func bundToViewModel() {
      cancellables.removeAll()
      let input = ListViewModelInput(onAppear: onAppearPublisher.eraseToAnyPublisher())
      
      let output = viewModel.transform(input: input)
      output.sink { [weak self] state in
         self?.handleState(state)
      }.store(in: &cancellables)
   }
   
   
   private func handleState(_ state: ListViewState) {
      switch state {
      case .loading:
         print("Loading...") // we could add a loader, but since we are not getting requesting remote data it doesn't make sense
      case .loaded(let listViewModel):
         listView.apply(viewModel: listViewModel)
         adapter.set(viewModels: listViewModel.values.map { .init(title: $0) })
      case .error(let errorMessage):
         print("Error: \(errorMessage)") // we could add an error message, but since our use cases cannot fail, we won't display any error
      }
   }
   
   override func viewWillAppear(_ animated: Bool) {
      navigationController?.navigationBar.isHidden = true
   }
}
