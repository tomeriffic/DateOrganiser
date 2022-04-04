//
//  ServerRequest.swift
//  LadsOrganiser
//
//  Created by Tomas Pilvelis on 17/03/2022.
//

import Foundation

let serverURL: String = "https://hrgb5lfg8h.execute-api.eu-west-2.amazonaws.com/dev"

class AWSServices{

    static let shared = AWSServices()

    func AWSGetEvents(eventId: String, completion: @escaping (Result<Event, Error>) -> Void){
        var newEvent = Event()
        let url = URL(string: serverURL + "/event/\(eventId)")!

        /*let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                return
            }
            
            guard let data = data else {return}
            
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
            catch let jsonErr {
                print(jsonErr)
            }
        }
        task.resume()*/
        
        
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let httpResponse = response as? HTTPURLResponse {
                print("API Status: \(httpResponse.statusCode)")
            }
            
            guard let validData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                if let jsonArray = try JSONSerialization.jsonObject(with: validData, options : .allowFragments) as? [Dictionary<String,Any>]
                {
                    print(jsonArray) // use the json here
                    let formatter = DateFormatter()
                    formatter.dateFormat = DATE_FORMAT_AWS
                    
                    newEvent.id = UUID(uuidString: eventId)!
                    newEvent.title = jsonArray[0]["title"] as! String
                    newEvent.fromDate = formatter.date(from: jsonArray[0]["fromDate"] as! String)!
                    newEvent.toDate = formatter.date(from: jsonArray[0]["toDate"] as! String)!
                    newEvent.isWeekendOnly = jsonArray[0]["isWeekendOnly"] as! Bool
                    
                    completion(.success(newEvent))
                    
                } else {
                    print("bad json")
                }
            }
            catch let jsonError {
                completion(.failure(jsonError))
            }
        }.resume()
    }
}

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
