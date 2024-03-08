import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key});

  @override
  Widget build(BuildContext context) {
    final words = nouns.take(50).toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text("H"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box("favorites").listenable(),
        builder: (context, Box box, child) {
          return ListView.builder(
            itemCount: words.length,
            itemBuilder: (context, index) {
              final word = words[index];
              final isFavorite = box.get(index) != null;
              return ListTile(
                title: Text(word),
                trailing: IconButton(
                  onPressed: () async {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    if (isFavorite) {
                      await box.delete(index);
                      final snackBar = SnackBar(
                        content: const Text("Se eliminó un favorito"),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else {
                      await box.put(index, word);
                      final snackBar = SnackBar(
                        content: const Text("Se agregó un favorito"),
                        backgroundColor: Colors.blue,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : null,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
