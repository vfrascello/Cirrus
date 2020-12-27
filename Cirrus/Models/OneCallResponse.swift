struct OneCallResponse: Decodable {
    
    let current: CurrentConditions
    let daily: [DailyForecast]
    
}

struct CurrentConditions: Decodable {
    
    let temp: Double
    let feelsLike: Double
    let conditionDescription: [ConditionDecription]
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case conditionDescription = "weather"
    }
}

struct ConditionDecription: Decodable {
    
    let description: String
    
}
struct DailyForecast: Decodable {
    
    let epochDate: Int
    let tempRange: TemperatureRange
    
    enum CodingKeys: String, CodingKey{
        case epochDate = "dt"
        case tempRange = "temp"
    }
}

struct TemperatureRange: Decodable {
    let min, max: Double
}
