import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:wire/config/colors.dart';

class SpeedCheck extends StatefulWidget {
  const SpeedCheck({Key? key}) : super(key: key);

  @override
  State<SpeedCheck> createState() => _SpeedCheckState();
}

class _SpeedCheckState extends State<SpeedCheck> {
  final internetSpeedTest = FlutterInternetSpeedTest()..enableLog();

  bool _testInProgress = false;
  double _downloadRate = 0;
  double _uploadRate = 0;
  String _downloadProgress = '0';
  String _uploadProgress = '0';
  int downloadCompletionTime = 0;
  int uploadCompletionTime = 0;
  bool isServerSelectionInProgress = false;

  String? _ip;
  String? _asn;
  String? _isp;

  String _unitText = 'Mbps';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff040819),
      appBar: AppBar(backgroundColor: const Color(0xff040819)),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SfRadialGauge(
                      enableLoadingAnimation: true,
                      // title: GaugeTitle(
                      //     text:
                      //     textStyle: const TextStyle(
                      //         fontSize: 20.0, fontWeight: FontWeight.bold)),
                      axes: <RadialAxis>[
                        RadialAxis(
                            minimum: 0,
                            maximum: 150,
                            axisLabelStyle:
                                const GaugeTextStyle(color: Colors.blue),
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 50,
                                  color: Colors.blue,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 50,
                                  endValue: 100,
                                  color: Colors.blue,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 100,
                                  endValue: 150,
                                  color: Colors.blue,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: _uploadProgress == "0"
                                    ? _downloadRate
                                    : _uploadRate,
                                enableAnimation: true,
                                knobStyle: const KnobStyle(knobRadius: 0.05),
                                needleEndWidth: 5,
                                needleLength: 0.4,
                                needleStartWidth: 0.4,
                              )
                            ],
                            axisLineStyle: const AxisLineStyle(
                              gradient: SweepGradient(colors: [
                                Colors.blue,
                                Colors.green,
                              ]),
                            ),
                            annotations: <GaugeAnnotation>[
                              GaugeAnnotation(
                                  widget: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _uploadProgress == "0"
                                            ? '${_downloadRate.toStringAsFixed(2)} $_unitText'
                                            : '${_uploadRate.toStringAsFixed(2)} $_unitText',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: blue,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        _uploadProgress != "0"
                                            ? 'Upload Speed'
                                            : 'Download Speed',
                                        style: const TextStyle(
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                  angle: 90,
                                  positionFactor: 0.7)
                            ])
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 70,
                            width: 100,
                            child: SfRadialGauge(axes: <RadialAxis>[
                              RadialAxis(
                                minimum: 0,
                                maximum: 100,
                                pointers: <GaugePointer>[
                                  NeedlePointer(
                                    value: num.parse(_uploadProgress == "0"
                                            ? _downloadProgress
                                            : _uploadProgress)
                                        .toDouble(),
                                    enableAnimation: true,
                                    needleStartWidth: 1,
                                    needleEndWidth: 0,
                                    needleLength: 0.4,
                                  )
                                ],
                                axisLabelStyle:
                                    const GaugeTextStyle(fontSize: 0),
                                axisLineStyle: const AxisLineStyle(
                                  gradient: SweepGradient(
                                    colors: [
                                      Colors.blue,
                                      Colors.green,
                                    ],
                                  ),
                                  thickness: 4,
                                ),
                              )
                            ]),
                          ),
                          const Text(
                            "Progress",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          // if (_uploadProgress == "0")
                          //   if (_downloadCompletionTime > 0)
                          //     Text(
                          //         'Time taken: ${(_downloadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
                          // if (_uploadProgress != "0")
                          //   if (_uploadCompletionTime > 0)
                          //     Text(
                          //         'Time taken: ${(_uploadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  if (_ip != null)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xff20253A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          child: Column(
                            children: [
                              const Text("IP Address"),
                              Text(
                                _ip ?? '--',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xff20253A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          child: Column(
                            children: [
                              const Text("ASP"),
                              Text(
                                _asn ?? '--',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xff20253A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          child: Column(
                            children: [
                              const Text("ISP"),
                              Text(
                                _isp ?? '--',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_downloadProgress == "100")
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xff20253A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.file_download_sharp,
                                size: 18,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "$_downloadRate $_unitText",
                                style: TextStyle(color: blue, fontSize: 16),
                              ),
                              const SizedBox(height: 4.0),
                              const Text(
                                "Download",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      if (_uploadProgress == "100")
                        Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xff20253A),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.only(
                              left: 25, right: 25, top: 10, bottom: 10),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.upload,
                                size: 18,
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                "$_uploadRate $_unitText",
                                style: TextStyle(color: blue),
                              ),
                              const SizedBox(height: 4.0),
                              const Text(
                                "Upload",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              if (!_testInProgress) ...{
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: blue,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Start Speed Test',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  onPressed: () async {
                    reset();
                    await internetSpeedTest.startTesting(onStarted: () {
                      setState(() => _testInProgress = true);
                    }, onCompleted: (TestResult download, TestResult upload) {
                      if (kDebugMode) {
                        print(
                            'the transfer rate ${download.transferRate}, ${upload.transferRate}');
                      }
                      setState(() {
                        _downloadRate = download.transferRate;
                        _unitText =
                            download.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _downloadProgress = '100';
                        downloadCompletionTime = download.durationInMillis;
                      });
                      setState(() {
                        _uploadRate = upload.transferRate;
                        _unitText =
                            upload.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _uploadProgress = '100';
                        uploadCompletionTime = upload.durationInMillis;
                        _testInProgress = false;
                      });
                    }, onProgress: (double percent, TestResult data) {
                      if (kDebugMode) {
                        print(
                            'the transfer rate $data.transferRate, the percent $percent');
                      }
                      setState(() {
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        if (data.type == TestType.download) {
                          _downloadRate = data.transferRate;
                          _downloadProgress = percent.toStringAsFixed(2);
                        } else {
                          _uploadRate = data.transferRate;
                          _uploadProgress = percent.toStringAsFixed(2);
                        }
                      });
                    }, onError: (String errorMessage, String speedTestError) {
                      if (kDebugMode) {
                        print(
                            'the errorMessage $errorMessage, the speedTestError $speedTestError');
                      }
                      reset();
                    }, onDefaultServerSelectionInProgress: () {
                      setState(() {
                        isServerSelectionInProgress = true;
                      });
                    }, onDefaultServerSelectionDone: (Client? client) {
                      setState(() {
                        isServerSelectionInProgress = false;
                        _ip = client?.ip;
                        _asn = client?.asn;
                        _isp = client?.isp;
                      });
                    }, onDownloadComplete: (TestResult data) {
                      setState(() {
                        _downloadRate = data.transferRate;
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        downloadCompletionTime = data.durationInMillis;
                      });
                    }, onUploadComplete: (TestResult data) {
                      setState(() {
                        _uploadRate = data.transferRate;
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        uploadCompletionTime = data.durationInMillis;
                      });
                    }, onCancel: () {
                      reset();
                    });
                  },
                )
              } else ...{
                const CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton.icon(
                    onPressed: () => internetSpeedTest.cancelTest(),
                    icon: const Icon(Icons.cancel_rounded),
                    label: const Text('Cancel'),
                  ),
                )
              },
            ],
          ),
        ),
      ),
    );
  }

  void reset() {
    setState(() {
      {
        _testInProgress = false;
        _downloadRate = 0;
        _uploadRate = 0;
        _downloadProgress = '0';
        _uploadProgress = '0';
        _unitText = 'Mbps';
        downloadCompletionTime = 0;
        uploadCompletionTime = 0;

        _ip = null;
        _asn = null;
        _isp = null;
      }
    });
  }
}
