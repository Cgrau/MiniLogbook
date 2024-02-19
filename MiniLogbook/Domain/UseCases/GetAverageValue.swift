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
      let average = values.compactMap { Double($0.replacingOccurrences(of: ",", with: ".")) }.reduce(0, +) / Double(values.count)
      switch selectedType {
      case .mgDL:
         guard let value = Double(String(format: "%.2f", average)) else { return average.rounded() }
         return value
      case .mmolL:
         return average / Constants.conversionRate
      }
   }
}
