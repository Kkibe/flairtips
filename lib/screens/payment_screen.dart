import 'package:flairtips/utils/api_service.dart';
import 'package:flairtips/utils/user_provider.dart';
import 'package:flairtips/widgets/filled_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentScreen extends StatefulWidget {
  final int planId;
  const PaymentScreen({required this.planId, super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: true);
    final user = userProvider.user;

    void submitPayment(int userId) async {
      if (_formKey.currentState!.validate()) {
        setState(() => _isLoading = true);
        try {
          final rawPhone = _phoneController.text.trim();
          final phone =
              rawPhone.startsWith('07')
                  ? rawPhone.replaceFirst('0', '254')
                  : rawPhone;

          await initiatePayment(
            planId: widget.planId,
            phone: phone,
            userId: userId,
          );

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Payment initiated successfully')),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
        } finally {
          setState(() => _isLoading = false);
        }
      }
    }

    String? validatePhone(String? value) {
      if (value == null || value.trim().isEmpty) {
        return 'Phone is required';
      }

      final input = value.trim();
      final pattern = RegExp(r'^(07\d{8}|2547\d{8})$');

      if (!pattern.hasMatch(input)) {
        return 'Enter a valid phone (07XXXXXXXX or 2547XXXXXXXX)';
      }

      return null;
    }

    return Scaffold(
      appBar: AppBar(title: Text("Make Payment")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone (e.g., 2547XXXXXXXX or 07XXXXXXXX)",
                  ),
                  keyboardType: TextInputType.phone,
                  validator: validatePhone,
                ),
                const SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator()
                    : AppFilledButton(
                      text: "Pay Now",
                      onPressed:
                          () => {
                            _isLoading || user == null
                                ? null
                                : () => submitPayment(int.parse(user.id)),
                          },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
