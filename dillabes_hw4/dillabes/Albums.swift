//
//  Albums.swift
//  dillabes
//
//  Created by Ryan Rotella on 2/23/25.
//


import SwiftUI
import UIKit


struct Album: Hashable {
    let name: String
    let imageLink: String
    var cover: UIImage = UIImage()
    let year: String
    let notes: String
    let trackList: [String]
    var audio: String = "blank"
    var artist: String = "blank"
    
//    init(name: String, imageLink: String, cover: UIImage, year: Int, notes: String, trackList: [String]) {
//        self.name = name
//        self.imageLink = imageLink
//        self.cover = cover
//        self.year = year
//        self.notes = notes
//        self.trackList = trackList
//    }
    
    mutating func changeCover(_ image : UIImage) {
        cover = image
    }
    
}

var modalSoul = Album(name: "Modal Soul",
                      imageLink: "https://i.discogs.com/vrRLAdjSll2Frd-Le6iDp4Od-tCsjidW1VnwzkV59h4/rs:fit/g:sm/q:90/h:600/w:600/czM6Ly9kaXNjb2dz/LWRhdGFiYXNlLWlt/YWdlcy9SLTMxNzgy/NjY4LTE3MzIxMzI2/NTQtMzU0OS5qcGVn.jpeg",
                     // cover: UIImage(systemName: "music.note")!,
                      year: "2005",
                      notes: """
On November 11, 2005, Hydeout Productions released Modal Soul, the second LP from the revered Japanese producer and instrumentalist Nujabes. Since its release Modal Soul has been enshrined in the canon of classic hip-hop, cherished by a dedicated following that is modest in number but unparalleled in passion. Nujabes is usually referenced as a hip-hop producer, but Modal Soul blends such disparate influences as to become a new, one-of-a-kind world music transcending all musical, physical or temporal boundaries. While each Nujabes project is a masterpiece in itself, Modal Soul is undoubtedly the producer's most dynamic and most popular effort. 


It’s not uplifting lyrical content or the producer’s technical virtuosity that distinguishes Modal Soul, though the album has both in spades. What distinguishes Modal Soul is its mood, its essence. Splicing together a beat and a piano sample is no longer revolutionary, though Nujabes, real name Seba Jun (February 7, 1974 – February 26, 2010), does so with a master’s grace. Flipping the samples and aligning the sound to make the listener feel with such great depth – that is the revelation of Modal Soul. If you don’t feel the music, that’s okay. But for those who do, it is healing sound.

- from https://www.therustmusic.net/rust-blog/2017/11/11/classic-albums-001-nujabes-modal-soul

""",
                      trackList: ["Feather (featuring Cise Starr & Akin)",
                 "Ordinary Joe (featuring Terry Callier)",
                 "Reflection Eternal",
                "Luv (Sic.) Part 3 (featuring Shing02)",
                "Music Is Mine",
                "Eclipse (featuring Substantial)",
               "The Sign (featuring Pase Rock)",
                "Thank You (featuring Apani B)",
                "World's End Rhapsody",
                  "Modal Soul (featuring Uyama Hiroto)",
                  "Flowers",
                  "Sea of Cloud",
                  "Light on the Land",
                   "Horizon"
                ],
                      audio: "modalSoul.mp3",
                      artist: "Nujabes"
                      )


var metaMus = Album(name: "Metaphorical Music",
                      imageLink: "https://m.media-amazon.com/images/I/91tIjOEyHGL._UF1000,1000_QL80_.jpg",
                     // cover: UIImage(systemName: "music.note")!,
                      year: "2003",
                      notes: """
Metaphorical Music is what I’d like to call the perfect upper. From start to finish the record is an unwinding euphoria trip. There’s just something awe-inducing about Nujabes’s approach to making beats. The traditionalistic boom bap infused with colorful, wavering, watery jazz is what makes me always come back for more. It’s a simple format, yet so damn effective. His sound is mellow, it’s melancholic, and it’s all too beautiful. The way the piano melody effortlessly flows through tracks with a simple yet enthralling boom bap beat hanging in the background in songs like “Blessing It” and “Kumomi”. The way the fast-paced and manic drumming passages on “Horn in the Middle” break into that iconic trumpet refrain. The way said trumpet refrain is followed by a small piano refrain. It’s all too engaging and hypnotic. The guitar loop on “Lady Brown” and the low key synth pattern on “Highs 2 Lows”. There’s just something innately down to Earth about these tracks. They feel as natural and blissful as a wave caressing your feet, or a summer breeze gracing your face.

- from https://www.sputnikmusic.com/review/72143/Nujabes-Metaphorical-Music/

""",
                      trackList: ["Blessing It Remix (Street Version) (Ft. Pase Rock & Substantial)",
                 "Horn in the Middle",
                 "Lady Brown (ft. Cise Starr)",
                "Kumomi",
                "Highs 2 Lows (ft. Cise Starr)",
                "Beat Laments the World",
               "Letters From Yokosuka",
                "Think Different (ft. Substantial)",
                "A Day by Atmosphere Supreme",
                  "Next View (featuring Uyama Hiroto)",
                  "Latitude (Nujabes Remix) by Five Deez",
                  "F.I.L.O (ft. Shing02)",
                  "Summer Gypsy",
                   "The Final View",
                   "Peaceland"
                ],
                    audio: "metaMus.mp3",
                    artist: "Nujabes"
                    )


