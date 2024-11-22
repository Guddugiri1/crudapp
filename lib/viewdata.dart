import 'package:flutter/material.dart';
import 'contact.dart'; // Ensure Contact class is imported

class Viewdata extends StatefulWidget {
  final List<Contact> contactList; // This will hold the passed list of contacts

  // Constructor to receive the contact list
  Viewdata({required this.contactList});

  @override
  _ViewdataState createState() => _ViewdataState();
}

class _ViewdataState extends State<Viewdata> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 34,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.cyan,
      ),
      body: widget.contactList.isEmpty
          ? const Center(
        child: Text(
          'No Data Available',
          style: TextStyle(fontSize: 24),
        ),
      )
          : ListView.builder(
        itemCount: widget.contactList.length,
        itemBuilder: (context, index) {
          return Card(

            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: index % 2 == 0 ? Colors.cyan : Colors.teal,
                foregroundColor: Colors.white,
                child: Text(
                  widget.contactList[index].name[0],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.contactList[index].name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  Text(widget.contactList[index].email),
                  Text(widget.contactList[index].phone),
                  Text(widget.contactList[index].address),
                  Text('Date: ${widget.contactList[index].date}'),
                ],
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  setState(() {
                    widget.contactList.removeAt(index); // Remove the contact
                  });
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
