enum ListViewState: Equatable {
   case loading
   case loaded(ListScreenViewModel)
   case error(String)
}

struct ListScreenViewModel: Equatable {
   let values: [String]
}
