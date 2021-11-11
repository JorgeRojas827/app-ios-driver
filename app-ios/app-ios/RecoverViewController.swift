
import UIKit
import FirebaseAuth

class RecoverViewController: UIViewController {
    @IBOutlet weak var usuarioTF: UITextField!

    
    @IBAction func recoverPass(_ sender: Any) {
        let email = usuarioTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().sendPasswordReset(withEmail: email) {
            err in
            if err != nil {
                // There was an error
                self.showError(_error: err!.localizedDescription, title: "Hubo un error")
            } else{
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBOutlet weak var anchorBottomScroll: NSLayoutConstraint!

    override func viewDidLoad() {
        //Este se ejecuta una unica vez, es como el oncreate del controller
        super.viewDidLoad()
    }

    //Se ejecutan por varias veces
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.registrerKeyboardEvents()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unregisterKeyboardEvents()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }

    @IBAction private func tapToCloseKeyboard(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    func showError(_error: String, title: String) {
            let alertController = UIAlertController(title: title, message: _error, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }
}

extension RecoverViewController {
    private func registrerKeyboardEvents() {

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func unregisterKeyboardEvents() {

        NotificationCenter.default.removeObserver(self)
    }

    @objc func keyboardWillShow(_ notification: Notification) {

        let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect ?? .zero
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0

        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomScroll.constant = keyboardFrame.size.height
            self.view.layoutIfNeeded()
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {

        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0

        UIView.animate(withDuration: animationDuration) {
            self.anchorBottomScroll.constant = 0
            self.view.layoutIfNeeded()
        }
    }
}
