//
//  Pokemon.swift
//  pokedex-by-devslopes
//
//  Created by Felipe Soares on 23/03/16.
//  Copyright © 2016 Felipe Soares. All rights reserved.
//

import Foundation
import Alamofire

class Pokemon {
    private var _name:String!
    private var _pokedexId:Int!
    private var _description:String!
    private var _type:String!
    private var _defense:String!
    private var _height:String!
    private var _weight:String!
    private var _attack:String!
    private var _nextEvolutionTxt:String!
    private var _nextEvolutionId:String!
    private var _nextEvolutionLvl:String!
    private var _pokemonURL: String!
    
    var nextEvolutionTxt:String{
        if _nextEvolutionTxt == nil{
            return ""
        }
        return _nextEvolutionTxt
    }
    
    var nextEvolutionId:String{
        if _nextEvolutionId == nil{
            return ""
        }
        return _nextEvolutionId
    }
    
    var nextEvolutionLvl:String{
        get{
            if _nextEvolutionLvl == nil{
                return ""
            }
            return _nextEvolutionLvl
        }
    }
    
    var description:String{
        if _description == nil{
            return ""
        }
        return _description
    }
    
    var type:String{
        if _type == nil{
            return ""
        }
        return _type
    }
    
    var defense:String{
        if _defense == nil{
            return ""
        }
        return _defense
    }
    
    var height:String{
        if _height == nil{
            return ""
        }
        return _height
    }
    
    var weight:String{
        if _weight == nil{
            return ""
        }
        return _weight
    }
    
    var attack:String{
        if _attack == nil{
            return ""
        }
        return _attack
    }
    
    var name:String{
        return _name
    }
    
    var pokedexId:Int{
        return _pokedexId
    }
    
    init(name:String, pokedexId:Int){
        self._name = name
        self._pokedexId = pokedexId
        
        _pokemonURL = "\(URL_BASE)\(URL_POKEMON)\(self._pokedexId)/"
    }
    
    func downloadPokemonDetails(completed: DownloadComplete){
        
        let url = NSURL(string: _pokemonURL)!
        Alamofire.request(.GET, url).responseJSON { (response) in
            let result = response.result
            print(result.debugDescription)
            
            if let dict = result.value as? Dictionary<String, AnyObject>{
                
                if let weight = dict["weight"] as? String{
                    self._weight = weight
                }
                
                if let height = dict["height"] as? String{
                    self._height = height
                }
                
                if let attack = dict["attack"] as? Int{
                    self._attack = "\(attack)"
                }
                
                if let defense = dict["defense"] as? Int{
                    self._defense = "\(defense)"
                }
                
                if let types = dict["types"] as? [Dictionary<String, String>] where types.count > 0{
                    
                    if let name = types[0]["name"]{
                        self._type = name.capitalizedString
                    }
                    
                    if types.count > 1{
                        var x = 1
                        repeat{
                            if let name = types[x]["name"]{
                                self._type! += "/\(name.capitalizedString)"
                            }
                            x = x + 1
                        }while x < types.count
                    }
                    print(types.debugDescription)
                }else{
                    self._type = ""
                }
                
                print(self._type)
                
                if let descArr = dict["descriptions"] as? [Dictionary<String, String>] where descArr.count > 0{
                    
                    if let url = descArr[0]["resource_uri"]{
                        let nsurl = NSURL(string: "\(URL_BASE)\(url)")!
                        Alamofire.request(.GET, nsurl).responseJSON(completionHandler: { (response) in
                            
                            let desResult = response.result
                            if let descDict = desResult.value as? Dictionary<String,AnyObject>{
                                if let description = descDict["description"] as? String{
                                    self._description = description
                                    print(self._description)
                                }
                            }
                            
                            completed()
                            
                        })
                    }
                    
                }else{
                    self._description = ""
                }
                
                if let evolutions = dict["evolutions"] as? [Dictionary<String,AnyObject>] where evolutions.count > 0{
                    
                    if let to = evolutions[0]["to"] as? String{
                        
                        //Can't support mega pokemon right now but
                        //api still has mega data
                        if to.rangeOfString("mega") == nil{
                            if let uri = evolutions[0]["resource_uri"] as? String{
                                let string_api = "/api/v1/pokemon/"
                                let newStr = uri.stringByReplacingOccurrencesOfString(string_api, withString: "")
                                
                                let num = newStr.stringByReplacingOccurrencesOfString("/", withString: "")
                                
                                self._nextEvolutionId = num
                                self._nextEvolutionTxt = to
                                
                                if let lvl = evolutions[0]["level"] as? Int{
                                    self._nextEvolutionLvl = "\(lvl)"
                                }
                                
                                print(self._nextEvolutionId)
                                print(self._nextEvolutionTxt)
                                print(self._nextEvolutionLvl)
                                
                            }
                        }
                        
                    }
                    
                }
                
            }
            
        }
        
    }
}