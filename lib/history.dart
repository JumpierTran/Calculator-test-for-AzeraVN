// ignore_for_file: avoid_print, unused_element, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:calculation/calculate.dart';

CalculateScreen remove = const CalculateScreen();

class HistoryCalculate extends StatefulWidget {
  const HistoryCalculate({super.key});

  @override
  State<HistoryCalculate> createState() => _HistoryCalculateState();
}

class _HistoryCalculateState extends State<HistoryCalculate> {
  @override
  // ignore: annotate_overrides
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Đồng ý',
                      ),
                      content: const Text(
                        'Bạn có đồng ý xóa hết dữ liệu tính toán ?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Hủy'),
                        ),
                        TextButton(
                          onPressed: () {
                            removeData();
                            setState(() {
                              calculationsHistory.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          child: const Text('Đồng ý'),
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.delete),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: calculationsHistory.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(
                calculationsHistory[index],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
