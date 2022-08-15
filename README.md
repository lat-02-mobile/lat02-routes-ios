# lat02-routes-ios
Routes repository for ios
### Set up the Google Signin authentication

1. Download the `GoogleService-Info.plist` file from the [firebase iOS app](https://console.firebase.google.com/u/1/project/routes-app-8c8e4/settings/general/ios:com.jalasoft.routesapp) and copy it into the **RoutesApp_ios** folder of the project.

![Captura de Pantalla 2022-08-15 a la(s) 17 28 12](https://user-images.githubusercontent.com/20176876/184721638-64d7e12e-8e7d-4831-9507-2cd50372e211.png)


2. In the google info.plist file replace the **identifier** `GOOGLE_REVERSE_CLIENT` with the value of the key `REVERSED_CLIENT_ID` from the `GoogleService-Info.plist`.

### Set up the Facebook Login authentication

1. Download the `GoogleService-Info.plist` file from the [firebase iOS app](https://console.firebase.google.com/u/1/project/routes-app-8c8e4/settings/general/ios:com.jalasoft.routesapp) and copy it into the **RoutesApp_ios** folder of the project.

![Captura de Pantalla 2022-08-15 a la(s) 17 28 12](https://user-images.githubusercontent.com/20176876/184721638-64d7e12e-8e7d-4831-9507-2cd50372e211.png)


2. In the google info.plist file replace the both **identifiers** `FB_APP_IDENTIFIER` with the value of the `app identifier` from the [facebook developer console iOS app](https://developers.facebook.com/apps/3146525082229053/dashboard/).

3. It's also necessary to replace the **identifier** `FB_TOKEN_CLIENT` with the value of the `client token` from the [facebook developer console iOS app](https://developers.facebook.com/apps/3146525082229053/dashboard/).

At the end of the Google and Facebook login setup, the info.plist should look similar to the following:

![Captura de Pantalla 2022-08-15 a la(s) 17 32 45](https://user-images.githubusercontent.com/20176876/184722573-283160ba-bf72-477e-aef0-ce34099bd453.png)
