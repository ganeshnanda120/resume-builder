import 'package:flutter/material.dart';
import '../main.dart';
import '../services/pdf_generator.dart';
import 'widgets/form_sections.dart';
import 'widgets/resume_preview_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isDownloading = false;

  Future<void> _handleDownload() async {
    final name = resumeProvider.resumeData.personalInfo.name.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter at least your name before downloading!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _isDownloading = true;
    });

    try {
      await PdfGenerator.downloadPdf(resumeProvider.resumeData);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isDownloading = false;
        });
      }
    }
  }

  void _showResetConfirm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Resume?'),
        content: const Text('This will clear all the fields you have filled. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              resumeProvider.resetData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Resume cleared successfully.')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear All'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.description,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Hero Resume',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          actions: [
            // Dark Mode Toggle
            IconButton(
              icon: Icon(isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: 'Toggle Theme',
              onPressed: () {
                themeNotifier.value = isDark ? ThemeMode.light : ThemeMode.dark;
              },
            ),
            const SizedBox(width: 4),
            // Reset Button
            TextButton.icon(
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset'),
              onPressed: _showResetConfirm,
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.error,
              ),
            ),
            const SizedBox(width: 4),
            // Sample Data Button
            TextButton.icon(
              icon: const Icon(Icons.auto_awesome, size: 18),
              label: const Text('Sample Data'),
              onPressed: () {
                resumeProvider.loadSampleData();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sample data loaded successfully!')),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            // Download Button
            _isDownloading
                ? const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2.5),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ElevatedButton.icon(
                      onPressed: _handleDownload,
                      icon: const Icon(Icons.download, size: 18),
                      label: const Text('Download PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              color: isDark ? Colors.grey[800] : Colors.grey[200],
              height: 1.0,
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= 900;

            if (isDesktop) {
              return Column(
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Pane: Form Editor
                        const Expanded(
                          flex: 9,
                          child: Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: FormSectionsWidget(),
                          ),
                        ),
                        // Divider line
                        Container(
                          width: 1,
                          color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                        ),
                        // Right Pane: Live Resume Preview
                        const Expanded(
                          flex: 11,
                          child: ResumePreviewWidget(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              // Mobile / Tablet Tabbed Layout
              return Column(
                children: [
                  Material(
                    color: theme.appBarTheme.backgroundColor,
                    elevation: 1,
                    child: TabBar(
                      tabs: const [
                        Tab(text: 'Edit Details', icon: Icon(Icons.edit_note)),
                        Tab(text: 'Live Preview', icon: Icon(Icons.visibility)),
                      ],
                      labelColor: theme.colorScheme.primary,
                      unselectedLabelColor: theme.hintColor,
                      indicatorColor: theme.colorScheme.primary,
                    ),
                  ),
                  const Expanded(
                    child: TabBarView(
                      children: [
                        FormSectionsWidget(),
                        ResumePreviewWidget(),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
