
<img src="https://raw.githubusercontent.com/harchani-ritik/rutorrent-flutter/master/assets/logo/light_mode_white_background.png" alt="ruTorrent Mobile" height=200px>




# ruTorrent Mobile

<img src="https://raw.githubusercontent.com/harchani-ritik/rutorrent-flutter/master/gsoc_2020.png" alt="GSOC 2020" height=30px>

**A ruTorrent-based client build in Flutter**

The project is a flutter application for ruTorrent web interface. The app communicates with ruTorrent's backend via REST APIs to display the information about the torrents and the functionality to control its basic features. It also supports some plugin functionalities as provided in the ruTorrent web.

Additionally, you can also stream torrents from your server (or seedbox) and download them locally to your mobile device (a save offline feature), which makes torrenting a seamless experience for ruTorrent users.

## Download App
<a href="https://play.google.com/store/apps/details?id=org.ccextractor.rutorrentflutter"><img src="https://play.google.com/intl/en_us/badges/static/images/badges/en_badge_web_generic.png" width="200"></img></a>

## ruTorrent and rtorrent

<img src="https://raw.githubusercontent.com/CCExtractor/rutorrent-flutter/master/rutorrent.jpeg" alt="ruTorrent Web" height=100px>

[ruTorrent](https://github.com/Novik/ruTorrent) is the most popular web interface for [rtorrent](https://github.com/rakshasa/rtorrent), which is possibly the most used BitTorrent client in Linux. It is mostly a web application, but it has its own backend that connects to rtorrent.

In short: 

rtorrent ⇒ The BitTorrent client, a console-based tool that also has an API to interact with it.

ruTorrent ⇒ A web interface for rtorrent that uses that API. It also does other things, for example, it can download torrents from an RSS feed. You configure RSS feeds in rutorrent's web interface, but there's also a backend service (written in PHP) that is part of rutorrent to do the actual download.

Thus, our Flutter application talks with ruTorrent's backend service to provide a native interface.

![Diagram](./assets/docs/ruTorrent%20Flutter%20Application%20Diagram.png)

## App Preview

<details>
<summary>📷 <b>Screenshots</b> </summary>
<br/>


Login Screen            |  All Torrents Screen       | Downloaded Torrents Screen      |  Drawer Screen
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![Login_screen](https://user-images.githubusercontent.com/47276307/113502426-e6aa3e00-9549-11eb-84d1-ef206be8c81d.jpeg)|![All_Torrents_screen](https://user-images.githubusercontent.com/47276307/113502413-de520300-9549-11eb-874c-75df7fdc9bb9.png)|![Downloaded_Torrents_screen](https://user-images.githubusercontent.com/47276307/113501966-be6d1000-9546-11eb-8e25-8712453db047.jpeg)|![Drawer_screen](https://user-images.githubusercontent.com/47276307/113501974-c6c54b00-9546-11eb-8293-348a66e19e30.jpeg)|

Rss-Feed Screen         |  RSS-filters Screen        |   Settings Screen               |  Splash Screen
:-------------------------:|:-------------------------:|:-------------------------:|:-------------------------:
![RSS_feed_screen](https://user-images.githubusercontent.com/47276307/113501981-cfb61c80-9546-11eb-8b96-74c959cf6bb2.jpeg)|![RSS_filters_screen](https://user-images.githubusercontent.com/47276307/113501983-d2b10d00-9546-11eb-853f-aeff84964462.jpeg)|![Settings_screen](https://user-images.githubusercontent.com/47276307/113501986-d6dd2a80-9546-11eb-8cfb-c85493c474fc.jpeg)|![Splash_screen](https://user-images.githubusercontent.com/47276307/113501988-d93f8480-9546-11eb-885d-85801fc71b3e.jpeg)|

Disk Explorer Screen (seedbox)         | History Screen       |   
:-------------------------:|:---------------------:|
![Disk_Explore_screen](https://user-images.githubusercontent.com/47276307/113501965-bb721f80-9546-11eb-84d9-ea450462296e.jpeg)|![History_screen](https://user-images.githubusercontent.com/47276307/113501977-c927a500-9546-11eb-9bae-f13fb384828a.jpeg)|
</details>


## Usage

In order to use this flutter application you should have ruTorrent configured on your system, after which you can connect your mobile on the same network as your system and use the app by entering the configuration (IP address).

If you find any difficulty to run ruTorrent and rtorrent on your system, you can use this [docker image](https://hub.docker.com/r/crazymax/rtorrent-rutorrent).

Though the primary usage of this application is to control ruTorrent hosted on your seedbox account.

## Seedbox

A seedbox is a dedicated BitTorrent server. Oftentimes they are rented out by companies called seedbox providers.

Seedboxes usually have a high speed Internet connection. This allows users to download torrents quickly and seed the torrents for a long time.

You can learn more about seedbox [here](https://en.wikipedia.org/wiki/Seedbox).


## Getting Started

1. Clone the repository from GitHub:

```bash
git clone https://github.com/CCExtractor/rutorrent-flutter
```

2. Navigate to project's root directory:

```bash
cd rutorrent-flutter
```

3. Check for Flutter setup and connected devices:

```bash
flutter doctor
```

4. For IOS
- Uncomment ```platform :ios, '9.0'``` from ios/Podfile
- Cd into the new ios directory```cd ios```
- From the ios directory ```pod install --verbose```

5. Run the app:

```bash
flutter run
```

## Contributing

Contribution to the project can be made if you have some improvements for the project or if you find some bugs.
You can contribute to the project by reporting issues, forking it, modifying the code and making a pull request to the repository.

Please make sure you specify the commit type when opening pull requests:

```
feat: The new feature you're proposing

fix: A bug fix in the project

style: Feature and updates related to UI improvements and styling

test: Everything related to testing

docs: Everything related to documentation

refactor: Regular code refactoring and maintenance
```

## Community
You may join the gsoc-rutorrent channel of CCExtractor community through slack and propose improvements to the project.

* CCExtractor Development on [Slack](https://ccextractor.org/public:general:support?)

## License

The project is released under the [MIT License](http://www.opensource.org/licenses/mit-license.php). The license can be found [here](LICENSE).

## Flutter

For help getting started with Flutter, view
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
