//
//  LoginViewController.swift
//  RxLectureExample
//
//  Created by David Yoon on 2022/03/31.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift
import Lottie

final class LoginViewController: UIViewController {
    private let disposeBag = DisposeBag()
    
    private let idValidSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    private let pwValidSubject: BehaviorSubject<Bool> = BehaviorSubject(value: false)
    
    private let idInputTextSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    private let pwInputTextSubject: BehaviorSubject<String> = BehaviorSubject(value: "")
    
    // Lottie
    private lazy var lottieView: AnimationView = {
        let view = AnimationView(name: "stocks")
        view.loopMode = .loop
        return view
    }()
    
    private lazy var idTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = "아이디를 입력하세요."
        textField.font = .systemFont(ofSize: 16.0, weight: .light)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 12
        return textField
    }()
    
    private lazy var pwTextField: PaddingTextField = {
        let textField = PaddingTextField()
        textField.placeholder = "비밀번호를 입력하세요"
        textField.font = .systemFont(ofSize: 16.0, weight: .light)
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.gray.cgColor
        textField.layer.cornerRadius = 12
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var idValidView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.isHidden = false
        return view
    }()
    
    private lazy var pwValidView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.isHidden = false
        return view
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("조건을 만족시켜주세요.", for: .disabled)
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted)
        button.isEnabled = false
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 12
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        bindUI()
    }
}

private extension LoginViewController {
    func setupViews() {
        [lottieView, idTextField, pwTextField, loginButton]
            .forEach {
                view.addSubview($0)
            }
        
        let inset: CGFloat = 16.0
        
        lottieView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(inset * 4)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(300.0)
        }
        
        lottieView.play()
        
        idTextField.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(inset)
            $0.trailing.equalToSuperview().offset(-inset)
            $0.height.equalTo(50.0)
        }
        
        pwTextField.snp.makeConstraints {
            $0.top.equalTo(idTextField.snp.bottom).offset(8.0)
            $0.leading.equalToSuperview().offset(inset)
            $0.trailing.equalToSuperview().offset(-inset)
            $0.height.equalTo(50.0)
        }
        
        loginButton.snp.makeConstraints {
            $0.top.equalTo(pwTextField.snp.bottom).offset(16.0)
            $0.leading.equalToSuperview().offset(inset)
            $0.trailing.equalToSuperview().offset(-inset)
            $0.height.equalTo(65.0)
        }
        
        idTextField.addSubview(idValidView)
        
        idValidView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8.0)
            $0.width.height.equalTo(8.0)
        }
        
        pwTextField.addSubview(pwValidView)
        
        pwValidView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-8.0)
            $0.width.height.equalTo(8.0)
        }
    }
    
    func bindUI() {
        idTextField.rx.text
            .orEmpty
            .map(isValidID)
            .subscribe(onNext: { [weak self] result in
                self?.idValidView.isHidden = result
            })
            .disposed(by: disposeBag)

        pwTextField.rx.text
            .orEmpty
            .map(isValidPW)
            .subscribe(onNext: { [weak self] result in
                self?.pwValidView.isHidden = result
            })
            .disposed(by: disposeBag)
        
        idTextField.rx.text
            .orEmpty
            .bind(to: idInputTextSubject)
            .disposed(by: disposeBag)

        pwTextField.rx.text
            .orEmpty
            .bind(to: pwInputTextSubject)
            .disposed(by: disposeBag)


        idInputTextSubject
            .map(isValidID)
            .bind(to: idValidSubject)
            .disposed(by: disposeBag)

        pwInputTextSubject
            .map(isValidPW)
            .bind(to: pwValidSubject)
            .disposed(by: disposeBag)


        idValidSubject
            .subscribe(onNext: { result in
                self.idValidView.isHidden = result
            })
            .disposed(by: disposeBag)

        pwValidSubject
            .subscribe(onNext: { result in
                self.pwValidView.isHidden = result
            })
            .disposed(by: disposeBag)

        Observable.combineLatest(idValidSubject,
                                 pwValidSubject,
                                 resultSelector: { $0 && $1 }
        )
        .subscribe(onNext: { result in
            self.loginButton.isEnabled = result
            if result {
                self.loginButton.setTitle("로그인", for: .normal)
            } else {

            }
        })
        .disposed(by: disposeBag)
        
        loginButton.rx.tap.throttle(.microseconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: {
                print("Tapped")
            })
            .disposed(by: disposeBag)
    }
    
    func isValidID(id: String) -> Bool {
        return id.contains("@") && id.contains(".")
    }
    
    func isValidPW(pw: String) -> Bool {
        return pw.count > 6
    }
}


class PaddingTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 8.0, bottom: 0, right: 0)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
