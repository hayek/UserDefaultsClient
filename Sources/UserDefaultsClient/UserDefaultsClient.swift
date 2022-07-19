import Foundation



/// UserDefaults client with safe keys definition supports dependency injection.
/// Use: You can use SFGUserDefaultsClient.standard implementation or suiteName(:String) or UserDefaults implementations.
public struct SFGUserDefaultsClient {
    public init(getValue: @escaping (String) -> PlistCompatible?,
                setValueForKey: @escaping (PlistCompatible, String) -> Void) {
        self.getValue = getValue
        self.setValueForKey = setValueForKey
    }
    
    private var getValue: (String) -> PlistCompatible?
    private var setValueForKey: (PlistCompatible, String) -> Void
    
    func value<A>(key: SFGUserDefaultsKey<A>) -> A where A: OptionalType, A.Wrapped:PlistCompatible{
        getValue(key.key) as! A
    }
    
    func value<A>(key: SFGUserDefaultsKey<A>) -> A where A : PlistCompatible {
        getValue(key.key) as? A ?? key.default!
    }
    
    func setValue<A>(_ value: A, for key: SFGUserDefaultsKey<A>){
        setValueForKey(value, key.key)
    }
}

public extension SFGUserDefaultsClient {
    static var standard = SFGUserDefaultsClient { key in
        UserDefaults.standard.value(forKey: key) as? PlistCompatible
    } setValueForKey: {
        value, key in
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func suiteName(_ suiteName: String) -> SFGUserDefaultsClient {
        guard let userDefaultsOfSuite = UserDefaults(suiteName: suiteName) else {
            assertionFailure("SFGUserDefaultsClient failure: preferences search list for the domain '\(suiteName)' failed. Passing the current application's bundle identifier, NSGlobalDomain, or the corresponding CFPreferences constants is an error")
            return .standard
        }
        return .init { key in
            userDefaultsOfSuite.value(forKey: key) as? PlistCompatible
        } setValueForKey: {
            value, key in
            userDefaultsOfSuite.set(value, forKey: key)
        }
    }
    
    static var mock = SFGUserDefaultsClient { key in
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

