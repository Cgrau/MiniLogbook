enum ListViewState: Equatable {
   case idle
   case loading
   case loaded(ListScreenViewModel)
   case error(String)
}

struct ListScreenViewModel: Equatable {
   let values: [String]
}
