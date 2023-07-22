import Fluent


struct CreateYouTubeStatistics: AsyncMigration {

    func prepare(on database: Database) async throws {
        try await database.schema("youtube_statistics")
            .id()
            .field("channel_id", .string, .required)
            .field("view_count", .int, .required)
            .field("subscriber_count", .int, .required)
            .field("hidden_subscriber_count", .bool, .required)
            .field("video_count", .int, .required)
            .field("date", .date, .required)
            .field("created_at", .datetime)
            .create()
    }

    func revert(on database: Database) async throws {
        try await database.schema("youtube_statistics").delete()
    }

}
