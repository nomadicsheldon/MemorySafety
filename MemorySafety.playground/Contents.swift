import UIKit

// Understanding conflicting access to memory

// write access
var one = 1

// read access
print("we're number \(one)!")

// Characterstics of Memory Access

/*
A conflict occurs if you have two accesses that meet all of the following conditions:
 * Atleast one is a write access
 * They access the same location in the memory
 * Their duration overlap.
  
*/

// instantaneous
func oneMore(than number: Int) -> Int {
    return number + 1
}

var myNumber = 1
myNumber = oneMore(than: myNumber)
print(myNumber)

//------------------------------------------------------------------------------------------//
// Conflicting access to In-Out Parameters

var stepsize = 1
func increment(_ number: inout Int) {
    number += stepsize
}

//increment(&stepsize) // Code with crash because of read write overlap.

// one way to solve this
var copyOfStepSize = stepsize
increment(&copyOfStepSize)

stepsize = copyOfStepSize

// other example of conflict
func balance(_ x: inout Int, _ y: inout Int) {
    let sum = x + y
    x = sum / 2
    y = sum - x
}

var playerOneScore = 42
var playerTwoScore = 30
balance(&playerOneScore, &playerTwoScore)
//balance(&playerOneScore, &playerOneScore) // it will crash here

//------------------------------------------------------------------------------------------//
// Conflicting Access to self in methods

struct Player {
    var name: String
    var health: Int
    var energy: Int
    
    static let maxHealth = 10
    
    mutating func restoreHealth() {
        health = Player.maxHealth
    }
}

extension Player {
    mutating func shareHealth(with teammate: inout Player) {
        balance(&teammate.health, &health)
    }
}

var himanshu = Player(name: "Himanshu", health: 10, energy: 10)
var shivanshu = Player(name: "Shivanshu", health: 5, energy: 10)
himanshu.shareHealth(with: &shivanshu)

//himanshu.shareHealth(with: &himanshu) // it will not allow because of write and write overlap

//------------------------------------------------------------------------------------------//
// Conflicting access to properties

var playerInformation = (health: 10, energy: 20)
//balance(&playerInformation.health, &playerInformation.energy) // there are two write accesses required for property of a structure

var aman = Player(name: "Aman", health: 10, energy: 10)
// balance(&aman.health, &aman.energy) // it will crash here because of overlapping access to stored property because of global, make it local to work it properly

func someFunction() {
    var himanshu = Player(name: "Himanshu", health: 10, energy: 10)
    balance(&himanshu.energy, &himanshu.health)
    
}
