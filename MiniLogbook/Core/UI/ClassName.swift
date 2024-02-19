import Foundation

public protocol ClassName {}
public extension ClassName {
    var className: String { String(describing: type(of: self)) }
    static var className: String { String(describing: self) }
}

extension NSObject: ClassName {}
