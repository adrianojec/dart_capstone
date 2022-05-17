import 'dart:io';

import 'package:dart_capstone/credentials.dart';
import 'package:dart_capstone/employee.dart';
import 'package:dart_capstone/functions.dart';
import 'package:intl/intl.dart';

List<dynamic> newEmployeeList = <dynamic>[];
Map<int, dynamic> leaveRequests = {};
Map<String, dynamic> employeeBundyClock = {};

var forEmployeeId = 0;

void main() {
  var userRegister = UserEmployee();
  var choice = start();
  int loginId;
  while (choice != 'Q' && choice != 'q') {
    switch (choice) {
      case 'L':
      case 'l':
        String userRole = adminOrUser();
        if (userRole != 'No user!') {
          loginId = login(userRole);
          loginId == 000
              ? admin()
              : loginId >= 1
                  ? user(loginId)
                  : print('Invalid credentials!');
        } else {
          print('Please choose from the given options. Thank you!');
        }
        break;
      case 'R':
      case 'r':
        userRegister = UserEmployee();
        forEmployeeId += 1;
        userRegister.userAddDetails(newEmployeeId: forEmployeeId);
        newEmployeeList.add(userRegister);
        userCredentials.addAll({
          forEmployeeId: {
            'ID': forEmployeeId,
            'Username': userRegister.userName,
            'Password': userRegister.passWord,
          },
        });
        print('Successfully registered!');
        break;
      case 'T':
      case 't':
        int employeeId = getEmployeeId();
        int listIndex = Employee()
            .listIndex(employeeId: employeeId, employeeList: newEmployeeList);
        if (listIndex >= 0) {
          print(Employee().timeInTimeOut(
            employeeBundyClock: employeeBundyClock,
            employeeList: newEmployeeList,
            listIndex: listIndex,
            employeeId: employeeId,
          ));
        } else {
          print('Not existing!');
        }
        break;
      case 'Q':
      case 'q':
        loginId = -1;
        break;
      default:
        print('Please choose from the given options. Thank you!');
    }
    choice = start();
  }
}

void admin() {
  print('Please choose your actions: (A)Add (E)Edit (V)View List'
      ' (T)Time logs (L)Leave requests (D)Delete (Q)Quit');
  var choice = stdin.readLineSync();
  while (choice != 'Q' && choice != 'q') {
    var employee = Employee();
    switch (choice) {
      case 'A':
      case 'a':
        forEmployeeId += 1;
        employee.addDetails(
          newEmployeeId: forEmployeeId,
        );
        newEmployeeList.add(employee);
        userCredentials.addAll({
          forEmployeeId: {
            'ID': forEmployeeId,
            'Username': 'user@-$forEmployeeId',
            'Password': 'pass@-$forEmployeeId',
          },
        });
        print('Employee has been added successfully!');
        break;
      case 'E':
      case 'e':
        int employeeId = getEmployeeId();
        int index = employee.listIndex(
          employeeId: employeeId,
          employeeList: newEmployeeList,
        );
        if (index >= 0) {
          print('Pick the field you want to edit:');
          print('(1)First Name (2)Last Name (3)Day of Birth '
              '(4)Gender (5)Designation (6)Department (7)Leaves');
          int fieldNumber = int.parse(stdin.readLineSync()!);
          print('Enter updated value: ');
          String value = stdin.readLineSync()!;
          print(employee.updateFieldValue(
            fieldNumber: fieldNumber,
            indexList: index,
            newValue: value,
            employeeList: newEmployeeList,
          ));
        } else {
          print('No existing user!');
        }
        break;
      case 'V':
      case 'v':
        print('EMPLOYEES LIST');
        print('**********************************************');
        newEmployeeList.isEmpty
            ? print('Nothing to show here..')
            : newEmployeeList
                .map((employee) => employee.showDetails())
                .toList();
        break;
      case 'T':
      case 't':
        if (employeeBundyClock.isNotEmpty) {
          employeeBundyClock.forEach((key, value) {
            final day = key.split('-');
            print(day[0]);
            print('\tID: ${value['ID']}\n\tName: ${value['Name']}');
            print(
                '\tTime In: ${value['Time In']}\n\tTime Out: ${value['Time Out']}');
          });
        } else {
          print('Nothing to show here..');
        }
        break;
      case 'L':
      case 'l':
        if (leaveRequests.isNotEmpty) {
          print('LEAVE REQUESTS');
          print('**********************************************');
          leaveRequests.forEach((key, value) {
            value['Status'] == 'PENDING' || value['Status'] == 'DECLINED'
                ? print(
                    'ID: ${value['ID']}\nName: ${value['Name']}\nDate of Leave: ${value['Date of Leave']}\n'
                    'Reason: ${value['Reason']}\nStatus: ${value['Status']}')
                : print('No pending request. Thank you!');
          });
          choice = requestActions();
          if (choice != 'B' && choice != 'b') {
            int employeeId = getEmployeeId();
            leaveRequests.containsKey(employeeId) == false
                ? print('No pending request for this ID. Thank you!')
                : print(employee.changeStatus(
                    employeeId: employeeId,
                    choice: choice,
                    requestList: leaveRequests,
                    employeeList: newEmployeeList,
                  ));
          }
        } else {
          print('Nothing to show here..');
        }
        break;
      case 'D':
      case 'd':
        var employeeId = getEmployeeId();
        print(employee.deleteEmployee(
          employeeId: employeeId,
          employeeList: newEmployeeList,
        ));
        userCredentials.remove(employeeId);
        continue;
      case 'Q':
      case 'q':
        break;
      default:
        print('Please choose from the given options. Thank you!');
    }
    choice = nextAction();
  }
}

