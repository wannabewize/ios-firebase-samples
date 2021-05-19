//
//  ViewController.swift
//  FirebaseExample
//
//  Created by MRF on 2021/05/19.
//

import UIKit
import FirebaseUI

class ViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    @IBAction func signIn(_ sender: Any) {
        self.textView.text.append("\n로그인 시도")
        let email = "user@wannabewize.xyz"
        let password = "123456"
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            guard error == nil else {
                self.textView.text.append("\n로그인 에러: \(error!.localizedDescription)")
                return
            }
            // 에러처리
            if let user = result?.user {
                self.textView.text.append("""
                    \n==로그인 성공==
                    로그인 한 사용자 이름 : \(user.displayName)
                    Email: \(user.email)
                    """
                )
            }
        }
    }
    
    @IBAction func signInUI(_ sender: Any) {
        let authUI = FUIAuth.defaultAuthUI()!
        // 델리게이트 설정
        authUI.delegate = self
        // 프로바이서 설정
        let providers: [FUIAuthProvider] = [
            FUIEmailAuth()
//            FUIFacebookAuth(),
//            FUIGoogleAuth()
        ]
        authUI.providers = providers
        let authViewController = authUI.authViewController()
        // 모달로 기본 인증 VC
        self.present(authViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func signOut(_ sender: Any) {
        do {
            try Auth.auth().signOut()
            self.textView.text.append("\n로그아웃 성공")
        }
        catch let error {
            print(error)
            self.textView.text.append("\n로그아웃 실패: \(error.localizedDescription)\n")
        }
    }
    
    
    @IBAction func showUserInfo(_ sender: Any) {
        if let user = Auth.auth().currentUser {
            self.textView.text.append("""
            \n== 유저 정보 ==
            uid: \(user.uid)
            email: \(user.email)
            provider: \(user.providerID)
            """)
        }
        else {
            self.textView.text.append("\n유저 없음\n")
        }
    }
}

extension ViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        self.textView.text.append("\n로그인 시도")
        if let user = authDataResult?.user {
            self.textView.text.append("""
                \n==로그인 성공==
                로그인 한 사용자 이름 : \(user.displayName)
                Email: \(user.email)
                """
            )

        }
    }
    
}

