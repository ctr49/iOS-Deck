// Created for ios-deck in 2020
// Using Swift 5.0

import Foundation

final class Settings {
  
  private enum Keys: String {
    case user = "current_user"
  }
  
  static var currentUser: User? {
    get {
      guard let data = UserDefaults.standard.data(forKey: Keys.user.rawValue) else {
        return nil
      }
      return try? JSONDecoder().decode(User.self, from: data)
    }
    set {
      if let data = try? JSONEncoder().encode(newValue) {
        UserDefaults.standard.set(data, forKey: Keys.user.rawValue)
      } else {
        UserDefaults.standard.removeObject(forKey: Keys.user.rawValue)
      }
      UserDefaults.standard.synchronize()
    }
  }
  
}
