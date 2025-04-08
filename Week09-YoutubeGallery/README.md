#  Youtube Gallery

Create a user profile and add Youtube videos to a gallery to share with friends.

Just go to youtube, copy and paste a link, give it a title, and click add!

Made with Firebase as backend to authenticate users and store YouTube URLs, not the actual videos. 

Model -> VideoItem.swift | Database link -> VideosStore.swift | 

As part of YouTube embedding, YouTube provides a pattern to parse their URLs for a linked thumbnail to a video - see YouTubeURLParser.swift

Going forward, I could add the actual YouTube API to acquire the actual title, published date, youtube account, other data. Also, I need to fix the embbeded video player on mobile to handle a user turning their phone horizontally to watch. 

To counter these, I make people supply the title to their YouTube submission and give the option of watching the video externally on YouTube by providing a button. 

For now though, I enjoy being able to save a YouTube video I like and share with people in one place, free from Google's algorithms and my messages inbox.
