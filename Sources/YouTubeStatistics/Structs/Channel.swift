import Vapor


struct Channel {

    var channelID: String

    var platform: Platform

    var name: String

}


extension Channel: Content { }


extension Channel: Codable { }


enum Platform: String, Codable {

    case youtube = "YouTube"

    case twitch = "Twitch"

}
