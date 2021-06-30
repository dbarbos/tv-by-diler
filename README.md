# TV by Diler

<img src="https://user-images.githubusercontent.com/2342417/123990917-9acc3100-d9a0-11eb-9431-8297870bc0ba.png" width="180" align="center">

#About

This is an iOS app that connects to tvmaze.com api services to show information about TV shows. The purpose of this app is to present different programing techniques that can be used to accomplish this kind of task. This app can be used as a reference for the following frameworks and patterns:

# Patterns

+ MVVM
  - Is an architectural pattern commonly used in mobile application development. The idea is to facilite the separation of business logic from the interface.
+ Coordinator
  - Is a structural pattern design to organize flow logic between viewControllers.
+ Observer
  - Is a behavioural pattern used to identify common communication patterns between objects. In this case it is used throught the <b>Combine</b> framework.
+ Delegate
  - Is a pattern used to allow an object to "delegate" the responsibility of an algorith to another weakly refered object.
+ Singleton
  + Is a design pattern used to prevent multiple instantiations of shared resources. It is used in this project to provide a single source of access to shared services like: 
    - Network
    - Local persistence
    - Authentication

# Frameworks 

+ Combine
+ Security
+ LocalAuthentication
+ Foundation
+ UIKit
+ Coredata

# Features

+ PIN Authentication screen
  - When you open the app for the first time, it will ask you to create a 4-digit access PIN. This PIN number will be requested everytime you open the app.
  - If your device has biometric authentication features like touchID or faceID, you will be offered to use that in the future to log in.
  - In case you forget your PIN number you will be prompted to reset the keychain and create a new one.

<img width="532" alt="Captura de Tela 2021-06-30 às 13 12 42" src="https://user-images.githubusercontent.com/2342417/123995587-dec13500-d9a4-11eb-820a-68bb335862e8.png">
<img width="527" alt="Captura de Tela 2021-06-30 às 13 16 36" src="https://user-images.githubusercontent.com/2342417/123996142-67d86c00-d9a5-11eb-9c4b-e9a31d1f1fc0.png">
<img width="533" alt="Captura de Tela 2021-06-30 às 13 18 17" src="https://user-images.githubusercontent.com/2342417/123996354-a40bcc80-d9a5-11eb-9fc7-e27db71a29ee.png">

+ List of shows
  - Is a list of all the shows provided by tvmaze.com API starting at page 1. 
  - By scrolling down when you are about to reach the end of the list the app will request a new page of content until there are no more shows to display.
  - You can use 3D touch to highligh a specific show. Whis will prompt you the option to share or add to your favorite the selected show.
  - By tapping on a show you will be forwars to the show detail screen.
  
<img width="536" alt="Captura de Tela 2021-06-30 às 13 23 01" src="https://user-images.githubusercontent.com/2342417/123997004-4d52c280-d9a6-11eb-8e04-6cca42edfc41.png">
<img width="530" alt="Captura de Tela 2021-06-30 às 13 23 33" src="https://user-images.githubusercontent.com/2342417/123997084-5fccfc00-d9a6-11eb-8764-709e5e531e5c.png">

+ Show details
  + It show the details of the selected show:
    - name
    - poster
    - genre
    - rating
    - episodes
    - seasons
    - summary
    - days and time it is aired
    - status
  - Tap on the <b>seasons</b> button to promt the season selection sheet.
  - 3D touch an episode to prompt the share action.
  - Tap on an episode to load the Episode details screen.
  - Tap on add to favorite to add the show to your favorites list.

<img width="523" alt="Captura de Tela 2021-06-30 às 13 32 29" src="https://user-images.githubusercontent.com/2342417/123998188-9f481800-d9a7-11eb-807a-105e15e0ebbc.png">
<img width="528" alt="Captura de Tela 2021-06-30 às 13 32 55" src="https://user-images.githubusercontent.com/2342417/123998263-af5ff780-d9a7-11eb-87ba-fa6fe9d21375.png">
<img width="519" alt="Captura de Tela 2021-06-30 às 13 33 17" src="https://user-images.githubusercontent.com/2342417/123998301-bbe45000-d9a7-11eb-9358-7f33919fe8b8.png">

+ Episode details
  + It show the details of the selected episode:
    - image
    - episode name
    - season
    - episode number
    - air date
    - air time
    - summary
  + Tap on "Share with..." to share.

<img width="522" alt="Captura de Tela 2021-06-30 às 13 35 41" src="https://user-images.githubusercontent.com/2342417/123998650-11b8f800-d9a8-11eb-9bde-611191e699cd.png">

+ Favorite shows
  - It is a list of your favorite shows
  - Tap on a show to open the show detail screen.
  - Swipe left to remove the show from the favorites list.

<img width="521" alt="Captura de Tela 2021-06-30 às 13 37 43" src="https://user-images.githubusercontent.com/2342417/123998943-5a70b100-d9a8-11eb-92dc-2d564a5fd561.png">
<img width="521" alt="Captura de Tela 2021-06-30 às 13 38 03" src="https://user-images.githubusercontent.com/2342417/123998978-665c7300-d9a8-11eb-8c68-eb14992edef2.png">

+ Search shows and persons
  - The search screen can be used to search for shows and artists.
  - Tap on the search category to change the search filter> "All", "Shows", "Artists".
  - tap on a show to open the show detail screen
  - tap on an artist to open the artist detail screen.

<img width="537" alt="Captura de Tela 2021-06-30 às 13 40 52" src="https://user-images.githubusercontent.com/2342417/123999346-cc48fa80-d9a8-11eb-9a1b-dd47bd929bb5.png">
<img width="515" alt="Captura de Tela 2021-06-30 às 13 41 29" src="https://user-images.githubusercontent.com/2342417/123999430-e1be2480-d9a8-11eb-84bf-2fd7339664e7.png">

+ Artist details
  + Shows the details of the artist:
    - picture
    - name
    - country
    - shows that appeared
+ Tap on a show to open the show details screen.

<img width="520" alt="Captura de Tela 2021-06-30 às 13 43 25" src="https://user-images.githubusercontent.com/2342417/123999669-2649c000-d9a9-11eb-87ab-d74c45f48d90.png">
<img width="520" alt="Captura de Tela 2021-06-30 às 13 43 56" src="https://user-images.githubusercontent.com/2342417/123999750-38c3f980-d9a9-11eb-9033-1f15b65b46fe.png">


# Dependencies

This project runs using 3rd party code libraries managed by Cocoapods, to install
it you must:

- **sudo gem install Cocoapods**

in the root folder of the project:

- **pod install**

Installed Pods:

- **SDWebImage**: Used to cache images and improve connection speed;
- **IQKeyboardManagerSwift**: keyboard helper;


# Author

+ developed by: Dilermando Barbosa Jr (Diler)
+ e-mail: dilermando.barbosa@gmail.com
