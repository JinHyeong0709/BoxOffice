//
//  Movie.swift
//  BoxOffice
//
//  Created by 김진형 on 04/12/2018.
//  Copyright © 2018 JinHyeongKim. All rights reserved.
//

import Foundation

//movielist
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
        return "평점 : \(self.userRating) 예매율 : \(self.reservationRate) 예매순위 : \(self.reservationGrade)"
    }
    
    var collectionViewInfoText: String {
        return "\(self.reservationGrade)위(\(self.userRating) / \(self.reservationRate)%"
    }
    
    enum CodingKeys: String, CodingKey {
        case grade, thumb, title, date, id
        case reservationGrade = "reservation_grade"
        case reservationRate = "reservation_rate"
        case userRating = "user_rating"
    }
}

//detail
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

//comment
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


//{"duration":139,"image":"http://movie.phinf.naver.net/20171201_181/1512109983114kcQVl_JPEG/movie_image.jpg","genre":"판타지, 드라마","director":"김용화","actor":"하정우(강림), 차태현(자홍), 주지훈(해원맥), 김향기(덕춘)","audience":11676822,"date":"2017-12-20","reservation_grade":1,"user_rating":7.98,"id":"5a54c286e8a71d136fb5378e","grade":12,"synopsis":"저승 법에 의하면, 모든 인간은 사후 49일 동안 7번의 재판을 거쳐야만 한다. 살인, 나태, 거짓, 불의, 배신, 폭력, 천륜 7개의 지옥에서 7번의 재판을 무사히 통과한 망자만이 환생하여 새로운 삶을 시작할 수 있다. \n\n “김자홍 씨께선, 오늘 예정 대로 무사히 사망하셨습니다” \n\n화재 사고 현장에서 여자아이를 구하고 죽음을 맞이한 소방관 자홍, 그의 앞에 저승차사 해원맥과 덕춘이 나타난다.\n자신의 죽음이 아직 믿기지도 않는데 덕춘은 정의로운 망자이자 귀인이라며 그를 치켜세운다.\n저승으로 가는 입구, 초군문에서 그를 기다리는 또 한 명의 차사 강림, 그는 차사들의 리더이자 앞으로 자홍이 겪어야 할 7개의 재판에서 변호를 맡아줄 변호사이기도 하다.\n염라대왕에게 천년 동안 49명의 망자를 환생시키면 자신들 역시 인간으로 환생시켜 주겠다는 약속을 받은 삼차사들, 그들은 자신들이 변호하고 호위해야 하는 48번째 망자이자 19년 만에 나타난 의로운 귀인 자홍의 환생을 확신하지만, 각 지옥에서 자홍의 과거가 하나 둘씩 드러나면서 예상치 못한 고난과 맞닥뜨리는데…\n\n누구나 가지만 아무도 본 적 없는 곳, 새로운 세계의 문이 열린다!","title":"신과함께-죄와벌","reservation_rate":35.5}
