import Foundation
import RequestKit

public extension Octokit {
    public func stars(name: String, completion: (response: Response<[Repository]>) -> Void) {
        let router = StarsRouter.ReadStars(name, configuration)
        router.loadJSON([[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedStars = json.map { Repository($0) }
                    completion(response: Response.Success(parsedStars))
                }
            }
        }
    }

    public func myStars(completion: (response: Response<[Repository]>) -> Void) {
        let router = StarsRouter.ReadAuthenticatedStars(configuration)
        router.loadJSON([[String: AnyObject]].self) { json, error in
            if let error = error {
                completion(response: Response.Failure(error))
            } else {
                if let json = json {
                    let parsedStars = json.map { Repository($0) }
                    completion(response: Response.Success(parsedStars))
                }
            }
        }
    }
}

public enum StarsRouter: Router {
    case ReadAuthenticatedStars(Configuration)
    case ReadStars(String, Configuration)
    public var method: HTTPMethod {
        return .GET
    }

    public var configuration: Configuration {
        switch self {
        case .ReadAuthenticatedStars(let config): return config
        case .ReadStars(_, let config): return config
        }
    }

    public var encoding: HTTPEncoding {
        return .URL
    }

    public var path: String {
        switch self {
        case .ReadAuthenticatedStars:
            return "user/starred"
        case .ReadStars(let username, _):
            return "users/\(username)/starred"
        }
    }

    public var params: [String: String] {
        return [:]
    }

    public var URLRequest: NSURLRequest? {
        return request()
    }
}