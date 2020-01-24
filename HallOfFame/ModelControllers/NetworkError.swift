//
//  NetworkError.swift
//  HallOfFame
//
//  Created by Uzo on 1/23/20.
//  Copyright © 2020 Uzo. All rights reserved.
//

import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case unableToDecodeData
    case thrownError(Error)
}
