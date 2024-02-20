import Combine
import UIKit

class MainViewController: UIViewController {
   private let mainView = MainView()
   private var cancellables: Set<AnyCancellable> = []
   private var viewModel: MainViewModelable
   private var onAppearPublisher = PassthroughSubject<Void, Never>()
   private var onOptionTappedPublisher = PassthroughSubject<String, Never>()
   private var saveButtonTapsPublisher = PassthroughSubject<(String?), Never>()
   private var onTextFieldTextChangedPublisher = PassthroughSubject<String?, Never>()
   
   required init(viewModel: MainViewModelable) {
      self.viewModel = viewModel
      super.init(nibName: nil, bundle: nil)
   }
   
   required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
   }
   
   static func buildDefault() -> Self {
      .init(viewModel: MainViewModel.buildDefault())
   }
   
   override func loadView() {
      mainView.delegate = self
      view = mainView
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
      let input = MainViewModelInput(onAppear: onAppearPublisher.eraseToAnyPublisher(),
                                     onOptionTapped: (onOptionTappedPublisher.eraseToAnyPublisher()),
                                     onSaveTapped: saveButtonTapsPublisher.eraseToAnyPublisher(),
                                     onTextFieldTextChanged: onTextFieldTextChangedPublisher.eraseToAnyPublisher())
      
      let output = viewModel.transform(input: input)
      output.sink { [weak self] state in
         self?.handleState(state)
      }.store(in: &cancellables)
   }
   
   
   private func handleState(_ state: MainViewState) {
      switch state {
      case .idle:
         print("Idle")
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
   func didTapOption(with text: String) {
      onOptionTappedPublisher.send(text)
   }
   
   func didTapSaveButton(with text: String?) {
      saveButtonTapsPublisher.send(text)
   }
   
   func didTextFieldTextChange(with text: String?) {
      onTextFieldTextChangedPublisher.send(text)
   }
}
