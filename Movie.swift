//
//  Movie.swift
//  BoxOffice
//
//  Created by 김진형 on 04/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import Foundation

//MARK:- Movielist
struct OfficeBox: Codable {
    let movies: [Movie]
}

struct Movie: Codable {
    let grade: Int
    let thumb: String
    let reservationGrade: Int
    let title: String
    let reservationRate: Double
    let userRating: Double
    let date: String
    let id: String
    
    var tableViewInfoText: String {
        return "평점 : \(self.userRating) 예매율 : \(self.reservationRate)% 예매순위 : \(self.reservationGrade)위"
    }
    
    var collectionViewInfoText: String {
        return "\(self.reservationGrade)위(\(self.userRating) / \(self.reservationRate)%)"
    }
    
    enum CodingKeys: String, CodingKey {
        case grade, thumb, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}

//MARK:- Detail
struct OfficeInfo: Codable {
    let movieInfo: [MovieInfo]
}

struct MovieInfo: Codable {
        let audience: Int
        let actor: String
        let duration: Int
        let director: String
        let synopsis: String
        let genre: String
        let grade: Int
        let image: String
        let reservationGrade: Int
        let title: String
        let reservationRate: Double
        let userRating: Double
        let date: String
        let id: String
        
        enum CodingKeys: String, CodingKey {
            case audience, actor, duration, director, synopsis, genre, grade, image, title, date, id
            case reservationGrade = "reservation_grade"
            case reservationRate = "reservation_rate"
            case userRating = "user_rating"
        }
}

//MARK:- Comments
struct ComentsInfo: Codable {
    let comments: [Comment]
}
    struct Comment: Codable {
    let rating: Double
    let timestamp: Double
    let writer : String
    let movieId : String
    let contents: String
    
    enum CodingKeys: String, CodingKey {
        case rating, timestamp, writer, contents
        case movieId = "movie_id"
    }
}
