//
//  LanguageVC.swift
//  SalamExpress
//
//  Created by Aziz's MacBook Air on 17.03.2023.
//

import UIKit
import EasyPeasy
import Localize_Swift

class LanguageVC: UIViewController {
    
    lazy var selectedInd = IndexPath(row: 0, section: 0)

    lazy var languagesShortNames = ["en", "ru", "tk",]
    lazy var languagesLongNames = ["English", "Русский", "Türkmençe"]
      
    lazy var tableView: UITableView = {
        var tb = UITableView()
        tb.register(LanguageCell.self, forCellReuseIdentifier: "languageCell")
        tb.separatorStyle = .none
        tb.backgroundColor = .whiteBlackColor
        return tb
    }()
    
    lazy var header = HeaderWithBackBtn(title: "languages".localized())
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavbar()

        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(header)
        header.easy.layout([
            Leading(), Trailing(), Top().to(view.safeAreaLayoutGuide, .top), Height(44)
        ])
        
        self.view.addSubview(tableView)
        tableView.easy.layout([
            Leading(), Trailing(), Top().to(header, .bottom), Bottom()
        ])
        
        header.backBtnClickCallback = { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        let currentLangCode = AccountUserDefaults.shared.getLanguageCode()
        let ind = languagesShortNames.firstIndex(of: currentLangCode) ?? 0
        selectedInd = IndexPath(row: ind, section: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavbar()
    }
    
    func setupNavbar() {
//        header.backgroundColor = .white
        self.view.backgroundColor = .whiteBlackColor
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.isHidden = true
    }
}


extension LanguageVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languagesLongNames.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldSelection = selectedInd
        selectedInd = indexPath
        tableView.reloadRows(at: [ oldSelection, selectedInd ], with: .none)
        AccountUserDefaults.shared.saveLanguage(languageCode: languagesShortNames[indexPath.row])
        Localize.setCurrentLanguage( languagesShortNames[indexPath.row])
        
        SettingsVC.changeLanguage.onNext(())
        MainChildTabBarController.changeLanguage.onNext(())
        navigationController?.popViewController(animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCell", for: indexPath) as! LanguageCell
        cell.configureCellWithRadioBtn(name: languagesLongNames[indexPath.row], isSelected: selectedInd == indexPath)
        return cell
    }
}


