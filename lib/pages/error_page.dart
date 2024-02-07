import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  ErrorPage({super.key, this.ex, this.isHomePage = false});

  Exception? ex;
  bool isHomePage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: isHomePage
            ? null
            : AppBar(
                title: Text('back_to_homepage'.tr()),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    context.go('/');
                  },
                ),
              ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 100,
              ),
              Text(
                'page_not_found'.tr(),
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ));
  }
}
