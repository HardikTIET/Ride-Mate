import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:erickshawapp/features/rides/presentation/bloc/ride_cubit.dart';
import 'package:erickshawapp/shared/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:phonepe_payment_sdk/phonepe_payment_sdk.dart';

class PaymentScreen extends StatefulWidget {
  String? rideId;
  String? userId;
  bool? isPreBook;

  PaymentScreen({super.key, this.rideId, this.userId,  this.isPreBook});

  @override
  State<PaymentScreen> createState() => MerchantScreen();
}

class MerchantScreen extends State<PaymentScreen> {
  String body = "";
  String callBackUrl =
      "https://webhook.site/18b97022-5593-4007-8853-a0db128b43dc";
  String checksum = "";

  bool enableLogs = true;
  Object? result;
  String environmentValue = 'SANDBOX';
  String appId = "";
  String merchantId = "PGTESTPAYUAT86";
  String packageName = "";
  String saltKey = '96434309-7796-489d-8924-ab56988a6076';
  String saltIndex = "1";
  String apiEndPoint = "/pg/v1/pay";

  @override
  void initState() {
    initPhonePeSdk();
    body = getCheckSums().toString();
    super.initState();
  }

  void initPhonePeSdk() {
    PhonePePaymentSdk.init(environmentValue, appId, merchantId, enableLogs)
        .then((isInitialized) => {
              setState(() {
                result = 'PhonePe SDK Initialized - $isInitialized';
              })
            })
        .catchError((error) {
      handleError(error);
      print(error);
      return <dynamic>{};
    });
  }

  getCheckSums() {
    final reqData = {
      "merchantId": merchantId,
      "merchantTransactionId": "MT7850590068188104",
      "merchantUserId": "MUID123",
      "amount": 4400,
      "callbackUrl": callBackUrl,
      "mobileNumber": "9999999999",
      "paymentInstrument": {"type": "PAY_PAGE"}
    };

    String base64Body = base64.encode(utf8.encode(json.encode(reqData)));
    checksum =
        '${sha256.convert(utf8.encode(base64Body + apiEndPoint + saltKey)).toString()}###$saltIndex';
    return base64Body;
  }

  void startTransaction() async {
    try {
      PhonePePaymentSdk.startTransaction(
              body, callBackUrl, checksum, packageName)
          .then((response) => {
                setState(() {
                  if (response != null) {
                    String status = response['status'].toString();
                    String error = response['error'].toString();
                    if (status == 'SUCCESS') {
                      context.read<RideCubit>().paymentCompleted(
                          widget.rideId ?? "",
                          widget.userId ?? "",
                          widget.isPreBook ?? false);
                      result = "Flow Completed - Status: Success!";
                    } else {
                      result =
                          "Flow Completed - Status: $status and Error: $error";
                    }
                  } else {
                    result = "Flow Incomplete";
                  }
                })
              })
          .catchError((error) {
        handleError(error);
        return <dynamic>{};
      });
    } catch (error) {
      handleError(error);
    }
  }

  void handleError(error) {
    setState(() {
      if (error is Exception) {
        result = error.toString();
      } else {
        result = {"error": error};
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: const Image(image: AssetImage(AppImages.pay))),
              const SizedBox(height: 20), // Add some spacing
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                  ),
                  onPressed: startTransaction,
                  child: Text(
                    "Pay Now",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
