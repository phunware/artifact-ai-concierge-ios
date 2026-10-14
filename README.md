# AI Concierge iOS Module

`PhunwareAIConcierge` is a Phunware module that embeds an AI-powered concierge experience inside your iOS application.

## Requirements

- iOS 15.5+
- Swift 5.9+
- Xcode 15+
- CocoaPods 1.16.2+

## Installation

### CocoaPods

Add the module and its spec source to your `Podfile`:

```ruby
source 'git@bitbucket.org:phunware/phunware-module-specs.git'
source 'https://cdn.cocoapods.org/'

platform :ios, '15.5'
use_frameworks!

target 'YourApp' do
  pod 'PhunwareAIConciergeSource'
end
```

Then run:

```sh
pod install
```

### Swift Package Manager

Add `PhunwareAIConcierge` to your project through **File → Add Package Dependencies…** in Xcode, using the repository URL:

```
git@github.com:phunware/artifact-ai-concierge-ios.git
```

Or add it to a `Package.swift` manifest:

```swift
dependencies: [
    .package(url: "git@github.com:phunware/artifact-ai-concierge-ios.git", from: "1.0.0"),
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "PhunwareAIConcierge", package: "module-ai-concierge-ios"),
        ]
    ),
]
```

## Permissions

The AI Concierge uses the device microphone and Apple's speech recognition for voice input. Add the following keys to your app's `Info.plist`:

- `NSMicrophoneUsageDescription`
- `NSSpeechRecognitionUsageDescription`

The module presents permission-priming bottom sheets before the system prompts appear.

## Getting Started

### 1. Configure PWCore

Configure PWCore with your Phunware application credentials before launching the AI Concierge (typically in your app or scene delegate, or in the view controller that presents it):

```swift
import PWCore

PWCore.setEnvironment(.prod)
PWCore.setApplicationID("<YOUR_APPLICATION_ID>", accessKey: "<YOUR_ACCESS_KEY>")
```

### 2. Present the AI Concierge

Create an `AssistantCoordinator` with a `UINavigationController` and a `Configuration`, assign a delegate, and call `start()`:

```swift
import UIKit
import PhunwareCorePlugin
import PhunwareAIConcierge

final class ViewController: UIViewController {
    private var assistantCoordinator: AssistantCoordinator?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        launchAIConcierge()
    }

    func launchAIConcierge() {
        guard assistantCoordinator == nil,
              let navigationController else { return }

        let coordinator = AssistantCoordinator(
            navigationController: navigationController,
            moduleConfig: Configuration(
                venueId: "<YOUR_VENUE_ID>",
                theme: .init(),
                localization: nil
            )
        )
        coordinator.delegate = self
        assistantCoordinator = coordinator
        coordinator.start()
    }
}

extension ViewController: AssistantCoordinatorDelegate {
    func coordinator(_ coordinator: AssistantCoordinator,
                     didTrigger action: Action,
                     for intent: String) {
        // Route the action to the appropriate part of your app.
    }

    func coordinatorDidFinish(_ coordinator: AssistantCoordinator) {
        assistantCoordinator = nil
    }
}
```

## Configuration

`Configuration` bundles all inputs the module needs to run:

| Parameter      | Type         | Description                                                  |
| -------------- | ------------ | ------------------------------------------------------------ |
| `venueId`      | `String`     | Identifier of the venue the assistant is scoped to.          |
| `theme`        | `Theme`      | Optional visual theme (colors and text styles). Defaults to the module's built-in theme if not provided. |
| `localization` | `Localizing` | Optional localization provider. When a key isn't resolved, the module falls back to its built-in defaults. |

### Theming

Provide a `Theme` to match your app's design system. `Theme` wraps `ColorPalette` and `TextStyles` from `PhunwareTheming`:

```swift
import PhunwareTheming
import PhunwareAIConcierge

let colors = ColorPalette(
    primary: .init(resource: .primary),
    secondary: .init(resource: .secondary),
    primaryVariant: .init(resource: .primaryVariant),
    secondaryVariant: .init(resource: .secondaryVariant),
    background: .init(resource: .background),
    surface: .init(resource: .surface),
    surfaceContainer: .init(resource: .surfaceContainer),
    onPrimary: .init(resource: .onPrimary),
    onSecondary: .init(resource: .onSecondary),
    onBackground: .init(resource: .onBackground),
    onSurface: .init(resource: .onSurface),
    error: .init(resource: .error),
    onError: .init(resource: .onError)
)

let textStyles = TextStyles(
    headline1: .boldSystemFont(ofSize: 28),
    headline2: .boldSystemFont(ofSize: 18),
    headline3: .systemFont(ofSize: 16),
    subtitle1: .boldSystemFont(ofSize: 16),
    subtitle2: .boldSystemFont(ofSize: 14),
    body1: .systemFont(ofSize: 14),
    body2: .systemFont(ofSize: 14),
    overline: .systemFont(ofSize: 12),
    caption: .boldSystemFont(ofSize: 12),
    button: .boldSystemFont(ofSize: 14)
)

let theme = Theme(colors: colors, textStyles: textStyles)
```

Passing `Theme()` uses the module's built-in colors and text styles.

### Localization

Conform to the `Localizing` protocol to supply your own strings. Unresolved keys automatically fall back to the module's built-in `LocalizableDefaults` table:

```swift
import PhunwareAIConcierge

final class AppLocalization: Localizing {
    func localized(_ key: String) -> String {
        String(localized: .init(key), table: "Localizable")
    }
}
```

Pass an instance to `Configuration(localization:)`. Passing `nil` uses only the module's defaults.

## Handling Actions

When the user taps an action on an assistant response, the coordinator forwards it to your delegate through `coordinator(_:didTrigger:for:)`. `Action` (from `PhunwareCorePlugin`) is an enum with the following cases your app is expected to handle:

- `.calendar(Calendar)` — add an event to the user's calendar.
- `.deepLink(DeepLink)` — open a deep link in your app, with an optional web fallback.
- `.email(Email)` — compose an email.
- `.map(Map)` — show an address on a map.
- `.navigation(Navigation)` — start turn-by-turn navigation to a destination.
- `.phone(Phone)` — initiate a phone call.
- `.webLink(WebLink)` — open a URL in a browser or in-app web view.
- `.sms(SMS)` — compose an SMS.

Example:

```swift
func coordinator(_ coordinator: AssistantCoordinator,
                 didTrigger action: Action,
                 for intent: String) {
    switch action {
    case .calendar(let event):     addToCalendar(event)
    case .deepLink(let deepLink):  open(deepLink.url, fallback: deepLink.fallbackWebURL)
    case .email(let email):        composeEmail(email)
    case .map(let map):            showMap(for: map.address)
    case .navigation(let nav):     startNavigation(to: nav.destination)
    case .phone(let phone):        call(phone.number)
    case .webLink(let webLink):    openWeb(webLink.url)
    case .sms(let sms):            sendSMS(to: sms.recipients, body: sms.body)
    @unknown default:              break
    }
}
```

`coordinatorDidFinish(_:)` is called when the AI Concierge flow ends. Release your coordinator reference there.

## Dependencies

`PhunwareAIConcierge` depends on the following Phunware libraries:

- `PWCore`
- `PhunwareCorePluginSource`
- `PhunwareFoundationSource`
- `PhunwareThemingSource`
- `PhunwarePermissionPrimingSource/Microphone`
- `PhunwarePermissionPrimingSource/SpeechRecognition`

## License

Copyright © 2009-present Phunware, Inc. All rights reserved.
