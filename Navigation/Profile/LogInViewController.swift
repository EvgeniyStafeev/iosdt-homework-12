//
//  LoginViewController.swift
//  Navigation
//
//  Created by Евгений Стафеев on 15.11.2022.
//

import UIKit
import RealmSwift

class LogInViewController: UIViewController {
    var users: Results<Category>?
    let realmService = RealmService()
    let realm = try! Realm()
    var loginDelegate: LoginViewControllerDelegate?
    let userDefault = UserDefaults.standard
    private var timer: Timer?
    private let currentUserService = CurrentUserService()
    private let testUserService = TestUserService()
    private let brutForceService = BrutForceService()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private lazy var logoImageView: UIImageView = {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo")
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        return logoImageView
    }()
    
    private lazy var emailTextField: UITextField = {
        let emailTextField = UITextField()
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.indent(size: 10)
        emailTextField.placeholder = "Login"
        emailTextField.textColor = .black
        emailTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        emailTextField.autocapitalizationType = .none
        emailTextField.backgroundColor = .systemGray6
        emailTextField.delegate = self
        return emailTextField
    }()
    
    private lazy var passTextField: UITextField = {
        let passTextField = UITextField()
        passTextField.translatesAutoresizingMaskIntoConstraints = false
        passTextField.indent(size: 10)
        passTextField.placeholder = "Password"
        passTextField.isSecureTextEntry = true
        passTextField.textColor = .black
        passTextField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        passTextField.backgroundColor = .systemGray6
        passTextField.delegate = self
        return passTextField
    }()
    
    private lazy var verticalStack: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.spacing = 1
        verticalStack.distribution = .fillEqually
        verticalStack.layer.cornerRadius = 10
        verticalStack.clipsToBounds = true
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        return verticalStack
    }()
    private lazy var myButton: UIButton = {
        let myButton = UIButton()
        let colorButton = UIColor(patternImage: UIImage(named: "blue_pixel.png")!)
        myButton.backgroundColor = colorButton
        myButton.backgroundColor = .blue
        myButton.translatesAutoresizingMaskIntoConstraints = false
        myButton.setTitle("Log In", for: .normal)
        myButton.layer.cornerRadius = 10
        myButton.setTitleColor(UIColor.white, for: .normal)
        myButton.backgroundColor?.withAlphaComponent(1)
        
        if myButton.isSelected || myButton.isHighlighted || myButton.isEnabled == false {
            myButton.backgroundColor?.withAlphaComponent(0.8)
        }
        myButton.addTarget(self, action: #selector(actionButton), for: .touchUpInside)
        return myButton
    }()
    
    private lazy var getPassButton: CustomButton = {
        let getPassButton = CustomButton(title: "Подобрать пароль", titleColor: .white)
        getPassButton.clipsToBounds = true
        getPassButton.setBackgroundImage(#imageLiteral(resourceName: "blue_pixel"), for: .normal)
        getPassButton.layer.cornerRadius = 10
        return getPassButton
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        return activityIndicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupGestures()
        setupViews()
        stateMyButton(sender: myButton)
        actionButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
    }
    
    
    private func setupTimer(_ interval: Double, repeats: Bool) {
        timer = Timer.scheduledTimer(timeInterval: interval,
                                     target: self,
                                     selector: #selector(wakeUpAlertController),
                                     userInfo: nil,
                                     repeats: repeats)
    }
    
    @objc func wakeUpAlertController() {
        let title = "Забыли пароль?"
        let titleRange = (title as NSString).range(of: title)
        let titleAttribute = NSMutableAttributedString.init(string: title)
        titleAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: titleRange)
        titleAttribute.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "HelveticaNeue-Bold", size: 25)!, range: titleRange)
        
        let message = "Пароль можно подобрать, с вашего разрешения. Помочь?"
        let messageRange = (message as NSString).range(of: message)
        let messageAttribute = NSMutableAttributedString.init(string: message)
        messageAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: messageRange)
        messageAttribute.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "Helvetica", size: 17)!, range: messageRange)
        let alert = UIAlertController(title: "", message: "",  preferredStyle: .actionSheet)
        alert.setValue(titleAttribute, forKey: "attributedTitle")
        alert.setValue(messageAttribute, forKey: "attributedMessage")
        
        let okAction = UIAlertAction(title: "Да", style: .destructive) {_ in
            self.timer?.invalidate()
            self.getPassword()
            
        }
        let noAction = UIAlertAction(title: "Не надо", style: .cancel) { alertAction in
            self.timer?.invalidate()
        }
        alert.addAction(okAction)
        alert.addAction(noAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    private func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(logoImageView)
        verticalStack.addArrangedSubview(emailTextField)
        verticalStack.addArrangedSubview(passTextField)
        scrollView.addSubview(verticalStack)
        scrollView.addSubview(myButton)
        scrollView.addSubview(getPassButton)
        passTextField.addSubview(activityIndicator)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            logoImageView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 120),
            logoImageView.heightAnchor.constraint(equalToConstant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 120),
            logoImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            verticalStack.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 120),
            verticalStack.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 16),
            verticalStack.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            verticalStack.heightAnchor.constraint(equalToConstant: 100),
            myButton.topAnchor.constraint(equalTo: verticalStack.bottomAnchor,constant: 16),
            myButton.heightAnchor.constraint(equalToConstant: 50),
            myButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            myButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            getPassButton.topAnchor.constraint(equalTo: myButton.bottomAnchor, constant: 20),
            getPassButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            getPassButton.heightAnchor.constraint(equalToConstant: 50),
            getPassButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            getPassButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            activityIndicator.centerYAnchor.constraint(equalTo: passTextField.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: passTextField.centerXAnchor)
            
        ])
    }
    @objc func dissmiskeyboard() {
        view.endEditing(true)
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
    }
    private func getPassword() {
        self.passTextField.isSecureTextEntry = true
        self.passTextField.text = "qaz"
        let queue = DispatchQueue(label: "ru.IOSInt-homeworks.9", attributes: .concurrent)
        let workItem = DispatchWorkItem {
            self.brutForceService.bruteForce(passwordToUnlock: "qaz")
        }
        self.activityIndicator.startAnimating()
        queue.async(execute: workItem)
        workItem.notify(queue: .main) {
            self.passTextField.isSecureTextEntry = false
            self.activityIndicator.stopAnimating()
        }
    }
    
    @objc private func actionButton() {
        guard let login = self.emailTextField.text, let password = self.passTextField.text else { return
        }
        if !login.isEmpty, !password.isEmpty {
            let allCategory = self.realm.objects(Category.self)
            self.userDefault.setValue(login, forKey: "login")
            self.userDefault.setValue(password, forKey: "password")
            let newUser = NewUsers()
            newUser.login = login
            newUser.password = password
            self.realmService.addUser(categoryId: allCategory[0].id, user: newUser)
            print(allCategory)
            let profileVC = ProfileViewController()
            self.navigationController?.pushViewController(profileVC, animated: true)
        }else{
            print("Что то пошло не так")
        }
        getPassButton.action = {
            self.getPassword()
        }
    }
  
    
    private func setupGestures() {
        let tapDissmis = UITapGestureRecognizer(target: self, action: #selector(dissmiskeyboard))
        view.addGestureRecognizer(tapDissmis)
    }
    private func stateMyButton(sender: UIButton) {
        switch sender.state {
        case .normal:
            sender.alpha = 1.0
        case .selected:
            sender.alpha = 0.8
        case .highlighted:
            sender.alpha = 0.8
        default:
            sender.alpha = 1.0
        }
    }
}
extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

