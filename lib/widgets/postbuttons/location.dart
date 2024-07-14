import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LocationButton extends StatefulWidget {
  final String name;
  // ignore: non_constant_identifier_names
  const LocationButton({super.key, required this.name});

  @override
  State<LocationButton> createState() => _LocationButtonState();
}

class _LocationButtonState extends State<LocationButton> {
  String? _currentAddress;
  Position? _currentPosition;
  bool _isLoading = false;
  getPostion() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  //get current position with high accuracy
  Future<void> _getCurrentPosition() async {
    setState(() => _isLoading = true);
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      setState(() => _isLoading = false);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color.fromARGB(150, 0, 0, 0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            InkWell(
              child: const Icon(Icons.pin_drop, size: 25,),
              onTap: () async {
                String name = widget.name;
                _isLoading ?
                const Center(child: CircularProgressIndicator()):
                await _getCurrentPosition().then((value) => {
                  showBottomSheet(
                          enableDrag: false,
                          context: context,
                          backgroundColor: const Color.fromARGB(100, 0, 0, 0),
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: SizedBox(
                                      height: 560,
                                      width: (double.infinity / 10),
                                      child: WebView(
                                        initialUrl:
                                            'https://www.google.com/maps/dir/?api=1&origin=${_currentPosition?.latitude},${_currentPosition?.longitude}&destination=${widget.name}}+%?&destination_place=${widget.name}&travelmode=walking',
                                        gestureNavigationEnabled: true,

                                    ),
                                  ),
                                  )],
                              ),
                            );
                          })
                    });
              },
            ),
            const SizedBox(
              height: 5,
            )
          ],
        ),
      ),
    );
  }

  //check location permission status before anything
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

}
class WebView extends StatefulWidget{
  final String url;

  WebView({required this.url})

  @override
  WebViewState createState() => WebViewState();
}
class WebViewState extends State<WebView>{
  late final WebViewController _controller;

  @override
  void initState(){
    super.initState();
    _controller = WebViewController();
  }

  @override
  Widget build(BuildContext context){

    return WebViewWidget(
        controller: _controller,
        initialUrl:widget.url,
    )
  }
}
