import XCTest
@testable import UserDefaultsClient

struct SomeCodableStruct: Codable, Equatable {
    let name: String
}

extension UserDefaultsKey {
    static var someBoolKey: UserDefaultsKey<Bool> { .init(key: "someBoolKey", default: true)}
    static var someInt: UserDefaultsKey<Int> { .init(key: "someInt", default: 2) }
    static var someOptionalInt: UserDefaultsKey<Int?> { .init(key: "someOptionalInt") }
    static var someStruct: UserDefaultsKey<SomeCodableStruct> {.init(key: "someStruct", default: .init(name: "default something")) }

}

extension UserDefaultsClient {
    static var storage: [String: Any] = [:]
    
    static var testClient: Self {
        .init(
            getValue: { key in
                storage[key]
            } ,
            setValueForKey: { value, key in
                storage[key] = value
            })
    }
}

final class UserDefaultsClientTests: XCTestCase {
    func testValues() throws {
        XCTAssertTrue(UserDefaultsClient.testClient.value(key: .someBoolKey))
        UserDefaultsClient.testClient.setValue(false, for: .someBoolKey)
        XCTAssertFalse(UserDefaultsClient.testClient.value(key: .someBoolKey))
        
        XCTAssertEqual(UserDefaultsClient.testClient.value(key: .someInt), 2)
        UserDefaultsClient.testClient.setValue(3, for: .someInt)
        XCTAssertEqual(UserDefaultsClient.testClient.value(key: .someInt), 3)
    }
    
    func testOptionalValues() throws {
        XCTAssertEqual(UserDefaultsClient.testClient.value(key: .someOptionalInt), nil)
        UserDefaultsClient.testClient.setValue(3, for: .someOptionalInt)
        XCTAssertEqual(UserDefaultsClient.testClient.value(key: .someOptionalInt), 3)
        UserDefaultsClient.testClient.setValue(nil, for: .someOptionalInt)
        XCTAssertEqual(UserDefaultsClient.testClient.value(key: .someOptionalInt), nil)
    }
    
    func testCodableValues() throws {
        XCTAssertEqual(UserDefaultsClient.testClient.value(key: .someStruct), .init(name: "default something"))
        UserDefaultsClient.testClient.setValue(.init(name: "something else"), for: .someStruct)
        XCTAssertEqual(UserDefaultsClient.testClient.value(key: .someStruct), .init(name: "something else"))
    }
}
