import UIKit

final class ValueViewCell: TableViewCell {
   
   private var titleLabel: UILabel = {
      let label = UILabel()
      label.font = label.font.withSize(22)
      return label
   }()
   
   override func setupView() {
      addSubview(titleLabel)
   }
   
   override func setupConstraints() {
      titleLabel.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(Spacing.s)
         make.leading.equalToSuperview().offset(Spacing.l)
         make.trailing.equalToSuperview().offset(-Spacing.l)
         make.bottom.equalToSuperview().offset(-Spacing.s)
      }
   }
}

extension ValueViewCell {
   func apply(viewModel: ValueCellViewModel) {
      titleLabel.text = viewModel.title
   }
}
