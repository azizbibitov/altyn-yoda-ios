//
//  SettingsTableData.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 05.04.2023.
//

import Foundation

struct SettingsTableCellModel {
    var image: String
    var title: String
    var forLanguage: Bool
    var withSwitch: Bool
    var forLogout: Bool
}

struct SettingsTableData {
    
    var data: [SettingsTableCellModel] = [
        SettingsTableCellModel(image: "notification", title: "notification".localized(), forLanguage: false, withSwitch: true, forLogout: false),
        SettingsTableCellModel(image: "moon", title: "dark_mode".localized(), forLanguage: false, withSwitch: true, forLogout: false),
        SettingsTableCellModel(image: "lock", title: "pin_code".localized(), forLanguage: false, withSwitch: true, forLogout: false),
        SettingsTableCellModel(image: "language-circle", title: "language".localized(), forLanguage: true, withSwitch: false, forLogout: false),
        SettingsTableCellModel(image: "shield-security", title: "confidentiality".localized(), forLanguage: false, withSwitch: false, forLogout: false),
        SettingsTableCellModel(image: "terms-of-use", title: "terms_of_use_inf".localized(), forLanguage: false, withSwitch: false, forLogout: false),
        SettingsTableCellModel(image: "error", title: "about_us".localized(), forLanguage: false, withSwitch: false, forLogout: false),
//        SettingsTableCellModel(image: "verified_user", title: "v1.0 - Altyn Ýoda", forLanguage: false, withSwitch: false, forLogout: false),
        SettingsTableCellModel(image: "logout", title: "log_out".localized(), forLanguage: false, withSwitch: false, forLogout: true),
        SettingsTableCellModel(image: "user-remove", title: "delete_account".localized(), forLanguage: false, withSwitch: false, forLogout: true),
    ]
}

