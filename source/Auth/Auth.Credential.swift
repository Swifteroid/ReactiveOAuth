import Foundation
import OAuthSwift

public struct Credential
{
    public var accessToken: String
    public var refreshToken: String?
    public var expireDate: Date?

    public init(accessToken: String, refreshToken: String? = nil, expireDate: Date? = nil) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expireDate = expireDate
    }

    internal init(credential: OAuthSwiftCredential) {
        self.init(
            accessToken: credential.oauthToken,
            refreshToken: credential.oauthRefreshToken == "" ? nil : credential.oauthRefreshToken,
            expireDate: credential.oauthTokenExpiresAt
        )
    }
}