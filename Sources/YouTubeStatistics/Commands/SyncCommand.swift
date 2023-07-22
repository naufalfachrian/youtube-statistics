import FluentSQL
import Vapor


struct SyncCommand: Command {

    var help: String = "Sync data from YouTube Channels API"

    struct Signature: CommandSignature { }

    func run(using context: CommandContext, signature: Signature) throws {
        let promise = context
            .application
            .eventLoopGroup
            .next()
            .makePromise(of: Void.self)
        promise.completeWithTask {
            try await self.run(using: context, signature: signature)
        }
        try promise.futureResult.wait()
    }

}


extension SyncCommand {

    func run(using context: CommandContext, signature: Signature) async throws {
        try await context.application.youTubeStatistics.syncYouTubeStatistics()
    }

}