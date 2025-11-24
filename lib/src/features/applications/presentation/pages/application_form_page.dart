import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../../gen/assets.gen.dart';
import '../../../../core/base_types/loading_status.dart';
import '../../../../core/widgets/widgets.dart';
import '../../domain/domain.dart';
import '../blocs/application_form_page/bloc.dart';
import '../widgets/application_forms/absence_form.dart';
import '../widgets/application_forms/alpina_access_form.dart';

class ApplicationFormPage extends StatefulWidget {
  const ApplicationFormPage({super.key});

  @override
  State<ApplicationFormPage> createState() => _ApplicationFormPageState();
}

class _ApplicationFormPageState extends State<ApplicationFormPage> {
  CreateApplicationParams? _currentParams;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Создание заявки'),
        leading: IconButton(
          icon: SvgPicture.asset(Assets.icons.backIcon),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: SvgPicture.asset(Assets.icons.crossIcon),
            onPressed: () => context.go('/applications'),
          ),
        ],
      ),
      body: BlocListener<ApplicationFormBloc, ApplicationFormState>(
        listenWhen: (previous, current) {
          // Only listen when transitioning FROM submitting TO not submitting
          return previous.isSubmitting && !current.isSubmitting;
        },
        listener: (context, state) {
          // Handle successful submission
          if (state.status == LoadingStatus.success) {
            showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.transparent,
              builder: (dialogContext) => SubmitResultWidget(
                message: 'Заявка успешно создана',
                isSuccess: true,
                onClose: () {
                  Navigator.of(dialogContext).pop();
                  context.go('/applications');
                },
              ),
            );
          }

          // Handle error during submission
          if (state.status == LoadingStatus.error) {
            showDialog(
              context: context,
              barrierDismissible: false,
              barrierColor: Colors.transparent,
              builder: (dialogContext) => SubmitResultWidget(
                message: 'Ошибка: ${state.errorMessage ?? 'Unknown error'}',
                isSuccess: false,
                onClose: () {
                  Navigator.of(dialogContext).pop();
                },
              ),
            );
          }
        },
        child: Column(
          children: [
            // Form title
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                context.read<ApplicationFormBloc>().applicationForm.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // Form content
            Expanded(child: _buildFormContent()),

            // Submit button
            Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<ApplicationFormBloc, ApplicationFormState>(
                builder: (context, state) {
                  final isSubmitting = state.isSubmitting;

                  return SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isSubmitting || _currentParams == null
                          ? null
                          : () {
                              context.read<ApplicationFormBloc>().add(
                                ApplicationFormEvent.submitForm(
                                  _currentParams!,
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF5E6AD2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text(
                              'Создать',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormContent() {
    // Switch on form code to display appropriate form
    switch (context.read<ApplicationFormBloc>().applicationForm.code) {
      case 'alpinaAccess':
        return AlpinaAccessForm(
          onFormChanged: (params) {
            setState(() {
              _currentParams = params;
            });
          },
        );

      case 'absence':
        return AbsenceForm(
          onFormChanged: (params) {
            setState(() {
              _currentParams = params;
            });
          },
        );

      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.construction, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              Text(
                'Форма для "${context.read<ApplicationFormBloc>().applicationForm.name}" еще не реализована',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        );
    }
  }
}
