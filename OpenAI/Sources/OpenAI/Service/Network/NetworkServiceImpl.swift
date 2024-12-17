//
//  NetworkService.swift
//  OpenAI
//
//  Created by Francesco Paolo Dellaquila on 15/12/24.
//

import Foundation

class NetworkServiceImpl: NetworkService, @unchecked Sendable {
    let session: URLSessionProtocol
    let decoder: JSONDecoder
    
    init(session: URLSessionProtocol, decoder: JSONDecoder = JSONDecoder()) {
        self.session = session
        self.decoder = decoder
    }
    
    public func fetchContentsOfFile(
       request: URLRequest)
       async throws -> Data
    {
       let (data, response) = try await session.data(for: request)
       guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.requestFailed(description: "invalid response unable to get a valid HTTPURLResponse")
       }
        
       NetworkMisc.printHTTPURLResponse(httpResponse)
        
       guard httpResponse.statusCode == 200 else {
          var errorMessage = "status code \(httpResponse.statusCode)"
          do {
             let error = try decoder.decode(OpenAIErrorResponse.self, from: data)
             errorMessage += " \(error.error.message ?? "NO ERROR MESSAGE PROVIDED")"
          } catch {
             // If decoding fails, proceed with a general error message
             errorMessage = "status code \(httpResponse.statusCode)"
          }
          throw APIError.responseUnsuccessful(description: errorMessage,
                                              statusCode: httpResponse.statusCode)
       }
        
