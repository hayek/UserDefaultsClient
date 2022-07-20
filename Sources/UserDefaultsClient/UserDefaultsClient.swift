import Foundation



/// UserDefaults client with safe keys definition supports dependency injection.
/// Use: You can use SFGUserDefaultsClient.standard implementation or suiteName(:String) or UserDefaults implementations.
public struct UserDefaultsClient {
    public init(getValue: @escaping (String) -> Any?,
                setValueForKey: @escaping (Codable, String) -> Void) {
        self.getValue = getValue
        self.setValueForKey = setValueForKey
    }
    
    private var getValue: (String) -> Any?
    private var setValueForKey: (Codable, String) -> Void
    
    func value<A>(key: UserDefaultsKey<A>) -> A where A: OptionalType, A.Wrapped:Codable{
        let value = getValue(key.key)
        if let data = value as? Data {
            return try! JSONDecoder().decode(A.self, from: data)
        }
        return value as! A
    }
    
    func value<A>(key: UserDefaultsKey<A>) -> A where A : Codable {
        let value = getValue(key.key)
        if let data = value as? Data {
            return try! JSONDecoder().decode(A.self, from: data)
        }
        return value as? A ?? key.default!
    }
    
    func setValue<A>(_ value: A, for key: UserDefaultsKey<A>){
        if let value = value as? PlistCompatible {
            setValueForKey(value, key.key)
        } else {
            let data = try! JSONEncoder().encode(value)
            setValueForKey(data, key.key)
        }
    }
}

public extension UserDefaultsClient {
    static var standard = userDefaults(.standard)
    
    static func suiteName(_ suiteName: String?) -> UserDefaultsClient {
        guard let userDefaultsOfSuite = UserDefaults(suiteName: suiteName) else {
            assertionFailure("SFGUserDefaultsClient failure: preferences search list for the domain '\(suiteName ?? "nil")' failed. Passing the current application's bundle identifier, NSGlobalDomain, or the corresponding CFPreferences constants is an error")
            return .standard
        }
        return userDefaults(userDefaultsOfSuite)
    }
    
    
    private static func userDefaults(_ userDefaults: UserDefaults) -> UserDefaultsClient {
        .init { key in
            userDefaults.value(forKey: key)
        } setValueForKey: {
            value, key in
            userDefaults.set(value, forKey: key)
        }
    }
    static var mock = UserDefaultsClient { key in
        switch key {
        case "aaa":
            return true
        case "fff":
            return 10
        case "ds":
            return nil
        default:
            return nil
        }
    } setValueForKey: { _,_ in }
}

