//
//  SettingsVC.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 04.04.2023.
//

import UIKit
import EasyPeasy
import RxRelay
import RxSwift
import Localize_Swift

class SettingsVC: UIViewController {
    
    
    static let shared = SettingsVC()
    lazy var disposeBag = DisposeBag()
    var changeTheme: PublishRelay<Bool> = PublishRelay<Bool>.init()
    var data: [SettingsTableCellModel] = SettingsTableData().data
    static let changeLanguage: PublishSubject<Void> = PublishSubject<Void>.init()
    var tableHeader: SettingTableHeader!
    
    var mainView: SettingsView {
        return view as! SettingsView
    }
    
    override func loadView() {
        super.loadView()
        view = SettingsView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCallbacks()
        
        mainView.tableView.dataSource = self
        mainView.tableView.delegate = self
        mainView.tableView.allowsSelection = true
        
        SettingsVC.changeLanguage.subscribe { _ in
            self.langChanged()
        }.disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mainView.tableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: .none)
        mainView.tableView.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }
 
    
    func setupCallbacks(){
//        mainView.header.backBtnClickCallback = { [weak self] in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
//                self?.navigationController?.popViewController(animated: true)
//            }
//            print("backBtn")
//        }
    }
  
    func langChanged(){
        data = SettingsTableData().data
        mainView.tableView.reloadData()
        mainView.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
    }
    
}

extension SettingsVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableHeader == nil {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: SettingTableHeader.identifier) as! SettingTableHeader
            
            header.goProfileClickCallback = { [weak self] in
                print("goProfileClickCallback")
                let vc = UpdateProfileVC()
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            header.profileBtn.setupProfile(name: AccountUserDefaults.shared.getUser().username, phoneNumber: AccountUserDefaults.shared.getUser().phone)
            tableHeader = header
            
            return tableHeader
        }else{
            return tableHeader
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsTableCell.identifier, for: indexPath) as! SettingsTableCell
        
        switch indexPath.row {
        case 0:
            cell.setupImageAndLabel()
            cell.setupCellWithSwitch()
            cell.selectionStyle = .none
            let isNotificationOn = AccountUserDefaults.shared.isNotificationOff() == false
            cell.switchByCode.isOn = isNotificationOn
            
            cell.switchChangedCallback = { [weak self] isOn in
                print("Notification")
                if isOn {
                    
                    self!.addFCM(token: AccountUserDefaults.shared.getNotificationToken())
                }else{
                    
                    self!.deleteFCM()
                }
            }
        case 1:
            cell.setupImageAndLabel()
            cell.setupCellWithSwitch()
            cell.selectionStyle = .none
            
            let themeRaw = ThemeUserDefaults.shared.theme.rawValue
            var isDark: Bool = false
            if themeRaw == 0 { isDark = false } else { isDark = true }
            cell.switchByCode.isOn = isDark
            
            cell.switchChangedCallback = { [weak self] isOn in
                print("Dark Mode")
                var themeRaw: Int = 0
                if isOn == true { themeRaw = 1 } else { themeRaw = 0 }
                ThemeUserDefaults.shared.theme = Theme(rawValue: themeRaw) ?? .light
                if #available(iOS 13.0, *) {
                    UIWindow.key.overrideUserInterfaceStyle = ThemeUserDefaults.shared.theme.getUserInterfaceStyle()
                    SettingsVC.shared.changeTheme.accept((isOn))
                }
            }
        case 2:
            cell.setupImageAndLabel()
            cell.setupCellWithSwitch()
            cell.switchByCode.isOn = !AccountUserDefaults.shared.getPinCodeApp().isEmpty
            cell.selectionStyle = .none
            cell.switchChangedCallback = { [weak self] isOn in
                print("Pin Code")
                if cell.switchByCode.isOn {
                    let vc = EnterPinCodeVC()
                    vc.headerTitle = "first_code".localized()
                    self?.navigationController?.pushViewController(vc, animated: true)
                } else {
                    AccountUserDefaults.shared.savePinCodeApp(pinCode: "")
                }
            }
        case 3:
            cell.setupImageAndLabel()
            cell.setupCellForLanguage()
        case 4, 5, 6:
            cell.setupImageAndLabel()
            cell.setupCellWithRightIcon()
//        case 7:
//            cell.setupImageAndLabel()
        case 7:
            cell.setupImageAndLabel()
        case 8:
            cell.setupImageAndLabel()
            cell.icon.tintColor = .systemRed
            cell.nameLabel.textColor = .systemRed
        default:
            print("")
        }
        cell.setupCellData(data: data[indexPath.row])
