import 'package:fast_feet_app/@exceptions/api_exceptions.dart';
import 'package:fast_feet_app/@mixins/form_validations_mixin.dart';
import 'package:fast_feet_app/components/custom_text_field.dart';
import 'package:fast_feet_app/components/loading_overlay.dart';
import 'package:fast_feet_app/providers/recipients_provider.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class CreateNewRecipientScreen extends StatefulWidget {
  const CreateNewRecipientScreen({super.key});

  @override
  State<CreateNewRecipientScreen> createState() =>
      _CreateNewRecipientScreenState();
}

class _CreateNewRecipientScreenState extends State<CreateNewRecipientScreen>
    with FormValidationsMixin {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  bool _isLoading = false;

  Future<void> handleSubmitForm() async {
    setState(() => _isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      print('Invalid form!');
      return;
    }

    formKey.currentState?.save();

    try {
      await Provider.of<RecipientsProvider>(
        context,
        listen: false,
      ).registerNewRecipient(formData);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Destinatário cadastrado com sucesso!',
            ),
          ),
        );

        Navigator.pop(context);
      }

      setState(() => _isLoading = false);
    } on ApiExceptions catch (error) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.message,
          ),
        ),
      );
    } catch (error) {
      print('Unexpected error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ocorreu um erro inesperado. Tente novamente.',
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    formData.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Novo destinatário',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        CustomTextField(
                          hintText: 'Nome',
                          prefixIcon: Icon(
                            PhosphorIconsRegular.user,
                            size: 20,
                          ),
                          textInputAction: TextInputAction.next,
                          validator: isNotEmpty,
                          onSaved: (value) {
                            formData['name'] = value ?? '';
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: 'Email',
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icon(
                            PhosphorIconsRegular.at,
                            size: 20,
                          ),
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            formData['email'] = value ?? '';
                          },
                          validator: (value) => combine(
                            [
                              () => isNotEmpty(value),
                              () => isEmail(
                                    value,
                                    'Por favor, informe um e-mail válido.',
                                  )
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: 'CPF',
                                keyboardType: TextInputType.numberWithOptions(),
                                prefixIcon: Icon(
                                  PhosphorIconsRegular.identificationCard,
                                  size: 20,
                                ),
                                textInputAction: TextInputAction.next,
                                validator: isNotEmpty,
                                onSaved: (value) {
                                  formData['cpf'] = value ?? '';
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Telefone',
                                keyboardType: TextInputType.numberWithOptions(),
                                prefixIcon: Icon(
                                  PhosphorIconsRegular.phone,
                                  size: 20,
                                ),
                                textInputAction: TextInputAction.next,
                                validator: isNotEmpty,
                                onSaved: (value) {
                                  formData['phone'] = value ?? '';
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: 'Rua',
                          textInputAction: TextInputAction.next,
                          validator: isNotEmpty,
                          onSaved: (value) {
                            formData['street'] = value ?? '';
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Número',
                                textInputAction: TextInputAction.next,
                                validator: isNotEmpty,
                                onSaved: (value) {
                                  formData['number'] = value ?? '';
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                hintText: 'CEP',
                                keyboardType: TextInputType.numberWithOptions(),
                                textInputAction: TextInputAction.next,
                                validator: isNotEmpty,
                                onSaved: (value) {
                                  formData['cep'] = value ?? '';
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: 'Complemento',
                          textInputAction: TextInputAction.next,
                          onSaved: (value) {
                            if (value == null) return;
                            formData['complement'] = value;
                          },
                        ),
                        const SizedBox(height: 10),
                        CustomTextField(
                          hintText: 'Bairro',
                          textInputAction: TextInputAction.next,
                          validator: isNotEmpty,
                          onSaved: (value) {
                            formData['district'] = value ?? '';
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Cidade',
                                textInputAction: TextInputAction.next,
                                validator: isNotEmpty,
                                onSaved: (value) {
                                  formData['city'] = value ?? '';
                                },
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: CustomTextField(
                                hintText: 'Estado',
                                textInputAction: TextInputAction.done,
                                validator: isNotEmpty,
                                onSaved: (value) {
                                  formData['state'] = value ?? '';
                                },
                                onFieldSubmitted: (_) => handleSubmitForm(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading) LoadingOverlay(),
        ],
      ),
      bottomNavigationBar: _isLoading
          ? null
          : Padding(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: ElevatedButton(
                child: const Text('Salvar'),
                onPressed: () => handleSubmitForm(),
              ),
            ),
    );
  }
}
