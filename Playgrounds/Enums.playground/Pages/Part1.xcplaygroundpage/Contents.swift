//: Playground - noun: a place where people can play

import UIKit

enum Dia {
    case Lunes
    case Martes
    case Miercoles
    case Jueves
    case Viernes
}

var diaSemana: Dia

diaSemana = .Lunes

switch diaSemana {
case .Lunes:
    print("Otra vez a trabajar :c")
case .Martes:
    print("Ya quiero que acabe la semana")
case .Miercoles:
    print("Apenas vamos a la mitad")
case .Jueves:
    print("Ya casi es fin de semana")
case .Viernes:
    print("Por fin es viernes!")
}
