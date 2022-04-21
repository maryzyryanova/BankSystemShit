//
//  PRequest.swift
//  BankSystem
//
//  Created by Maria Zyryanova on 19.04.22.
//

import Foundation

protocol PRequest{
    var id: String { get }
    var bank: String { get }
    var status: String { get }
    
    func setStatus(_ status: String)
    func info() -> String
}
