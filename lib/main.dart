import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  // Ensure that plugin services are initialized so that `availableCameras()`
  // can be called before `runApp()`
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras.
  final firstCamera = cameras[0];

  runApp(
    MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      home: TakePictureScreen(
        // Pass the appropriate camera to the TakePictureScreen widget.
        camera: firstCamera,
      ),
    ),
  );
}

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  const TakePictureScreen({
    Key key,
    @required this.camera,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  CameraController _controller;
  Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('FYP app console')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: MyWidget(),

      // FutureBuilder<void>(
      //   future: _initializeControllerFuture,
      //   builder: (context, snapshot) {
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       // If the Future is complete, display the preview.
      //       return CameraPreview(_controller);
      //     } else {
      //       // Otherwise, display a loading indicator.
      //       return Center(child: CircularProgressIndicator());
      //     }
      //   },
      // ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.camera_alt),
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            // Construct the path where the image should be saved using the
            // pattern package.
            final path = join(
              // Store the picture in the temp directory.
              // Find the temp directory using the `path_provider` plugin.
              (await getTemporaryDirectory()).path,
              '${DateTime.now()}.png',
            );
            print("Image path is $path");

            // Attempt to take a picture and log where it's been saved.
            await _controller.takePicture(path);

            // If the picture was taken, display it on a new screen.
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(imagePath: path),
              ),
            );
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
      ),
    );
  }
}

// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Instance snapshot')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new MyWidgetState();
  }
}

class MyWidgetState extends State<MyWidget> {
  double posx = 100.0;
  double posy = 100.0;

  var tapDownTime = DateTime.now();
  var tapUpTime = DateTime.now();
  var tapCount = 0;

  void onTapDown(BuildContext context, TapDownDetails details) {
    // print('${details.globalPosition}');
    final RenderBox box = context.findRenderObject();
    final Offset localOffset = box.globalToLocal(details.globalPosition);
    setState(() {
      posx = localOffset.dx;
      posy = localOffset.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTapDown: (TapDownDetails details) => onTapDown(context, details),
      child: new Stack(fit: StackFit.expand, children: <Widget>[
        // Hack to expand stack to fill all the space. There must be a better
        // way to do it.
        GestureDetector(
          child: Container(
            color: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Tapdown time $tapDownTime",style: TextStyle(
                  fontSize: 15,
                  color: Colors.lightGreen
                ),),
                Text("Tapup time $tapUpTime",style: TextStyle(
                  fontSize: 15,
                  color: Colors.lightGreen
                ),),
                Text("Tapup count $tapCount",style: TextStyle(
                  fontSize: 15,
                  color: Colors.lightGreen
                ),),
              ],
            ),
          ),
          onTap: () {
            setState(() {
              tapCount++;
            });
            print("on tap ${DateTime.now()}");
          },
          onTapCancel: () {
            print("on tap cancle ${DateTime.now()}");
          },
          onDoubleTap: () {
            print("on Double tap  ${DateTime.now()}");
          },
          onTapDown: (TapDownDetails details) => _onTapDown(details),
          onTapUp: (TapUpDetails details) => _onTapUp(details),
        )

        // new Positioned(
        //   child: new Text('hello'),
        //   left: posx,
        //   top: posy,
        // ),
      ]),
    );
  }

  _onTapDown(TapDownDetails details) {
    setState(() {
      tapDownTime = DateTime.now();
    });
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("tap down " +
        x.toString() +
        ", " +
        y.toString() +
        "time ${DateTime.now()}");
  }

  _onTapUp(TapUpDetails details) {
    setState(() {
      tapUpTime = DateTime.now();
    });
    var x = details.globalPosition.dx;
    var y = details.globalPosition.dy;
    print("tap up " +
        x.toString() +
        ", " +
        y.toString() +
        "time ${DateTime.now()}");
  }
}
