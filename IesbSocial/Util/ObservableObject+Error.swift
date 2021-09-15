//
//  ObserverObject+Error.swift
//  IesbSocial
//
//  Created by Filipe Lopes on 02/09/21.
//

import Foundation
import Combine

extension ObservableObject {
    func sinkError(_ completion: Subscribers.Completion<Error>, loadingFinisher: () -> Void) {
        switch completion {
            case .failure(let error):
                loadingFinisher()
                debugPrint(error)
            default:
                break
        }
    }
}
