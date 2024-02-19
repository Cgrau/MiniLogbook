import Combine
import Foundation

final class GetAverageValue {
   typealias UseCase = () -> Int
   
   private let repository: LocalStorage
   
   static func buildDefault() -> Self {
      self.init(repository: UserDefaultsLocalStorage.buildDefault())
   }
   
   init(repository: LocalStorage) {
      self.repository = repository
   }
   
   func execute() -> Int {
      let values = repository.retrieveValues()
      guard values.count != 0 else { return 0 }
      let average = values.compactMap { Int($0) }.reduce(0, +) / values.count
      return average
   }
}
