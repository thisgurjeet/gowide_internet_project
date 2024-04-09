import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiRepository {
  final String baseUrl = 'https://www.gowidenet.in/admin/api';

  // user complaint list api
  Future<List<Map<String, dynamic>>> getUserComplaintList(String userId) async {
    final url = '$baseUrl/complaint/UserComplaintList.php?userID=$userId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(response.body)['records'];
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch user complaints');
      }
    } catch (e) {
      throw Exception('Failed to fetch user complaints: $e');
    }
  }

  // PAYMENT HISTORY API

  Future<List<Map<String, dynamic>>> getPaymentHistory(String userId) async {
    final url = '$baseUrl/file/PaymentHistory.php?userID=$userId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(response.body)['records'];
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch payment history');
      }
    } catch (e) {
      throw Exception('Failed to fetch payment history: $e');
    }
  }
  // check plan status

  Future<Map<String, dynamic>> checkPlanStatus(String userId) async {
    final url = '$baseUrl/file/CheckPlanStatus.php?userID=$userId';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        // Parse JSON response
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to check plan status');
      }
    } catch (e) {
      throw Exception('Failed to check plan status: $e');
    }
  }

// complaints list subject
  Future<List<String>> getComplaintSubjects() async {
    final url = '$baseUrl/SubjectList.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(response.body)['records'];
        return responseData.cast<String>();
      } else {
        throw Exception('Failed to fetch complaint subjects');
      }
    } catch (e) {
      throw Exception('Failed to fetch complaint subjects: $e');
    }
  }

  // GET PLANS LIST API
  Future<List<Map<String, dynamic>>> getPlansList() async {
    final url = '$baseUrl/PlanList.php';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(response.body)['records'];
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch plans list');
      }
    } catch (e) {
      throw Exception('Failed to fetch plans list: $e');
    }
  }

  // Register Complaint API
  Future<Map<String, dynamic>> registerComplaint(
      String userId, String subject, String message) async {
    final url = '$baseUrl/complaint/RegisterComplaint.php';
    final Map<String, String> body = {
      "userID": userId,
      "subject": subject,
      "message": message
    };
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register complaint');
      }
    } catch (e) {
      throw Exception('Failed to register complaint: $e');
    }
  }

  // Notification History API
  Future<List<Map<String, dynamic>>> getNotificationHistory(
      String username) async {
    final url = '$baseUrl/NotificationHistory.php?username=$username';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> responseData =
            json.decode(response.body)['records'];
        return responseData.cast<Map<String, dynamic>>();
      } else {
        throw Exception('Failed to fetch notification history');
      }
    } catch (e) {
      throw Exception('Failed to fetch notification history: $e');
    }
  }

  // Update Notification Status API
  Future<void> updateNotificationStatus(String nid, String username) async {
    final url =
        '$baseUrl/UpdateNotificationStatus.php?nid=$nid&username=$username';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] != 'OK') {
          throw Exception('Failed to update notification status');
        }
      } else {
        throw Exception('Failed to update notification status');
      }
    } catch (e) {
      throw Exception('Failed to update notification status: $e');
    }
  }
  // download invoice
}
