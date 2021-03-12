
<img src="https://raw.githubusercontent.com/harchani-ritik/rutorrent-flutter/master/assets/logo/light_mode_white_background.png" alt="ruTorrent Mobile" height=200px>




# ruTorrent Mobile

<img src="https://raw.githubusercontent.com/harchani-ritik/rutorrent-flutter/master/gsoc_2020.png" alt="GSOC 2020" height=30px>

**A ruTorrent-based client build in Flutter**

The project is a flutter application for ruTorrent web interface. The app communicates with ruTorrent's backend via REST APIs to display the information about the torrents and the functionality to control its basic features. It also supports some plugin functionalities as provided in the ruTorrent web.

Additionally, you can also stream torrents from your server (or seedbox) and download them locally to your mobile device (a save offline feature), which makes torrenting a seamless experience for ruTorrent users.

## ruTorrent and rtorrent

<img src="https://raw.githubusercontent.com/CCExtractor/rutorrent-flutter/master/rutorrent.jpeg" alt="ruTorrent Web" height=100px>

[ruTorrent](https://github.com/Novik/ruTorrent) is the most popular web interface for [rtorrent](https://github.com/rakshasa/rtorrent), which is possibly the most used BitTorrent client in Linux. It is mostly a web application, but it has its own backend that connects to rtorrent.

In short: 

rtorrent ⇒ The BitTorrent client, a console-based tool that also has an API to interact with it.

ruTorrent ⇒ A web interface for rtorrent that uses that API. It also does other things, for example, it can download torrents from an RSS feed. You configure RSS feeds in rutorrent's web interface, but there's also a backend service (written in PHP) that is part of rutorrent to do the actual download.

Thus, our Flutter application talks with ruTorrent's backend service to provide a native interface.

![Diagram](./assets/docs/ruTorrent%20Flutter%20Application%20Diagram.png)

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
