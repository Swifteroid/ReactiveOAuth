# ReactiveOauth

[![Build Status](https://travis-ci.org/swifteroid/reactiveoauth.svg?branch=master)](https://travis-ci.org/swifteroid/reactiveoauth)
[![Carthage Compatible](https://img.shields.io/badge/carthage-compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
![Platform](https://img.shields.io/badge/platform-macos-lightgray.svg?style=flat)

[ReactiveOauth](https://github.com/swifteroid/reactiveoauth) is a wrapper for [OAuthSwift](https://github.com/OAuthSwift/OAuthSwift) with [ReactiveSwift](https://github.com/ReactiveCocoa/ReactiveSwift) support and some [pre-configured services](source/Service), mostly useful in macOS projects.

- [x] Elegant api with reactive extensions support.
- [x] Oauth and re-oauth (refresh token) commands with or without account details.
- [x] Customisable account detalisators: full response / json with custom field filtering.

<div align="center"><img width="444px" src="documentation/asset/gifox-oauth.png"></div>

```swift
import AppKit
import Foundation
import ReactiveOauth
import ReactiveSwift

internal class MainViewController: NSViewController
{
    @IBAction private func handleOauthButtonAction(_ button: NSButton) {
        let storyboard: NSStoryboard = NSStoryboard(name: "main", bundle: Bundle.main)
        let controller: OauthViewController = storyboard.instantiateController(withIdentifier: "OauthViewController") as! OauthViewController
        let configuration: Oauth.Configuration = Dropbox.configure(access: Access(key: "foo", secret: "bar"), url: "https://baz.com/quz")
        let detalisator: Detalisator<String> = DropboxDetalisator()
        let oauth: DetailedOauth<String> = DetailedOauth(oauth: Oauth(configuration: configuration), detalisator: detalisator)

        oauth.reactive.authorised.observe(Observer(
            value: { (credential: Credential, string: String) in
                Swift.print(credential, string)
            },
            failed: { (error: ReactiveOauth.Error) in
                Swift.print(error.description)
            }
        ))

        self.authorise(oauthViewController: controller, oauth: oauth)
    }
}
```

## Install

Add ReactiveOauth to `Cartfile`:

```
github "swifteroid/reactiveoauh" "master"
```

## Testing

ReactiveOauth uses real accounts for testing provided in [test/oauth.json](test/oauth.json), they are kept blank for security reasons and injected by Travis CI during testing. So, if you want to test your own integrations, simply configure required services, unconfigured ones will be skipped. Travis expects `REACTIVEOAUTH_CREDENTIALS` environment variable, the following command copies current configuration in acceptable format escaped for shell.

```sh
jq --join-output "tojson | @sh" test/oauth.json | pbcopy
```