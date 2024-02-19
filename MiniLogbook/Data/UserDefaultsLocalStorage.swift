import Foundation

protocol LocalStorage {
   func save(values: [String])
   func retrieveValues() -> [String]
}

final class UserDefaultsLocalStorage: LocalStorage {
   enum Constants {
      static let savedValues = "SavedData"
   }

   private let userDefaults: UserDefaults
   
   init(userDefaults: UserDefaults) {
      self.userDefaults = userDefaults
   }
   
   static func buildDefault() -> Self {
      .init(userDefaults: UserDefaults.standard)
   }
   
   func save(values: [String]) {
      let valuesJSON: [String?] = values.map {
         guard let jsonData = try? JSONEncoder().encode($0) else { return nil }
         let jsonString = String(data: jsonData, encoding: .utf8)!
         return jsonString
      }.compactMap {$0}
      userDefaults.set(valuesJSON, forKey: Constants.savedValues)
   }
   
   func retrieveValues() -> [String] {
      let jsonDataArray = userDefaults.array(forKey: Constants.savedValues) as? [String] ?? []
      let values: [String?] = jsonDataArray.map {
         let jsonData = $0.data(using: .utf8)!
         guard let value = try? JSONDecoder().decode(String.self, from: jsonData) else { return nil }
         return value
      }
      return values.compactMap {$0}
   }
}
