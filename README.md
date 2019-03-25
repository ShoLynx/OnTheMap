# OnTheMap
**On The Map** is the submitted Udacity iOS Developer project.

## Installation
Clone the GitHub repository and use Xcode to install.

## How to Use
A Udacity account and internet connection are required to use **On The Map**.  When you first open the app, you'll be presented with a login screen to enter an existing account or create a new one through your device's browser.

Once you successfully login, you'll be presented with a full-screen **map**.  The pins on the map represent students who have provided their general location and contact links.

### Map Controls
- Double-tap to zoom in 
- Tap a pin: Shows an annotation of student's city and contact link
- Tap an annotation: Opens a browser page to the contact link (if available)
- Log off: Ends your session and returns you to the Login screen
- Reload icon: Refreshes the map to get the latest information
- '+' icon: Presents the Add Location screen, where you can create your own pin
- Students icon: Presents a table view of the available pins of the map

### Students Table Controls
- Swipe vertically: Scroll through the latest 100 Student items
- Tap a Student item: Opens a browser page to the contact link (if available)
- Reload icon: Refreshes the table to get the latest information
- Map icon: Returns to the map view

Once you have entered a browser page, you can use the device's 'On The Map' item on the upper-left to immediately return to the app.

## Add Location
Feeling social?  You can add your own pin to the map, by entering your own city and contact link.  It is possible to place a pin, without a contact link.  Tapping Find Location will confirm what you entered can be linked to an actual place on the map.

## Confirm Location
Another map view will appear with only your pin.  This is your opportunity to confirm if the pin's location is in the city you wanted it in and your contact link is correct.  Tap Finish to confirm or use the Go Back button to return to the Add Location screen and try again.

## Planned Updates
- 'Log Off' should be updated to 'Log Out', for consistency with 'Log In'.
- A logout confirmation will be added, before returning to the Login screen
- A pinch zoom feature will be added to the map view
