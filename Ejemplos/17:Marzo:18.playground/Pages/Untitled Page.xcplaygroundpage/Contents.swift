//: [Previous](@previous)

import Foundation

class Alumno {
    var numCuenta: Int
    
    init(numCuenta: Int) {
        self.numCuenta = numCuenta
    }
}

class Ingeniero: Alumno {
    var promedio: Double = 0.0
    var status: Bool
    
    init(numCuenta: Int, promedio: Double) {
        self.promedio = promedio
        status = true
        super.init(numCuenta: numCuenta)
    }
}

protocol Evaluable {
    func examinar(calif: Double) -> String
}

extension Ingeniero: Evaluable {
    func examinar(calif: Double) -> String {
        if(calif > 5) {
            return "Aprobado"
        } else {
            return "Reprobado"
        }
    }

}

let inge = Ingeniero(numCuenta: 12, promedio: 7.0)
print(inge.examinar(calif: inge.promedio))

//: [Next](@next)
