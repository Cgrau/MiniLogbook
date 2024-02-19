import Combine
import Foundation

final class SaveValue {
   typealias UseCase = (_ value: String) -> Void
   
   private let repository: LocalStorage
   
   static func buildDefault() -> Self {
      self.init(repository: UserDefaultsLocalStorage.buildDefault())
   }
   
   init(repository: LocalStorage) {
      self.repository = repository
   }
   
   func execute(value: String) -> Void {
      var values = repository.retrieveValues()
      values.append(value)
      repository.save(values: values)
   }
}
