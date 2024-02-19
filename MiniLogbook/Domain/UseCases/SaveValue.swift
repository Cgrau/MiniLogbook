import Combine
import Foundation

final class SaveValue {
   typealias UseCase = (_ value: String, _ selectedType: SelectedType) -> Void
   
   enum Constants {
      static let conversionRate: Double = 18.0182
   }
   
   private let repository: LocalStorage
   private let getSavedData: GetSavedData.UseCase
   
   static func buildDefault() -> Self {
      self.init(repository: UserDefaultsLocalStorage.buildDefault(),
                getSavedData: GetSavedData.buildDefault().execute)
   }
   
   init(repository: LocalStorage,
        getSavedData: @escaping GetSavedData.UseCase) {
      self.repository = repository
      self.getSavedData = getSavedData
   }
   
   func execute(value: String, selectedType: SelectedType) -> Void {
      var values = getSavedData()
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
