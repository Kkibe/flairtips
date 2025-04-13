import 'package:flutter/material.dart';
import 'package:goalgenius/utils/constants.dart';
import 'package:goalgenius/widgets/social_icons.dart';

class Help extends StatefulWidget {
  const Help({super.key});

  @override
  State<Help> createState() => _HelpState();
}

class _HelpState extends State<Help> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                final faq = faqs[index];
                return CustomFAQ(
                  question: faq['question']!,
                  answer: faq['answer']!,
                );
              },
            ),
          ),
          SocialIcons(),
        ],
      ),
    );
  }
}

class CustomFAQ extends StatefulWidget {
  final String question;
  final String answer;

  CustomFAQ({required this.question, required this.answer});

  @override
  CustomFAQState createState() => CustomFAQState();
}

class CustomFAQState extends State<CustomFAQ> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(4.0),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey, // Grey border
          width: .5, // Border width
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() => isExpanded = !isExpanded);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(widget.question),
              trailing: Icon(
                isExpanded
                    ? Icons.add_box_rounded
                    : Icons.indeterminate_check_box_rounded,
              ),
              onTap: () => setState(() => isExpanded = !isExpanded),
            ),
            AnimatedCrossFade(
              firstChild: Container(),
              secondChild: Padding(
                //padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                padding: EdgeInsets.all(0),
                child: Text(widget.answer, textAlign: TextAlign.start),
              ),
              crossFadeState:
                  isExpanded
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
              duration: Duration(milliseconds: 200),
            ),
          ],
        ),
      ),
    );
  }
}
