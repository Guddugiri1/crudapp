import 'dart:convert'; // For JSON encoding/decoding
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'contact.dart';
import 'viewdata.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  DateTime? selectedDate;
  List<Contact> contactList = []; // List of contacts

  @override
  void initState() {
    super.initState();
    _loadContacts(); // Load saved contacts on startup
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'To Do List',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _buildTextField('Enter Your Name', nameController),
            _buildTextField('Enter Your Email Id', emailController,
                keyboardType: TextInputType.emailAddress),
            _buildTextField('Enter Your Mobile No', phoneController,
                keyboardType: TextInputType.number, maxLength: 10),
            _buildTextField('Enter Your Address', addressController),
            _buildDatePicker(),
            _buildButtons(),
            const SizedBox(height: 20),
            Expanded(
              child: _buildContactListView(), // Show the saved contacts
            ),
          ],
        ),
      ),
    );
  }

  // Build TextField widget
  Widget _buildTextField(String hintText, TextEditingController controller,
      {TextInputType? keyboardType, int? maxLength}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLength: maxLength,
        decoration: InputDecoration(
          hintText: hintText,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  // Build Date Picker widget
  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              selectedDate == null
                  ? 'Selected Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}'
                  : 'Selected Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
              child: const Text('Select Date'),
            ),
          ),
        ],
      ),
    );
  }

  // Build Buttons
  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              _saveContact();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save Data'),
          ),
        ),
      ],
    );
  }

  // Build ListView to show saved contacts
  Widget _buildContactListView() {
    return contactList.isEmpty
        ? const Center(child: Text('No Contacts Saved Yet'))
        : ListView.builder(
      itemCount: contactList.length,
      itemBuilder: (context, index) {
        final contact = contactList[index];
        return Card(
          child: ListTile(
            title: Text(contact.name),
            subtitle: Text(
                '${contact.email}\n${contact.phone}\n${contact.address}\nDate: ${contact.date}'),
          ),
        );
      },
    );
  }

  // Save a contact to the list and SharedPreferences
  void _saveContact() async {
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String phone = phoneController.text.trim();
    String address = addressController.text.trim();
    String date = selectedDate != null
        ? DateFormat('yyyy-MM-dd').format(selectedDate!)
        : DateFormat('yyyy-MM-dd').format(DateTime.now());

    if (name.isNotEmpty &&
        email.isNotEmpty &&
        phone.isNotEmpty &&
        address.isNotEmpty &&
        date.isNotEmpty) {
      setState(() {
        contactList.add(Contact(
          name: name,
          email: email,
          phone: phone,
          address: address,
          date: date,
        ));
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        addressController.clear();
        selectedDate = null;
      });

      // Save the updated contact list to SharedPreferences
      await _saveContactsToPreferences();
    }
  }

  // Load saved contacts from SharedPreferences
  Future<void> _loadContacts() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? contactsJson = prefs.getString('contacts');
    if (contactsJson != null) {
      List<dynamic> decodedList = jsonDecode(contactsJson);
      setState(() {
        contactList = decodedList.map((json) => Contact.fromJson(json)).toList();
      });
    }
  }

  // Save contacts to SharedPreferences
  Future<void> _saveContactsToPreferences() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedContacts =
    jsonEncode(contactList.map((contact) => contact.toJson()).toList());
    await prefs.setString('contacts', encodedContacts);
  }
}
