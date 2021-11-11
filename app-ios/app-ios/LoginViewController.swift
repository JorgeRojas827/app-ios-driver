
import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    @IBOutlet weak var nombreUsuario: UITextField!
    @IBOutlet weak var contrasenaTF: UITextField!
    
    @IBAction func login(_ sender: Any) {
        let email = nombreUsuario.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = contrasenaTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password){
            (result, err) in
            if err != nil {
                self.showError(_error: err!.localizedDescription)
            } else {
                let alertController = UIAlertController(title: "Login", message: "Inicio de sesion correctamente", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func showError(_error: String){
            let alertController = UIAlertController(title: "email o contraseña incorrecta", message: _error, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
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
}

extension LoginViewController {
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
            self.anchorBottomScroll.constant = -keyboardFrame.size.height
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
