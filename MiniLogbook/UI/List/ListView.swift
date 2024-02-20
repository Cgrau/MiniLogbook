import UIKit
import SnapKit

final class ListView: View {
   private enum Constants {
      static let undelineHeight = 2
      enum TitleLabel {
         static let title = "Saved Values in mg/dL:"
         static let font = UIFont.boldSystemFont(ofSize: 20)
      }
   }
   
   private var titleLabel: UILabel = {
      let label = UILabel()
      label.text = Constants.TitleLabel.title
      label.font = Constants.TitleLabel.font
      label.textAlignment = .center
      return label
   }()
   
   private var underline: UIView = {
      let view = UIView()
      view.backgroundColor = .black
      return view
   }()
   
   var tableView: UITableView = {
      let tableView = UITableView()
      return tableView
   }()
   
   // MARK: View Functions
   override func setupView() {
      backgroundColor = .white
      addSubview(titleLabel)
      addSubview(underline)
      addSubview(tableView)
   }
   
   override func setupConstraints() {
      titleLabel.snp.makeConstraints { make in
         make.top.equalTo(safeAreaLayoutGuide).offset(Spacing.l)
         make.leading.equalToSuperview().offset(Spacing.l)
         make.trailing.equalToSuperview().offset(-Spacing.l)
      }
      underline.snp.makeConstraints { make in
         make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.s)
         make.leading.equalToSuperview().offset(Spacing.l)
         make.trailing.equalToSuperview().offset(-Spacing.l)
         make.height.equalTo(Constants.undelineHeight)
      }
      tableView.snp.makeConstraints { make in
         make.top.equalTo(underline.snp.bottom)
         make.leading.equalToSuperview().offset(Spacing.l)
         make.trailing.equalToSuperview().offset(-Spacing.l)
         make.bottom.equalToSuperview()
      }
   }
}
