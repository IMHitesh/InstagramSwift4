//
//  Validator.swift
//  Created by Sandip Patel (SM) on 19/06/18.
//  Copyright © 2018 BV. All rights reserved.
//

import Foundation
import UIKit

enum ValidationType:String{
    case Email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case PasswordLogin = "^[a-zA-Z0-9@]{8,16}$"
    case Password = "(^(?=.*?[A-Z])(?=.*?[a-z]))((?=.*?[0-9])|(?=.*?[#?!@$%^&*-])).{6,}$"//"(^(?=.*?[A-Z])(?=.*?[a-z]))((?=.*?[0-9])|(?=.*?[#?!@$%^&*-])).{6,}$"
    case UserName = "[A-Za-z0-9_ ]{2,20}"
    case CompanyName = "^.{6,50}$"
    case MobileNumber = "^[0-9]{10,15}"
    case Url = "(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+"
    case DecimalNumber = "^([0-9]+)?(\\.([0-9]+)?)?$"
    case DecimalNumberWithComma = "^([0-9, ]+)?(\\.([0-9, ]+)?)?$"
    case Blank
}

extension UIView {
    
    func ValidateAllTextField() -> Bool{
        let aryAllTextField:[ACFloatingTextfield] = self.allSubViewsOf(type:ACFloatingTextfield.self)
        for txtField in aryAllTextField {
            if !txtField.isValidate(){
                return false
            }
        }
        return true
    }
    
    fileprivate func allSubViewsOf<T : UIView>(type : T.Type) -> [T]{
        var all = [T]()
        func getSubview(view: UIView) {
            if let aView = view as? T{
                all.append(aView)
            }
            guard view.subviews.count>0 else { return }
            view.subviews.forEach{ getSubview(view: $0) }
        }
        getSubview(view: self)
        return all
    }
}

extension String {
    var isNumeric: Bool {
        guard self.characters.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self.characters).isSubset(of: nums)
    }
}

extension ACFloatingTextfield{
    
    func setValidation(Type:ValidationType,fieldName:String){
        
        validation.append(Type)
        
        if Type == .Blank{
            validationErrorMessage.append("Please enter \(fieldName).")
        }else{
            validationErrorMessage.append("Please enter valid \(fieldName).")
        }
    }
    
    func setValidation(Type:ValidationType,message:String){
        validation.append(Type)
        validationErrorMessage.append(message)
    }
    
    func setValidation(Type:ValidationType){
        validation.append(Type)
        
        if Type == .Blank{
            validationErrorMessage.append("Please enter \(self.placeholder?.lowercased() ?? "value")")
        }else{
            validationErrorMessage.append("Please enter valid \(self.placeholder?.lowercased() ?? "value")")
        }
    }
    
    func isValidate() -> Bool {
        
        var aryAllValidationStatus = [Bool]()
        
        var currentIndex = 0
            for type in validation{
                
                var isValid = false
                if type == .Blank{
                    isValid = isBlank()
                }else if type == .MobileNumber{
                    if (self.text?.count)! >= 10 && (self.text?.count)! <= 19{
                        isValid = true
                    }else{
                        isValid = false
                    }
                }else{
                    
                    isValid = isValidValue(regEX: type.rawValue)
                }
                
                if isValid {
                    aryAllValidationStatus.append(true)
                }else{
                    //SMP: Validation
                    //Alert.showAlert(title:"Validation Failed", message:validationErrorMessage[currentIndex])

                    self.showErrorWithText(errorText: validationErrorMessage[currentIndex])
                    self.shake()
                APPLICATION.appDelegate.window?.rootViewController?.view.makeToast(validationErrorMessage[currentIndex], duration: 3.0, position: .bottom)
                    break
                }
                currentIndex = currentIndex + 1
            }
        
        if validation.count == aryAllValidationStatus.count {
            return true
        }else{
            return false
        }
    }
    
    func removeAllValidation() {
        validation.removeAll()
        validationErrorMessage.removeAll()
    }
    
    fileprivate func isValidValue(regEX:String)->Bool{
        let emailTest = NSPredicate(format:"SELF MATCHES %@", regEX)
        return emailTest.evaluate(with: self.text)
    }
    

    fileprivate func isBlank()->Bool{
        return !(self.text?.isEmpty)!
    }
    
}

private var kAssociationKeyMaxLength: Int = 0

extension UITextField {
    
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
            addTarget(self, action: #selector(checkMaxLength), for: .editingChanged)
        }
    }
    
    @objc func checkMaxLength(textField: UITextField) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}

extension UITextView:UITextViewDelegate {
    
    
    @IBInspectable var maxLength: Int {
        get {
            if let length = objc_getAssociatedObject(self, &kAssociationKeyMaxLength) as? Int {
                return length
            } else {
                return Int.max
            }
        }
        set {
            self.delegate = self

            objc_setAssociatedObject(self, &kAssociationKeyMaxLength, newValue, .OBJC_ASSOCIATION_RETAIN)
        }
    }
    
    public func textViewDidChange(_ textView: UITextView) {
        checkMaxLength(textField: self)
    }
    @objc func checkMaxLength(textField: UITextView) {
        guard let prospectiveText = self.text,
            prospectiveText.count > maxLength
            else {
                return
        }
        
        let selection = selectedTextRange
        
        let indexEndOfText = prospectiveText.index(prospectiveText.startIndex, offsetBy: maxLength)
        let substring = prospectiveText[..<indexEndOfText]
        text = String(substring)
        
        selectedTextRange = selection
    }
}
