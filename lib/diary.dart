import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'base.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final List<Map<String, String>> _entries = [];

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 60), (_) {
      setState(() {}); // refresh timestamps
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _addEntry() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) return;

    String now = DateFormat('MMMM d, yyyy • h:mm a').format(DateTime.now());

    setState(() {
      _entries.insert(0, {
        'title': _titleController.text,
        'content': _contentController.text,
        'createdAt': now,
        'lastEditedAt': '',
      });
      _titleController.clear();
      _contentController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BasePage(
      selectedIndex: 2,
      child: Container(
        // 🌈 Gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0072FF), Color(0xFF00C6FF)], // Blue → Cyan
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: ListView(
            children: [
              // Daily Diary header with gradient background label
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3A7BD5), Color(0xFF00D2FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Daily Diary',
                    style: GoogleFonts.leckerliOne(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // --- Entry Container ---
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title",
                        style: GoogleFonts.leckerliOne(
                            fontSize: 20, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 10),
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: "Enter title here...",
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                      ),
                      style: GoogleFonts.leckerliOne(fontSize: 18),
                    ),

                    const SizedBox(height: 20),
                    Text("Content",
                        style: GoogleFonts.leckerliOne(
                            fontSize: 20, fontWeight: FontWeight.bold)),

                    const SizedBox(height: 10),
                    TextField(
                      controller: _contentController,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: 'Write your diary here....',
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey[600],
                          fontFamily: 'Georgia',
                          fontSize: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.all(16),
                      ),
                      style: GoogleFonts.leckerliOne(fontSize: 18),
                    ),

                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: double.infinity, // flexible width
                        child: ElevatedButton(
                          onPressed: _addEntry,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF005AAA),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            'Add Entry',
                            style: TextStyle(
                              color: Colors.white, // white text
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
              Text('Previous',
                  style: GoogleFonts.leckerliOne(
                      fontSize: 26, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              ..._entries.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, String> data = entry.value;

                return StatefulBuilder(
                  builder: (context, setStateEntry) {
                    double scale = 1.0;

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EntryDetailPage(
                              title: data['title']!,
                              content: data['content']!,
                              createdAt: data['createdAt']!,
                              lastEditedAt: data['lastEditedAt']!,
                              onEdit: (newTitle, newContent) {
                                setState(() {
                                  _entries[index]['title'] = newTitle;
                                  _entries[index]['content'] = newContent;
                                  _entries[index]['lastEditedAt'] =
                                      DateFormat('MMMM d, yyyy • h:mm a')
                                          .format(DateTime.now());
                                });
                              },
                            ),
                          ),
                        );
                      },
                      onLongPress: () async {
                        setStateEntry(() => scale = 1.05);
                        await Future.delayed(
                            const Duration(milliseconds: 150));
                        setStateEntry(() => scale = 1.0);

                        // Show entry content in a dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(data['title']!,
                                style: GoogleFonts.leckerliOne(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            content: SingleChildScrollView(
                              child: Text(data['content']!,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontFamily: 'Georgia',
                                      fontStyle: FontStyle.italic)),
                            ),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close")),
                            ],
                          ),
                        );
                      },
                      child: AnimatedScale(
                        scale: scale,
                        duration: const Duration(milliseconds: 150),
                        curve: Curves.easeInOut,
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 12),
                            title: Text(data['title']!,
                                style: GoogleFonts.leckerliOne(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            subtitle: Text(
                              data['lastEditedAt']!.isNotEmpty
                                  ? "Last edited: ${data['lastEditedAt']}"
                                  : "Created: ${data['createdAt']}",
                              style: GoogleFonts.leckerliOne(
                                  fontSize: 16, color: Colors.grey[800]),
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Colors.redAccent),
                              onPressed: () {
                                // Simple delete confirmation
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete Entry"),
                                    content: const Text(
                                        "Are you sure you want to delete this entry?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel")),
                                      TextButton(
                                        onPressed: () {
                                          setState(() =>
                                              _entries.removeAt(index));
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Delete",
                                            style: TextStyle(
                                                color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

// Full-screen detail page with edit functionality
class EntryDetailPage extends StatelessWidget {
  final String title;
  final String content;
  final String createdAt;
  final String lastEditedAt;
  final Function(String, String) onEdit;

  const EntryDetailPage({
    Key? key,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.lastEditedAt,
    required this.onEdit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Diary Entry"),
        backgroundColor: const Color(0xFF005AAA),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () => _showEditDialog(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.leckerliOne(
                    fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Created: $createdAt",
                style: GoogleFonts.leckerliOne(
                    fontSize: 16, color: Colors.grey[700])),
            if (lastEditedAt.isNotEmpty) ...[
              const SizedBox(height: 5),
              Text("Last edited: $lastEditedAt",
                  style: GoogleFonts.leckerliOne(
                      fontSize: 16, color: Colors.grey[700])),
            ],
            const Divider(height: 30, thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                child: Text(content,
                    style: const TextStyle(
                        fontSize: 18,
                        fontFamily: 'Georgia',
                        fontStyle: FontStyle.italic)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    final titleController = TextEditingController(text: title);
    final contentController = TextEditingController(text: content);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Entry"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title")),
            const SizedBox(height: 10),
            TextField(
                controller: contentController,
                maxLines: 5,
                decoration: const InputDecoration(labelText: "Content")),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              onEdit(titleController.text, contentController.text);
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // back to diary list
            },
            child: const Text("Save", style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
