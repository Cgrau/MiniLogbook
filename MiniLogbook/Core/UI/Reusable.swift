import UIKit

public protocol Reusable: ClassName {}
public extension Reusable where Self: UIView {
    static var reuseIdentifier: String { className }
}

extension UITableViewCell: Reusable {
    @objc public static func reuseIdentifier() -> String {
        reuseIdentifier
    }
}
