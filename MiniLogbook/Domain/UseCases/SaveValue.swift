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
   
   func execute(value: String, selectedType: SelectedType) {
       var values = getSavedData()
       let newValue = value.replacingOccurrences(of: ",", with: ".")

       guard let originalDouble = Double(newValue) else {
           return
       }

       let roundedValue: Double
       switch selectedType {
       case .mgDL:
           roundedValue = originalDouble
       case .mmolL:
           roundedValue = (originalDouble * Constants.conversionRate).rounded(to: 6)
       }

       values.append(String(roundedValue))
       saveData(values)
   }
}
