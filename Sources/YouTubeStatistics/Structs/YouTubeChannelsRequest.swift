struct YouTubeChannelsRequest {
    
    let id: String
    
    let part: String
    
    let maxResults: Int

    let key: String
    
}


extension YouTubeChannelsRequest: Codable { }