       return data
    }
    
    public func fetch<T: Decodable>(
        debugEnabled: Bool,
        type: T.Type,
        with request: URLRequest
    ) async throws -> T {
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.requestFailed(description: "Invalid response: Unable to get a valid HTTPURLResponse")
        }
        
        if debugEnabled {
            if let body = request.httpBody, let bodyString = String(data: body, encoding: .utf8) {
                print("Request Body: \(bodyString)")
            }
            print("Request URL: \(request.url?.absoluteString ?? "No URL")")
            print("Request Headers: \(request.allHTTPHeaderFields ?? [:])")
            NetworkMisc.printHTTPURLResponse(httpResponse)
        }
        
        // Handle non-successful status codes
        guard httpResponse.statusCode == 200 else {
            var errorMessage = "Status code \(httpResponse.statusCode)"
            
            // Try to decode the error response
            do {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                   let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
                   let jsonString = String(data: jsonData, encoding: .utf8) {
                    print("API Error JSON: \(jsonString)")
                }
                
                let errorResponse = try decoder.decode(OpenAIErrorResponse.self, from: data)
                errorMessage += " \(errorResponse.error.message ?? "NO ERROR MESSAGE PROVIDED")"
            } catch {
                // If decoding fails, print the raw response body
                let rawError = String(data: data, encoding: .utf8) ?? "Unable to parse error response"
                print("Raw API Error: \(rawError)")
                errorMessage += " | Raw response: \(rawError)"
            }
            
            throw APIError.responseUnsuccessful(description: errorMessage, statusCode: httpResponse.statusCode)
        }
        
        #if DEBUG
        if debugEnabled {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let prettyString = String(data: prettyData, encoding: .utf8) {
                print("DEBUG JSON FETCH API = \(prettyString)")
            } else {
                print("DEBUG JSON FETCH API = Unable to format response JSON")
            }
        }
        #endif
        
        // Decode the successful response
        do {
            return try decoder.decode(type, from: data)
        } catch let DecodingError.keyNotFound(key, context) {
            let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
            let codingPath = "CodingPath: \(context.codingPath)"
            let debugMessage = debug + " | " + codingPath
            print("Decoding Error: \(debugMessage)")
            throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
        } catch {
            print("Decoding Error: \(error.localizedDescription)")
            throw APIError.jsonDecodingFailure(description: error.localizedDescription)
        }
    }


    @preconcurrency
    public func fetchStream<T: Decodable>(
       debugEnabled: Bool,
       type: T.Type,
       with request: URLRequest)
       async throws -> AsyncThrowingStream<T, Error>
    {

       let (data, response) = try await session.bytes(for: request)
       guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.requestFailed(description: "invalid response unable to get a valid HTTPURLResponse")
       }
       if debugEnabled {
           NetworkMisc.printHTTPURLResponse(httpResponse)
       }
       guard httpResponse.statusCode == 200 else {
          var errorMessage = "status code \(httpResponse.statusCode)"
          do {
             let data = try await data.reduce(into: Data()) { data, byte in
                data.append(byte)
             }
             let error = try decoder.decode(OpenAIErrorResponse.self, from: data)
             errorMessage += " \(error.error.message ?? "NO ERROR MESSAGE PROVIDED")"
          } catch {
             // If decoding fails, proceed with a general error message
             errorMessage = "status code \(httpResponse.statusCode)"
          }
          throw APIError.responseUnsuccessful(description: errorMessage,
                                              statusCode: httpResponse.statusCode)
       }
       return AsyncThrowingStream { continuation in
          let task = Task {
              
              let decoder = self.decoder
              
             do {
                for try await line in data.lines {
                   if line.hasPrefix("data:") && line != "data: [DONE]",
                      let data = line.dropFirst(5).data(using: .utf8) {
                      #if DEBUG
                      if debugEnabled {
                         print("DEBUG JSON STREAM LINE = \(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])")
                      }
                      #endif
                       
                       do {
                           let decoded = try decoder.decode(T.self, from: data)
                           continuation.yield(decoded)
                       } catch let DecodingError.keyNotFound(key, context) {
                           let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
                           let codingPath = "codingPath: \(context.codingPath)"
                           let debugMessage = debug + codingPath
                          #if DEBUG
                           if debugEnabled {
                               print(debugMessage)
                           }
                          #endif
                           throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
                       } catch {
                          #if DEBUG
                           if debugEnabled {
                               debugPrint("CONTINUATION ERROR DECODING \(error.localizedDescription)")
                           }
                           #endif
                           
                           continuation.finish(throwing: error)
                       }
                   }
                }
                await MainActor.run {
                     continuation.finish()
                }
             } catch let DecodingError.keyNotFound(key, context) {
                let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
                let codingPath = "codingPath: \(context.codingPath)"
                let debugMessage = debug + codingPath
                #if DEBUG
                if debugEnabled {
                   print(debugMessage)
                }
                #endif
                throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
             } catch {
                #if DEBUG
                if debugEnabled {
                   print("CONTINUATION ERROR DECODING \(error.localizedDescription)")
                }
                #endif
                 await MainActor.run {
                     continuation.finish(throwing: error)
                 }
             }
          }
          continuation.onTermination = { @Sendable _ in
             task.cancel()
          }
       }
    }
    
    @preconcurrency
    public func fetchAssistantStreamEvents(
       with request: URLRequest,
       debugEnabled: Bool)
       async throws -> AsyncThrowingStream<AssistantStreamEvent, Error>
    {

       let (data, response) = try await session.bytes(for: request)
       guard let httpResponse = response as? HTTPURLResponse else {
          throw APIError.requestFailed(description: "invalid response unable to get a valid HTTPURLResponse")
       }
        NetworkMisc.printHTTPURLResponse(httpResponse)
        
       guard httpResponse.statusCode == 200 else {
          var errorMessage = "status code \(httpResponse.statusCode)"
          do {
             let data = try await data.reduce(into: Data()) { data, byte in
                data.append(byte)
             }
             let error = try decoder.decode(OpenAIErrorResponse.self, from: data)
             errorMessage += " \(error.error.message ?? "NO ERROR MESSAGE PROVIDED")"
          } catch {
             // If decoding fails, proceed with a general error message
             errorMessage = "status code \(httpResponse.statusCode)"
          }
          throw APIError.responseUnsuccessful(description: errorMessage,
                                              statusCode: httpResponse.statusCode)
       }
       return AsyncThrowingStream { continuation in
          let task = Task {
             do {
                for try await line in data.lines {
                   if line.hasPrefix("data:") && line != "data: [DONE]",
                      let data = line.dropFirst(5).data(using: .utf8) {
                      do {
                         if
                            let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
                            let object = json["object"] as? String,
                            let eventObject = AssistantStreamEventObject(rawValue: object)
                         {
                            switch eventObject {
                            case .threadMessageDelta:
                               let decoded = try self.decoder.decode(MessageDelta.self, from: data)
                               continuation.yield(.threadMessageDelta(decoded))
                            case .threadRunStepDelta:
                               let decoded = try self.decoder.decode(RunStepDelta.self, from: data)
                               continuation.yield(.threadRunStepDelta(decoded))
                            case .threadRun:
                               // We expect a object of type "thread.run.SOME_STATE" in the data object
                               // However what we get is a `thread.run` object but we can check the status
                               // of the decoded run to determine the stream event.
                               // If we check the event line instead, this will contain the expected "event: thread.run.step.completed" for example.
                               // Therefore the need to stream this event in the following way.
                               let decoded = try self.decoder.decode(Run.self, from: data)
                               switch Run.Status(rawValue: decoded.status) {
                               case .queued:
                                  continuation.yield(.threadRunQueued(decoded))
                               case .inProgress:
                                  continuation.yield(.threadRunInProgress(decoded))
                               case .requiresAction:
                                  continuation.yield(.threadRunRequiresAction(decoded))
                               case .cancelling:
                                  continuation.yield(.threadRunCancelling(decoded))
                               case .cancelled:
                                  continuation.yield(.threadRunCancelled(decoded))
                               case .failed:
                                  continuation.yield(.threadRunFailed(decoded))
                               case .completed:
                                  continuation.yield(.threadRunCompleted(decoded))
                               case .expired:
                                  continuation.yield(.threadRunExpired(decoded))
                               default:
                               #if DEBUG
                                  if debugEnabled {
                                     print("DEBUG threadRun status not found = \(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])")
                                  }
                               #endif
                               }
                            default:
                            #if DEBUG
                               if debugEnabled {
                                  print("DEBUG EVENT \(eventObject.rawValue) IGNORED = \(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])")
                               }
                            #endif
                            }
                         } else {
                            #if DEBUG
                            if debugEnabled {
                               print("DEBUG EVENT DECODE IGNORED = \(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])")
                            }
                            #endif
                         }
                      } catch let DecodingError.keyNotFound(key, context) {
                      #if DEBUG
                         if debugEnabled {
                            print("DEBUG Decoding Object Failed = \(try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any])")
                         }
                      #endif
                         let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
                         let codingPath = "codingPath: \(context.codingPath)"
                         let debugMessage = debug + codingPath
                      #if DEBUG
                         if debugEnabled {
                            print(debugMessage)
                         }
                      #endif
                         throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
                      } catch {
                      #if DEBUG
                         if debugEnabled {
                            debugPrint("CONTINUATION ERROR DECODING \(error.localizedDescription)")
                         }
                      #endif
                         continuation.finish(throwing: error)
                      }
                   }
                }
                continuation.finish()
             } catch let DecodingError.keyNotFound(key, context) {
                let debug = "Key '\(key.stringValue)' not found: \(context.debugDescription)"
                let codingPath = "codingPath: \(context.codingPath)"
                let debugMessage = debug + codingPath
                #if DEBUG
                if debugEnabled {
                   print(debugMessage)
                }
                #endif
                throw APIError.dataCouldNotBeReadMissingData(description: debugMessage)
             } catch {
                #if DEBUG
                if debugEnabled {
                   print("CONTINUATION ERROR DECODING \(error.localizedDescription)")
                }
                #endif
                continuation.finish(throwing: error)
             }
          }
          continuation.onTermination = { @Sendable _ in
             task.cancel()
          }
       }
    }

}
