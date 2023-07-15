# ToDo List App

A simple Flutter ToDo list implementation. For now, only Android version is supported.

## Description

With this application you can easily create tasks, choose priority for each task, and set a deadline.

## List of features

* Managing your tasks
  * Creating
  * Editing
  * Marking as done
  * Removing
* Set a priority for tasks
* Set a deadline for tasks
* [Google Material 3 design](https://m3.material.io/)
* Smooth animations
* Saving tasks in phone storage
* Adaptive light and dark themes
* Dynamic colors (available from Android S+)
* Adaptive language (english and russian are supported)
* Cloud syncing of tasks
* Offline work
* Error handling

## Technologies and materials used

* [Dart programming language](https://dart.dev)
* [Flutter framework](https://flutter.dev)
* Several flutter libraries. List available at [pubspec.yaml](https://github.com/vladdan16/todo_list/blob/master/pubspec.yaml) file

## Demonstration

<p>Home page with tasks:</p>
<p float="left">
 <img src="./screens/main_screen.png" width="230" height="490">
</p>
<p>Home page with tasks and collapsed AppBar:</p>
<p float="left">
 <img src="./screens/main_screen_2.png" width="230" height="490">
</p>
<p>Adding and editing task page:</p>
<p float="left">
 <img src="./screens/task_screen.png" width="230" height="490">
</p>

## Android release

You can try ToLo List right now! Just install `.apk` file by [this link](https://github.com/vladdan16/todo_list/releases/download/v1.2.0/Todo_List_App_v1.2.0.apk).

## Project installation and run

Before start be sure that you have installed git, [Flutter](https://flutter.dev) sdk and `dart` and `flutter` commands are added to path.

1. Clone the repository
```console
git clone git@github.com:vladdan16/todo_list.git
```

2. Go to the following directory
```console
cd todo_list/packages/remote_storage_todos_api
```

3. Add `.env` file to this directory with the following content:
```
BASE_URL=<BACKEND_ADDRESS>
TOKEN=<YOUR_TOKEN>
```

4. Run this command in the same directory:
```console
dart run build_runner build --delete-conflicting-outputs
```

5. Go back to root directory of project and get all dependencies
```console
dart pub get
```

6. Run project
```console
flutter run
```
