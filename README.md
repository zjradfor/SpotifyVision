# SpotifyVision

Leverages Spotify's Beta Player API to view and control an active Spotify session.

#### Features
* Authenticate in-app with Spotify
* View what you are currently playing on Spotify
* Play, pause, and skip tracks
* See which device is currently actively playing Spotify
* Open Spotify app if no player is detected
* View the recently played tracks in your current Spotify session

### Setup

Go to the <a href="https://developer.spotify.com/dashboard/login" target="_blank">`Spotify Developer Console`</a> and create a new project to get your client ID and Client Secret, you will need to put these unique keys in ClientKeys.swift to authenticate properly. Also register a redirect URI to use in the app.

Put these credentials in SpotifyCredentials.swift.

Warning!!! If you don't have these credentials when you run the app, you will get an assertion failure on launch.