var spirSt = Album(name: "Spiritual State",
                      imageLink: "https://m.media-amazon.com/images/I/61pB3CQ-XrS._UF1000,1000_QL80_.jpg",
                      //cover: UIImage(systemName: "music.note")!,
                      year: "2011",
                      notes: """
Spiritual State is Nujabes’ third and final studio album, released posthumously after his death in 2010.

Though it was released on December 3, 2011, in Japan, it wasn’t until three months later, in February 2012, that it was made available in the West.

For many fans, Spiritual State feels like an unfinished/rushed swan song.

In this case, Spiritual State was released by Hydeout Productions, Nujabes’ own record label.

Onto the record, in contrast to Nujabes’ smooth blends of Hip-Hop and Jazz music, Spiritual State feels more Jazz-oriented.

It is clear that this LP went in a different direction compared to Nujabes’ previous work, however, that doesn’t make me mad at all.

This is primarily due to the strong contribution of Japanese saxophonist, multi-instrumentalist, and producer Uyama Hiroto.



- from https://www.sputnikmusic.com/review/72143/Nujabes-Metaphorical-Music/

""",
                      trackList: ["Spiritual State (Ft. Uyama Hiroto)",
                 "Sky Is Tumbling (ft. Cise Starr)",
                 "Gone Are The Days (Ft. Uyama Hiroto)",
                "Spiral",
                "City Lights (ft. Pase Rock & Substantial)",
                "Color of Autumn",
               "Dawn On The Side",
                "Yes (ft. Pase Rock)",
                "Rainyway Back Home",
                  "Far Fowls",
                  "Fellows",
                  "Waiting For The Clouds (ft. Substantial)",
                  "Prayer",
                   "Island (Ft. haruka nakamura & Uyama Hiroto)"
                ],
                   audio: "spirSt.mp3",
                   artist: "Nujabes"

)

var donuts = Album(name: "Donuts",
                      imageLink: "https://m.media-amazon.com/images/I/913nQ96vc6L._UF1000,1000_QL80_.jpg",
                     // cover: UIImage(systemName: "music.note")!,
                      year: "2006",
                      notes: """
The role Donuts occupies is something more than the weight of its rep or impact-- or even the circumstances in which it was created, as hard as it is to separate the idea of the album's sound from the motivation of a prolific creator knowingly constructing his final work. 

As an album, it just gets deeper the longer you live with it, front-to-back listens revealing emotions and moods that get pulled in every direction: mournful nostalgia, absurd comedy, raucous joy, sinister intensity. 

There's all kinds of neat little tics and idiosyncrasies, pushing Dilla's early 00s beat-tape experiments and exchanges into compositions that tinker with Thelonious Monk's off-kilter timing and Lee Perry's warped fidelity. 

The songs on Donuts are like miniature lessons in how to take sample-based music and use it to build elaborate suites out of all those nagging little pieces of songs that stick with you long after you've last listened to them. 

There's little else in Dilla's catalog quite like it; at points, it sounds like he was busy quickly unlearning everything he'd taught himself just so he could have the experience of relearning it all again one last time.



- from Nate Patrin, https://pitchfork.com/reviews/albums/17510-donuts-45-box-set/

""",
                      trackList: [
                        "Donuts (Outro)",
                 "Workinonit",
                 "Waves",
                "Light My Fire",
                "The New",
                "Stop",
               "People",
                "The Diff'rence",
                "Mash",
                  "Time: The Donut of the Heart",
                  "Glazed",
                  "Airworks",
                  "Lightworks",
                   "Stepson Of The Clapper",
                    "The Twister (Huh, What)",
                 "One Eleven",
                 "Two Can Win",
                "Don't Cry",
                "Anti-American Graffiti",
                "Geek Down",
               "Thunder",
                "Gobstopper",
                "One For Ghost",
                  "Dilla Says Go",
                  "Walkinonit",
                  "The Factory",
                  "U-Love",
                   "Hi",
                    "Bye",
                    "Last Donut Of The Night",
                        "Welcome To The Show"
                        
                ],
                   audio: "donuts.mp3",
                   artist: "J Dilla"

)

