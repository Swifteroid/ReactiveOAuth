import SwiftyJSON
import ReactiveOauth

internal typealias Email = String

internal class DropboxDetalisator: ReactiveOauth.DropboxDetalisator<Email>
{
    override internal func detail(json: JSON) {
        self.succeed(json["email"].stringValue)
    }
}

internal class GoogleDriveDetalisator: ReactiveOauth.GoogleDriveDetalisator<Email>
{
    override internal func detail(json: JSON) {
        self.succeed(json["user"]["emailAddress"].stringValue)
    }
}

internal class ImgurDetalisator: ReactiveOauth.ImgurDetalisator<Email>
{
    override internal func detail(json: JSON) {
        self.succeed(json["data"]["email"].stringValue)
    }
}