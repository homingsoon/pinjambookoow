import 'package:flutter/material.dart';

void main() {
  runApp(BookLibraryApp());
}

class BookLibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinjambookoow',
      theme: ThemeData(
        primaryColor: Color.fromARGB(104, 139, 126, 73), // Ubah warna primer menjadi #68534899
        primarySwatch: Colors.brown, // Tetap gunakan swatch biru untuk warna aksen
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                String username = _usernameController.text;
                String password = _passwordController.text;
                // Kirim data ke autentikasi (misalnya, validasi username dan password)
                // Jika autentikasi berhasil, navigasikan ke halaman MainScreen
                if (username.isNotEmpty && password.isNotEmpty) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(username: username),
                    ),
                  );
                } else {
                  showDialog( 
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Error'),
                      content: Text('Please enter both username and password.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    ),
                  );
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  final String username;

  MainScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Book Library'),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.list), text: 'Book List'),
              Tab(icon: Icon(Icons.favorite), text: 'Favorites'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            BookListScreen(),
            FavoriteBooksScreen(),
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.account_circle),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(username: username),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FavoriteBooksScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BookListScreen extends StatefulWidget {
  @override
  _BookListScreenState createState() => _BookListScreenState();
}

class _BookListScreenState extends State<BookListScreen> {
  List<Book> _books = [
    Book(title: "bookoowsatu", isBorrowed: false, isFavorite: false, imageUrl: 'https://img.freepik.com/free-psd/camping-place-flyer-template_23-2148688066.jpg?t=st=1716119267~exp=1716122867~hmac=e0ebb1972767603993182a151bac21bbdc3316fd7a073eef9c88e599c65a29f6&w=740'),
    Book(title: "bookoowdua", isBorrowed: false, isFavorite: false, imageUrl: 'https://img.freepik.com/free-psd/world-forest-day-poster-template_23-2148899238.jpg?t=st=1716120629~exp=1716124229~hmac=f6312724813b1e7b51dd5d56e5c2f76968a4f780cd8dadb83d02efcaa890832b&w=740'),
    Book(title: "bookoowtiga", isBorrowed: false, isFavorite: true, imageUrl: 'https://img.freepik.com/free-vector/abstract-business-book-cover-template_23-2148726776.jpg?t=st=1716120648~exp=1716124248~hmac=1942a325b3a8a2ef3a8c70d96a44d1fb2a87ebde39f27a9e36493b372697dbe5&w=740'),
  ];
  List<Book> _favoriteBooks = [];

  // Fungsi untuk meminjam buku
  void _borrowBook(int index) {
    setState(() {
      _books[index].isBorrowed = true; // Set status buku menjadi dipinjam
    });
  }

  // Fungsi untuk mengembalikan buku
  void _returnBook(int index) {
    setState(() {
      _books[index].isBorrowed = false; // Set status buku menjadi tersedia
    });
  }

  void _updateFavoriteBooks(Book book) {
    setState(() {
      if (!_favoriteBooks.contains(book)) {
        _favoriteBooks.add(book);
      } else {
        _favoriteBooks.remove(book);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _books.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Image.network(_books[index].imageUrl), // Menambahkan gambar
          title: Text(_books[index].title),
          subtitle: _books[index].isBorrowed
              ? Row(
                  children: [
                    Icon(Icons.bookmark, color: Colors.green), // Icon borrowed book
                    Text('Telah Dipinjam'),
                  ],
                )
              : Text('Tersedia'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: _favoriteBooks.contains(_books[index])
                    ? Icon(Icons.favorite)
                    : Icon(Icons.favorite_border),
                onPressed: () {
                  _updateFavoriteBooks(_books[index]);
                },
              ),
              SizedBox(width: 8),
              _books[index].isBorrowed
                  ? IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        _returnBook(index); // Panggil fungsi untuk mengembalikan buku
                      },
                    )
                  : IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        _borrowBook(index); // Panggil fungsi untuk meminjam buku
                      },
                    ),
            ],
          ),
        );
      },
    );
  }
}

class Book {
  String title;
  bool isBorrowed;
  bool isFavorite;
  String imageUrl;

  Book({
    required this.title,
    required this.isBorrowed,
    required this.isFavorite,
    required this.imageUrl,
  });
}

class ProfileScreen extends StatelessWidget {
  final String username;

  ProfileScreen({required this.username});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Username: $username',
              style: TextStyle(fontSize: 24),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginScreen(),
                  ),
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

class FavoriteBooksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buku Favorit'),
      ),
      body: Center(
        child: Text('Laman Buku Favorit'),
      ),
    );
  }
}
