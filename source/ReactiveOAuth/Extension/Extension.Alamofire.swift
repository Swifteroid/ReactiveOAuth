import Alamofire
import ReactiveSwift

extension DataRequest: ReactiveExtensionsProvider
{
}

extension Reactive where Base: DataRequest
{
    public var responded: Signal<Data, Swift.Error> {
        let pipe = Signal<Data, Swift.Error>.pipe()

        self.base.response(completionHandler: {
            if let error: Swift.Error = $0.error {
                pipe.input.send(error: error)
            } else if let data: Data = $0.data {
                pipe.input.send(value: data)
            }
            pipe.input.sendCompleted()
        })

        return pipe.output
    }
}