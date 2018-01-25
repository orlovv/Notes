//
//  BiometricAuth.swift
//  MyNotes
//
//  Created by Vladimir Orlov on 17.01.2018.
//  Copyright © 2018 Vladimir Orlov. All rights reserved.
//

import Foundation
import LocalAuthentication

class BiometricAuth {
  
  let context = LAContext()
  
  func canEvaluatePolicy() -> Bool {
    return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
  }
  
  func authenticateUser(completion: @escaping (String?) -> Void) {
    guard canEvaluatePolicy() else {
      completion("TouchID is not available")
      return
    }
    
    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Logging in with Touch ID") { (success, evaluateError) in
      if success {
        DispatchQueue.main.async {
          completion(nil)
        }
      } else {
        let message: String
        
        switch evaluateError {
        case LAError.authenticationFailed?:
          message = "There was a problem verifying your identity."
        case LAError.userCancel?:
          message = "You pressed cancel."
        case LAError.userFallback?:
          message = "You pressed password."
        case LAError.biometryNotAvailable?:
          message = "Face ID/Touch ID is not available."
        case LAError.biometryNotEnrolled?:
          message = "Face ID/Touch ID is not set up."
        case LAError.biometryLockout?:
          message = "Face ID/Touch ID is locked."
        default:
          message = "Face ID/Touch ID may not be configured"
        }
        
        completion(message)
      }
    }
  }
}
