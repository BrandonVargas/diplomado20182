//: [Previous](@previous)
import UIKit

var escudos = 5
var balasDispardas = 0
var armaSobrCalentada = false
var limiteBalas = 10

func jugar() {
    while escudos > 0 {
        shoot()
    }
    print("Game over")
}

func shoot() {
    if (balasDispardas < limiteBalas) {
        balasDispardas += 1
        print("disparo ", balasDispardas)
    } else {
        overheatWeapon()
    }
}

func overheatWeapon() {
    escudos -= 1
    armaSobrCalentada = true
    print("Arma sobrecalentada")
    print("Perdiste un escudo - ", escudos)
    sleep(1)
    balasDispardas = 0
    armaSobrCalentada = false
}

jugar()

//: [Next](@next)
