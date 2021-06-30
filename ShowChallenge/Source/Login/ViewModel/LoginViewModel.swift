//
//  LoginViewModel.swift
//  ShowChallenge
//
//  Created by Diler Barbosa on 29/06/21.
//

import Foundation
import LocalAuthentication

enum PINState {
    case noPin
    case pinStored
}

protocol LoginViewModelDelegate: AnyObject {
    func didGetPINStaste(state: PINState)
    func didAuthenticateWithPIN()
    func didFailToAuthenticateWithPIN()
}

class LoginViewModel {
    
    let keychainPinKey = "app-pin"
    let kcService = "authentication"
    let kcAccount = "com.tvShow.diler.app"
    
    weak var delegate: LoginViewModelDelegate?
    
    var currentPINState: PINState! {
        didSet {
            delegate?.didGetPINStaste(state: currentPINState)
        }
    }
    
    func checkAuthenticationState() -> Data? {
        do {
            let password = try KeyChain.readPassword(service: kcService, account: kcAccount)
            
            currentPINState = .pinStored
            
            return password
            
        } catch {
            currentPINState = .noPin
            print("Error when reading keychain")
            return nil
        }
    }
    
    func saveNewPIN(pin: String) {
        do {
            try KeyChain.save(password: Data(pin.utf8), service: kcService, account: kcAccount)
        } catch {
            print("error when trying to save to keychain")
        }
    }
    
    func resetPin() {
        do {
            try KeyChain.deletePassword(service: kcService, account: kcAccount)
            _ = checkAuthenticationState()
        } catch {
            print("error when trying to delete the PIN from keychain")
        }
    }
    
    func validatePin(pin: String) {
        
        if pin.count >= 4 {
            switch currentPINState {
            case .noPin:
                saveNewPIN(pin: pin)
                delegate?.didAuthenticateWithPIN()
            case .pinStored:
                if let storedPin = checkAuthenticationState() {
                    if storedPin == Data(pin.utf8) {
                        delegate?.didAuthenticateWithPIN()
                    } else {
                        delegate?.didFailToAuthenticateWithPIN()
                    }
                }
            case .none:
                return
            }
        }
    }
    
    func canUseAuthenticationWithBiometrics() -> Bool {
        let context = LAContext()
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return true
        } else {
            return false
        }
    }
    
    func offerAuthenticationWithBiometrics() {
        let context = LAContext()

        let reason = "Would you like to use Authentication with biometrics?"
        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) {
            [weak self] success, authenticationError in

            DispatchQueue.main.async {
                if success {
                    self?.delegate?.didAuthenticateWithPIN()
                } else {
                    print("Something went wrong!")
                }
            }
        }
    }
    
}
