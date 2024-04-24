

import 'package:firebase_auth/firebase_auth.dart';
import 'package:schedule_calendar/login/login_page.dart';

//const root = "JFPZIljXFtUjkSi6jl6qc24lK8J3";
//const root = "schedule";
// var uid = LoginPage().userUid;

final root = FirebaseAuth.instance.currentUser!.uid;
