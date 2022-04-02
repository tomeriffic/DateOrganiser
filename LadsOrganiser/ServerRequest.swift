//
//  ServerRequest.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 17/03/2022.
//

import Foundation

let serverURL: String = "https://hrgb5lfg8h.execute-api.eu-west-2.amazonaws.com/dev"

func AWSStoreVote(eventId: String, id: String, vote: String){
    
    let s = serverURL + "/vote/\(eventId)/\(id)/\(vote)"
    
    let url = URL(string: s)!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard
            error == nil,
            let data = data,
            let string = String(data: data, encoding: .utf8)
        else {
            print(error ?? "Unknown error")
            return
        }

        print(string)
    }
    task.resume()
}

func AWSGetVotes(eventId: String) -> [Vote]{
    let url = URL(string: serverURL + "/vote/\(eventId)")!

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard
            error == nil,
            let data = data,
            let string = String(data: data, encoding: .utf8)
        else {
            print(error ?? "Unknown error")
            return
        }

        print(string)
    }
    task.resume()
    
    return [Vote()]
}

func AWSPatchVote(eventId: String, id: String, vote: String){
    let url = URL(string: serverURL + "/vote/\(eventId)/\(id)/\(vote)")!

    var request = URLRequest(url: url)
    request.httpMethod = "PATCH"

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard
            error == nil,
            let data = data,
            let string = String(data: data, encoding: .utf8)
        else {
            print(error ?? "Unknown error")
            return
        }

        print(string)
    }
    task.resume()
}

func AWSGetEvents(eventId: String) -> Event{
    var newEvent = Event()
    let url = URL(string: serverURL + "/event/\(eventId)")!

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        guard
            error == nil,
            let data = data as? Data,
            let string = String(data: data, encoding: .utf8)
            
        else {
            print(error ?? "Unknown error")
            return
        }

        print(string)
        do {
            if let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
                print(jsonArray) // use the json here
                let formatter = DateFormatter()
                formatter.dateFormat = DATE_FORMAT_AWS
                
                newEvent.id = UUID(uuidString: eventId)!
                newEvent.title = jsonArray[0]["title"] as! String
                newEvent.fromDate = formatter.date(from: jsonArray[0]["fromDate"] as! String)!
                newEvent.toDate = formatter.date(from: jsonArray[0]["toDate"] as! String)!
                newEvent.isWeekendOnly = jsonArray[0]["isWeekendOnly"] as! Bool
                
            } else {
                print("bad json")
            }
        }
        catch {
            
        }
        
    }
    task.resume()
    
    return newEvent
}

func AWSStoreEvent(event: Event){
    
    let formatter = DateFormatter()
    formatter.dateFormat = DATE_FORMAT_AWS
    
    let s = serverURL + "/event/\(event.id)"
    let parameters = [
        "title": event.title,
        "fromDate": formatter.string(from: event.fromDate),
        "toDate": formatter.string(from: event.toDate),
        "isWeekendOnly": event.isWeekendOnly
    ] as [String : Any]
    
    let url = URL(string: s)!

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to data object and set it as request body
    } catch let error {
        print(error.localizedDescription)
    }

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard
            error == nil,
            let data = data,
            let string = String(data: data, encoding: .utf8)
        else {
            print(error ?? "Unknown error")
            return
        }

        print(string)
    }
    task.resume()
}
