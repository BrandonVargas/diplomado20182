//: Playground - noun: a place where people can play

import UIKit

class Alumno {
    var numCuenta: String = ""
    var nombre: String = ""
    var edad: Int {
        willSet {
            print("Edad: \(edad)")
            print("Nuevo valor: \(newValue)")
        }
        didSet {
            print("Edad: \(edad)")
            print("Valor antiguo: \(oldValue)")
        }
    }
    
    init(nombre:String, numCuenta: String) {
        self.nombre = nombre
        self.numCuenta = numCuenta
        self.edad = 0
    }
    
    func nombreCuenta() -> String {
        return nombre + "/"  + numCuenta
     }
}

class Ingenieria: Alumno {
    override func nombreCuenta() -> String {
        return nombre + "//" + numCuenta
    }
}

class Contaduria: Alumno {
    override func nombreCuenta() -> String {
        return nombre + "#" + numCuenta
    }
}

let alumno = Alumno(nombre: "alumno", numCuenta: "111")
let alumnoIng = Ingenieria(nombre: "alumnoIng", numCuenta: "222")
let alumnoCont = Contaduria(nombre: "alumnoCont", numCuenta: "333")

print(alumno.nombreCuenta())
print(alumnoIng.nombreCuenta())
print(alumnoCont.nombreCuenta())

alumno.edad = 26


struct Profesor {
    var numEmpleo: String
}

//var marduk = Profesor(numEmpleo: "000000")
//var parrita = Alumno(numCuenta: "1111111")

//var german = parrita

//german.numCuenta = "2222222"

//parrita.numCuenta

