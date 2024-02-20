// Generated using Sourcery 2.1.7 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
@testable import MiniLogbook
#if os(iOS) || os(tvOS) || os(watchOS)
import UIKit
import Combine
#elseif os(OSX)
import AppKit
#endif


// MARK: - LocalStorage

class LocalStorageMock: LocalStorage {

    //MARK: - save

    struct SaveValues {
      var callsCount = 0
      var called: Bool { return callsCount > 0 }
      var receivedValues: [String]?
    }

    var saveValuesClosure: (([String]) -> Void)?

    var _saveValues = SaveValues()

    func save(values: [String]) {
        _saveValues.callsCount += 1
        _saveValues.receivedValues = values
        saveValuesClosure?(values)
    }

    //MARK: - retrieveValues

    struct RetrieveValues {
      var callsCount = 0
      var called: Bool { return callsCount > 0 }
      var returnValue: [String]!
    }

    var retrieveValuesClosure: (() -> [String])?

    var _retrieveValues = RetrieveValues()

    func retrieveValues() -> [String] {
        _retrieveValues.callsCount += 1
        return retrieveValuesClosure.map({ $0() }) ?? _retrieveValues.returnValue
    }
}
