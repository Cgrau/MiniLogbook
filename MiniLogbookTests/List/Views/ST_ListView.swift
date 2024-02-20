import SnapshotTesting
import XCTest
@testable import MiniLogbook

class ST_ListView: XCTestCase {
   private var sut: ListView!
   private var adapter: ListTableViewAdapter!
   
   override func setUp() {
      sut = listView()
      let controller = ListRowCellController.buildDefault()
      adapter = .init(tableView: sut.tableView,
                      controller: controller)
   }
   
   override func tearDown() {
      sut = nil
      adapter = nil
   }
   
   func test_empty_list_view_state() {
      givenEmptyState()
      assertSnapshot(matching: sut, as: .image)
   }
   
   func test_list_view_filled_state() {
      givenUsers()
      assertSnapshot(matching: sut, as: .image)
   }
   
   private func givenUsers() {
      let viewModels = givenViewModels(values: [String](repeating: Constants.title, count: 10))
      adapter.set(viewModels: viewModels)
   }
   
   private func givenEmptyState() {
      let viewModels = givenViewModels()
      adapter.set(viewModels: viewModels)
   }
   
   private func givenViewModels(values: [String] = []) -> [ValueCellViewModel] {
      values.compactMap { .init(title: $0) }
   }
   
   private enum Constants {
      static let title = "LoremIpsum"
   }
}

extension ST_ListView {
   private func listView() -> ListView {
      return ListView(frame: CGRect(origin: .zero, size: CGSize(width: 375, height: 667)))
   }
}