void user(int employeeId) {
  int listIndex = Employee().listIndex(
    employeeId: employeeId,
    employeeList: newEmployeeList,
  );
  var choice = nextUserAction();
  while (choice != 'Q' && choice != 'q') {
    switch (choice) {
      case 'E':
      case 'e':
        print(newEmployeeList[listIndex]);
        print('Username: ${userCredentials[employeeId]['Username']}');
        print('Password: ${userCredentials[employeeId]['Password']}');
        print('**********************************************');
        print('Pick the field you want to edit:');
        print('(1)First Name (2)Last Name (3)Day of Birth '
            '(4)Gender (5)Username (6)Password (7)Back');
        int field = int.parse(stdin.readLineSync()!);
        if (field != 7) {
          print('Enter updated value: ');
          String value = stdin.readLineSync()!;

          print(UserEmployee().userUpdateFieldValue(
            fieldNumber: field,
            indexList: listIndex,
            newValue: value,
            employeeList: newEmployeeList,
            userCredentials: userCredentials,
          ));
        }
        break;
      case 'M':
      case 'm':
        print('REQUEST');
        print('**********************************************');
        leaveRequests.containsKey(employeeId)
            ? print(
                'Date of Leave: ${leaveRequests[employeeId]['Date of Leave']}\nReason: '
                '${leaveRequests[employeeId]['Reason']}\nStatus : ${leaveRequests[employeeId]['Status']}')
            : print('Nothing to show here..');
        break;
      case 'T':
      case 't':
        String currentDay = DateFormat("MMMM dd, yyyy").format(DateTime.now());
        if (employeeBundyClock.containsKey('$currentDay-$employeeId')) {
          employeeBundyClock.forEach((key, value) {
            final day = key.split('-');
            print(day[0]);
            print(
                '\tTime In: ${value['Time In']}\n\tTime Out: ${value['Time Out']}');
          });
        } else {
          print('Nothing to show here..');
        }
        break;
      case 'R':
      case 'r':
        print('Available leaves: ${newEmployeeList[listIndex].leaves}');
        newEmployeeList[listIndex].leaves == 0
            ? print('You don\'t have any leave credits.')
            : (leaveRequests.containsKey(employeeId) == false)
                ? addRequest(
                    employeeId: employeeId,
                    listIndex: listIndex,
                    listOfRequest: leaveRequests,
                    employeeList: newEmployeeList,
                  )
                : (checkPending(employeeId) == true)
                    ? print('You still have a pending request. Thank you!')
                    : addRequest(
                        employeeId: employeeId,
                        listIndex: listIndex,
                        listOfRequest: leaveRequests,
                        employeeList: newEmployeeList,
                      );
        break;
      case 'Q':
      case 'q':
        break;
      default:
        print('Please choose from the given options. Thank you!');
    }
    choice = nextUserAction();
  }
}
