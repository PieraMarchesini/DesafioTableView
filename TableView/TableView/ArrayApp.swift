//
//  ArrayApp.swift
//  TableView
//
//  Created by Piera Marchesini on 11/04/17.
//  Copyright © 2017 Piera Marchesini. All rights reserved.
//

import Foundation

public class ArrayApp{
    
    //Instancializa um Array de Apps
    var apps: [App] = [App(foto: "facebook.png", nome: "Facebook", categoria: "Social"), App(foto: "instagram.png", nome: "Instagram", categoria: "Social"), App(foto: "messenger.png", nome: "Messenger", categoria: "Comunicação"), App(foto: "snapchat.png", nome: "Snapchat", categoria: "Social"), App(foto: "spotify.png", nome: "Spotify", categoria: "Entretenimento"), App(foto: "uber.png", nome: "Uber", categoria: "Transporte"), App(foto: "whatsapp.png", nome: "WhatsApp", categoria: "Comunicação"), App(foto: "youtube.png", nome: "Youtube", categoria: "Entretenimento")]
    
    
    //Singleton da instância
    static let instance = ArrayApp()
    
    
    //Possibilita mudar o index de um App dentro do Array inicializado
    public func changeIndex(index: Int, app: App){
        apps[index] = app
    }
}
