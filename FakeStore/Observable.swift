//
//  Observable.swift
//  FakeStore
//
//  Created by Muhsin Can Yılmaz on 3.04.2023.
//

import Foundation

class Observable<T>{
    
    var value: T?{
        didSet{
            _callback?(value)
        }
    }
    
    private var _callback: ((T?) -> Void)?
    
    func bind(_ callback: @escaping (T?) -> Void){
        _callback = callback
    }
    
}
