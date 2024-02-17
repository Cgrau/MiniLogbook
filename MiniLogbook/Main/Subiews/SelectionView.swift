import UIKit

protocol SelectionViewDelegate: AnyObject {
   func didTapButton()
}

final class SelectionView: View {
   enum Constants {
      enum Button {
         static let size = CGSize(width: 33, height: 33)
      }
      enum TitleLabel {
         static let font = UIFont.boldSystemFont(ofSize: 20)
      }
   }
   
   weak var delegate: SelectionViewDelegate?
   
   private var titleLabel: UILabel = {
      let label = UILabel()
      label.font = Constants.TitleLabel.font
      return label
   }()
   
   private var button: UIButton = {
      let button = UIButton()
      button.imageView?.contentMode = .scaleAspectFit
      return button
   }()
   
   override func setupView() {
      addSubview(button)
      addSubview(titleLabel)
      button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
   }
   
   override func setupConstraints() {
      button.snp.makeConstraints { make in
         make.top.equalToSuperview().offset(Spacing.xs)
         make.leading.equalToSuperview().offset(Spacing.s)
         make.size.equalTo(Constants.Button.size)
         make.bottom.equalToSuperview().offset(-Spacing.xs)
      }
      titleLabel.snp.makeConstraints { make in
         make.leading.equalTo(button.snp.trailing).offset(Spacing.s)
         make.centerY.equalTo(button)
         make.trailing.equalToSuperview().offset(-Spacing.s)
      }
   }
   
   @objc func buttonTapped() {
      delegate?.didTapButton()
   }
}

extension SelectionView {
   func apply(viewModel: SelectionViewModel) {
      button.setImage(viewModel.image, for: .normal)
      titleLabel.text = viewModel.text
   }
}
