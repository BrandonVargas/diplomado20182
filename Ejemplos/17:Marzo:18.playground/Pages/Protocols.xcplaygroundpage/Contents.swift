//: [Previous](@previous)

import Foundation

protocol Vehiculo {
    func acelerar()
    func frenar()
}

protocol Pintura {
    func  colorear()
}

protocol Tuning: Vehiculo {
    func rines(tipo: String)
}

class Motito: Vehiculo, Pintura {
    var wheels: Int {
        get {
            return 2
        }
    }
    
    func acelerar() {
        print("Acelerar...")
    }
    
    func frenar() {
        print("Frenar...")
    }
    
    func  colorear() {
        print("Colorear...")
    }
}

class RapidoYFurioso: Tuning {
    
    func rines(tipo: String) {
        
    }
    
    func acelerar() {
        print("Toreto Acelerar...")
    }
    
    func frenar() {
        print("Toreto Frenar...")
    }
}

protocol Reflexion {
    var tipoReflexion: String { get }
}

extension String: Reflexion {
    var tipoReflexion: String {
        return "Muy pensativo el dia de hoy"
    }
}

let palabrita = "Hola mundo"
palabrita.tipoReflexion

//: [Next](@next)
