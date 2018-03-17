//: Playground - noun: a place where people can play

import UIKit

struct Cuerpo {
    var altura: Double = 0 //Propiedades con almacenamiento y valor por default
    var peso: Double = 0
}

var cuerpo = Cuerpo()
cuerpo.altura = 1.85
cuerpo.peso = 80.0

var cuerpo2 = cuerpo

cuerpo.altura = 2.0
cuerpo2

