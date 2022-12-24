import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('HATA'),
      content: Text(
          'Kullanıcı bulunamadı. Lütfen bilgileriniz doğruluğundan emin olun.'),
    );
  }
}
