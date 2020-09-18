//
//  MapPath.swift
//  UberCook
//
//  Created by Kira on 2020/9/18.
//

 struct MapPath : Decodable{
    var routes : [Route]?
}

 struct Route : Decodable{
    var overview_polyline : OverView?
}

 struct OverView : Decodable {
    var points : String?
}
