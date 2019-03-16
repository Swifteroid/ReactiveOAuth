import Alamofire
import ReactiveSwift
import SwiftyJSON

open class GoogleDetalisator<Detail>: JsonDetalisator<Detail>
{
    open override func detail(credential: Credential) {
        let headers: HTTPHeaders = ["Authorization": "Bearer \(credential.accessToken)"]
        let parameters: Parameters = ["access_token": credential.accessToken]

        // Todo: check for json errors…

        Alamofire.request(Google.url.detail, method: HTTPMethod.get, parameters: parameters, headers: headers).reactive.responded
            .attemptMap({ try JSON(data: $0) })
            .observe({ [weak self] in
                if case .value(let value) = $0 {
                    self?.detail(json: value)
                } else if case .failed(let error) = $0 {
                    self?.fail(Error.unknown(description: error.localizedDescription))
                }
            })
    }
}