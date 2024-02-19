import Combine
import Foundation

final class GetSavedData {
   typealias UseCase = () -> [String]
   
   private let repository: LocalStorage
   
   static func buildDefault() -> Self {
      self.init(repository: UserDefaultsLocalStorage.buildDefault())
   }
   
   init(repository: LocalStorage) {
      self.repository = repository
   }
   
   func execute() -> [String] {
      return repository.retrieveValues()
   }
}
