//
//  KeychainAccessible.swift
//  Todo-Testing_tut
//
//  Created by Elikem Savie (Team Ampersand) on 08/01/2021.
//

import Foundation


protocol KeychainAccessible {
    func setPassword(password: String,
        account: String)
    
    func deletePasswortForAccount(account: String)
    
    func passwordForAccount(account: String) -> String?
}

