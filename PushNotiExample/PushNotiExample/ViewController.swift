//
//  ViewController.swift
//  PushNotiExample
//
//  Created by Jaehoon Lee on 2022/12/01.
//

import UIKit
import FirebaseMessaging

class ViewController: UIViewController {
    
    let topicName = "worldcup"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func subscribeTopic(_ sender: Any) {
        Messaging.messaging().subscribe(toTopic: topicName) { error in
            debugPrint("subscribe topic. error?", error)
        }
    }
    
    @IBAction func unsubscribeTopic(_ sender: Any) {
        Messaging.messaging().unsubscribe(fromTopic: topicName) { error in
            debugPrint("unsubscribe topic. error?", error)
        }
    }
}

