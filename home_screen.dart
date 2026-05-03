import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'widgets/stat_card.dart';
   // same folder
import 'vital_s_form.dart';   // same folder

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Patient info controllers
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  // Vitals controllers
  final TextEditingController _heartRateController = TextEditingController();
  final TextEditingController _bpController = TextEditingController();
  final TextEditingController _temperatureController = TextEditingController();
  final TextEditingController _sugarController = TextEditingController();

  // Settings
  bool _isOfflineMode = true;
  String _selectedLanguage = 'English';
  final List<String> _languages = ['English', 'Hindi', 'Gujarati', 'Punjabi'];
  int _currentIndex = 0;

  // Medicine inventory
  final List<Map<String, dynamic>> _medicines = [
    {'name': 'Paracetamol', 'available': true, 'quantity': 50},
    {'name': 'Amoxicillin', 'available': true, 'quantity': 30},
    {'name': 'Ibuprofen', 'available': false, 'quantity': 0},
    {'name': 'Metformin', 'available': true, 'quantity': 25},
    {'name': 'Atorvastatin', 'available': false, 'quantity': 0},
  ];
  final TextEditingController _medicineQueryController = TextEditingController();

  // Activity log
  final List<Map<String, String>> _activityLog = [
    {'title': 'Consultation started', 'time': '5 mins ago'},
    {'title': 'E-Prescription given', 'time': '15 mins ago'},
    {'title': 'Appointment confirmed', 'time': '45 mins ago'},
    {'title': 'Vitals saved', 'time': '1 hour ago'},
  ];

  void _addActivityLog(String title) {
    setState(() {
      _activityLog.insert(0, {'title': title, 'time': 'Just now'});
    });
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _heartRateController.dispose();
    _bpController.dispose();
    _temperatureController.dispose();
    _sugarController.dispose();
    _medicineQueryController.dispose();
    super.dispose();
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _languages.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(_languages[index]),
                  trailing: _selectedLanguage == _languages[index]
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLanguage = _languages[index];
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _showConsultationDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pending Consultations'),
          content: const Text('5 consultations are pending for today.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showAppointmentDetails() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Today's Appointments"),
          content: const Text('12 appointments scheduled for today.\nNext: S. Kaur (9:10-9:30 AM)'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _initiateVideoCall() {
    // Validate inputs
    if (_patientNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter patient name')),
      );
      return;
    }
    if (_mobileNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter mobile number')),
      );
      return;
    }

    // Save vitals (if any) and log activity
    String vitalsSummary = '';
    if (_heartRateController.text.isNotEmpty ||
        _bpController.text.isNotEmpty ||
        _temperatureController.text.isNotEmpty ||
        _sugarController.text.isNotEmpty) {
      vitalsSummary = 'HR:${_heartRateController.text}, BP:${_bpController.text}, Temp:${_temperatureController.text}, Sugar:${_sugarController.text}';
      _addActivityLog('Vitals saved for ${_patientNameController.text}');
    }
    _addActivityLog('Consultation started with ${_patientNameController.text}');

    // Show connecting dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text('Connecting to doctor...',
                    style: TextStyle(color: Colors.grey[700])),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ),
        );
      },
    );

    // Simulate connection
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pop(); // Close connecting dialog
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => VideoCallScreen(
            patientName: _patientNameController.text,
            language: _selectedLanguage,
          ),
        ),
      );
    });
  }

  void _showMedicineInventory() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String searchQuery = '';
        return StatefulBuilder(
          builder: (context, setState) {
            final filteredMedicines = _medicines.where((med) {
              return med['name'].toLowerCase().contains(searchQuery.toLowerCase());
            }).toList();

            return AlertDialog(
              title: const Text('Medicine Inventory'),
              content: SizedBox(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search medicines...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredMedicines.length,
                        itemBuilder: (context, index) {
                          final medicine = filteredMedicines[index];
                          return ListTile(
                            title: Text(medicine['name']),
                            subtitle: Text(medicine['available']
                                ? 'Available: ${medicine['quantity']}'
                                : 'Out of Stock'),
                            trailing: Icon(
                              medicine['available'] ? Icons.check_circle : Icons.error,
                              color: medicine['available'] ? Colors.green : Colors.red,
                            ),
                            onTap: () {
                              if (!medicine['available']) {
                                _showMedicineQueryDialog(medicine['name']);
                              }
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showMedicineQueryDialog(String medicineName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$medicineName Not Available'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('This medicine is currently out of stock. Would you like to send a query to the pharmacy?'),
              const SizedBox(height: 16),
              TextField(
                controller: _medicineQueryController,
                decoration: const InputDecoration(
                  hintText: 'Enter your query or special request...',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Query for $medicineName sent successfully!')),
                );
                _medicineQueryController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Send Query'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFF4CAF50),
              child: Icon(Icons.favorite, color: Colors.white),
            ),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sanjivni',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Consulting from Home for Healthcare',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.medical_services, color: Colors.grey),
            onPressed: _showMedicineInventory,
          ),
          IconButton(
            icon: const Icon(Icons.language, color: Colors.grey),
            onPressed: _showLanguageDialog,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Text(
                  'Offline Mode Ready',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 5),
                Switch(
                  value: _isOfflineMode,
                  onChanged: (value) {
                    setState(() {
                      _isOfflineMode = value;
                    });
                  },
                  activeColor: Colors.green,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: Colors.green[200],
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Welcome, Sahayak Apanjimar!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: <Widget>[
                Expanded(
                  child: StatCard(
                    title: 'Pending Consultations',
                    value: '5',
                    icon: Icons.access_time_filled,
                    color: Colors.blue,
                    detailsText: 'View Details',
                    onTap: _showConsultationDetails,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: StatCard(
                    title: "Today's Appointments",
                    value: '12',
                    icon: Icons.calendar_month,
                    color: Colors.green,
                    subValue: 'Total',
                    detailsText: 'Next: S. Kaur (9:10-9:30 AM)',
                    tag: 'All',
                    onTap: _showAppointmentDetails,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildPatientVisitSection(),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: VitalsForm(
                heartRateController: _heartRateController,
                bpController: _bpController,
                temperatureController: _temperatureController,
                sugarController: _sugarController,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _showMedicineInventory,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.medical_services, color: Colors.white),
                    label: const Text(
                      'Medicine Inventory',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _initiateVideoCall,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF50),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Save Vitals & Request Doctor',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildActivityLogSection(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color(0xFF4CAF50),
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chat feature coming soon!')),
            );
          } else if (index == 2) {
            _showMedicineInventory();
          } else if (index == 3) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Settings page coming soon!')),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble), label: 'Chat'),
          BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Medicine'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

  Widget _buildPatientVisitSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'New Patient Visit',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.sync, color: Colors.blue),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Syncing patient data...')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildTextField('Patient Name', _patientNameController),
          const SizedBox(height: 16),
          _buildTextField('Mobile Number', _mobileNumberController, isNumber: true),
          const SizedBox(height: 16),
          _buildTextField('Email', _emailController),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool isNumber = false}) {
    return TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
      ),
    );
  }

  Widget _buildActivityLogSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Activity History',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ..._activityLog.map((log) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(log['title']!, style: const TextStyle(fontSize: 14)),
                Text(log['time']!, style: TextStyle(fontSize: 12, color: Colors.grey[500])),
              ],
            ),
          )),
        ],
      ),
    );
  }
}

// Video Call Screen (kept here as it's only used in HomePage)
class VideoCallScreen extends StatelessWidget {
  final String patientName;
  final String language;

  const VideoCallScreen({
    Key? key,
    required this.patientName,
    required this.language,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Video Consultation - $patientName'),
        backgroundColor: const Color(0xFF2E7D32),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam, size: 100, color: Colors.green),
            const SizedBox(height: 20),
            const Text('Connected to Doctor',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Patient: $patientName', style: const TextStyle(fontSize: 18)),
            Text('Language: $language', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.mic, size: 36),
                  onPressed: () {},
                  color: Colors.green,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.videocam_off, size: 36),
                  onPressed: () {},
                  color: Colors.red,
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.call_end, size: 36),
                  onPressed: () => Navigator.of(context).pop(),
                  color: Colors.red,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}