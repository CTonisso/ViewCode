//
//  LoginController.swift
//  gameofchats
//
//  Created by Brian Voong on 6/24/16.
//  Copyright © 2016 letsbuildthatapp. All rights reserved.
//

import UIKit
import Firebase

class LoginController: ACViewController {

    var messagesController: MessagesController?
    
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate

    let inputsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()

    lazy var loginRegisterButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 80, green: 101, blue: 161)
        button.setTitle("Register", for: UIControl.State())
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(UIColor.white, for: UIControl.State())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return button
    }()

    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleNewUser()
        }
    }

    func handleNewUser() {
        guard let name = nameTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }

        Auth.auth().createUser(withEmail: email, password: password) { (_, error) in
            if error == nil {
                print("You have successfully signed up")
                let userID = Auth.auth().currentUser?.uid ?? ""
                let values = ["userID": userID,
                              "email": email,
                              "name": name]
                self.registerUserIntoDatabaseWithUID(userID, values: values as [String: AnyObject])
                self.appDelegate?.window = UIWindow(frame: UIScreen.main.bounds)
                UIView.transition(with: (self.appDelegate?.window)!,
                                  duration: 0.3,
                                  options: .curveEaseIn,
                                  animations: {
                                    let recordViewController = UIStoryboard(name: "RecordDescription", bundle: nil)
                                        .instantiateViewController(withIdentifier: "RecordDescription")
                                        as? RecordDescriptionViewController
                                    self.appDelegate?.window?.rootViewController = recordViewController
                                    self.appDelegate?.window?.makeKeyAndVisible()
                })
                self.dismiss(animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Error",
                                                        message: error?.localizedDescription,
                                                        preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }

    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Form is not valid")
            return
        }
        
        UserServices().logIn(email: email, password: password) { (uid, _) in
            if uid != nil {
                UserServices().fetchUser(withUserID: uid!, completionHandler: { (user) in
                    if let descriptionID = user.descriptionID, !descriptionID.isEmpty {
                        self.appDelegate?.window = UIWindow(frame: UIScreen.main.bounds)
                        UIView.transition(with: (self.appDelegate?.window)!,
                                          duration: 0.3,
                                          options: .curveEaseIn,
                                          animations: {
                            self.appDelegate?.window?.rootViewController = self.appDelegate?.initialTabBarController()
                            self.appDelegate?.window?.makeKeyAndVisible()
                        })
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        self.appDelegate?.window = UIWindow(frame: UIScreen.main.bounds)
                        UIView.transition(with: (self.appDelegate?.window)!,
                                          duration: 0.3,
                                          options: .curveEaseIn,
                                          animations: {
                                            let recordViewController = UIStoryboard(name: "RecordDescription",
                                                                                    bundle: nil)
                                                .instantiateViewController(withIdentifier: "RecordDescription")
                                                as? RecordDescriptionViewController
                                            self.appDelegate?.window?.rootViewController = recordViewController
                                            self.appDelegate?.window?.makeKeyAndVisible()
                        })
                        self.dismiss(animated: true, completion: nil)
                    }
                })

            } else {
                // TODO: user not logged
                print("TODO: user not logged")
            }
        }
        
//        self.messagesController?.fetchUserAndSetupNavBarTitle()
//        self.dismiss(animated: true, completion: nil)
    }

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let nameSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    let emailSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 220, green: 220, blue: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.isSecureTextEntry = true
        return textField
    }()

    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "gameofthrones_splash")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill

        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                              action: #selector(handleSelectProfileImageView)))
//        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Login", "Register"])
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.tintColor = UIColor.white
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return segmentedControl
    }()

    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at:
            loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControl.State())

        // change height of inputContainerView, but how???
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150

        // change height of nameTextField
        nameTextFieldHeightAnchor?.isActive = false
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(
            equalTo: inputsContainerView.heightAnchor,
            multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3))
        nameTextFieldHeightAnchor?.isActive = true
        nameTextField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0

        emailTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor = emailTextField.heightAnchor.constraint(
            equalTo: inputsContainerView.heightAnchor,
            multiplier: (loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3))
        emailTextFieldHeightAnchor?.isActive = true

        passwordTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor = passwordTextField.heightAnchor.constraint(
            equalTo: inputsContainerView.heightAnchor,
            multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor(red: 61, green: 91, blue: 151)

        view.addSubview(inputsContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)

        setupInputsContainerView()
        setupLoginRegisterButton()
        setupProfileImageView()
        setupLoginRegisterSegmentedControl()
    }

    func setupLoginRegisterSegmentedControl() {
        //need x, y, width, height constraints
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsContainerView.topAnchor,
                                                              constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor,
                                                             multiplier: 1).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }

    func setupProfileImageView() {
        //need x, y, width, height constraints
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor,
                                                 constant: -12).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }

    var inputsContainerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?

    func setupInputsContainerView() {
        //need x, y, width, height constraints
        inputsContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputsContainerViewHeightAnchor = inputsContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true

        inputsContainerView.addSubview(nameTextField)
        inputsContainerView.addSubview(nameSeparatorView)
        inputsContainerView.addSubview(emailTextField)
        inputsContainerView.addSubview(emailSeparatorView)
        inputsContainerView.addSubview(passwordTextField)

        //need x, y, width, height constraints
        nameTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsContainerView.topAnchor).isActive = true

        nameTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameTextFieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsContainerView.heightAnchor,
                                                                          multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true

        //need x, y, width, height constraints
        nameSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        //need x, y, width, height constraints
        emailTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true

        emailTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true

        emailTextFieldHeightAnchor = emailTextField
            .heightAnchor
            .constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)

        emailTextFieldHeightAnchor?.isActive = true

        //need x, y, width, height constraints
        emailSeparatorView.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        //need x, y, width, height constraints
        passwordTextField.leftAnchor.constraint(equalTo: inputsContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true

        passwordTextField.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        passwordTextFieldHeightAnchor = passwordTextField
            .heightAnchor
            .constraint(equalTo: inputsContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }

    func setupLoginRegisterButton() {
        //need x, y, width, height constraints
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsContainerView.bottomAnchor,
                                                 constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsContainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UIColor {
    convenience init(red: CGFloat, green: CGFloat, blue: CGFloat) {
        self.init(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
