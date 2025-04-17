import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class GovernmentSchemes extends StatelessWidget {
  final List<Scheme> schemes = [
    Scheme(
      name: 'Ayushman Bharat Pradhan Mantri Jan Arogya Yojana (AB PM-JAY)',
      description:
          'Provides health coverage of up to ₹5 lakh per family per year for secondary and tertiary care hospitalization to over 10.74 crore poor and vulnerable families.',
      websiteUrl: 'https://nha.gov.in/',
    ),
    Scheme(
      name: 'Central Government Health Scheme (CGHS)',
      description:
          'Provides comprehensive medical care facilities to Central Government employees, pensioners and certain other categories of beneficiaries and their family members.',
      websiteUrl: 'https://cghs.gov.in/',
    ),
    Scheme(
      name: 'Janani Shishu Suraksha Karyakram (JSSK)',
      description:
          'Entitles all pregnant women and sick newborns to free and cashless services at government health facilities.',
      websiteUrl:
          'https://nhm.gov.in/NHM_Components/RMNCH+A/maternal-health/janani-shishu-suraksha-karyakram.html',
    ),
    Scheme(
      name: 'Rashtriya Bal Swasthya Karyakram (RBSK)',
      description:
          'A child health screening and early intervention services program for children from birth to 18 years.',
      websiteUrl:
          'https://nhm.gov.in/NHM_Components/RMNCH+A/child-health/rashtriya-bal-swasthya-karyakram-rbsk.html',
    ),
    Scheme(
      name: 'Pradhan Mantri Swasthya Suraksha Yojana (PMSSY)',
      description:
          'Aims at establishing institutions like AIIMS and upgrading existing government medical colleges across the country.',
      websiteUrl: 'https://pmssy-mohfw.nic.in/',
    ),
    Scheme(
      name: 'National Digital Health Mission (NDHM)',
      description:
          'Aims to develop an integrated digital health infrastructure for the country.',
      websiteUrl: 'https://ndhm.gov.in/',
    ),
    Scheme(
      name:
          'Revised National Tuberculosis Control Programme (RNTCP) (now National TB Elimination Programme - NTEP)',
      description:
          'The National TB Elimination Programme aims to eliminate tuberculosis in India by 2025.',
      websiteUrl: 'https://tbcindia.gov.in/',
    ),
    Scheme(
      name: 'National Leprosy Eradication Programme (NLEP)',
      description:
          'Provides services for the prevention, early detection and treatment of leprosy free of cost.',
      websiteUrl: 'https://nlep.nic.in/',
    ),
    Scheme(
      name: 'National Vector Borne Disease Control Programme (NVBDCP)',
      description:
          'Aims at prevention and control of vector borne diseases like Malaria, Dengue, Chikungunya, Japanese Encephalitis, Lymphatic Filariasis and Kala-Azar.',
      websiteUrl: 'https://nvbdcp.gov.in/',
    ),
    Scheme(
      name:
          'National Programme for Prevention and Control of Cancer, Diabetes, Cardiovascular Diseases and Stroke (NPCDCS)',
      description:
          'Focuses on the prevention and control of major non-communicable diseases.',
      websiteUrl:
          'https://nhm.gov.in/NHM_Components/NCD_Control_Programme.html',
    ),
    Scheme(
      name: 'National Mental Health Programme (NMHP)',
      description:
          'Aims to provide accessible and affordable mental healthcare to all.',
      websiteUrl: 'https://nmhp.nic.in/',
    ),
    Scheme(
      name: 'National AIDS Control Programme (NACP)',
      description:
          'Aims to prevent the spread of HIV and provide care and support to people living with HIV/AIDS.',
      websiteUrl: 'https://naco.gov.in/',
    ),
    Scheme(
      name: 'Eat Right India Movement',
      description: 'An initiative by FSSAI to promote healthy eating habits.',
      websiteUrl: 'https://eatrightindia.gov.in/',
    ),
    Scheme(
      name: 'Swachh Bharat Abhiyan - Health and Sanitation aspects',
      description:
          'While primarily a sanitation drive, it has significant positive impacts on public health.',
      websiteUrl: 'https://swachhbharatmission.gov.in/',
    ),
    Scheme(
      name: 'Pradhan Mantri Matru Vandana Yojana (PMMVY)',
      description:
          'A maternity benefit program providing cash incentives to pregnant women and lactating mothers.',
      websiteUrl: 'https://pmmvy.wcd.gov.in/',
    ),
    Scheme(
      name: 'Mission Indradhanush',
      description:
          'Aims to increase the full immunization coverage for children and pregnant women.',
      websiteUrl: 'https://www.nhm.gov.in/mission-indradhanush.html',
    ),
    Scheme(
      name: 'National Ayush Mission (NAM)',
      description:
          'Aims to promote the traditional systems of medicine and healthcare including Ayurveda, Yoga & Naturopathy, Unani, Siddha and Homoeopathy (AYUSH).',
      websiteUrl: 'https://nam.gov.in/',
    ),
    Scheme(
      name: 'Surakshit Matritva Aashwasan (SUMAN)',
      description:
          'An initiative to provide quality and respectful care during pregnancy, delivery, and the postpartum period.',
      websiteUrl:
          'https://nhm.gov.in/NHM_Components/RMNCH+A/maternal-health/surakshit-matritva-aashwasan-suman.html',
    ),
    Scheme(
      name: 'Anaemia Mukt Bharat',
      description:
          'Aimed at reducing the prevalence of anaemia across all age groups.',
      websiteUrl:
          'https://nhm.gov.in/NHM_Components/RMNCH+A/anaemia-mukt-bharat.html',
    ),
  ];

  GovernmentSchemes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Government Health Schemes',
            style: TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo[400], // A nice primary color
        elevation: 1.0, // Subtle shadow
      ),
      backgroundColor: Colors.grey[100], // Light background
      body: ListView.builder(
        padding: const EdgeInsets.all(12.0),
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 3.0, // Slightly more pronounced shadow
            shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12.0)), // More rounded corners
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebViewScreen(
                        url: scheme.websiteUrl, title: scheme.name),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      scheme.name,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700, // More prominent bold
                        color: Colors.indigo[700], // Darker primary color
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Text(
                      scheme.description,
                      style: TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 12.0),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Learn More',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.indigo[400],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class Scheme {
  final String name;
  final String description;
  final String websiteUrl;

  Scheme(
      {required this.name,
      required this.description,
      required this.websiteUrl});
}

class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;

  const WebViewScreen({super.key, required this.url, required this.title});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (error) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Error loading website: ${error.description}')),
            );
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        backgroundColor: Colors.indigo[400],
        elevation: 1.0,
        iconTheme: IconThemeData(color: Colors.white), // White back arrow
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.indigo[400]!), // Themed progress indicator
              ),
            ),
        ],
      ),
    );
  }
}
