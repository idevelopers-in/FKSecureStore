//
//  ViewController.swift
//  FKSecureStoreExample
//
//  Created by Firoz Khan on 27/01/22.
//

import UIKit

let keychainDataKey = "userData"

class ViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var infoTextView: UITextView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        clearFields()
    }
    
    @IBAction func saveTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text, username.count > 0 else { return }
        guard let password = passwordTextField.text, password.count > 0 else { return }
        
        let user = User(username: username, password: password)
        
        do {
            let data = try NSKeyedArchiver.archivedData(withRootObject: user, requiringSecureCoding: false)
            
            switch FKSecureStore.save(data: data, key: keychainDataKey) {
                    
                case .success:
                    showAlert(message: "Credentials saved to keychain successfully")
                    clearFields()
                    break
                    
                default:
                    showAlert(message: "Unable to store credentials in keychain")
                    break
            }
        }
        catch {
            let message = "Unable to archive user: \(error.localizedDescription)"
            showAlert(title: "Error", message: message)
        }
    }
    
    @IBAction func loadTapped(_ sender: Any) {
        
        guard let data = FKSecureStore.load(dataForKey: keychainDataKey) else {
            
            showAlert(title: "Oops", message: "No saved credentials present in keychain")
            return
        }
        
        do {
            // https://developer.apple.com/forums/thread/683077
            guard let user = try NSKeyedUnarchiver.unarchivedObject(ofClasses: [User.self, NSString.self], from: data) as? User else {
                showAlert(title: "Error", message: "Unable to unarchive saved data into User")
                return
            }
            
            let infoString = "Username: \(user.username)\nPassword: \(user.password)"
            infoTextView.text = infoString
        }
        catch {
            let message = "Unable to unarchive user: \(error.localizedDescription)"
            showAlert(title: "Error", message: message)
        }
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        
        switch FKSecureStore.delete(key: keychainDataKey) {
                
            case .success:
                showAlert(message: "Data deleted from keychain successfully")
                clearFields()
                break
                
            case .noData:
                showAlert(message: "No data to delete in keychain")
                break
                
            case .other:
                showAlert(title: "Error", message: "Unable to delete data in keychain")
                break
        }
    }
    
    @IBAction func clearTapped(_ sender: Any) {
        
        switch FKSecureStore.clear() {
                
            case .success:
                showAlert(message: "Data cleared from keychain successfully")
                clearFields()
                break
                
            case .noData:
                showAlert(message: "No data to delete in keychain")
                break
                
            case .other:
                showAlert(title: "Error", message: "Unable to clear data in keychain")
                break
        }
    }
}

extension ViewController {
    
    private func showAlert(title: String? = "Success", message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func clearFields() {
        
        usernameTextField.text = nil
        passwordTextField.text = nil
        infoTextView.text = nil
    }
}
