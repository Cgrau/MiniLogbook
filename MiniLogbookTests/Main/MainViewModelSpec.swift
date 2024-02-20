import XCTest
import Combine
@testable import MiniLogbook

final class MainViewModelSpec: XCTestCase {
   private var sut: MainViewModelable!
   private var getLaunchDataCalled: Bool = false
   private var getLaunchDataCalledCount: Int = 0
   private var selectedActionCalled: Bool = false
   private var selectedActionCalledCount: Int = 0
   private var saveActionCalled: Bool = false
   private var saveActionCalledCount: Int = 0
   private var textFieldChangeActionCalled: Bool = false
   private var textFieldChangeActionCalledCount: Int = 0
   private var cancellables: Set<AnyCancellable> = []
   
   override func tearDown() {
      sut = nil
      getLaunchDataCalled = false
      getLaunchDataCalledCount = 0
      selectedActionCalled = false
      selectedActionCalledCount = 0
      saveActionCalled  = false
      saveActionCalledCount = 0
      textFieldChangeActionCalled = false
      textFieldChangeActionCalledCount = 0
      cancellables = []
      super.tearDown()
   }
   
   func testTransform_onAppear() {
      givenSUT()
      let input = MainViewModelInput(onAppear: Just(()).eraseToAnyPublisher(),
                                     onOptionTapped: Empty().eraseToAnyPublisher(),
                                     onSaveTapped: Empty().eraseToAnyPublisher(),
                                     onTextFieldTextChanged: Empty().eraseToAnyPublisher())
      var receivedStates: [MainViewState] = []
      
      sut.transform(input: input)
         .sink { state in
            receivedStates.append(state)
         }
         .store(in: &cancellables)
      
      XCTAssertEqual(receivedStates, [.loaded(self.givenViewModel())])
      XCTAssertTrue(getLaunchDataCalled)
      XCTAssertEqual(getLaunchDataCalledCount, 1)
   }
   
   func testTransform_onOptionTapped() {
      givenSUT()
      let input = MainViewModelInput(onAppear: Just(()).eraseToAnyPublisher(),
                                     onOptionTapped: Just(Constants.Options.mmolLTitle).eraseToAnyPublisher(),
                                     onSaveTapped: Empty().eraseToAnyPublisher(),
                                     onTextFieldTextChanged: Empty().eraseToAnyPublisher())
      var receivedStates: [MainViewState] = []
      
      sut.transform(input: input)
         .sink { state in
            receivedStates.append(state)
         }
         .store(in: &cancellables)
      
      XCTAssertEqual(receivedStates, [.loaded(self.givenViewModel())])
      XCTAssertTrue(selectedActionCalled)
      XCTAssertEqual(selectedActionCalledCount, 1)
   }
   
   
   func testTransform_onSaveTapped() {
      givenSUT()
      let input = MainViewModelInput(
         onAppear: Just(()).eraseToAnyPublisher(),
         onOptionTapped: Empty().eraseToAnyPublisher(),
         onSaveTapped: Just("123").eraseToAnyPublisher(),
         onTextFieldTextChanged: Empty().eraseToAnyPublisher()
      )
      
      var receivedStates: [MainViewState] = []
      
      sut.transform(input: input)
         .sink { state in
            receivedStates.append(state)
         }
         .store(in: &cancellables)
      
      XCTAssertEqual(receivedStates, [.loaded(self.givenViewModel())])
      XCTAssertTrue(saveActionCalled)
      XCTAssertEqual(saveActionCalledCount, 1)
   }
   
   
   func testTransform_onTextFieldTextChanged() {
      givenSUT()
      let input = MainViewModelInput(onAppear: Just(()).eraseToAnyPublisher(),
                                     onOptionTapped: Empty().eraseToAnyPublisher(),
                                     onSaveTapped: Empty().eraseToAnyPublisher(),
                                     onTextFieldTextChanged: Just("123").eraseToAnyPublisher())
      var receivedStates: [MainViewState] = []
      
      sut.transform(input: input)
         .sink { state in
            receivedStates.append(state)
         }
         .store(in: &cancellables)
      
      XCTAssertEqual(receivedStates, [.loaded(self.givenViewModel())])
      XCTAssertTrue(textFieldChangeActionCalled)
      XCTAssertEqual(textFieldChangeActionCalledCount, 1)
   }
   
   private func givenSUT() {
      sut = MainViewModel(getLaunchData: {
         self.getLaunchDataCalled = true
         self.getLaunchDataCalledCount += 1
         return self.givenViewModel()
      }, selectedAction: { selectedOption, viewModel in
         self.selectedActionCalled = true
         self.selectedActionCalledCount += 1
         return self.givenViewModel()
      }, saveAction: { text, viewModel in
         self.saveActionCalled = true
         self.saveActionCalledCount += 1
         return self.givenViewModel(textFieldText: "")
      }, textFieldChangeAction: { text, viewModel in
         self.textFieldChangeActionCalled = true
         self.textFieldChangeActionCalledCount += 1
         return self.givenViewModel()
      })
   }
   
   private func givenViewModel(selectedType: SelectedType = .mgDL, textFieldText: String = "") -> ScreenViewModel {
      .init(result: Constants.result,
            description: Constants.description,
            options: Constants.Options.viewModels,
            textFieldText: textFieldText,
            textFieldTitle: selectedType.rawValue,
            buttonTitle: Constants.buttonTitle,
            errorText: nil,
            selectedType: selectedType)
   }
   
   enum Constants {
      enum Average {
         static let value1: Double = 0
         static let value2: Double = 1.20
      }
      static let result = "Your average is 0 mg/dL"
      static let description = "Add measurement:"
      
      enum Options {
         static let mgDLTitle = SelectedType.mgDL.rawValue
         static let mmolLTitle = SelectedType.mmolL.rawValue
         static let viewModels: [SelectionViewModel] = [
            .init(image: .selected,
                  type: .mgDL),
            .init(image: .unselected,
                  type: .mmolL)
         ]
      }
      static let buttonTitle = "Save"
   }
}
