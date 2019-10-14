# Live-Healthy (Updated 14-Oct-2019)

Live Healthy is an Apple Watch and iPhone application which allows a user to track various aspects of their life. By leaveraging AWS services, the application supports multiple users and cloud data storage.

## Current Features
Track:
* The length of a meal


## Requirments
Apple Watch (watchOS 5 and later), iPhone (iOS 12.4 and later), and Mac (macOS 10.14.6 or later)

## Setup
1. Clone [this repository](https://github.com/r-kondaveeti/Live-Healthy.git) to your computer.

2. Open the project using XCode by clicking on the `Live Healthy.xcodeproj` file or by running \
`$ open Live\ Healthy.xcodeproj`

3. Ensure that your watch and your phone are paired properly and that your phone is a device that can be used as a build location.

4. Build/Run the project by either using `Cmd + r` or going to `Product -> Run`

5. Once the app is installed on your phone and your watch, you should be able to open it.

## Usage

### On the Apple Watch
* Open the app.
* Choose something from the menu. This will take you to an appropriate interface.
where you can see relevant information for the activity/tool.
* The `dismiss` button on the screen will return you to the selection menu.

### On the iPhone
* Open the app.
* The data your watch gathers will be visible on both the watch and phone interfaces

## How it works
Behind the scenes, the WatchKit gathers data from various sensors and the user interface. It then sends this data to the 
paired phone.
The app collects the data from the watch and sends it to the paired iPhone using the WatchKit library.
This data is then formatted into a JSON file and sent to Amazon Web Services using the AWS SDK for Swift.
