import UIKit

struct SelectionViewModel: Equatable {
   let image: UIImage
   let type: SelectedType
}

enum SelectedType: String {
   case mgDL = "mg/dL"
   case mmolL = "mmol/L"
}
