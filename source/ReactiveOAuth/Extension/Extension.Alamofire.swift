import Alamofire
import ReactiveSwift
import Result

extension DataRequest: ReactiveExtensionsProvider
{
}

extension Reactive where Base: DataRequest
{
    public var responded: Signal<Data, AnyError> {
        let pipe = Signal<Data, AnyError>.pipe()

        self.base.response(completionHandler: {
            if let error: Swift.Error = $0.error {
                pipe.input.send(error: AnyError(error))
            } else if let data: Data = $0.data {
                pipe.input.send(value: data)
            }
            pipe.input.sendCompleted()
        })

        return pipe.output
    }
}