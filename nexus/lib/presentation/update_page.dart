import 'package:flutter/material.dart';
import 'package:nexus/core/models/operation_state.dart';
import 'package:nexus/features/update/domain/services/update_service.dart';
import 'package:nexus/features/update/domain/usecases/update_usecase.dart';
import 'package:nexus/presentation/home/home_page.dart';
import 'package:nexus/presentation/initialization_page.dart';
import 'package:nexus/presentation/splash_page.dart';

class UpdatePage extends StatefulWidget {
  final UpdateUsecase _updateUsecase;
  const UpdatePage(this._updateUsecase, {super.key});

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  UpdateUsecase get _updateUsecase => widget._updateUsecase;

  bool _updateFinished = false;
  OperationState<UpdatingStep, UpdateError> ? _operationState;

  @override
  Widget build(BuildContext context) {
    final OperationState<UpdatingStep, UpdateError> ? operationState = _operationState;

    if(operationState == null) {
      if(_updateFinished) WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return HomePage(logoutUsecase: getter());
        }));
      });

      return const SplashPage();
    } 

    if(!operationState.success) {
      return Scaffold(
        body: Center(
          child: Text(operationState.error.translate),
        ),
      );
    }

    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsetsGeometry.all(10),
          child: Column(
            spacing: 12,
            mainAxisSize: .min,
            children: [
              Text(operationState.data.translate),
          
              operationState.progress == null ? const CircularProgressIndicator() : LinearProgressIndicator(
                value: operationState.progress!.progress,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await for(final OperationState<UpdatingStep, UpdateError> operationState in _updateUsecase()) {
        if(!mounted) return;
        setState(() => _operationState = operationState);
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() {
          _operationState = null;
          _updateFinished = true;
        });
      });
    });
  }
}