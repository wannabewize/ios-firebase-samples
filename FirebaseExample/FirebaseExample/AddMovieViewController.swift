//
//  AddMovieViewController.swift
//  FirebaseExample
//
//  Created by MRF on 2021/05/20.
//

import UIKit
import FirebaseFirestore

class AddMovieViewController: UIViewController {
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var directorField: UITextField!
    @IBOutlet weak var actorsField: UITextField!
    
    // 영화 추가시 - 영화 다시 읽기
    var delegate: MovieDataChangHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func hadleCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func handleDone(_ sender: Any) {
        let data = [
            "title": titleField.text,
            "director": directorField.text,
            "actors": actorsField.text
        ]
        
        // 데이터베이스에 데이터 저장
        let db = Firestore.firestore()
        db.collection("movies").addDocument(data: data) { error in
            guard error == nil else {
                print("Error :", error)
                return
            }
            print("success")

            // 모달 닫기가 viewWillAppear를 호출하지 않는다. - delegate로
            self.delegate?.resolveMovies()
            self.dismiss(animated: true, completion: nil)
            
        }
    }
}
