
<img src="https://raw.githubusercontent.com/CCExtractor/rutorrent-flutter/master/assets/logo/light_mode.png" alt="ruTorrent Mobile" height=100px>




# ruTorrent Mobile

<img src="https://raw.githubusercontent.com/harchani-ritik/rutorrent-flutter/master/gsoc_2020.png" alt="GSOC 2020" height=30px>

**A ruTorrent-based client build in Flutter**

The project is a flutter application for ruTorrent web interface. The app communicates with ruTorrent's backend via REST APIs to display the information about the torrents and the functionality to control its basic features. It also supports some plugin functionalities such as **RSS Feeds**, **History**, **Disk Space** etc. as provided in the ruTorrent web.

Additionally, you can also stream torrents from your server (or seedbox) and download them locally to your mobile device (a save offline feature), which makes torrenting a seamless experience for ruTorrent users.

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
- Delete ios folder from the root directory ```/ios```
- From the root directory```flutter create -i swift --project-name rutorrent . ```
- Uncomment ```platform :ios, '9.0'``` from ios/Podfile
- Cd into the new ios directory```cd ios```
- From the ios directory ```pod install ```

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
