# JPM Take Home Project 
<img width="250" alt="Screenshot 2023-08-24 at 3 31 46 PM" src="https://github.com/rezatakhti/JPMWeather/assets/36284798/ad744026-c531-4ecd-a6cc-19196fe93499">
<img width="250" alt="Screenshot 2023-08-24 at 3 32 02 PM" src="https://github.com/rezatakhti/JPMWeather/assets/36284798/60eeffec-4de3-4287-b001-0428cf1f87df">

## General Overview and Thoughts 
I was very short on time while working on this project, as it's been a very busy week for me. Thus, I had to cut back on some features that I would've loved to add, but might not have been critical to this assignment. I sacrified some features and UI/UX improvements, 
as in a professional environment these can always be added per business requirements. Thus, the UI is very basic, but it allows you to search for a location, and it displays current weather data for that location. What I focused on the most was scalability, testability, and app architecture. Below are more details.

## Code/design decisions Made
- App UI archicture follows MVVM with Combine for bindings 
- App utilizes a protocol oriented approach with testability/scalability in mind. This should allow for mocking as necessary to test
- App is in UIKit
- Added Unit Tests
- Utlizied GCD to prevent unnecessary API calls to be made
- Utilized NSCache for image caching
- Core Location for grabbing user's location
- User Defaults for basic persistence 

## Areas of improvement to get to a production ready application 
- Adequate loading indicators/error messages 
- UI improvements for larger screens and landscape mode
- Dark mode support
- Accessiblity
- More Unit Tests. I wrote the app with testability in mind, but was short in time when it came to writing the actual tests. I wrote one very basic test.
- Using a Coordinator for navigation. Not entirely necessary for a small project, but Coordinator would solve/prevent many issues in a large scale application. 
