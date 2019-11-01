flutter build appbundle &&
echo - &&
echo APP BUNDLE BUILD DONE &&
echo - &&
flutter build apk --target-platform android-arm,android-arm64,android-x64 --split-per-abi &&
echo - &&
echo APK BUILD DONE &&
echo - &&
flutter build web &&
echo - &&
echo WEB BUILD DONE &&
echo - &&
cd ./build/web &&
del /f web.zip &&
7z a -tzip web.zip * &&
echo - &&
echo WEB ZIPPED &&
echo -