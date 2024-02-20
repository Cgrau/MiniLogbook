import Foundation

final class SaveData {
   typealias UseCase = ([String]) -> Void
   
   private let repository: LocalStorage
   
   static func buildDefault() -> Self {
      self.init(repository: UserDefaultsLocalStorage.buildDefault())
   }
   
   init(repository: LocalStorage) {
      self.repository = repository
   }
   
   func execute(values: [String]) -> Void {
      repository.save(values: values)
   }
}
