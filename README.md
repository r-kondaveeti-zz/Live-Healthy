# Live-Healthy (Updated 08-Oct-2019)

Live-Healthy is an applicaiotn which allows a user to track various aspects of their life, such as amount of time spent eating.

## Requirments:

Apple Watch (watchOS 6), iPhone (iOS 13), and Mac (macOS 10.14.6 or later)

## Setup:

1. Clone [this repository](https://github.com/r-kondaveeti/Live-Healthy.git) to your computer.

2. Do not open project yet. You must install pod (from Cocoapods) first by the command: "pod install --repo-update"

3. Open the project by .xcworkspace.

4. Generate awsamplifcation.json by using the following commands from AWS Amplify:
   - "amplify init"
   - "amplify add analytics" Hit Y for allow unauth users
   - "amplify push" to get your awsapplication.json
5. Add awsapplication.json to the Project.

6. Build and Run the project

7. Once the app is installed on your phone and your watch, you should be able to open it.

## Usage:

### On the Apple Watch

- Open the app.
- Choose something from the menu. This will take you to an appropriate interface.
  where you can see relevant information for the activity/tool.
- The `dismiss` button on the screen will return you to the selection menu.

### On the iPhone:

- Open the app.
- The data your watch gathers will be visible on both the watch and phone interfaces

## How it works:

Behind the scenes, the WatchKit gathers data from various sensors and the user interface. It then sends this data to the
paired phone.
The app collects the data from the watch and sends it to the paired iPhone using the WatchKit library.
This data is then formatted into a JSON file and sent to Amazon Web Services using the AWS SDK for Swift.
