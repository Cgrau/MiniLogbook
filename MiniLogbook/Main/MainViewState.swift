enum MainViewState {
    case loading
    case loaded(MainViewModel)
    case error(String)
}
