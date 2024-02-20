final class GetAverageValue {
   typealias UseCase = (_ selectedType: SelectedType) -> Double
   
   enum Constants {
      static let conversionRate: Double = 18.0182
   }
   
   private let getSavedData: GetSavedData.UseCase
   
   static func buildDefault() -> Self {
      self.init(getSavedData: GetSavedData.buildDefault().execute)
   }
   
   init(getSavedData: @escaping GetSavedData.UseCase) {
      self.getSavedData = getSavedData
   }
   
   func execute(selectedType: SelectedType) -> Double {
      let values = getSavedData()
      
      guard values.count > 0 else { return 0 }
      
      let average = calculateAverage(from: values)
      return applyConversion(average, for: selectedType)
   }
   
   private func calculateAverage(from values: [String]) -> Double {
      let numericValues = values.compactMap { Double($0.replacingOccurrences(of: ",", with: ".")) }
      guard numericValues.count > 0 else { return 0 }
      return numericValues.reduce(0, +) / Double(numericValues.count)
   }
   
   private func applyConversion(_ value: Double, for selectedType: SelectedType) -> Double {
      var convertedValue = value
      if selectedType == .mmolL {
         convertedValue /= Constants.conversionRate
      }
      return convertedValue.rounded(to: 6)
   }
}
