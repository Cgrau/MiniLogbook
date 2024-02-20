import Foundation

final class SaveValue {
   typealias UseCase = (_ value: String, _ selectedType: SelectedType) -> Void
   
   enum Constants {
      static let conversionRate: Double = 18.0182
   }
   
   private let getSavedData: GetSavedData.UseCase
   private let saveData: SaveData.UseCase
   
   static func buildDefault() -> Self {
      self.init(getSavedData: GetSavedData.buildDefault().execute,
                saveData: SaveData.buildDefault().execute)
   }
   
   init(getSavedData: @escaping GetSavedData.UseCase,
        saveData: @escaping SaveData.UseCase) {
      self.getSavedData = getSavedData
      self.saveData = saveData
   }
   
   func execute(value: String, selectedType: SelectedType) -> Void {
      var values = getSavedData()
      let newValue = value.replacingOccurrences(of: ",", with: ".")
      switch selectedType {
      case .mgDL:
         values.append(newValue)
      case .mmolL:
         guard let expectedValue = Double(newValue) else { return }
         let newValue = String(expectedValue * Constants.conversionRate)
         values.append(newValue)
      }
      saveData(values)
   }
}
