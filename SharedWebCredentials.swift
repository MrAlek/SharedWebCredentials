//  Copyright (c) 2016 Alek Åström. All rights reserved.

import Security

public enum SharedWebCredentials {

    public typealias Credential = (account: String, password: String)

    public static func request(fqdn fqdn: String?, completion: (Credential?, ErrorType?) -> Void) {
        SecRequestSharedWebCredential(fqdn, nil) { webCredentials, requestError in
            var error: ErrorType? = nil
            var credential: Credential? = nil

            defer {
                completion(credential, error)
            }

            guard requestError == nil else {
                let cocoaError = requestError! as NSError
                let errorIsNoCredentialsFound = cocoaError.domain == NSOSStatusErrorDomain && cocoaError.code == Int(errSecItemNotFound)

                if !errorIsNoCredentialsFound { // No credentals found shouldn't be treated as an error
                    error = cocoaError
                }

                return
            }

            guard let webCredentials = webCredentials where CFArrayGetCount(webCredentials) > 0 else {
                // User probably pressed "not now"
                return
            }

            // Casting bonanza!!

            let unsafeCredential = CFArrayGetValueAtIndex(webCredentials, 0)
            let credentialDictionary = unsafeBitCast(unsafeCredential, CFDictionaryRef.self)

            let unsafeAccount = CFDictionaryGetValue(credentialDictionary, unsafeAddressOf(kSecAttrAccount))
            let account = unsafeBitCast(unsafeAccount, CFString.self) as String

            let unsafePassword = CFDictionaryGetValue(credentialDictionary, unsafeAddressOf(kSecSharedPassword))
            let password = unsafeBitCast(unsafePassword, CFString.self) as String

            credential = (account, password)
        }
    }

    public static func save(credential credential: Credential, fqdn: String, completion: (ErrorType?) -> Void) {
        SecAddSharedWebCredential(fqdn, credential.account, credential.password) { error in
            completion(error)
        }
    }

    public static func delete(for account: String, fqdn: String, completion: (ErrorType?) -> Void) {
        SecAddSharedWebCredential(fqdn, account, nil) { error in
            completion(error)
        }
    }

    public static func generatePassword() -> String? {
        return SecCreateSharedWebCredentialPassword() as String?
    }

}
