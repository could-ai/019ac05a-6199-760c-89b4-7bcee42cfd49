import 'package:flutter/material.dart';

class AbstractGeneratorScreen extends StatefulWidget {
  const AbstractGeneratorScreen({super.key});

  @override
  State<AbstractGeneratorScreen> createState() => _AbstractGeneratorScreenState();
}

class _AbstractGeneratorScreenState extends State<AbstractGeneratorScreen> with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers for input fields
  final TextEditingController _purposeController = TextEditingController();
  final TextEditingController _methodController = TextEditingController();
  final TextEditingController _resultsController = TextEditingController();
  final TextEditingController _conclusionController = TextEditingController();

  String _generatedAbstractIndo = '';
  String _generatedAbstractEng = '';
  bool _isGenerating = false;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _purposeController.dispose();
    _methodController.dispose();
    _resultsController.dispose();
    _conclusionController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _generateAbstract() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isGenerating = true;
      });

      // Simulate AI processing delay
      await Future.delayed(const Duration(seconds: 2));

      setState(() {
        // Mock generation logic - combining inputs
        _generatedAbstractIndo = 
            "Penelitian ini bertujuan untuk ${_purposeController.text.trim()}. "
            "Metode yang digunakan dalam penelitian ini adalah ${_methodController.text.trim()}. "
            "Berdasarkan hasil analisis, ditemukan bahwa ${_resultsController.text.trim()}. "
            "Dapat disimpulkan bahwa ${_conclusionController.text.trim()}.";

        // Mock translation logic (In a real app, this would call an API)
        _generatedAbstractEng = 
            "This study aims to [translate: ${_purposeController.text.trim()}]. "
            "The method used in this research is [translate: ${_methodController.text.trim()}]. "
            "Based on the analysis results, it was found that [translate: ${_resultsController.text.trim()}]. "
            "It can be concluded that [translate: ${_conclusionController.text.trim()}].";
        
        _isGenerating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generator Abstrak'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Masukkan Poin Penting Proposal',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sistem akan menyusunnya menjadi abstrak yang padu (150-250 kata).',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              
              _buildInputField(
                controller: _purposeController,
                label: 'Tujuan Penelitian',
                hint: 'Apa tujuan utama dari penelitian ini?',
                minLines: 2,
              ),
              const SizedBox(height: 16),
              
              _buildInputField(
                controller: _methodController,
                label: 'Metode Penelitian',
                hint: 'Jelaskan metode, subjek, dan instrumen yang digunakan.',
                minLines: 2,
              ),
              const SizedBox(height: 16),
              
              _buildInputField(
                controller: _resultsController,
                label: 'Hasil Utama',
                hint: 'Apa temuan terpenting dari penelitian ini?',
                minLines: 3,
              ),
              const SizedBox(height: 16),
              
              _buildInputField(
                controller: _conclusionController,
                label: 'Kesimpulan',
                hint: 'Apa implikasi atau kesimpulan akhirnya?',
                minLines: 2,
              ),
              const SizedBox(height: 24),
              
              FilledButton.icon(
                onPressed: _isGenerating ? null : _generateAbstract,
                icon: _isGenerating 
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) 
                    : const Icon(Icons.auto_awesome),
                label: Text(_isGenerating ? 'Sedang Menyusun...' : 'Buat Abstrak'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              
              if (_generatedAbstractIndo.isNotEmpty) ...[
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Hasil Abstrak',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                
                TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Bahasa Indonesia'),
                    Tab(text: 'English'),
                  ],
                ),
                const SizedBox(height: 16),
                
                SizedBox(
                  height: 300, // Fixed height for results area
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildResultCard(_generatedAbstractIndo),
                      _buildResultCard(_generatedAbstractEng),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int minLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: true,
      ),
      minLines: minLines,
      maxLines: null,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bagian ini tidak boleh kosong';
        }
        return null;
      },
    );
  }

  Widget _buildResultCard(String content) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 16, height: 1.5),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
