import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:goalgenius/utils/constants.dart';
import 'package:goalgenius/utils/user_data_service.dart';
import 'package:goalgenius/widgets/faded_divider.dart';
import 'package:paystack_for_flutter/paystack_for_flutter.dart';

class PlanCard extends StatelessWidget {
  final bool isPopular;
  final String billing;
  final double charge;

  const PlanCard({
    this.isPopular = false,
    required this.charge,
    required this.billing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;
    return Card(
      margin: EdgeInsets.all(4), // Remove spacing between cards
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(
          color: Colors.grey, // Grey border
          width: .5, // Border width
        ),
      ),

      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.transparent, Colors.purpleAccent.withOpacity(0.2)],
          ),
        ),
        child: InkWell(
          onTap: () async {
            try {
              await PaystackFlutter().pay(
                context: context,
                secretKey: paystackSecretKey,
                amount: 1 * 100, // Amount in base currency (e.g., kobo for NGN)
                email: 'theelitedevelopers1@gmail.com',
                callbackUrl: '',
                showProgressBar: true,
                paymentOptions: [
                  PaymentOption.card,
                  PaymentOption.bankTransfer,
                  PaymentOption.mobileMoney,
                ],
                currency:
                    Currency
                        .KES, // Make sure your Paystack account supports this
                /* metaData: {
                  "product_name": "Nike Sneakers",
                  "product_quantity": 3,
                  "product_price": 24000,
                },*/
                onSuccess: (paystackCallback) async {
                  final now = DateTime.now().toUtc();
                  late DateTime endDate;

                  switch (billing) {
                    case "Weekly":
                      endDate = now.add(const Duration(days: 7));
                      break;
                    case "Monthly":
                      endDate = DateTime.utc(now.year, now.month + 1, now.day);
                      break;
                    case "Yearly":
                      endDate = DateTime.utc(now.year + 1, now.month, now.day);
                      break;
                    default:
                      endDate = now; // fallback in case billing is unknown
                  }

                  await UserDataService()
                      .updateUserField(currentUser?.email, "subscription", {
                        'plan': billing,
                        'startDate': now.toIso8601String(),
                        'endDate': endDate.toIso8601String(),
                      })
                      .then((_) async {
                        await UserDataService().updateUserField(
                          currentUser?.email,
                          "isPremium",
                          true,
                        );
                      });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor:
                          Colors
                              .transparent, // Make snackbar background transparent
                      elevation: 0, // Optional: removes shadow
                      behavior:
                          SnackBarBehavior.floating, // Optional: makes it float
                      content: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.purpleAccent,
                              Colors.greenAccent,
                            ], // Your gradient colors
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Transaction Successful: ${paystackCallback.reference}',

                          //style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
                onCancelled: (paystackCallback) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Transaction Cancelled: ${paystackCallback.reference}',
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment Failed: $e'),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // First Row (Competition and Date)
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$billing Billing",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "$charge KES",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.transparent,
                            Colors.purpleAccent.withOpacity(0.2),
                          ],
                        ),
                        border: Border.all(color: Colors.grey, width: 0.5),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: Card(
                        color: Colors.transparent,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "TBD",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: 4),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              FadedDivider(fadeWidth: 40),

              // Second Row (Home Team and Score)
              Padding(
                padding: EdgeInsets.all(12.0), // Adjust padding
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "First day is free",
                          overflow: TextOverflow.ellipsis, // Prevents overflow
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "First 3 days are free",
                          overflow: TextOverflow.ellipsis, // Prevents overflow
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    isPopular
                        ? Container(
                          margin: EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Colors.green.withOpacity(0.2),
                                Colors.purpleAccent.withOpacity(0.2),
                              ],
                            ),
                            border: Border.all(color: Colors.grey, width: 0.5),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                          child: Card(
                            color: Colors.transparent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                            clipBehavior: Clip.hardEdge,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "MOST POPULAR",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  SizedBox(width: 4),
                                ],
                              ),
                            ),
                          ),
                        )
                        : SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
