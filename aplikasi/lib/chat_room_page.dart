import 'package:flutter/material.dart';

import 'home_page.dart';

class ChatRoomPage extends StatefulWidget {
  final String doctorName;
  final String patientName;

  ChatRoomPage({required this.doctorName, required this.patientName});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  List<Map<String, String>> messages = [];
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _showInitialWarning();
  }

  void _showInitialWarning() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Peringatan'),
            content: Text(
                'Anda sedang berada pada chat room. Pesan akan dijawab oleh sistem bot, dan kemudian akan dijawab oleh dokter yang Anda pilih sebelumnya. Jika belum memilih dokter, silakan memilih dokter terlebih dahulu, atau pesan tidak akan dibalas oleh dokter yang menangani.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void addMessage(String message) {
    setState(() {
      messages.add({"sender": "You", "text": message});
      // Simulate bot response
      String botResponse = getBotResponse(message);
      messages.add({"sender": widget.doctorName, "text": botResponse});
    });
    _messageController.clear(); // Clear the input field after sending a message
  }

 String getBotResponse(String userMessage) {
    userMessage = userMessage.toLowerCase();
    if (userMessage.contains("halo")) {
      return "Selamat Datang, apa yang bisa saya bantu?";
    } else if (userMessage.contains("karang gigi")) {
      return "Karang gigi adalah plak yang mengeras dan menempel pada gigi. Membersihkan karang gigi secara rutin penting untuk kesehatan mulut. Anda bisa berkonsultasi dengan dokter terkait saat anda melakukan pemeriksaan. Semoga Informasi ini membantu :)";
    } else if (userMessage.contains("sakit gigi")) {
      return "Sakit gigi bisa disebabkan oleh berbagai hal seperti gigi berlubang, infeksi, atau masalah gusi. Saya sarankan untuk memeriksakan ke dokter gigi untuk diagnosis yang tepat.";
    } else if (userMessage.contains("konsul") || userMessage.contains("konsultasi")) {
      return "Untuk konsultasi, Anda bisa membuat janji temu dengan dokter kami melalui aplikasi ini. Apakah Anda ingin melanjutkan ke halaman janji temu atau ada pertanyaan lain?";
    } else if (userMessage.contains("tanya") || userMessage.contains("nama dokter")) {
      return "Terima kasih atas pertanyaannya. Bagaimana saya bisa membantu Anda?";
    } else if (userMessage.contains("terimakasih informasinya")) {
      return "Baik, semoga lekas sembuh";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Room'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
                Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );},
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Align(
                    alignment: messages[index]["sender"] == "You"
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: messages[index]["sender"] == "You" ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        messages[index]["text"]!,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        addMessage(value);
                      }
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_messageController.text.isNotEmpty) {
                      addMessage(_messageController.text);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

