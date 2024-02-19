import UIKit
import SnapKit

final class ListView: View {
   var tableView: UITableView = {
      let tableView = UITableView()
      return tableView
   }()
   
   // MARK: View Functions
   override func setupView() {
      backgroundColor = .white
      addSubview(tableView)
   }
   
   override func setupConstraints() {
      tableView.snp.makeConstraints { make in
         make.top.equalTo(safeAreaLayoutGuide).offset(Spacing.l)
         make.leading.equalToSuperview().offset(Spacing.l)
         make.trailing.equalToSuperview().offset(-Spacing.l)
         make.bottom.equalToSuperview()
      }
   }
}

extension ListView {
   func apply(viewModel: ListScreenViewModel) {
      
   }
}
