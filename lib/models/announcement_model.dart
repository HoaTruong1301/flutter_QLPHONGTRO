class Announcement {
  final int id;
  final String title;
  final String content;

  Announcement({required this.id, required this.title, required this.content});

  // Chuyển từ JSON nhận được từ API sang Object
  factory Announcement.fromJson(Map<String, dynamic> json) {
    return Announcement(
      id: json['id'],
      title: json['title'], // Giả sử API trả về trường 'title'
      content: json['body'], // Giả sử API trả về trường 'body' làm nội dung
    );
  }
}
