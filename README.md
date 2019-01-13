# ReactiveOAuth

[![Build Status](https://travis-ci.com/Swifteroid/ReactiveOAuth.svg?branch=master)](https://travis-ci.com/Swifteroid/ReactiveOAuth)
[![GitHub Release](https://img.shields.io/github/release/Swifteroid/ReactiveOAuth.svg)](https://github.com/Swifteroid/ReactiveOAuth/releases)
[![Carthage Compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform](https://img.shields.io/badge/platform-macOS-lightgray.svg?style=flat)

[ReactiveOAuth](https://github.com/Swifteroid/ReactiveOAuth) is a wrapper for [OAuthSwift](https://github.com/OAuthSwift/OAuthSwift) with [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) support and some [pre-configured services](source/Service), mostly useful in macOS projects.

- [x] Elegant api with reactive extensions support.
- [x] OAuth and re-OAuth (refresh token) commands with or without account details.
- [x] Customisable account detalisators: full response / json with custom field filtering.

<div align="center"><img width="444px" src="documentation/asset/gifox-oauth.png"></div>

```swift
import AppKit
import Foundation
import ReactiveOAuth
import ReactiveSwift

internal class MainViewController: NSViewController
{
    @IBAction private func handleOAuthButtonAction(_ button: NSButton) {
        let storyboard: NSStoryboard = NSStoryboard(name: "main", bundle: Bundle.main)
        let controller: OAuthViewController = storyboard.instantiateController(withIdentifier: "OAuthViewController") as! OAuthViewController
        let configuration: OAuth.Configuration = Dropbox.configure(access: Access(key: "foo", secret: "bar"), url: "https://baz.com/quz")
        let detalisator: Detalisator<String> = DropboxDetalisator()
        let oauth: DetailedOAuth<String> = DetailedOAuth(oauth: OAuth(configuration: configuration), detalisator: detalisator)

        oauth.reactive.authorised.observe(Observer(
            value: { (credential: Credential, string: String) in
                Swift.print(credential, string)
            },
            failed: { (error: ReactiveOAuth.Error) in
                Swift.print(error.description)
            }
        ))

        self.authorise(oauthViewController: controller, oauth: oauth)
    }
}
```

## Install

Add ReactiveOAuth to `Cartfile`:

```
github "swifteroid/reactiveoauh" "master"
```

## Testing

ReactiveOAuth uses real accounts for testing provided in [test/oauth.json](test/oauth.json), they are kept blank for security reasons and injected by Travis CI during testing. So, if you want to test your own integrations, simply configure required services, unconfigured ones will be skipped. Travis expects `REACTIVEOAUTH_CREDENTIALS` environment variable, the following command copies current configuration in acceptable format escaped for shell.

```sh
jq --join-output "tojson | @sh" test/oauth.json | pbcopy
```