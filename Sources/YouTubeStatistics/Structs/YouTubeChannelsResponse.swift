import Foundation
import Vapor


struct YouTubeChannelsResponse: Codable {
    
    let pageInfo: FetchChannelPageInfo
    
    let items: [YouTubeChannelItemResponse]
    
}

extension YouTubeChannelsResponse: Content { }


// MARK: - Youtube Channel Thumbnail

struct FetchChannelPageInfo: Codable {
    
    let totalResults: Int
    
    let resultsPerPage: Int
    
}


// MARK: - Youtube Channel Item

struct YouTubeChannelItemResponse: YouTubeStatistic, Codable {
    
    let id: String
    
    let statistics: YouTubeChannelStatistic
    
    var channelID: String {
        return self.id
    }

    var viewCount: UInt {
        return self.statistics.viewCount
    }

    var subscriberCount: UInt {
        return self.statistics.subscriberCount ?? 0
    }

    var isSubscriberCountHidden: Bool {
        return self.statistics.isSubscriberCountHidden
    }

    var videoCount: UInt {
        return self.statistics.videoCount
    }
    
}


// MARK: - Youtube Channel Statistic

struct YouTubeChannelStatistic: Codable {
    
    let viewCountString: String
    
    let subscriberCountString: String?
    
    let isSubscriberCountHidden: Bool
    
    let videoCountString: String
    
    var viewCount: UInt {
        return UInt(self.viewCountString) ?? 0
    }
    
    var subscriberCount: UInt? {
        guard let unwrapSubscriberCountString = self.subscriberCountString else {
            return nil
        }
        return UInt(unwrapSubscriberCountString)
    }
    
    var videoCount: UInt {
        return UInt(self.videoCountString) ?? 0
    }
    
    enum CodingKeys: String, CodingKey {
        case viewCountString = "viewCount"
        case subscriberCountString = "subscriberCount"
        case isSubscriberCountHidden = "hiddenSubscriberCount"
        case videoCountString = "videoCount"
    }
    
}
