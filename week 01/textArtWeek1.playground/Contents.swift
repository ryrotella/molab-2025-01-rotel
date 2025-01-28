import Cocoa
import Foundation

//"Vehicles", emojis: "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜")
//"Sports", emojis: "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳")
//"Music", emojis: "🎼🎤🎹🪘🥁🎺🪗🪕🎻")
//"Animals", emojis: "🐥🐣🐂🐄🐎🐖🐏🐑🦙🐐🐓🐁🐀🐒🦆🦅🦉🦇🐢🐍🦎🦖🦕🐅🐆🦓🦍🦧🦣🐘🦛🦏🐪🐫🦒🦘🦬🐃🦙🐐🦌🐕🐩🦮🐈🦤🦢🦩🕊🦝🦨🦡🦫🦦🦥🐿🦔")
//"Animal Faces", emojis: "🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲")
//"Flora", emojis: "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻")
//"Weather", emojis: "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪")
//"COVID", emojis: "💉🦠😷🤧🤒")
//"Faces", emojis: "😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠")

let vehicles = "🚙🚗🚘🚕🚖🏎🚚🛻🚛🚐🚓🚔🚑🚒🚀✈️🛫🛬🛩🚁🛸🚲🏍🛶⛵️🚤🛥🛳⛴🚢🚂🚝🚅🚆🚊🚉🚇🛺🚜"
//let sports = "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳"
let animalSportsFloraWeather = "🏈⚾️🏀⚽️🎾🏐🥏🏓⛳️🥅🥌🏂⛷🎳🐵🙈🙊🙉🐶🐱🐭🐹🐰🦊🐻🐼🐻‍❄️🐨🐯🦁🐮🐷🐸🐲🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻"
//let flora = "🌲🌴🌿☘️🍀🍁🍄🌾💐🌷🌹🥀🌺🌸🌼🌻"
let weatherFaces = "☀️🌤⛅️🌥☁️🌦🌧⛈🌩🌨❄️💨☔️💧💦🌊☂️🌫🌪😀😃😄😁😆😅😂🤣🥲☺️😊😇🙂🙃😉😌😍🥰😘😗😙😚😋😛😝😜"
let faces = "🤪🤨🧐🤓😎🥸🤩🥳😏😞😔😟😕🙁☹️😣😖😫😩🥺😢😭😤😠😡🤯😳🥶😥😓🤗🤔🤭🤫🤥😬🙄😯😧🥱😴🤮😷🤧🤒🤠"

let emojis = [vehicles, animalSportsFloraWeather, weatherFaces, faces]

let nameHeight: Int = 6
let nameWidth: Int = 39

func charAt(_ str:String, _ offset:Int) -> String {
    let index = str.index(str.startIndex, offsetBy: offset)
    let char = str[index]
    return String(char)
}

func emojiName() {
    for i in 1...nameHeight{
        for j in 1...nameWidth{
            
            //first row - only builds top of R shape
            if (i == 1
                && j < 7
            )
            {
                var randomTop = Int.random(in: 0..<vehicles.count)
                guard var randomString = emojis.randomElement() else { return }
                print(charAt(randomString, randomTop), terminator: "")
            } else if (i == 2){
                //&& [1, 9, 14, 18, 25, 26, 33, 34, 39].contains(j)
                
                switch j {
                    //R    //Y      //A     //N
                case 1, 11, 15, 19, 25, 26, 33, 34, 39:
                    var randomTop = Int.random(in: 0..<vehicles.count)
                    guard var randomString = emojis.randomElement() else { return }
                    print(charAt(randomString, randomTop), terminator: "")
                default:
                    print(" ", terminator: "")
                }
                
            } else if (i == 3){
                //note: space indexes get messed up when emojis are used; even though emoji takes up multiple empty spaces, it counts as one space when typed
                switch j {
                    //R             //Y      //A     //N
                case 1, 2, 3, 4, 5, 6, 11, 13, 19, 23, 28, 30, 34:
                    var randomTop = Int.random(in: 0..<vehicles.count)
                    guard var randomString = emojis.randomElement() else { return }
                    print(charAt(randomString, randomTop), terminator: "")
                default:
                    print(" ", terminator: "")
                }
            } else if (i == 4){
                switch j {
                    //R    //Y      //A         //N
                case 1, 9, 17, 23, 24, 25,26,27, 31, 34, 37:
                    var randomTop = Int.random(in: 0..<vehicles.count)
                    guard var randomString = emojis.randomElement() else { return }
                    print(charAt(randomString, randomTop), terminator: "")
                    
                default:
                    print(" ", terminator: "")
                }
            }else if (i == 5){
                switch j {
                    //R    //Y      //A     //N
                case 1, 9, 17, 23, 30, 34, 37, 38, 39:
                    var randomTop = Int.random(in: 0..<vehicles.count)
                    guard var randomString = emojis.randomElement() else { return }
                    print(charAt(randomString, randomTop), terminator: "")
                    
                default:
                    print(" ", terminator: "")
                }
            } else if (i == 6){
                switch j {
                    //R    //Y      //A     //N
                case 1, 9, 17, 23, 30, 34, 37, 38, 39:
                    var randomTop = Int.random(in: 0..<vehicles.count)
                    guard var randomString = emojis.randomElement() else { return }
                    print(charAt(randomString, randomTop), terminator: "")
                    
                default:
                    print(" ", terminator: "")
                }
            }
        }
        print()
    }
}
 
emojiName()
//function that produces a multi-line string of my name spelled out in random emojis


//  """
//  1234567890123456789012345678901234567890
//  ________
//  |       |    \   /      /\      |\    |
//  |_______|     \ /      /  \     | \   |
//  |\\            |      /----\    |  \  |
//  |  \\          |     /      \   |   \ |
//  |    \\        |    /        \  |    \|
//
//  ________
//  """


///row 1 - all underscore for top of R
///row 2 -
///row 3-
///row 4
///row5
///row 6 - end of first name
///row 7 -space
///row 8 - all underscore for top of R - last name
///9
///10
///11
///12
///13
