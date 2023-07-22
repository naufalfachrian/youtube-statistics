import Fluent
import Vapor


protocol YouTubeStatistic {

    var channelID: String { get }

    var viewCount: UInt { get }

    var subscriberCount: UInt { get }

    var isSubscriberCountHidden: Bool { get }

    var videoCount: UInt { get }

}


protocol YouTubeStatisticWithDate: YouTubeStatistic {

    var date: Date { get }

}


final class YouTubeStatisticModel: YouTubeStatisticWithDate, Model {

    static let schema = "youtube_statistics"

    @ID(key: .id)
    var id: UUID?

    @Field(key: "channel_id")
    var channelID: String

    @Field(key: "view_count")
    var viewCount: UInt

    @Field(key: "subscriber_count")
    var subscriberCount: UInt

    @Field(key: "hidden_subscriber_count")
    var isSubscriberCountHidden: Bool

    @Field(key: "video_count")
    var videoCount: UInt

    @Field(key: "date")
    var date: Date

    @Timestamp(key: "created_at", on: .create)
    var createdAt: Date?

    init() { }

    init(
        channelID: String, 
        viewCount: UInt, 
        subscriberCount: UInt, 
        isSubscriberCountHidden: Bool, 
        videoCount: UInt, 
        date: Date
    ) {
        self.channelID = channelID
        self.viewCount = viewCount
        self.subscriberCount = subscriberCount
        self.isSubscriberCountHidden = isSubscriberCountHidden
        self.videoCount = videoCount
        self.date = date
    }

    init(from statistic: YouTubeStatistic) {
        self.channelID = statistic.channelID
        self.viewCount = statistic.viewCount
        self.subscriberCount = statistic.subscriberCount
        self.isSubscriberCountHidden = statistic.isSubscriberCountHidden
        self.videoCount = statistic.videoCount
        self.date = Date()
    }

}


extension YouTubeStatisticModel: Content { }
