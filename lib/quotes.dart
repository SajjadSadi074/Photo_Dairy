import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class QuotesPage extends StatefulWidget {
  @override
  _QuotesPageState createState() => _QuotesPageState();
}

class Quote {
  final int quoteId;
  final String quote;
  final String name;

  Quote({required this.quoteId, required this.quote, required this.name});

  factory Quote.fromJson(Map<String, dynamic> json) {
    return Quote(
      quoteId: json['quoteId'],
      quote: json['quote'],
      name: json['name'],
    );
  }
}


class _QuotesPageState extends State<QuotesPage> {
  List<Quote> quotes = []; // Add this line to define a list of quotes
  String quoteText = 'Fetching quotes...';

  @override
  void initState() {
    super.initState();
    fetchQuotes();
  }


  Future<void> fetchQuotes() async {
    var headers = {
      'Content-Type': 'application/json',
      'X-RapidAPI-Key': 'c8b9526965msh08adbfd190d9e03p13afb0jsn3b7ddd2ded71',
      'X-RapidAPI-Host': 'quotel-quotes.p.rapidapi.com'
    };

    var body = jsonEncode({
      "pageSize": 25,
      "page": 0
    });

    var uri = Uri.https('quotel-quotes.p.rapidapi.com', '/quotes/list');
    var response = await http.post(uri, headers: headers, body: body);

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      try {
        List<dynamic> data = jsonDecode(response.body);
        print(data);
        String quotesDisplay = data.map((quote) {
          return '${quote['name']} (${quote['profession']}, ${quote['nationality']}): "${quote['quote']}"';
        }).join('\n\n');
        List<Quote> fetchedQuotes = data.map<Quote>((json) => Quote.fromJson(json)).toList();

        // Update this part based on the actual structure of your response
        setState(() {
          quotes = fetchedQuotes; // Update the quotes list
          quoteText = ''; // Reset the quoteText or set it to null
        });
      } catch (e) {
        setState(() {
          quoteText = 'Error parsing quotes: $e';
        });
      }
    } else {
      setState(() {
        quoteText = 'Request failed with status: ${response.statusCode}.';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quotes'),
      ),
      body: Center(
        child: quotes.isEmpty && quoteText.isNotEmpty
            ? CircularProgressIndicator() // Show loading indicator
            : ListView.builder(
          itemCount: quotes.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  quotes[index].quote,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${quotes[index].name} ',
                  style: TextStyle(fontSize: 14.0),
                ),
                leading: Icon(Icons.format_quote),
              ),
            );
          },
        ),
      ),
    );
  }
}
