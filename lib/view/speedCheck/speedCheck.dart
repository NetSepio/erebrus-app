import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_internet_speed_test/flutter_internet_speed_test.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

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
  int _downloadCompletionTime = 0;
  int _uploadCompletionTime = 0;
  bool _isServerSelectionInProgress = false;

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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (_ip != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(_isServerSelectionInProgress
                      ? 'Selecting Server...'
                      : 'IP: ${_ip ?? '--'} | ASP: ${_asn ?? '--'} | ISP: ${_isp ?? '--'}'),
                ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SfRadialGauge(
                      title: GaugeTitle(
                          text: _uploadProgress != "0"
                              ? 'Upload Speed'
                              : 'Download Speed',
                          textStyle: const TextStyle(
                              fontSize: 20.0, fontWeight: FontWeight.bold)),
                      axes: <RadialAxis>[
                        RadialAxis(
                            minimum: 0,
                            maximum: 150,
                            axisLabelStyle: const GaugeTextStyle(),
                            ranges: <GaugeRange>[
                              GaugeRange(
                                  startValue: 0,
                                  endValue: 50,
                                  // color: Colors.red,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 50,
                                  endValue: 100,
                                  // color: Colors.amber,
                                  startWidth: 10,
                                  endWidth: 10),
                              GaugeRange(
                                  startValue: 100,
                                  endValue: 150,
                                  // color: Colors.green,
                                  startWidth: 10,
                                  endWidth: 10)
                            ],
                            pointers: <GaugePointer>[
                              NeedlePointer(
                                value: _uploadProgress == "0"
                                    ? _downloadRate
                                    : _uploadRate,
                                enableAnimation: true,
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
                                  widget: Container(
                                    child: Text(
                                      _uploadProgress == "0"
                                          ? '${_downloadRate.toStringAsFixed(2)} $_unitText'
                                          : '${_uploadRate.toStringAsFixed(2)} $_unitText',
                                      style: const TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  angle: 90,
                                  positionFactor: 0.5)
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
                                  gradient: SweepGradient(colors: [
                                    Colors.blue,
                                    Colors.green,
                                  ]),
                                ),
                              )
                            ]),
                          ),
                          const Text(
                            "Progress",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (_uploadProgress == "0")
                            if (_downloadCompletionTime > 0)
                              Text(
                                  'Time taken: ${(_downloadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
                          if (_uploadProgress != "0")
                            if (_uploadCompletionTime > 0)
                              Text(
                                  'Time taken: ${(_uploadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (_downloadProgress == "100")
                        Column(
                          children: [
                            const Text(
                              'Download Speed',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Progress: $_downloadProgress%'),
                            Text('Download Rate: $_downloadRate $_unitText'),
                            if (_downloadCompletionTime > 0)
                              Text(
                                  'Time taken: ${(_downloadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
                          ],
                        ),
                      if (_uploadProgress == "100")
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              'Upload Speed',
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Progress: $_uploadProgress%'),
                            Text('Upload Rate: $_uploadRate $_unitText'),
                            if (_uploadCompletionTime > 0)
                              Text(
                                  'Time taken: ${(_uploadCompletionTime / 1000).toStringAsFixed(2)} sec(s)'),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 25.0),
              if (!_testInProgress) ...{
                ElevatedButton(
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Start Speed Test',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                        _downloadCompletionTime = download.durationInMillis;
                      });
                      setState(() {
                        _uploadRate = upload.transferRate;
                        _unitText =
                            upload.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _uploadProgress = '100';
                        _uploadCompletionTime = upload.durationInMillis;
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
                        _isServerSelectionInProgress = true;
                      });
                    }, onDefaultServerSelectionDone: (Client? client) {
                      setState(() {
                        _isServerSelectionInProgress = false;
                        _ip = client?.ip;
                        _asn = client?.asn;
                        _isp = client?.isp;
                      });
                    }, onDownloadComplete: (TestResult data) {
                      setState(() {
                        _downloadRate = data.transferRate;
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _downloadCompletionTime = data.durationInMillis;
                      });
                    }, onUploadComplete: (TestResult data) {
                      setState(() {
                        _uploadRate = data.transferRate;
                        _unitText =
                            data.unit == SpeedUnit.kbps ? 'Kbps' : 'Mbps';
                        _uploadCompletionTime = data.durationInMillis;
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
        _downloadCompletionTime = 0;
        _uploadCompletionTime = 0;

        _ip = null;
        _asn = null;
        _isp = null;
      }
    });
  }
}
