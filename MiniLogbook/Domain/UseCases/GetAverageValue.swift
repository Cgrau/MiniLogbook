import Combine
import Foundation

final class GetAverageValue {
   typealias UseCase = (_ selectedType: SelectedType) -> Double
   
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
   
   func execute(selectedType: SelectedType) -> Double {
      let values = repository.retrieveValues()
      guard values.count != 0 else { return 0 }
      let average = values.compactMap { Double($0) }.reduce(0, +) / Double(values.count)
      switch selectedType {
      case .mgDL:
         return average.rounded()
      case .mmolL:
         return average / Constants.conversionRate
      }
   }
}
