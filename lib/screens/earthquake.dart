import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class MyanmarEarthquakeScreen extends StatefulWidget {
  const MyanmarEarthquakeScreen({super.key});

  @override
  State<MyanmarEarthquakeScreen> createState() =>
      _MyanmarEarthquakeScreenState();
}

class _MyanmarEarthquakeScreenState extends State<MyanmarEarthquakeScreen> {
  List<dynamic> earthquakes = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchMyanmarEarthquakes();
  }

  Future<void> _fetchMyanmarEarthquakes() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final nowUtc = DateTime.now().toUtc();
      final sinceUtc = nowUtc.subtract(const Duration(days: 90));

      final uri = Uri.https('earthquake.usgs.gov', '/fdsnws/event/1/query', {
        'format': 'geojson',
        'starttime': sinceUtc.toIso8601String(),
        'endtime': nowUtc.toIso8601String(),
        'minmagnitude': '2.5',
        'minlatitude': '9.4',
        'maxlatitude': '28.5',
        'minlongitude': '92.2',
        'maxlongitude': '101.2',
        'orderby': 'time',
        'limit': '200',
      });

      final response = await http.get(uri);
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final data = jsonDecode(response.body);
      final List features = data['features'] as List;

      // Filter "Burma" or "Myanmar"
      final filtered = features.where((f) {
        final place = (f['properties']['place'] ?? '').toString().toLowerCase();
        return place.contains('burma') || place.contains('myanmar');
      }).toList();

      filtered.sort(
        (a, b) => b['properties']['time'].compareTo(a['properties']['time']),
      );

      setState(() {
        earthquakes = filtered;
      });
    } on SocketException catch (_) {
      setState(() {
        errorMessage = 'No internet connection. Please check your network and try again.';
      });
    } on http.ClientException catch (e) {
      setState(() {
        errorMessage = 'Network error: ${e.message}';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading data: ${e.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Myanmar Earthquakes',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _fetchMyanmarEarthquakes,
          )
        ],
        centerTitle: true,
        backgroundColor: const Color(0xFF58211B),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (errorMessage.isNotEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                errorMessage.contains('internet') || errorMessage.contains('Network')
                    ? Icons.wifi_off 
                    : Icons.error_outline,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
              Text(
                errorMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _fetchMyanmarEarthquakes,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF58211B),
                ),
                child: const Text(
                  'Retry',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }
    
    if (earthquakes.isEmpty) {
      return const Center(
        child: Text('No earthquakes recorded in Myanmar recently'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      itemCount: earthquakes.length,
      itemBuilder: (context, index) {
        final props = earthquakes[index]['properties'];
        final coords = earthquakes[index]['geometry']['coordinates'];
        final magnitude = props['mag']?.toDouble() ?? 0;
        final place = props['place'] ?? 'Unknown location';
        final time = DateTime.fromMillisecondsSinceEpoch(props['time']);
        final dateString = DateFormat.yMMMd().add_jm().format(time);
        final lat = coords[1].toStringAsFixed(4);
        final lng = coords[0].toStringAsFixed(4);
        final depth = coords[2].toStringAsFixed(1);

        Color badgeColor;
        if (magnitude < 4) {
          badgeColor = Colors.green.shade600;
        } else if (magnitude < 6) {
          badgeColor = Colors.orange.shade700;
        } else {
          badgeColor = Colors.red.shade700;
        }

        return Card(
          elevation: 3,
          margin: const EdgeInsets.symmetric(vertical: 6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: badgeColor,
                  child: Text(
                    magnitude.toStringAsFixed(1),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        dateString,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$lat°, $lng°',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.vertical_align_bottom,
                            size: 14,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$depth km',
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey.shade400,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}