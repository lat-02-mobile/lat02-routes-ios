//
//  ViewModel.swift
//  RoutesApp_ios
//
//  Created by Alvaro Choque on 11/8/22.
//

import Foundation

protocol ViewModelProtocol {
    var onFinish: (() -> Void)? { get set }
    var onError: ((_ error: String) -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
}

class ViewModel: ViewModelProtocol {
    var onFinish: (() -> Void)?
    var onError: ((String) -> Void)?
    var reloadData: (() -> Void)?
}
