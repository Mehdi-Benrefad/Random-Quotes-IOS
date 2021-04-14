//
//  QuoteService.swift
//  Random-Quotes-IOS
//
//  Created by Mehdi Benrefad on 14/04/2021.
//  Copyright © 2021 Mehdi Benrefad. All rights reserved.
//

import Foundation

class QuoteService {
    //url de l'api
    private static let quoteUrl = URL(string: "https://api.forismatic.com/api/1.0/")!
    private static let pictureUrl = URL(string: "https://source.unsplash.com/random/1000x1000")!
    //voici la fonction getquote qui nou permet de recuperer une citation et de communiquer avec le controlleur a travers un callback (fonction passee en parametres)
    
    static func getQuote(callback: @escaping (Bool, Quote?) -> Void) {
        
        //on cree un objet request parametre a l'ade de la fonctioncreateQuoteRequest declaree en bas
        let request = createQuoteRequest()
        
        /*Lancement de la tache*/
        //on cree un urlsession avec une configuratiopn par defaut
        // la session va creer une nouvelle queu (abstraction de threde) on n'est plus dans la mainQueu
        let session = URLSession(configuration: .default)
        //maitenant on cree notre tache en lui passant la requette et ule clossure qui contient le traitement a effectuer
        let task = session.dataTask(with: request) { (data, response, error) in

            //on revient a la Queu principale (Main Queu)
            DispatchQueue.main.async {
                
                //on teste si on a recu des donnees et si on n'apas d'erreurs
                if let data = data, error == nil {
                    //on teste si la reponse est sous la forme httpurlresponse et on teste aussi si la requete a reussit (statu==200)
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                         //on decode la reponse => on la transforme du format json incomrehensible par suift en un dictionnare swift
                        if let responseJSON = try? JSONDecoder().decode([String: String].self, from: data),
                            let text = responseJSON["quoteText"],
                            let author = responseJSON["quoteAuthor"] {
                                getImage { (data) in
                                if let data = data {
                                    let quote = Quote(text: text, author: author, imageData: data)
                                    callback(true, quote)
                                    print(data)
                                    print(text)
                                    print(author)
                                }else{ callback(false,nil) }
                            }
                        }else{ callback(false,nil) }
                        
                    }else{ callback(false,nil) }
                    
                }else{ callback(false,nil) }
                
            }
            
        }
        
        //on lance l'appel de la tache
        task.resume()
    }

    private static func createQuoteRequest() -> URLRequest {
        //on cree un objet url request et on lui passe l'url de l'api dectare en haut
        var request = URLRequest(url: quoteUrl)
        //on ajoute la methode a la requette
        request.httpMethod = "POST"
        //on ajoute le corps de la requette
        let body = "method=getQuote&lang=en&format=json"
        request.httpBody = body.data(using: .utf8)

        return request
    }

    private static func getImage(completionHandler: @escaping ((Data?) -> Void)) {
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: pictureUrl) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data, error == nil {
                    if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                        completionHandler(data)
                    }else{ completionHandler(nil)}
                    
                }else{ completionHandler(nil)}
                
            }
            
            
        }
        task.resume()
    }
}
