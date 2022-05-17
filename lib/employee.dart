// ignore_for_file: avoid_print
import 'dart:io';
import 'package:intl/intl.dart';

class Person {
  late int employeeId;
  late String firstName;
  late String lastName;
  late String dateOfBirth;
  late String gender;

  void addDetails({
    required int newEmployeeId,
  }) {
    employeeId = newEmployeeId;
    print('First Name:');
    firstName = stdin.readLineSync()!;
    print('Last Name:');
    lastName = stdin.readLineSync()!;
    print('Date of Birth:');
    dateOfBirth = stdin.readLineSync()!;
    print('Gender:');
    gender = stdin.readLineSync()!;
  }

  void showDetails() {
    print(
        'ID: $employeeId\nFullname: $firstName $lastName\nDate of Birth: $dateOfBirth\nGender: $gender');
  }
}

class Employee extends Person {
  late String designation;
  late String department;
  late int leaves;

  void userAddDetails({
    required int newEmployeeId,
  }) {
    super.addDetails(newEmployeeId: newEmployeeId);
    designation = '';
    department = '';
    leaves = 0;
  }

  @override
  void addDetails({required int newEmployeeId}) {
    super.addDetails(newEmployeeId: newEmployeeId);
    print('Designation:');
    designation = stdin.readLineSync()!;
    print('Department:');
    department = stdin.readLineSync()!;
    print('Leaves:');
    String leaveCredits = stdin.readLineSync()!;
    while (int.tryParse(leaveCredits) == null) {
      print('Please enter a number. Thank you!\nLeaves:');
      leaveCredits = stdin.readLineSync()!;
    }
    leaves = int.parse(leaveCredits);
  }

  String updateFieldValue({
    required int fieldNumber,
    required int indexList,
    required String newValue,
    required List<dynamic> employeeList,
  }) {
    String field;
    switch (fieldNumber) {
      case 1:
        employeeList[indexList].firstName = newValue;
        field = 'First name has been updated!';
        break;
      case 2:
        employeeList[indexList].lastName = newValue;
        field = 'Last name has been updated!';
        break;
      case 3:
        employeeList[indexList].dateOfBirth = newValue;
        field = 'Date of birth has been updated!';
        break;
      case 4:
        employeeList[indexList].gender = newValue;
        field = 'Gender has been updated!';
        break;
      case 5:
        employeeList[indexList].designation = newValue;
        field = 'Designation has been updated!';
        break;
      case 6:
        employeeList[indexList].department = newValue;
        field = 'Department has been updated!';
        break;
      case 7:
        employeeList[indexList].leaves = int.parse(newValue);
        field = 'Leaves has been updated!';
        break;
      default:
        field = 'Please choose from the given number. Thank you!';
    }
    return field;
  }

  int listIndex({
    required int employeeId,
    required List<dynamic> employeeList,
  }) {
    int? result;
    if (employeeList.isEmpty) {
      result = -2;
    } else {
      List<int> index = List.generate(employeeList.length, (index) => index);
      try {
        index.map((indexList) {
          (employeeList[indexList].employeeId == employeeId)
              ? throw result = indexList
              : result = -1;
        }).toList();
      } catch (e) {}
    }
    return result!;
  }

  String deleteEmployee({
    required int employeeId,
    required List<dynamic> employeeList,
  }) {
    int? index = listIndex(employeeId: employeeId, employeeList: employeeList);
    if (index == -1) {
      return 'No existing user. Thank you!';
    } else {
      employeeList.removeAt(index);
      return 'A record was deleted successfully!';
    }
  }

  String changeStatus({
    required int employeeId,
    required String choice,
    required Map<int, dynamic> requestList,
    required List<dynamic> employeeList,
  }) {
    late String message;

    var indexList = listIndex(
      employeeId: employeeId,
      employeeList: employeeList,
    );
    switch (choice) {
      case 'A':
      case 'a':
        requestList[employeeId]['Status'] = 'APPROVED';
        employeeList[indexList].leaves -= 1;
        message = 'Request has been approved. Thank you!';
        break;
      case 'D':
      case 'd':
        requestList[employeeId]['Status'] = 'DECLINED';
        message = 'Request has been declined. Thank you!';
        break;
      case 'B':
      case 'b':
        break;
      default:
        message = 'Please choose from the given options. Thank you!';
    }

    return message;
  }

  String timeInTimeOut({
    required Map<String, dynamic> employeeBundyClock,
    required List<dynamic> employeeList,
    required int listIndex,
    required int employeeId,
  }) {
    String currentDay = DateFormat("MMMM dd, yyyy").format(DateTime.now());
    String currentTime = DateFormat("hh:mm:ss a").format(DateTime.now());
    String message;

    if (employeeBundyClock.containsKey('$currentDay-$employeeId')) {
      if (employeeBundyClock['$currentDay-$employeeId']['Time Out'] != '') {
        message = 'You already logged out for the day. Thank you!';
      } else {
        employeeBundyClock['$currentDay-$employeeId']['Time Out'] = currentTime;
        message = 'You are now logged out. Take care!';
      }
    } else {
      employeeBundyClock.addAll({
        '$currentDay-$employeeId': {
          'ID': employeeId,
          'Name':
              '${employeeList[listIndex].firstName} ${employeeList[listIndex].lastName}',
          'Time In': currentTime,
          'Time Out': '',
        }
      });
      message = 'You\'re logged in. Happy Working!';
    }
    return message;
  }

  @override
  void showDetails() {
    super.showDetails();
    print(
        'Designation: $designation\nDepartment: $department\nLeave Credits: $leaves day/s\n');
  }

  @override
  String toString() {
    return 'ID: $employeeId\nFullname: $firstName $lastName\nBirthday: $dateOfBirth\nGender: $gender';
  }
}

class UserEmployee extends Employee {
  late final String userName;
  late final String passWord;

  @override
  void userAddDetails({
    required int newEmployeeId,
  }) {
    super.userAddDetails(newEmployeeId: newEmployeeId);
    print('Username: ');
    userName = stdin.readLineSync()!;
    print('Password: ');
    passWord = stdin.readLineSync()!;
  }

  String userUpdateFieldValue({
    required int fieldNumber,
    required int indexList,
    required String newValue,
    required List<dynamic> employeeList,
    required Map<int, dynamic> userCredentials,
  }) {
    String field;
    switch (fieldNumber) {
      case 1:
        employeeList[indexList].firstName = newValue;
        field = 'First name has been updated!';
        break;
      case 2:
        employeeList[indexList].lastName = newValue;
        field = 'Last name has been updated!';
        break;
      case 3:
        employeeList[indexList].dateOfBirth = newValue;
        field = 'Date of birth has been updated!';
        break;
      case 4:
        employeeList[indexList].gender = newValue;
        field = 'Gender has been updated!';
        break;
      case 5:
        userCredentials[employeeList[indexList].employeeId]['Username'] =
            newValue;
        field = 'Username has been updated!';
        break;
      case 6:
        userCredentials[employeeList[indexList].employeeId]['Password'] =
            newValue;
        field = 'Password has been updated!';
        break;
      default:
        field = 'Please choose from the given number. Thank you!';
    }
    return field;
  }

  @override
  String toString() {
    return 'ID: $employeeId\nFullname: $firstName $lastName\nBirthday: $dateOfBirth\nGender: $gender';
  }
}
