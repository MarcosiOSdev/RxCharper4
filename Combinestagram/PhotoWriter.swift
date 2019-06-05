/*
 * Copyright (c) 2016-present Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import Foundation
import UIKit
import Photos
import RxSwift

class PhotoWriter: NSObject, NSCoding {
    func encode(with aCoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
    
    enum Errors: Error {
        case couldNotSavePhoto
    }
    
    var completionHandler: ((_ error: NSError?) -> Void)
    private init(completionHandler: @escaping ((_ error: NSError?) -> Void)) {
        self.completionHandler = completionHandler
    }
    
    //private var callback: Callback
//    private init(callback: Callback) {
//        self.callback = callback
//    }
    
    
    
    @objc func image(_ image: UIImage,
               didFinishSavingWithError error: NSError?,
               contextInfo: UnsafeRawPointer) {
        //self.callback(error)
        self.completionHandler(error)
    }
    
    static func save(_ image: UIImage) -> Observable<Void> {
        
        return Observable.create({ (observer) -> Disposable in
            let writer = PhotoWriter(completionHandler: { error in
                if let error = error {
                    observer.onError(error)
                } else {
                    observer.onCompleted()
                }
            })
            
            UIImageWriteToSavedPhotosAlbum(image, writer,
                                           #selector(PhotoWriter.image(_:didFinishSavingWithError:contextInfo:)),
                                           nil)
            return Disposables.create()
        })
    }
}
