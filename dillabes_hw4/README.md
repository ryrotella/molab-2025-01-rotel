# dillabes

```

Debugging AlbumView for flashing during audio playback

!! album.cover
album.cover is empty

>> let _ = Self._printChanges()
Added for debugging

[_printChanges](https://www.hackingwithswift.com/quick-start/swiftui/how-to-find-which-data-change-is-causing-a-swiftui-view-to-update)

?? Image(uiImage: album.cover)
Where is this shown in the view?

?? ProgressView(
Where is this shown in the view?

# research animation
# [05-Heart-Shapes](https://github.com/molab-itp/05-Heart-Shapes)

[animation repeatforever docs]https://developer.apple.com/documentation/swiftui/animation/repeatforever(autoreverses:)
>> extracted AnimationDemo

# AlbumCoverView replaced by AlbumCoverAnimatedView and AlbumCoverStaticView
>> not obvious how to deal with animation start / stop without timer

```
