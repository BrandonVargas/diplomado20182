//: Playground - noun: a place where people can play

import UIKit

class Empleado {
    var sueldo: Float {
        willSet {
            if(newValue > 0) {
                if(newValue < descuentos) {
                    print("No puedes descontar mas del sueldo")
                } else {
                    print("Sueldo restante \(newValue - descuentos)")
                }
            } else {
                print("No puedes tener sueldo negativo")
            }
        }
    }
    var descuentos: Float {
        willSet {
            if(newValue > 0) {
                if(newValue > sueldo) {
                    print("No puedes descontar mas del sueldo")
                } else {
                    print("Sueldo restante \(sueldo - newValue)")
                }
            } else {
                print("No puedes tener descuentos negativo")
            }
        }
    }
    
    init(sueldo: Float, descuentos: Float) {
        self.sueldo = sueldo
        self.descuentos = descuentos
    }
}

var empleado = Empleado(sueldo: 1200, descuentos: 1000)

empleado.descuentos = 500
empleado.sueldo = 2000
empleado.descuentos = 2500
empleado.sueldo = -100
empleado.descuentos = -1
