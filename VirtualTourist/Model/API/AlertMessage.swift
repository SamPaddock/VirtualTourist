//
//  AlertMessage.swift
//  VirtualTourist
//
//  Created by Sarah Al-Matawah on 30/08/2020.
//  Copyright © 2020 Sarah Al-Matawah. All rights reserved.
//

import Foundation
import UIKit

class AlertMessage{
    
    //MARK: Error title case
    
    enum alertTitle {
        case defaultTitle
        case success
        case loadingFailed
        case loadingPhoto
        case network
        case photo
        case emptyContent
        case decodeFailed
        
        var titleStringValue: String {
            switch self {
            case .defaultTitle: return "An Unknow Issue occured"
            case .success: return "Success!!"
            case .loadingFailed: return "Loading Issue"
            case .loadingPhoto: return "Photo Loading Issues"
            case .network: return "Network Issues"
            case .photo: return "No Photos Found"
            case .emptyContent: return "No content avaliable"
            case .decodeFailed: return "Failed reading data"
            }
        }
        
        var title: String {return titleStringValue}
    }
    
    //MARK: Error message case
    
    enum alertMessage {
        case defaultMessage
        case success
        case loadingFailed
        case loadingPhoto
        case network
        case photo
        case emptyContent
        case decodeFailed
        
        var messageStringValue: String {
            switch self {
            case .defaultMessage: return "Contact Developer to review issue and correct it"
            case .success: return "Action completed successfully without any issues"
            case .loadingFailed: return "An error occured will attepmting to load the data"
            case .loadingPhoto: return "An error occured will attepmting to load the photo from the server"
            case .network: return "There is a network connectivity issue. Please check you are connects to a network. If issue persists, try again later"
            case .photo: return "There are no photos avliable for the selected location"
            case .emptyContent: return "Unable to find content for the selected location"
            case .decodeFailed: return "Failed in reading data from flickr. Please contact Developer to correct error"
            }
        }
        
        var message: String {return messageStringValue}
    }
    
    //Create Error message
    
    class func showAlertMessage(title: String, message: String) -> UIAlertController{
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertVC
    }
        
    //Switch function for error message to appear
    
    class func errorAlert(Code error: Int) -> UIAlertController{
        switch error{
        case ErrorCode.success: return successAlertMessage()
        case ErrorCode.networkFailure: return networkFailureAlertMessage()
            case ErrorCode.loadingFailure: return loadingFailureAlertMessage()
            case ErrorCode.loadingPhoto: return loadingPhotoAlertMessage()
            case ErrorCode.emptyContent: return emptyContentAlertMessage()
            case ErrorCode.decodeFailure: return decodeFailureAlertMessage()
        default:
            return defaultAlertMessage()
        }
    }
    
    //Success Message
    
    class func successAlertMessage() -> UIAlertController{
        let title = AlertMessage.alertTitle.success.title
        let message = AlertMessage.alertMessage.success.message
        return creatAlertMessage(title: title, message: message)
    }
    
    //Network Failure Message
    
    class func networkFailureAlertMessage() -> UIAlertController{
        let title = AlertMessage.alertTitle.network.title
        let message = AlertMessage.alertMessage.network.message
        return creatAlertMessage(title: title, message: message)
    }
    
    //loading Failure Error Message
    
    class func loadingFailureAlertMessage() -> UIAlertController{
        let title = AlertMessage.alertTitle.loadingFailed.title
        let message = AlertMessage.alertMessage.loadingFailed.message
        return creatAlertMessage(title: title, message: message)
    }
    
    //Photo loading Error Message
    
    class func loadingPhotoAlertMessage() -> UIAlertController{
        let title = AlertMessage.alertTitle.loadingPhoto.title
        let message = AlertMessage.alertMessage.loadingPhoto.message
        return creatAlertMessage(title: title, message: message)
    }
    
    //Empty Content Error Message
    
    class func emptyContentAlertMessage() -> UIAlertController{
        let title = AlertMessage.alertTitle.emptyContent.title
        let message = AlertMessage.alertMessage.emptyContent.message
        return creatAlertMessage(title: title, message: message)
    }
    
    //Decode Failure Error Message
    
    class func decodeFailureAlertMessage() -> UIAlertController{
        let title = AlertMessage.alertTitle.decodeFailed.title
        let message = AlertMessage.alertMessage.decodeFailed.message
        return creatAlertMessage(title: title, message: message)
    }
    
    //Default Error Message
    
    class func defaultAlertMessage() -> UIAlertController{
        let title = AlertMessage.alertTitle.defaultTitle.title
        let message = AlertMessage.alertMessage.defaultMessage.message
        return creatAlertMessage(title: title, message: message)
    }
    
    //Default message creation
    
    class func creatAlertMessage(title: String, message: String) -> UIAlertController{
        let alert = AlertMessage.showAlertMessage(title: title, message: message)
        return alert
    }
    
}
