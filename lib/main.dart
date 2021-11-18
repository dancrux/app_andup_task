import 'package:app_andup_task/app.dart';

import 'package:app_andup_task/viewModels/auth_view_model.dart';
import 'package:app_andup_task/viewModels/firebase_service_viewmodel.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) async {
    await Firebase.initializeApp();
    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
            create: (context) => AuthViewModel.instance()),
        ChangeNotifierProvider<FirebaseViewModel>(
            create: (context) => FirebaseViewModel())
      ],
      child: const App(),
    ));
  });
}
