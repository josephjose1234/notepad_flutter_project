import 'package:flutter/material.dart';
import 'theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _newNote = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  List<String> NoteList = [];
  List<String> NoteTime = [];
  List<String> filteredNotes = [];

  @override
  void initState() {
    super.initState();
    LoadNotes();
  }

  void SaveNote() async {
    SharedPreferences note = await SharedPreferences.getInstance();
    if (_newNote.text.isNotEmpty) {
      setState(() {
        NoteList.add(_newNote.text);
        DateTime now = DateTime.now();
        String dateTimeString =
            DateFormat('yyyy-MM-dd h:mm a').format(DateTime.now());
        NoteTime.add(dateTimeString);
        note.setStringList('note', NoteList);
        note.setStringList('time', NoteTime);
        _newNote.clear();
      });
    }
  }

  void LoadNotes() async {
    SharedPreferences note = await SharedPreferences.getInstance();
    setState(() {
      NoteList = note.getStringList('note') ?? [];
      NoteTime = note.getStringList('time') ?? [];
    });
  }

  void DeleteNote(int index) async {
    SharedPreferences note = await SharedPreferences.getInstance();
    setState(() {
      NoteList.removeAt(index);
      NoteTime.removeAt(index);
      note.setStringList('note', NoteList);
      note.setStringList('time', NoteTime);
    });
  }

  void searchNotes(String query) {
    setState(() {
      filteredNotes = NoteList.where(
          (note) => note.toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // themeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

    // Set system overlay style based on the selected theme
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return SafeArea(
      child: Scaffold(
        backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.white,
        body: Column(
          children: [
            ///appBar
            Container(
              margin: const EdgeInsets.all(20),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(
                    Icons.menu,
                    size: 40,
                    color: Colors.blue,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.all(15),
                    child: Text(
                      'NotePad',
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: themeProvider.isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            ///SearchBar
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? const Color.fromRGBO(70, 70, 73, 1)
                    : const Color.fromRGBO(230, 230, 238, 1),
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (value) {
                  searchNotes(value);
                },
                style: TextStyle(
                  color: themeProvider.isDarkMode ? Colors.white : Colors.black,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color:
                        themeProvider.isDarkMode ? Colors.white : Colors.black,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),

            ///Notes
            Expanded(
              child: ListView.builder(
                itemCount: _searchController.text.isNotEmpty
                    ? filteredNotes.length
                    : NoteList.length,
                itemBuilder: (BuildContext context, int index) {
                  final noteIndex = _searchController.text.isNotEmpty
                      ? NoteList.indexOf(filteredNotes[index])
                      : index;
                  return Container(
                    alignment: Alignment.centerLeft,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 7),
                    decoration: BoxDecoration(
                      color: themeProvider.isDarkMode
                          ? const Color.fromRGBO(70, 70, 73, 1)
                          : const Color.fromRGBO(230, 230, 238, 1),
                      borderRadius: BorderRadius.circular(30),
                      // border: Border.all(width: 1),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          alignment: Alignment.centerLeft,
                          child: Text(
                            NoteList[noteIndex],
                            style: TextStyle(
                              color: themeProvider.isDarkMode
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          margin: const EdgeInsets.all(0),
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                          decoration: BoxDecoration(
                            color: themeProvider.isDarkMode
                                ? const Color.fromRGBO(70, 70, 73, 1)
                                : const Color.fromRGBO(230, 230, 238, 1),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 0),
                                child: Text(
                                  NoteTime[noteIndex],
                                  style: TextStyle(
                                    color: themeProvider.isDarkMode
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  DeleteNote(noteIndex);
                                },
                                child: const Icon(
                                  Icons.delete,
                                  size:25,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            ///addNotesSection
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: themeProvider.isDarkMode
                    ? const Color.fromRGBO(70, 70, 73, 1)
                    : const Color.fromRGBO(230, 230, 238, 1),
                border: Border.all(width: 1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: TextField(
                        controller: _newNote,
                        style: TextStyle(
                          color: themeProvider.isDarkMode
                              ? Colors.white
                              : Colors.black,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                            color: themeProvider.isDarkMode
                                ? Colors.white
                                : Colors.black,
                          ),
                          hintText: 'Add Something...',
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SaveNote();
                    },
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40),
                        ),
                        color: Colors.blue,
                      ),
                      child: const Icon(Icons.add, size: 40),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
