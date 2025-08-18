import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'base.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final List<Map<String, String>> _entries = [
    {
      'title': 'My First Day',
      'date': 'July 23, 2025',
      'content': 'Today was my first day using this personal app...',
    },
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  void _addEntry() {
    if (_titleController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _contentController.text.isEmpty) {
      return;
    }
    setState(() {
      _entries.insert(0, {
        'title': _titleController.text,
        'date': _dateController.text,
        'content': _contentController.text,
      });
      _titleController.clear();
      _dateController.clear();
      _contentController.clear();
    });
  }

  void _deleteEntry(int index) {
    setState(() {
      _entries.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 2,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFCDFFD8), Color(0xFF94B9FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: ListView(
          children: [
            Center(
              child: Text(
                'Daily Dairy',
                style: GoogleFonts.leckerliOne(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 40),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: GoogleFonts.leckerliOne(fontSize: 20),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: GoogleFonts.leckerliOne(fontSize: 18),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(
                labelText: 'Date',
                labelStyle: GoogleFonts.leckerliOne(fontSize: 20),
                hintText: 'dd/mm/yyyy',
                suffixIcon: const Icon(Icons.calendar_today),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
              style: GoogleFonts.leckerliOne(fontSize: 18),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _contentController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your diary here....',
                hintStyle: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                  fontFamily: 'Georgia',
                  fontSize: 18,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
              style: GoogleFonts.leckerliOne(fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _addEntry,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF005AAA),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                textStyle: GoogleFonts.leckerliOne(fontSize: 22),
              ),
              child: const Text('Add Entry'),
            ),
            const SizedBox(height: 40),
            Text(
              'Previous Entries',
              style: GoogleFonts.leckerliOne(
                fontSize: 28,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ..._entries.asMap().entries.map((entry) {
              final int index = entry.key;
              final Map<String, String> data = entry.value;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  title: Text(
                    data['title']!,
                    style: GoogleFonts.leckerliOne(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data['content']!,
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 18,
                        color: Colors.grey[700],
                        fontFamily: 'Georgia',
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        data['date']!,
                        style: GoogleFonts.leckerliOne(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _deleteEntry(index),
                        child: const Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
