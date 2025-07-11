import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/base/base_view.dart';
import '../../../injection/injector.dart';
import '../../viewmodels/auth_view_model.dart';

class LoginScreen extends StatelessWidget {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<AuthViewModel>(
      viewModelBuilder: () => getIt<AuthViewModel>(),
      builder: (context, vm, child) {
        if (vm.isBusy) return CircularProgressIndicator();
        return Column(
          children: [
            TextField(controller: emailCtrl),
            TextField(controller: passCtrl),
            ElevatedButton(
              onPressed: () => vm.login(emailCtrl.text, passCtrl.text),
              child: Text('Login'),
            ),
            if (vm.errorMessage != null) Text(vm.errorMessage!),
            Consumer<AuthViewModel>(
              builder: (context, viewModel, child) {
                return Text(viewModel.user?.name ?? '');
              },
            ),
          ],
        );
      },
    );
  }
}