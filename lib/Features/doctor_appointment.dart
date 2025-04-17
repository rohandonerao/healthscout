import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorAppointment extends StatefulWidget {
  @override
  _DoctorAppointmentState createState() => _DoctorAppointmentState();
}

class _DoctorAppointmentState extends State<DoctorAppointment> {
  String? patientName;
  String? selectedHospital;
  String? selectedDoctor;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  final Map<String, List<String>> hospitalDoctors = {
    "Yashosai Hospital": ["Dr. A Sharma", "Dr. B Patel", "Dr. C Verma"],
    "Aadhar Hospital": ["Dr. D Singh", "Dr. E Rao"],
    "Government Hospital": ["Dr. F Mehta", "Dr. G Nair", "Dr. H Das"],
    "Bhagvati Hospital": ["Dr. A Patil", "Dr. B Chavhan", "Dr. N Verma"],
  };

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  Future<void> bookAppointment() async {
    if (patientName != null &&
        selectedHospital != null &&
        selectedDoctor != null &&
        selectedDate != null &&
        selectedTime != null) {
      String doctorName = selectedDoctor!;
      String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate!);
      String formattedTime = selectedTime!.format(context);

      await FirebaseFirestore.instance.collection('appointments').add({
        'patientName': patientName,
        'hospital': selectedHospital,
        'doctor': doctorName,
        'date': formattedDate,
        'time': formattedTime,
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        patientName = null;
        selectedHospital = null;
        selectedDoctor = null;
        selectedDate = null;
        selectedTime = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Appointment booked with $doctorName"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> deleteAppointment(String docId) async {
    await FirebaseFirestore.instance
        .collection('appointments')
        .doc(docId)
        .delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor Appointment"),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Patient Name",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Enter patient name",
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        prefixIcon:
                            Icon(Icons.person, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(color: Colors.blueAccent, width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                      onChanged: (value) {
                        setState(() {
                          patientName = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text("Select Hospital",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedHospital,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      hint: Text("Choose a hospital"),
                      items: hospitalDoctors.keys.map((hospital) {
                        return DropdownMenuItem(
                            value: hospital, child: Text(hospital));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedHospital = value;
                          selectedDoctor = null;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Text("Select Doctor",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: selectedDoctor,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                      hint: Text("Choose a doctor"),
                      items: selectedHospital == null
                          ? []
                          : hospitalDoctors[selectedHospital]!.map((doctor) {
                              return DropdownMenuItem(
                                  value: doctor, child: Text(doctor));
                            }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedDoctor = value;
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: pickDate,
                            child: Text(selectedDate == null
                                ? "Select Date"
                                : DateFormat('dd/MM/yyyy')
                                    .format(selectedDate!)),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: pickTime,
                            child: Text(selectedTime == null
                                ? "Select Time"
                                : selectedTime!.format(context)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: patientName != null &&
                              selectedHospital != null &&
                              selectedDoctor != null &&
                              selectedDate != null &&
                              selectedTime != null
                          ? bookAppointment
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Center(child: Text("Book Appointment")),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text("Booked Appointments",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                var appointments = snapshot.data!.docs;
                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: appointments.length,
                  itemBuilder: (context, index) {
                    var data = appointments[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.medical_services,
                            color: Colors.blueAccent),
                        title: Text(data['doctor'],
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            "Patient: ${data['patientName']}\n${data['hospital']}\nDate: ${data['date']}  Time: ${data['time']}"),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteAppointment(data.id),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
