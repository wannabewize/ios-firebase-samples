//
//  ViewController.swift
//  FirebaseExample
//
//  Created by MRF on 2021/05/19.
//

import UIKit
import FirebaseAuth
import AuthenticationServices

class AuthViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let listener = Auth.auth().addStateDidChangeListener { auth, user in
            self.textView.text.append("\nAuth State Changed.\n")
        }
        
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
                    UID : \(user.uid)
                    Email: \(user.email)
                    """
                )
            }
        }
    }
    @IBAction func signInWithApple(_ sender: Any) {
        let provider = ASAuthorizationAppleIDProvider()
        let request: ASAuthorizationAppleIDRequest = provider.createRequest()
        request.requestedScopes = [.email, .fullName]
        
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.delegate = self
        authController.presentationContextProvider = self
        authController.performRequests()
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
            email: \(user.email ?? "")
            provider: \(user.providerID)
            """)
            
            user.getIDToken { token, error in
                guard let token = token else { fatalError("Token is nil") }
                debugPrint("token :", token)
                let tokenStr = token[token.startIndex...token.index(token.startIndex, offsetBy: 20)]
                self.textView.text.append("\njwt : \(tokenStr)..., length: \(token.count)")
            }
        }
        else {
            self.textView.text.append("\n유저 없음\n")
        }
    }
}

extension AuthViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
}

extension AuthViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let user = credential.user
            let name = credential.fullName
            let email = credential.email
            guard let appleIDToken = credential.identityToken else { fatalError("fetch id token fail") }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else { fatalError("serialize token string error") }
            
            let fbCredential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nil)
            Auth.auth().signIn(with: fbCredential) { authResult, error in
                guard error == nil else {
                    fatalError(error!.localizedDescription)
                }
                // 에러처리
                if let user = authResult?.user {
                    self.textView.text.append("""
                        \n==FB 로그인 성공==
                        UID : \(user.uid)
                        Email: \(user.email)
                        """
                    )
                }
            }
            
            self.textView.text.append("\n== Sign In Apple\n \(user) \(name?.givenName ?? "") \(email ?? "")")
        }
        else {
            fatalError("Something wrong")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        debugPrint("SignIn With Apple Error :", error)
    }
}
