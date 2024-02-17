import UIKit
import SnapKit
import RxSwift
import RxCocoa

protocol MainViewDelegate: AnyObject {
}

final class MainView: View {
   weak var delegate: MainViewDelegate?
   var tableView = UITableView()
   private var bag = DisposeBag()
   
   private enum Constants {
      static let undelineHeight = 2
      enum Result {
         static let font = UIFont.boldSystemFont(ofSize: 22)
      }
      enum TitleLabel {
         static let font = UIFont.boldSystemFont(ofSize: 20)
      }
      enum Button {
         static let height: CGFloat = 33
      }
   }
   
   private var resultLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.textAlignment = .center
      label.font = Constants.Result.font
      return label
   }()
   
   private var underline: UIView = {
      let view = UIView()
      view.backgroundColor = .black
      return view
   }()
   
   private var titleLabel: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.textAlignment = .left
      label.font = Constants.TitleLabel.font
      return label
   }()
   
   private var measurementOptions: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .vertical
      stackView.alignment = .fill
      stackView.distribution = .equalSpacing
      stackView.translatesAutoresizingMaskIntoConstraints = false
      return stackView
   }()
   
   private var textFieldStackView: UIStackView = {
      let stackView = UIStackView()
      stackView.axis = .horizontal
      stackView.contentMode = .scaleToFill
      stackView.distribution = .fill
      stackView.spacing = 8
      stackView.translatesAutoresizingMaskIntoConstraints = false
      return stackView
   }()
   
   private var textField: UITextField = {
      let textField = UITextField()
      textField.font = Constants.Result.font
      textField.textColor = .gray
      textField.tintColor = .gray
      textField.borderStyle = .roundedRect
      textField.borderRect(forBounds: .init(x: .zero, y: .zero, width: 5, height: 5))
      return textField
   }()
   
   private var textFieldTitle: UILabel = {
      let label = UILabel()
      label.textColor = .black
      label.textAlignment = .left
      label.font = Constants.TitleLabel.font
      return label
   }()
   
   private var saveButton: UIButton = {
      let button = UIButton()
      button.setTitleColor(.black, for: .normal)
      button.layer.cornerRadius = 10
      button.layer.borderWidth = 1.0
      button.layer.borderColor = UIColor.black.cgColor
      return button
   }()
   
   // MARK: View Functions
   override func setupView() {
      backgroundColor = .white
      addSubview(resultLabel)
      addSubview(underline)
      addSubview(titleLabel)
      addSubview(measurementOptions)
      addSubview(textFieldStackView)
      textFieldStackView.addArrangedSubview(textField)
      textFieldStackView.addArrangedSubview(textFieldTitle)
      textField.setContentHuggingPriority(.defaultLow, for: .horizontal)
      textField.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
      textFieldTitle.setContentHuggingPriority(.defaultHigh, for: .horizontal)
      textFieldTitle.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
      addSubview(saveButton)
   }
   
   override func setupConstraints() {
      resultLabel.snp.makeConstraints { make in
         make.top.equalTo(safeAreaLayoutGuide).offset(Spacing.l)
         make.centerX.equalToSuperview()
      }
      underline.snp.makeConstraints { make in
         make.top.equalTo(resultLabel.snp.bottom).offset(Spacing.s)
         make.leading.equalToSuperview().offset(Spacing.l)
         make.trailing.equalToSuperview().offset(-Spacing.l)
         make.height.equalTo(Constants.undelineHeight)
      }
      titleLabel.snp.makeConstraints { make in
         make.top.equalTo(underline.snp.bottom).offset(Spacing.xl)
         make.leading.equalTo(underline).offset(Spacing.xs)
         make.trailing.equalTo(underline).offset(-Spacing.xs)
      }
      measurementOptions.snp.makeConstraints { make in
         make.top.equalTo(titleLabel.snp.bottom).offset(Spacing.m)
         make.leading.equalTo(titleLabel)
         make.trailing.equalTo(titleLabel)
      }
      textFieldStackView.snp.makeConstraints { make in
         make.top.equalTo(measurementOptions.snp.bottom).offset(Spacing.xl)
         make.leading.equalTo(measurementOptions)
         make.trailing.equalTo(measurementOptions)
      }
      saveButton.snp.makeConstraints { make in
         make.top.equalTo(textFieldStackView.snp.bottom).offset(Spacing.l)
         make.trailing.equalTo(measurementOptions)
         make.leading.equalTo(measurementOptions).offset(200)
         make.height.equalTo(Constants.Button.height)
      }
   }
}

extension MainView {
   func apply(viewModel: MainViewModel) {
      resultLabel.text = viewModel.result
      titleLabel.text = viewModel.description
      viewModel.options.forEach { measurementOptions.addArrangedSubview($0) }
      textField.text = viewModel.textFieldText
      textFieldTitle.text = viewModel.textFieldTitle
      saveButton.setTitle(viewModel.buttonTitle, for: .normal)
   }
}
