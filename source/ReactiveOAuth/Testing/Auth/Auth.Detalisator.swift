import SwiftyJSON
import ReactiveOAuth

internal typealias Email = String

internal class DropboxDetalisator: ReactiveOAuth.DropboxDetalisator<Email>
{
    override internal func detail(json: JSON) {
        self.succeed(json["email"].stringValue)
    }
}

internal class GoogleDetalisator: ReactiveOAuth.GoogleDetalisator<Email>
{
    override internal func detail(json: JSON) {
        self.succeed(json["email"].stringValue)
    }
}

internal class ImgurDetalisator: ReactiveOAuth.ImgurDetalisator<Email>
{
    override internal func detail(json: JSON) {
        self.succeed(json["data"]["email"].stringValue)
    }
}