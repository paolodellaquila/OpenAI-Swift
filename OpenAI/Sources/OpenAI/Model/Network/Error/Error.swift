//
//  Error.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

public enum APIError: Error {
   
   case requestFailed(description: String)
   case responseUnsuccessful(description: String, statusCode: Int)
   case invalidData
   case jsonDecodingFailure(description: String)
   case dataCouldNotBeReadMissingData(description: String)
   case bothDecodingStrategiesFailed
   case timeOutError
   
   public var displayDescription: String {
      switch self {
      case .requestFailed(let description): return description
      case .responseUnsuccessful(let description, _): return description
      case .invalidData: return "Invalid data"
      case .jsonDecodingFailure(let description): return description
      case .dataCouldNotBeReadMissingData(let description): return description
      case .bothDecodingStrategiesFailed: return "Decoding strategies failed."
      case .timeOutError: return "Time Out Error."
      }
   }
}
