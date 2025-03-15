Photo Graffiti

Goal: Make an app where a user can upload photos and then draw over the photos

-------------------------------------------------------------------------------

Approach #1: Canvas + ColorPicker + PhotoPicker (NO AI)

I started with importing code from [Drawing Together](https://developer.apple.com/documentation/groupactivities/drawing_content_in_a_group_session) and Instafilter (John Henry Thompson/Hacking with iOS) 

The result is present in ContentView.swift. I wasn't quite satisfied as you have to start drawing below the image in order to draw over it. Also, anytime you change the line's color, it changes every line you've drawn before. 

I saw this [article](https://levelup.gitconnected.com/swiftui-color-picker-2-ways-f825230f1569) mention a UIColorPickerViewController method of changing colors. This led me to change approach. 

-------------------------------------------------------------------------------

Approach #2: UIColorPickerViewController + UIViewControllerRepresentable, assisted by [Claude.AI](https://claude.ai/chat/4d621eea-b6c9-453a-8867-69760dd346c4)

For the sake of time, I described my troubles to claude.ai and received the UIViewControllerRepresentable and a class structure setup for DrawingView and calling functions for each UI Element - buttons, slider, image, etc

This took some time to tweak but proved to be more powerful and closer to the vision for my app

-------------------------------------------------------------------------------

Further Additions in the future: adding stickers/other images into image, another color picker for the background, sending/sharing creations

-------------------------------------------------------------------------------

Links:

https://developer.apple.com/documentation/groupactivities/drawing_content_in_a_group_session

https://github.com/molab-itp/07-Instafilter

https://levelup.gitconnected.com/swiftui-color-picker-2-ways-f825230f1569

https://claude.ai/chat/4d621eea-b6c9-453a-8867-69760dd346c4 - initial query

https://claude.ai/chat/10e505d0-0ea8-4440-b306-b566cf861317 - tidying up sublayer logic

