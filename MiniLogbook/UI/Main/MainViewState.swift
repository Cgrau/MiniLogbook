enum MainViewState: Equatable {
   case idle
   case loading
   case loaded(ScreenViewModel)
   case error(String)
}

struct ScreenViewModel: Equatable {
   var result: String
   let description: String
   var options: [SelectionViewModel]
   var textFieldText: String
   var textFieldTitle: String
   let buttonTitle: String
   var errorText: String?
   var selectedType: SelectedType
}
