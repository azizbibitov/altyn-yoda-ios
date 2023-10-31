//
//  AccUserDefaults.swift
//  Altyn
//
//  Created by Aziz's MacBook Air on 16.03.2023.
//

import Foundation

class AccountUserDefaults {
    
    static let shared = AccountUserDefaults()
   
    func notificationOff() {
        UserDefaults.standard.set(true, forKey: "notification_off")
    }
    
    func notificationOn() {
        UserDefaults.standard.set(false, forKey: "notification_off")
    }
    
    func isNotificationOff() -> Bool? {
        return UserDefaults.standard.bool(forKey: "notification_off")
    }
    
    func userLogin() {
        UserDefaults.standard.set(true, forKey: "user_login")
    }
    
    func isUserLogin() -> Bool? {
        return UserDefaults.standard.bool(forKey: "user_login")
    }
    
    func splashShown() {
        UserDefaults.standard.set(true, forKey: "splash_shown")
    }
    
    func isSplashShown() -> Bool? {
        return UserDefaults.standard.bool(forKey: "splash_shown")
    }
    
    func saveNotificationToken(token: String) {
        UserDefaults.standard.set(token, forKey: "notification_token")
    }
    
    func getNotificationToken() -> String {
        return UserDefaults.standard.string(forKey: "notification_token") ?? ""
    }
    
    func savePinCodeApp(pinCode: String) {
        UserDefaults.standard.set(pinCode, forKey: "pin_code_app")
    }
    
    func getPinCodeApp() -> String {
        return UserDefaults.standard.string(forKey: "pin_code_app") ?? ""
    }
    
    func saveLanguage(languageCode: String) {
        UserDefaults.standard.setValue(languageCode, forKey: "language")
    }
    
    func getLanguageCode() -> String {
        return UserDefaults.standard.string(forKey: "language") ?? ""
    }
    
    func saveUser(accountUserDefaultsModel: AccountUserDefaultsModel){
        UserDefaults.standard.set(accountUserDefaultsModel.uuid, forKey: "user_uuid")
        UserDefaults.standard.set(accountUserDefaultsModel.username, forKey: "user_name")
        UserDefaults.standard.set(accountUserDefaultsModel.location, forKey: "user_location")
        UserDefaults.standard.set(accountUserDefaultsModel.address, forKey: "user_address")
        UserDefaults.standard.set(accountUserDefaultsModel.phone, forKey: "user_phone")
        UserDefaults.standard.set(accountUserDefaultsModel.token, forKey: "user_token")
    }
    
    func getUser() -> AccountUserDefaultsModel {
        return  AccountUserDefaultsModel(
            uuid: UserDefaults.standard.string(forKey: "user_uuid") ?? "",
            username: UserDefaults.standard.string(forKey: "user_name") ?? "",
            phone: UserDefaults.standard.string(forKey: "user_phone") ?? "",
            address: UserDefaults.standard.string(forKey: "user_address") ?? "",
            location: UserDefaults.standard.string(forKey: "user_location") ?? "",
            token: UserDefaults.standard.string(forKey: "user_token") ?? ""
        )
    }
    
    func clearUserDefaults(){
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }
    
}
