import 'package:flutter/material.dart';

import 'package:gowiide_broadband_app/services/resources_respository.dart';

class ComplaintListPage extends StatefulWidget {
  final String userId;

  const ComplaintListPage({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _ComplaintListPageState createState() => _ComplaintListPageState();
}

class _ComplaintListPageState extends State<ComplaintListPage> {
  final ApiRepository _apiRepository = ApiRepository();
  List<Map<String, dynamic>> _complaints = [];

  @override
  void initState() {
    super.initState();
    fetchComplaints();
  }

  Future<void> fetchComplaints() async {
    try {
      final List<Map<String, dynamic>> complaints =
          await _apiRepository.getUserComplaintList(widget.userId);
      setState(() {
        _complaints = complaints;
      });
    } catch (e) {
      print('Error: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Complaints List'),
      ),
      body: _complaints.isEmpty
          ? Center(child: Text('empty'))
          : ListView.builder(
              itemCount: _complaints.length,
              itemBuilder: (context, index) {
                final complaint = _complaints[index];
                return ListTile(
                  title: Text(complaint['complaintSubject']),
                  subtitle: Text('Status: ${complaint['complaintStatus']}'),
                  onTap: () {
                    // Handle onTap
                  },
                );
              },
            ),
    );
  }
}
