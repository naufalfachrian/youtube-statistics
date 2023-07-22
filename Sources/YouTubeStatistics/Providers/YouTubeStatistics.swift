import Fluent
import Vapor


extension Application {

    struct YouTubeStatistics {

        fileprivate let application: Application

        final class Storage {
            let dataSourceURL: String

            init(dataSourceURL: String) {
                self.dataSourceURL = dataSourceURL
            }
        }

        struct Key: StorageKey {
            typealias Value = Storage
        }

        fileprivate var storage: Storage {
            if self.application.storage[Key.self] == nil {
                self.initialize()
            }
            return self.application.storage[Key.self]!
        }

        fileprivate func initialize() {
            self.application.storage[Key.self] = .init(dataSourceURL: "")
        }

        var dataSourceURL: String {
            self.storage.dataSourceURL
        }

        func use(dataSourceURL: String) {
            self.application.storage[Key.self] = .init(dataSourceURL: dataSourceURL)
        }

        // See https://developers.google.com/youtube/v3/docs/channels/list#parameters
        // for more information about the maxResults
        var maxResultsPerPage: Int {
            50
        }

        var baseURL: String {
            "https://www.googleapis.com/youtube/v3/channels"
        }

        func fetchChannels() async throws -> [Channel] {
            var lastPage = false
            var items: [Channel] = []
            let perPage = 100
            while !lastPage {
                let request = try await self.application.client
                    .get(URI(string: self.dataSourceURL)) { req in 
                        try req.query.encode([
                            "page": items.count / perPage + 1, 
                            "per": perPage
                        ])
                    }
                let page = try request.content.decode(Page<Channel>.self)
                items.append(contentsOf: page.items.filter { $0.platform == .youtube })
                lastPage = page.metadata.pageCount == page.metadata.page
            }
            return items
        }

        func fetchYouTubeStatistics() async throws -> [YouTubeChannelItemResponse] {
            let channelIDs = try await self.fetchChannels().map { $0.channelID }
            let q = channelIDs.count / maxResultsPerPage
            var items: [YouTubeChannelItemResponse] = []
            for i in 0 ... q {
                let from = i * maxResultsPerPage
                let _to = (i + 1) * maxResultsPerPage
                let to: Int
                if _to > channelIDs.count {
                    to = channelIDs.count
                } else {
                    to = _to
                }
                let ytRawResponse = try await self.application.client
                    .get(URI(string: baseURL)) { outgoingReq in
                        try outgoingReq.query.encode(
                            YouTubeChannelsRequest(
                                id: channelIDs[from ..< to].joined(separator: ","),
                                part: "id,statistics",
                                maxResults: maxResultsPerPage,
                                key: self.application.googleAPI.key
                            )
                        )
                    }
                let parsedResponse = try ytRawResponse.content.decode(YouTubeChannelsResponse.self)
                items.append(contentsOf: parsedResponse.items)
            }
            return items
        }

        func syncYouTubeStatistics() async throws {
            let youTubeStatistics = try await self.fetchYouTubeStatistics() as [YouTubeStatistic]
            try await youTubeStatistics.store(on: self.application.db, logger: self.application.logger)
        }

    }

    var youTubeStatistics: YouTubeStatistics {
        .init(application: self)
    }
    
}
