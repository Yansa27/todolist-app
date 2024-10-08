import 'package:flutter/material.dart';
import 'task_detail_page.dart';

class ToDoListPage extends StatefulWidget {
  @override
  _ToDoListPageState createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  List<Map<String, dynamic>> _tasks = [];
  String _selectedPriority = 'Rendah'; // Default priority
  final List<String> _priorities = ['Rendah', 'Sedang', 'Tinggi'];

  // Tambahkan variabel untuk menyimpan tanggal dan waktu
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  void _addTask(String task) {
    setState(() {
      _tasks.add({
        'task': task,
        'priority': _selectedPriority,
        'completed': false,
        'date': _selectedDate,
        'time': _selectedTime,
      });
    });
    // Reset pemilihan setelah menambahkan tugas
    _selectedDate = null;
    _selectedTime = null;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Tugas berhasil ditambahkan')),
    );
  }

  // Method untuk menandai tugas sebagai selesai
  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index]['completed'] = !_tasks[index]['completed'];
    });
  }

  // Method untuk mengedit tugas
  void _editTask(int index) {
    String editedTask = _tasks[index]['task'];
    String editedPriority = _tasks[index]['priority'];
    DateTime? editedDate = _tasks[index]['date'];
    TimeOfDay? editedTime = _tasks[index]['time'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Tugas'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    editedTask = value;
                  },
                  controller: TextEditingController(text: editedTask),
                  decoration: InputDecoration(labelText: 'Nama Tugas'),
                ),
                DropdownButtonFormField<String>(
                  value: editedPriority,
                  decoration: InputDecoration(labelText: 'Prioritas'),
                  items: _priorities.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      editedPriority = newValue!;
                    });
                  },
                ),
                // Pemilih tanggal
                TextButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: editedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        editedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    editedDate == null
                        ? 'Pilih Tanggal'
                        : 'Tanggal: ${editedDate!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                // Pemilih waktu
                TextButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: editedTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        editedTime = pickedTime;
                      });
                    }
                  },
                  child: Text(
                    editedTime == null
                        ? 'Pilih Waktu'
                        : 'Waktu: ${editedTime!.hour}:${editedTime!.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (editedTask.isNotEmpty) {
                  setState(() {
                    _tasks[index] = {
                      'task': editedTask,
                      'priority': editedPriority,
                      'completed': _tasks[index]['completed'],
                      'date': editedDate,
                      'time': editedTime,
                    };
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  // Method untuk menghapus tugas
  void _deleteTask(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Hapus Tugas'),
          content: Text('Apakah Anda yakin ingin menghapus tugas ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _tasks.removeAt(index);
                });
                Navigator.of(context).pop(); // Tutup dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Tugas berhasil dihapus')),
                );
              },
              child: Text('Hapus'),
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
        title: Text('To-Do List'),
      ),
      body: _tasks.isEmpty
          ? Center(child: Text('Tidak ada tugas'))
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(_tasks[index]['task']),
                    subtitle: Text(
                      'Prioritas: ${_tasks[index]['priority']} \n'
                      'Tanggal: ${_tasks[index]['date'] != null ? '${_tasks[index]['date']!.toLocal().toString().split(' ')[0]}' : 'Tidak ada'} \n'
                      'Waktu: ${_tasks[index]['time'] != null ? '${_tasks[index]['time']!.hour}:${_tasks[index]['time']!.minute.toString().padLeft(2, '0')}' : 'Tidak ada'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _editTask(index);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _deleteTask(index);
                          },
                        ),
                        Checkbox(
                          value: _tasks[index]['completed'],
                          onChanged: (bool? value) {
                            _toggleTaskCompletion(index);
                          },
                        ),
                      ],
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TaskDetailPage(task: _tasks[index]['task']),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: Icon(Icons.add),
      ),
    );
  }

  // Dialog untuk menambah tugas baru
  void _showAddDialog() {
    String newTask = '';
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Tambah Tugas Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    newTask = value;
                  },
                  decoration: InputDecoration(labelText: 'Nama Tugas'),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedPriority,
                  decoration: InputDecoration(labelText: 'Prioritas'),
                  items: _priorities.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue!;
                    });
                  },
                ),
                // Pemilih tanggal
                TextButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(
                    _selectedDate == null
                        ? 'Pilih Tanggal'
                        : 'Tanggal: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                  ),
                ),
                // Pemilih waktu
                TextButton(
                  onPressed: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime ?? TimeOfDay.now(),
                    );
                    if (pickedTime != null) {
                      setState(() {
                        _selectedTime = pickedTime;
                      });
                    }
                  },
                  child: Text(
                    _selectedTime == null
                        ? 'Pilih Waktu'
                        : 'Waktu: ${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (newTask.isNotEmpty) {
                  _addTask(newTask);
                  Navigator.of(context).pop(); // Tutup dialog
                }
              },
              child: Text('Tambah'),
            ),
          ],
        );
      },
    );
  }
}
