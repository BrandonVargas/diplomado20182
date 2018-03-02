//: Playground - noun: a place where people can play

import UIKit

//: Optionals

var variable: String?

variable = nil

variable?.sorted()

variable = "hola"

variable!.sorted()

//: Optional binding

if let saludo = variable {
    print("Saludo \(saludo)")
} else {
    print("No hay nada prro")
}

func saludos(cadena: String?) {
    guard cadena != nil else {
        print("Algo paso")
        return
    }
    
    print("No paso nada")
}

saludos(cadena: variable)

//: NIL coalescing

var edad: Int? = nil //22
var edadValida = edad ?? 18
print(edadValida)
