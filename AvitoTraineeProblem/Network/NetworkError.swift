//
//  NetworkError.swift
//  AvitoTraineeProblem
//
//  Created by Fed on 27.10.2022.
//

import Foundation

enum NetworkError: Error {
    case urlError
    case requestError(String?)
    case sessionError(String?)
    case decodingError(String?)
}
