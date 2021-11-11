
import UIKit
import Firebase
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var NameTF: UITextField!
    @IBOutlet weak var LastTF: UITextField!
    @IBOutlet weak var PasswordTF: UITextField!
    @IBOutlet weak var EmailTF: UITextField!
    @IBOutlet weak var PhoneTF: UITextField!
    
    @IBAction func RegisterUser(_ sender: Any) {
        
        let error = validarFormulario()
        
        if error != nil {
            self.error(_error: error!)
        } else {
            let name = NameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let apellido = LastTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = PasswordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = EmailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let telefono = PhoneTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                                
                            // Check for error
                            if err != nil{
                                
                                // There was an error creating the user
                                self.error(_error: err!.localizedDescription)
                            }else{
             
                                let db = Firestore.firestore()
                     
                                db.collection("drivers").addDocument(data: [
                                        "nombre" : name,
                                        "apellido" : apellido,
                                        "email" : email,
                                        "contrasena" : password,
                                    "telefono": telefono,
                                        "uid": result!.user.uid
                                ]) { (error) in
                                    
                                    if error != nil{
                                        
                                        self.error(_error: "Sucedio un error.")
                                    }
                                }
                                self.navigationController?.popToRootViewController(animated: true)
                            }
                        }
        }
    }
    @IBOutlet weak var anchorBottomScroll: NSLayoutConstraint!
    
    func error(_error: String) {
            let alertController = UIAlertController(title: "Register error", message: _error, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(alertController, animated: true, completion: nil)
        }

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
    
    func validarFormulario() -> String? {
         
            if NameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || LastTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            || EmailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
                || PasswordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
            {

                return "Debe rellenar todos los campos"
            }

            return nil
        }
}

extension RegisterViewController {
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
