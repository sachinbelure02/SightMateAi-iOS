//
//  AppState.swift
//  SightMate Ai
//
//  Created by Sachin Belure on 04/08/26.
//

import Foundation
import Combine

class AppState: ObservableObject {
    
    @Published var isLoggedIn: Bool = false
    
    @Published var username: String = "Guest User"
    
}
