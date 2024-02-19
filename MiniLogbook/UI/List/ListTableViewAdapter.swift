import UIKit

final class ListTableViewAdapter: NSObject {
   private var viewModels = [ValueCellViewModel]() {
      didSet {
         tableView?.reloadData()
      }
   }
   
   private let controller: ListRowCellControlling
   
   private weak var tableView: UITableView?
   
   init(tableView: UITableView,
        controller: ListRowCellControlling) {
      self.tableView = tableView
      self.controller = controller
      super.init()
      setup()
   }
   
   static func buildDefault(tableView: UITableView) -> Self {
      let controller = ListRowCellController.buildDefault()
      let adapter = Self(tableView: tableView,
                         controller: controller)
      return adapter
   }
   
   func set(viewModels: [ValueCellViewModel]) {
      self.viewModels = viewModels
   }
   
   private func setup() {
      guard let tableView else { return }
      tableView.dataSource = self
      registerCells()
   }
   
   private func registerCells() {
      guard let tableView else { return }
      controller.registerCell(on: tableView)
   }
}

extension ListTableViewAdapter: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      viewModels.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard viewModels.indices.contains(indexPath.row) else {
         return UITableViewCell()
      }
      let viewModel = viewModels[indexPath.row]
      
      return controller.tableView(tableView, cellForItemAt: indexPath, viewModel: viewModel)
   }
}