//        if indexPath.row == 7 {
//            let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
//            cell.nameLabel.text = "v\(appVersion ?? "1.0") - Altyn Ýoda"
//        }
        if !data[indexPath.row].withSwitch {
            let bgColorView = UIView()
            bgColorView.backgroundColor = .hoverColor!
            cell.selectedBackgroundView = bgColorView
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !data[indexPath.row].withSwitch {
            tableView.deselectRow(at: indexPath, animated: true)
        }
        
        switch indexPath.row {
        case 2:
            print("")
            //                presentSafariVC(with: URL(string: "https://salam-ex.com/privacy-policy")!)
        case 3:
            print("adw")
            self.navigationController?.pushViewController(LanguageVC(), animated: true)
        case 4:
            let languageCode = AccountUserDefaults.shared.getLanguageCode()
            switch languageCode {
            case "en":
                presentSafariVC(with: URL(string: "https://altynyoda.com.tm/privacy-policy-en")!)
            case "ru":
                presentSafariVC(with: URL(string: "https://altynyoda.com.tm/privacy-policy-ru")!)
            case "tk":
                presentSafariVC(with: URL(string: "https://altynyoda.com.tm/privacy-policy-tm")!)
            default: print("")
            }
        case 5:
            let languageCode = AccountUserDefaults.shared.getLanguageCode()
            switch languageCode {
            case "en":
                presentSafariVC(with: URL(string: "https://altynyoda.com.tm/terms-of-use-en")!)
            case "ru":
                presentSafariVC(with: URL(string: "https://altynyoda.com.tm/terms-of-use-ru")!)
            case "tk":
                presentSafariVC(with: URL(string: "https://altynyoda.com.tm/terms-of-use-tm")!)
            default: print("")
            }
        case 6:
            let languageCode = AccountUserDefaults.shared.getLanguageCode()
            switch languageCode {
            case "en":
                presentSafariVC(with: URL(string: "https://altynyoda.com.tm/about-us-en")!)
            case "ru":
                presentSafariVC(with: URL(string: "https://altynyoda.com.tm/about-us-ru")!)
            case "tk":
                presentSafariVC(with: URL(string: "https://altynyoda.com.tm/about-us-tm")!)
            default: print("")
            }
        case 7:
            print("log out")
            showAlertToConformLogout()
        case 8:
            print("Delete Account")
            showAlertToConformDeleteAccount()
        default:
            print("default")
        }
        
    }
   
    func showAlertToConformDeleteAccount() {
        let alert = UIAlertController(title: "delete_account".localized(), message: "delete_account_desc".localized(), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "no".localized(), style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "yes".localized(), style: .default, handler: { action in
            self.deleteUserAccount()
           
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func showAlertToConformLogout() {
        let alert = UIAlertController(title: "logout".localized(), message: "logout_alert".localized(), preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "no".localized(), style: .destructive, handler: nil))
        alert.addAction(UIAlertAction(title: "yes".localized(), style: .default, handler: { action in
            
            let languageCode = AccountUserDefaults.shared.getLanguageCode()
            let themeRaw = ThemeUserDefaults.shared.theme.rawValue
            
            AccountUserDefaults.shared.clearUserDefaults()
            
            Localize.setCurrentLanguage(languageCode)
            ThemeUserDefaults.shared.theme = Theme(rawValue: themeRaw) ?? .light
            AccountUserDefaults.shared.saveLanguage(languageCode: languageCode)
            AccountUserDefaults.shared.splashShown()
            if let window = UIApplication.shared.windows.first {
                window.rootViewController = UINavigationController(rootViewController:  EnterPhoneNumberVC())
                window.makeKeyAndVisible()
                UIView.transition(with: window, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            } else {
                print("window = UIApplication.shared.windows.first")
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
}

extension SettingsVC {
    
    func addFCM(token: String) {
        AuthRequests.shared.addFcmToken(token: token).subscribe { res in
            if res.status == true {
                AccountUserDefaults.shared.notificationOn()
            }else{

            }

        } onFailure: { _ in

        }.disposed(by: disposeBag)
    }
    
    func deleteFCM(){
        
        AuthRequests.shared.deleteFcmToken().subscribe { res in
            if res.status == true {
                AccountUserDefaults.shared.notificationOff()
            }else{

            }

        } onFailure: { _ in

        }.disposed(by: disposeBag)
        

    }
    
    func deleteUserAccount() {
        AuthRequests.shared.deleteUserAccount().subscribe { res in
            if res.status == true {
                
                let languageCode = AccountUserDefaults.shared.getLanguageCode()
                let themeRaw = ThemeUserDefaults.shared.theme.rawValue
                AccountUserDefaults.shared.clearUserDefaults()
                Localize.setCurrentLanguage(languageCode)
                ThemeUserDefaults.shared.theme = Theme(rawValue: themeRaw) ?? .light
                AccountUserDefaults.shared.saveLanguage(languageCode: languageCode)
                AccountUserDefaults.shared.splashShown()
                if let window = UIApplication.shared.windows.first {
                    window.rootViewController = UINavigationController(rootViewController:  EnterPhoneNumberVC())
                    window.makeKeyAndVisible()
                    UIView.transition(with: window, duration: 0.4, options: .transitionFlipFromLeft, animations: nil, completion: nil)
                } else {
                    print("window = UIApplication.shared.windows.first")
                }
            }
            
        } onFailure: { _ in
            
        }.disposed(by: disposeBag)
    }
    
    
}
