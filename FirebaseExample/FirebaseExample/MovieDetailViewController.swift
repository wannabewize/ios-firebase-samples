//
//  MovieDetailViewController.swift
//  FirebaseExample
//
//  Created by MRF on 2021/05/20.
//

import UIKit
import FirebaseFirestore

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var directorLabel: UILabel!
    @IBOutlet weak var actorsLabel: UILabel!
    
    var movieId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        resolveMovieDetail()
    }
    
    func resolveMovieDetail() {
        guard let movieId = movieId else {
            print("movie id is nil")
            return
        }
        
        let db = Firestore.firestore()
        let docRef = db.collection("movies").document(movieId)
        docRef.getDocument { (snapshot: DocumentSnapshot?, error: Error?) in
            guard error == nil else {
                print("movie detail error:", error)
                return
            }
            let movieId = snapshot!.documentID
            let movie = snapshot!.data()!
                                
            let title = (movie["title"] as? String) ?? "제목 없음"
            let director = (movie["director"] as? String) ?? "감독 정보 없음"
            let actors = (movie["actors"] as? String) ?? "배우 정보 없음"
            
            self.titleLabel.text = title
            self.directorLabel.text = director
            self.actorsLabel.text = actors
            
            if let poster = movie["poster"] as? String,
               let encoded = poster.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
               let url = URL(string: encoded) {

                DispatchQueue.global().async {
                    do {
                        let data = try Data(contentsOf: url)
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            self.posterImageView.image = image
                        }
                    }
                    catch let error {
                        print("포스터 이미지 다운로드 오류:", error)
                    }
                }
            }
            else {
                print("포스터 이미지 정보 오류:", movie)
            }
        }
    }
    
    // 영화 삭제
    @IBAction func deleteMovie(_ sender: Any) {
        guard let movieId = movieId else {
            print("movieId is nil")
            return
        }
        
        let dialog = UIAlertController(title: "삭제?", message: nil, preferredStyle: .alert)
        dialog.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        
        let deleteAction = UIAlertAction(title: "확인", style: .destructive) { _ in
            let db = Firestore.firestore()
            db.collection("movies").document(movieId).delete { error in
                guard error == nil else {
                    print("영화 삭제 에러", error)
                    return
                }
                self.navigationController?.popViewController(animated: true)
            }
        }
        dialog.addAction(deleteAction)
        self.present(dialog, animated: true, completion: nil)
    }
}
