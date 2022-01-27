# FKSecureStore

Using the Security framework is tedious. But at times, we need to utilize the keychain to do simple operations such as save and load sensitive data, user credentials for example. This library is a lightweight solution for the same.

# Installation

Simply drop `FKSecureStore.swift` in your project and you're good to go.

# Usage

```swift
@objc class func save(string: String, key: String) -> Status
```
Save a string for a particular key in the keychain.

```swift
@objc class func save(data: Data, key: String) -> Status
```
Save any data object for a particular key in the keychain. If you have custom classes, they should conform to `NSCoding` or (optionally) `NSSecureCoding`.

```swift
@objc class func load(key: String) -> String?
```
Retrieve a saved string for a particular key in the keychain.

```swift
@objc class func load(dataForKey key: String) -> Data?
```
Retrieve any saved data for a particular key in the keychain.

```swift
@objc class func delete(key: String) -> Status
```
Delete any saved data for a particular key in the keychain.

```swift
@objc class func clear() -> Status
```
Delete all saved data for the app in the keychain. All data for any key you might have saved will be deleted.

#### Note
Saved data will persist in keychain even after application is deleted or device is restarted.

# To-do

* Option to clear keychain data if app is uninstalled. [Might help?](https://developer.apple.com/forums/thread/36442)

# License

`FKSecureStore` is available under the MIT license. See the LICENSE file for more info.
