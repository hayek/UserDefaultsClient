import XCTest
@testable import UserDefaultsClient

extension SFGUserDefaultsKey {
    static var someBoolKey: SFGUserDefaultsKey<Bool> { .init(key: "aaa", default: true)}
    static var someInt: SFGUserDefaultsKey<Int> { .init(key: "fff", default: 2) }
    static var someOptionalInt: SFGUserDefaultsKey<Int?> { .init(key: "ds") }
}

final class UserDefaultsClientTests: XCTestCase {
    func testExample() throws {
//        let bbb = SFGUserDefaultsClient.standard.value(key: .someInt)
//        let aaa = SFGUserDefaultsClient.standard.value(key: .someOptionalInt)
        let ccc = SFGUserDefaultsClient.standard.value(key: .someBoolKey)
        XCTAssertTrue(ccc)
//        SFGUserDefaultsClient.standard.setValue(false, for: .someBoolKey)
//        SFGUserDefaultsClient.standard.setValue(nil, for: .someOptionalInt)
//
//        let mock = SFGUserDefaultsClient.mock.value(key: .someInt)
        
        
    }
}
