//: [Previous](@previous)

import Foundation

//: Dictionaries
var dictionary = ["Pedro":18, "Ana":20, "Lola":32]
print(dictionary["Lola"]! as Int)

var alumnos: [String:Int] = [:]
alumnos.isEmpty
alumnos.count

var perfil = [
    "nombre": "Brandon",
    "carrera": "Compu"
]

perfil.updateValue("CDMX", forKey: "Estado")
print(perfil)

perfil["Edad"] = "18"
print(perfil)

perfil.removeValue(forKey: "Edad")
print(perfil)

perfil["Estado"] = nil

print(perfil)

for (llave, valor) in perfil {
    print("\(llave) - \(valor)")
}

for (llave, valor) in perfil {
    print("\(llave), ", terminator:"")
}

//: [Next](@next)
