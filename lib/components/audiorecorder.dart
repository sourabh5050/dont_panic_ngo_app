import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:audio/audio.dart';
class AudioRecorder extends StatefulWidget {
  @override
  _AudioRecorderState createState() => _AudioRecorderState();
}

class _AudioRecorderState extends State<AudioRecorder> {


  final firestore = Firestore.instance;
  Audio audioPlayer = Audio(single: true);
  FlutterAudioRecorder _recorder;
  Recording _recording;
  Timer _t;
  Widget _buttonIcon = Icon(Icons.do_not_disturb_on);
  String _alert;
  String fileName, filePath,timeStamp,downloadUrl;
  String audioFile, statuss = 'Recorder Initialized', uploaderName = '';
  File file2;
  Color color = Colors.blue;
  List<String> sp;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _prepare();
    });
  }

  Future uploadFile() async {
    StorageReference storageReference =
    FirebaseStorage.instance.ref().child('storage1/temp');
    StorageUploadTask uploadTask = storageReference.putFile(file2);
    var downUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    print('File Uploaded');
    print(uploaderName);
    print(timeStamp);
    setState(() {
      statuss = 'File Successfully Uploaded';
    });
    setState(() {
      downloadUrl = downUrl;
    });
    //print(downloadUrl);
    updateData();

  }

  void updateData() async{
    await firestore.collection('Recordings').document('Audio').updateData({'Audio':downloadUrl});
  }


  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        {
          setState(() {
            statuss = 'Recording Started';
            color = Colors.green;
          });
          await _startRecording();
          break;
        }
      case RecordingStatus.Recording:
        {
          setState(() {
            statuss = 'Recording Stopped';
            color = Colors.red;
          });
          await _stopRecording();
          break;
        }
      case RecordingStatus.Stopped:
        {
          setState(() {
            statuss = 'Uploading';
            color = Colors.green;
          });
          await alert11();
          break;
        }

      default:
        break;
    }
    setState(() {
      _buttonIcon = _playerIcon(_recording.status);
    });
  }

  Future alert11() async {
    Alert(
      context: context,
      title: "File Upload",
      content: TextField(
        decoration: InputDecoration(
          labelText: 'Full Name',
        ),
        onChanged: (value) {
          uploaderName = value;
        },
      ),
      buttons: [
        DialogButton(
          child: Text(
            "Upload",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            //await uploadFile();
            File file1 = File('$filePath.wav');
            setState(() {
              file2 = file1;
              sp = filePath.split('/');
              fileName = sp[4];
              timeStamp = DateTime.now().toString();
            });
            uploadFile();
            Navigator.pop(context);
            _prepare();
          },
          width: 120,
        ),
        DialogButton(
          color: Colors.red,
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              statuss = 'Recording Cancelled';
              color = Colors.orangeAccent;
            });
            _prepare();
          },
        ),
      ],
    ).show();
  }

  Future _init() async {
    String customPath;
    customPath = 'storage/emulated/0/Music/File-' +
        DateTime.now().millisecondsSinceEpoch.toString();
    filePath = customPath;

    // .wav <---> AudioFormat.WAV
    // .mp4 .m4a .aac <---> AudioFormat.AAC
    // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.

    _recorder = FlutterAudioRecorder(customPath,
        audioFormat: AudioFormat.WAV, sampleRate: 22050);
    await _recorder.initialized;
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      setState(() {
        _recording = result;
        _buttonIcon = _playerIcon(_recording.status);
        _alert = "";
      });
    } else {
      setState(() {
        _alert = "Permission Required.";
      });
    }
  }

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current();
    setState(() {
      _recording = current;
    });

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      setState(() {
        _recording = current;
        _t = t;
      });
    });
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();

    setState(() {
      _recording = result;
    });
  }

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        {
          return Icon(Icons.fiber_manual_record);
        }
      case RecordingStatus.Recording:
        {
          return Icon(Icons.stop);
        }
      case RecordingStatus.Stopped:
        {
          return Icon(Icons.file_upload);
        }
      default:
        return Icon(Icons.do_not_disturb_on);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Duration',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '${_recording?.duration ?? "-"}',
                style: Theme.of(context).textTheme.body1,
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Status',
                style: Theme.of(context).textTheme.title,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                statuss,
                style: TextStyle(
                  color: color,
                  fontSize: 20,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                '${_alert ?? ""}',
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(color: Colors.red),
              ),
             /* RaisedButton(
                color: Colors.blue,
                child: Text('Play',style: TextStyle(
                  color: Colors.white,
                ),
                ),
                onPressed: (){
                  audioPlayer.play(downloadUrl);
                },
              ),*/
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _opt,
        child: _buttonIcon,
        tooltip: 'Don\'t Hold',
      ),
    );
  }
}
