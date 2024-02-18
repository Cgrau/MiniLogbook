import Combine
import UIKit

class MainViewController: UIViewController {
   private let mainView = MainView()
   private var cancellables: Set<AnyCancellable> = []
   var viewModel = MainViewModel.empty()
   
   override func loadView() {
      mainView.delegate = self
      view = mainView
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      bindViewModel()
   }
   
   private func bindViewModel() {
      viewModel.$state
         .sink { [weak self] state in
            self?.handleState(state)
         }
         .store(in: &cancellables)
      viewModel.loadUserData()
   }
   
   private func handleState(_ state: MainViewState) {
      switch state {
      case .loading:
         print("Loading...") // we could add a loader, but since we are not getting requesting remote data it doesn't make sense
      case .loaded(let mainViewModel):
         mainView.apply(viewModel: mainViewModel)
      case .error(let errorMessage):
         print("Error: \(errorMessage)") // we could add an error message, but since our use cases cannot fail, we won't display any error
      }
   }
   
   override func viewWillAppear(_ animated: Bool) {
      navigationController?.navigationBar.isHidden = true
   }
}

extension MainViewController: MainViewDelegate {
   func didTapSaveButton() {
      viewModel.save(value: viewModel.textFieldText)
   }
}
