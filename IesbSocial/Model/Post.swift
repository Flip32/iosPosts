//
//  ListUser.swift
//  IesbSocial
//
//  Created by Filipe Lopes on 02/09/21.
//

import Foundation

struct Post: Codable, Identifiable {
    let userId, id: Int
    let title, body: String
}
