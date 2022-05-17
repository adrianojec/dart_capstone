import 'dart:io';
import 'package:dart_capstone/credentials.dart';
import 'package:dart_capstone/main.dart';

String nextAction() {
  print('**********************************************');
  print('Choose another action: (A)Add (E)Edit (V)View List '
      '(T)Time logs (L)Leave requests (D)Delete (Q)Quit');
  String choice = stdin.readLineSync()!;
  return choice;
}

String nextUserAction() {
  print('**********************************************');
  print('Choose another action: (E)Edit (M)My Request (T)Time Logs '
      '(R)Request a leave (Q)Quit');
  String choice = stdin.readLineSync()!;
  return choice;
}

String requestActions() {
  print('**********************************************');
  print('Actions: (A)Approve (D)Decline (B)Back');
  String choice = stdin.readLineSync()!;
  return choice;
}

String start() {
  print('Please choose here: (L)Login (R)Register (T)Time In/Out (Q)Quit');
  String choice = stdin.readLineSync()!;
  return choice;
}

int login(String userRole) {
  print('Enter username: ');
  String userName = stdin.readLineSync()!;
  print('Enter password: ');
  String passWord = stdin.readLineSync()!;
  late int userId;
  switch (userRole) {
    case 'A':
    case 'a':
      userId = (userName == adminCredentials['Username'] &&
              passWord == adminCredentials['Password'])
          ? adminCredentials['ID']
          : -1;
      break;
    case 'U':
    case 'u':
      if (userCredentials.isNotEmpty) {
        try {
          userCredentials.forEach((key, value) {
            userName == userCredentials[key]['Username'] &&
                    passWord == userCredentials[key]['Password']
                ? throw userId = userCredentials[key]['ID']
                : userId = -1;
          });
        } catch (e) {}
      } else {
        // print('There is no existing user. Thank you!');
        userId = -1;
      }
      break;
    default:
      userId = 0;
  }

  return userId;
}

int getEmployeeId() {
  int employeeId;
  print('Enter the Employee ID:');
  String stringEmployeeId = stdin.readLineSync()!;
  while (int.tryParse(stringEmployeeId) == null) {
    print('Please enter a number. Thank you!\nEnter the Employee ID:');
    stringEmployeeId = stdin.readLineSync()!;
  }
  employeeId = int.parse(stringEmployeeId);
  return employeeId;
}

String adminOrUser() {
  print('Choose your role here: (A)Admin or (U)User');
  String userRole = stdin.readLineSync()!;
  switch (userRole) {
    case 'A':
    case 'a':
      return userRole;
    case 'U':
    case 'u':
      return userRole;
    default:
      return userRole = 'No user!';
  }
}

bool checkPending(int employeeId) {
  bool result = leaveRequests[employeeId]['Status'] == 'PENDING';
  return result;
}

void addRequest({
  required int employeeId,
  required int listIndex,
  required Map<int, dynamic> listOfRequest,
  required List<dynamic> employeeList,
}) {
  print('Reason: ');
  String reason = stdin.readLineSync()!;
  print('Date of leave: ');
  String dateOfLeave = stdin.readLineSync()!;
  listOfRequest.addAll({
    employeeId: {
      'ID': employeeId,
      'Name':
          '${employeeList[listIndex].firstName} ${employeeList[listIndex].lastName}',
      'Date of Leave': dateOfLeave,
      'Reason': reason,
      'Status': 'PENDING',
    }
  });
  print('Request submitted. Thank you!');
}
