import Combine
import Foundation

final class SaveValue {
   typealias UseCase = (_ value: String, _ selectedType: SelectedType) -> Void
   
   enum Constants {
      static let conversionRate: Double = 18.0182
   }
   
   private let repository: LocalStorage
   
   static func buildDefault() -> Self {
      self.init(repository: UserDefaultsLocalStorage.buildDefault())
   }
   
   init(repository: LocalStorage) {
      self.repository = repository
   }
   
   func execute(value: String, selectedType: SelectedType) -> Void {
      var values = repository.retrieveValues()
      switch selectedType {
      case .mgDL:
         values.append(value)
      case .mmolL:
         guard let expectedValue = Double(value) else { return }
         values.append(String(expectedValue / Constants.conversionRate))
      }
      repository.save(values: values)
   }
}
