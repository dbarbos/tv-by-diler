//
//  LoginViewController.swift
//  Challenge
//
//  Created by Diler Barbosa on 25/06/21.
//

import UIKit

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var actionTitleLabel: UILabel!
    @IBOutlet weak var actionDescriptionLabel: UILabel!
    
    @IBOutlet weak var pinTextField: UITextField!
    
    let viewModel = LoginViewModel()
    
    var didCallEvent: ((LoginViewController.Event) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        viewModel.delegate = self
        
        pinTextField.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        _ = viewModel.checkAuthenticationState()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if viewModel.currentPINState == PINState.pinStored && viewModel.canUseAuthenticationWithBiometrics() {
            viewModel.offerAuthenticationWithBiometrics()
        }
        
    }
    
    deinit {
        print("LoginViewController deinited properly")
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        didCallEvent?(.authenticate)
    }
    
    func showWrongPinAlert() {
        let alert = UIAlertController(title: "Wrong PIN", message: "Would you like to reset the keychain and create a new PIN?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.viewModel.resetPin()
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))

        self.present(alert, animated: true)
    }
    
}

extension LoginViewController {
    enum Event {
        case authenticate
    }
}

extension LoginViewController: LoginViewModelDelegate {
    func didGetPINStaste(state: PINState) {
        switch state {
        case .noPin:
            actionTitleLabel.text = "Create PIN"
            actionDescriptionLabel.text = "Create a 4 digit access PIN to keep your access private."
        case .pinStored:
            actionTitleLabel.text = "Enter PIN"
            actionDescriptionLabel.text = "You have created a 4 digit access PIN to keep your access private. Type it in to continue."
        }
    }
    
    func didAuthenticateWithPIN() {
        didCallEvent?(.authenticate)
    }
    
    func didFailToAuthenticateWithPIN() {
        showWrongPinAlert()
    }
}

extension LoginViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        guard let _ = string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) else { return false }
        
        let currentText = textField.text ?? ""
        
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        if updatedText.count >= 4 {
            viewModel.validatePin(pin: updatedText)
            textField.text = ""
        }
        
        return updatedText.count <= 4
        
    }

}