var shining = Album(name: "The Shining",
                      imageLink: "https://f4.bcbits.com/img/0032067217_71.jpg",
                     // cover: UIImage(systemName: "music.note")!,
                      year: "2006",
                      notes: """
In this respect The Shining is the most compressed demonstration of J Dilla’s desire to break his own mould. Flipped soul samples sit alongside live keyboard and drum work-outs, a monster kazoo orchestra roars one minute and is later supplanted by a blissful piece of nu-soul. It may not have the water-tight continuity of Dilla’s untouchable Donuts, but it does show the creative daring of a producer super-charged with ideas, even during a period of significant ill-health.

At the time of Dilla’s death The Shining was incomplete. Karriem Riggins, producer and collaborator, stepped in to organise the album prior to its release. It is not surprising, in this respect, that the album seems rife with lacunae. Love Jones drifts through a few rounds of a keyboard riff, bolstered by horns, and feels non-committal. Over the Breaks is interesting as an example of Dilla’s enthusiasm for the keyboard sounds of seventies and eighties electronica, but it is unlikely to find its way onto any greatest hits playlist. When The Shining was first released, this didn’t matter so much. People were keen to understand the versatility of the producer, to explore it as part of a narrative growing up around him, and the record highlighted this. Ten years down the line, and the release of several other projects (most recently the King of Beats series, and The Diary) has only served to emphasise the unfinished nature of the album.

It is not a bad album, however, and there are a number of stand-out tracks, especially where efforts have been made to marry up the right vocalists to the right song. Pharoahe Monch offers an ecstatic performance over the magnificent Love, an example of Dilla’s ability to chop sampled material into a new and heart-full thing. So Far To Go is excellent, the blipping, peculiar melody and shuffling sounds interwoven by D’Angelo’s eerie backing vocal (in fact so good it saw two releases, as well as the instrumental originally appearing on Donuts). 

- from https://www.bonafidemag.com/reissue-review-j-dilla-shining/

""",
                      trackList: [
                        "Geek Down",
                 "E=MC2",
                 "Waves",
                "Light My Fire",
                "Love Jones",
                "Love",
               "Baby",
                "So Far To Go",
                "Jungle Love",
                  "Over The Breaks",
                  "Body Movin",
                  "Dime Piece",
                  "Love Movin",
                   "Won't Do"
                        
                ],
                    audio: "shiningEx.mp3",
                    artist: "J Dilla"

)

var welcome = Album(name: "Welcome 2 Detroit",
                    imageLink: "https://media.pitchfork.com/photos/5bb76ccab5a62d2d54af628d/16:9/w_1280,c_limit/JDilla_Welcome2Detroit.jpg",
                  //  cover: UIImage(systemName: "music.note")!,
                    year: "2001",
                    notes: """

After working with the Ummah, a production trio alongside Q-Tip and Ali Shaheed Muhammad, he produced for Erykah Badu, De La Soul, and Busta Rhymes. His work with Slum Village made him beloved in underground circles. The release of his first album would begin his ascension to hip-hop royalty.

Welcome 2 Detroit, serves as J Dilla’s solo debut and the first time he used the name. The project features hard-hitting beats and creative samples his fans had come to expect. All the while, Welcome 2 Detroit is an experimental album that pushes the boundaries of hip-hop.

Welcome 2 Detroit is a debut album that does a bit of everything. He collides his instinct-based hip-hop with jazz, techno, and sounds from across the world. The album ultimately feels personal and brings us closer to Dilla and his beloved hometown. Today, rap is formulaic and obsessed with adding as much filler as possible. It remains a gem due to its ability to feel both complete and unrushed.



- from Noah, https://nlyons.medium.com/j-dilla-welcome-2-detroit-20-years-later-5b545d350aa8

""",
                    trackList: [
                      "Welcome 2 Detroit",
               "Y'all Ain't Ready",
               "Think Twice (Feat. Dwele)",
              "The Clapper (Feat. Blu)",
              "Come Get It (Feat. Elzhi)",
              "Pause (Feat. Frank N Dank)",
             "B.B.E. (Big Booty Express)",
              "Beej-N-Dem Pt. 2 (Feat. Beej)",
              "Brazilian Groove (EWF)",
                "It's Like That (Feat. Hodge Podge (Big Tone) and Lacks (Ta'Raach)",
                "Give It Up",
                "Rico Suave Bossa Nova",
                "Featuring Phat Kat (Feat. Phat Kat)",
                 "Shake It Down",
                  "African Rhythms",
               "One"
                      
              ],
                    audio: "welcomeMost.mp3",
                    artist: "J Dilla"


)





