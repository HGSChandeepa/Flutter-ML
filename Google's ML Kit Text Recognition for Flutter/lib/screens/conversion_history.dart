import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:langvify/models/conversion_model.dart';
import 'package:langvify/services/store_conversions_firestore.dart';

class HistoryConversions extends StatelessWidget {
  const HistoryConversions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History Conversions'),
      ),
      body: StreamBuilder<List<ConversionModel>>(
        stream: StoreConversionsFirestore().getUserConversions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final conversions = snapshot.data;

          if (conversions == null || conversions.isEmpty) {
            return const Center(
              child: Text('No conversions found.'),
            );
          }

          return ListView.builder(
            itemCount: conversions.length,
            itemBuilder: (context, index) {
              final conversion = conversions[index];
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Display image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          conversion.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 80,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.broken_image, size: 100);
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Display conversion data with a copy button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              conversion.conversionData.length > 200
                                  ? "${conversion.conversionData.substring(0, 200)}..."
                                  : conversion.conversionData,
                              style: const TextStyle(
                                fontSize: 14,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.copy, color: Colors.orange),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text: conversion.conversionData));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Text copied to clipboard!'),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Display converted date
                      Text(
                        'Converted on: ${conversion.convertedDate.toLocal().toString().split(' ')[0]}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
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
