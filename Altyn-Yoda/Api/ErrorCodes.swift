//
//  ErrorCodes.swift
//  Altyn-Yoda
//
//  Created by Aziz's MacBook Air on 10.04.2023.
//

import Foundation

import Foundation
import Localize_Swift

class ErrorCodes {
    
    static let shared = ErrorCodes()
    
    let missingParam           = "SE-00001"
    let notFound               = "SE-00003"
    let internalServer         = "SE-00004"
    let countryNotFound        = "SE-00005"
    let sendingSmsLimitFull    = "SE-00006"
    let notAcceptable          = "SE-00007"
    let checkPasswordLimitFull = "SE-00008"
    let userBlocked            = "SE-00009"
    let badRequest             = "SE-00010"
    let oldVersion             = "SE-00011"
    let bigFile                = "SE-00012"
    let nicknameError          = "SE-00013"
    let nicknameValidationError = "SE-00014"
    let phoneNumberUsed        = "SE-00015"
    let postLimitFull          = "SE-00016"

    let noFilmQuality = "L-00001"
    
    
    func showErrorMessage(errorCode: String?) {
        switch errorCode{
        case self.missingParam:
            PopUpLancher.showErrorMessage(text: "missing_param".localized())

        case self.notFound:
            break
//            PopUpLancher.showErrorMessage(text: "not_found".localized())

        case self.internalServer:
            break
//            PopUpLancher.showErrorMessage(text: "ineternal_server".localized())

        case self.countryNotFound:
            PopUpLancher.showErrorMessage(text: "country_not_found".localized())

        case self.sendingSmsLimitFull:
            PopUpLancher.showErrorMessage(text: "send_sms_limit_full".localized())

        case self.notAcceptable:
            PopUpLancher.showErrorMessage(text: "not_acceptable".localized())

        case self.checkPasswordLimitFull:
            PopUpLancher.showErrorMessage(text: "check_password_limit".localized())

        case self.userBlocked:
            PopUpLancher.showErrorMessage(text: "user_blocked".localized())

        case self.bigFile:
            PopUpLancher.showErrorMessage(text: "file_too_large".localized())

        case self.badRequest:
            PopUpLancher.showErrorMessage(text: "smth_went_wrong".localized())

        case self.oldVersion:
            PopUpLancher.showErrorMessage(text: "download_the_update".localized())

        case self.nicknameError:
            PopUpLancher.showErrorMessage(text: "nickname_exists".localized())

        case self.nicknameValidationError:
            PopUpLancher.showErrorMessage(text: "not_valid_nickname".localized())
        
        case self.phoneNumberUsed:
            PopUpLancher.showErrorMessage(text: "phone_number_has_been_used".localized())

        case self.postLimitFull:
            PopUpLancher.showErrorMessage(text: "post_limit_full".localized())

        case self.noFilmQuality:
            PopUpLancher.showSuccessMessage(text: "no_quality".localized())

        default:
            PopUpLancher.showErrorMessage(text: "error_occured".localized())
        }
    }
    
}
