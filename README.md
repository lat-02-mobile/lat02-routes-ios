# lat02-routes-ios
Routes repository for ios
### Set up the Google Signin authentication

1. Download the `GoogleService-Info.plist` file from the [firebase iOS app](https://console.firebase.google.com/u/1/project/routes-app-8c8e4/settings/general/ios:com.jalasoft.routesapp) and copy it into the **RoutesApp_ios** folder of the project.

![Captura de Pantalla 2022-08-15 a la(s) 17 28 12](https://user-images.githubusercontent.com/20176876/184721638-64d7e12e-8e7d-4831-9507-2cd50372e211.png)


2. In the info.plist file replace the **identifier** `REVERSED_CLIENT` with the value of the key `REVERSED_CLIENT_ID` from the `GoogleService-Info.plist`.

### Set up the Facebook Login authentication

1. Download the `GoogleService-Info.plist` file from the [firebase iOS app](https://console.firebase.google.com/u/1/project/routes-app-8c8e4/settings/general/ios:com.jalasoft.routesapp) and copy it into the **RoutesApp_ios** folder of the project.

![Captura de Pantalla 2022-08-15 a la(s) 17 28 12](https://user-images.githubusercontent.com/20176876/184721638-64d7e12e-8e7d-4831-9507-2cd50372e211.png)


2. In the info.plist file replace the both **identifiers** `FB_APP_IDENTIFIER` with the value of the `app identifier` from the [facebook developer console iOS app](https://developers.facebook.com/apps/3146525082229053/dashboard/).

3. It's also necessary to replace the **identifier** `FB_TOKEN_CLIENT` with the value of the `client token` from the [facebook developer console iOS app](https://developers.facebook.com/apps/3146525082229053/dashboard/).

At the end of the Google and Facebook login setup, the info.plist should look similar to the following:

![Captura de Pantalla 2022-08-15 a la(s) 17 32 45](https://user-images.githubusercontent.com/20176876/184722573-283160ba-bf72-477e-aef0-ce34099bd453.png)

### Set up Google Maps and Places for searching functionality

1. Go to [Google Cloud Console](https://console.cloud.google.com/) and in the Credentials option, under APIs & Services section

2. In that page you'll see a list of generated keys, search for **Places API Key** and **Google Maps iOS SDK**, on the right side of those items, there's a _SHOW_KEY_ button. Click on it and copy the key value to the AppDelegate.swift file and replace the hole string with key values where corresponds.

```swift
        GMSServices.provideAPIKey("${GOOGLE_MAPS_API_KEY}")
        GMSPlacesClient.provideAPIKey("${GOOGLE_PLACES_API_KEY}")
        // Should look like this after replacing the values
        GMSServices.provideAPIKey("COPIED_FOR_MAPS_KEY")
        GMSPlacesClient.provideAPIKey("COPIED_KEY_FOR GOOGLE_PLACES")
```
### Set up the Google Directions API for searching functionality

1. Go to [Google Cloud Console](https://console.cloud.google.com/) and in the Credentials option, under APIs & Services section.

2. In that page you'll see a list of generated keys, search for the **Direction API Key**, on the right side of that item, there's a _SHOW_KEY_ button. Click on it and copy the key value to the ConstantVariables.swift file and replace the hole string with key value.

```swift
        static let directionsApiKey = "${GOOGLE_DIRECTIONS_API_KEY}"
```


AppDelegate 
In the appDelegate the keys of “Google Maps config” are found in the file of “utilities/helpers/Constant variables”, the production ones have the name of “gmsServicesProvideAPIKeyProduction, gmsPlacesClientProvideAPIKeyProduction” and the development ones have the name of “gmsServicesProvideAPIKeyDevelopment, gmsPlacesClientProvideAPIKeyDevelopment ” 

Google Service 
For the Google service you must drag the file to the xcode project, the following window will appear, in the “add to targets” section you must select the one it belongs to, either production or development 
![image](https://user-images.githubusercontent.com/106118394/195852899-e4cd2d8f-875f-4269-8c10-ce981533dbfb.png)

Archivo Env. 

It will proceed to do the same as the Google service configuration. 


Select development environment 

To select the environment, you must choose the corresponding "schema", which is located at the top of the project ![image](https://user-images.githubusercontent.com/106118394/195853071-3e99e58d-b539-42bd-a8a6-447af5a0bb0e.png)

![image](https://user-images.githubusercontent.com/106118394/195853137-12f6950c-8fae-4691-87ec-e4c6b0781ee7.png)

Targets
In the part of "targets/info" don´t forget to change the “URL types“
![image](https://user-images.githubusercontent.com/106118394/195854612-e0ea36a9-da7f-4d09-b77e-07be06cdfff7.png)





