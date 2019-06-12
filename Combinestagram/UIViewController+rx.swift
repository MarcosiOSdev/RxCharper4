//
//  UIViewController+rx.swift
//  Combinestagram
//
//  Created by Marcos Felipe Souza on 12/06/19.
//  Copyright © 2019 Underplot ltd. All rights reserved.
//

import UIKit
import RxSwift

extension UIViewController {
    
    func showMessage(title: String, message: String) -> Observable<Void> {
        return Observable.create({ [weak self] (observer) -> Disposable in
            
            let alert = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close",
                                          style: .default,
                                          handler: { (_) in
                                            observer.onCompleted()
            }))
            self?.present(alert, animated: true)
            return Disposables.create()
        })
    }
    
}
