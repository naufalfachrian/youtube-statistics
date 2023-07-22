import Fluent


extension Array where Element == any YouTubeStatistic {

    func store(on db: Database, logger: Logger? = nil) async throws {
        for statistic in self {
            let create = YouTubeStatisticModel(from: statistic)
            logger?.info("Created \(statistic.channelID) with \(statistic.subscriberCount) subscribers (hidden: \(statistic.isSubscriberCountHidden)")
            try await create.save(on: db)
        }
    }

}
