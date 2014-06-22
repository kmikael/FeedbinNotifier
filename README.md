# Feedbin Notifier 1.0.4

Feedbin Notifier is a menu bar application that shows your [Feedbin](https://feedbin.com) unread count.

You can log in to Feedbin and Feedbin Notifier will securely store your password in the system keychain.
After that you can log out at any time.

By default, Feedbin Notifier refreshes every 2 minutes, you can change this in the defaults using

    defaults write com.kmikael.FeedbinNotifier KMFeedbinRefreshInterval 300
    
The number is in seconds. Don't forget to make sure the app is not running while you change the defaults.

You can also refresh from the menu manually at any time.

![](http://f.cl.ly/items/3g2Q3Z3w361q3q2v0j2h/feedbin-notifier-screenshot.jpg)

# Installation

You can build Feedbin Notifier with Xcode 5.1.1 on OS X 10.9.

A code-signed binary is also available in the release section.
[Download it now](https://github.com/kmikael/FeedbinNotifier/releases/v1.0.1/1896/feedbinnotifier.zip).
