import 'package:fast_feet_app/app_routes.dart';
import 'package:fast_feet_app/components/app_drawer/app_drawer.dart';
import 'package:fast_feet_app/components/custom_text_field.dart';
import 'package:fast_feet_app/providers/recipients_provider.dart';
import 'package:fast_feet_app/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:provider/provider.dart';

class RecipientsScreen extends StatefulWidget {
  const RecipientsScreen({super.key});

  @override
  State<RecipientsScreen> createState() => _RecipientsScreenState();
}

class _RecipientsScreenState extends State<RecipientsScreen> {
  TextEditingController _searchController = TextEditingController();
  bool _isDirtyField = false;

  Future<void> _refreshOrders(BuildContext context) {
    return Provider.of<RecipientsProvider>(context, listen: false)
        .loadRecipients();
  }

  Future<void> filterOrders() async {
    if (_searchController.text.isEmpty) return;

    await Provider.of<RecipientsProvider>(context, listen: false)
        .loadRecipients(search: _searchController.text);
  }

  Future<void> clearFilter() async {
    _searchController.clear();
    await Provider.of<RecipientsProvider>(context, listen: false)
        .loadRecipients();
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecipientsProvider>(context, listen: false).loadRecipients();
    });

    _searchController.addListener(_handleDirtyField);
  }

  void _handleDirtyField() {
    if (_searchController.text.isNotEmpty) {
      setState(() => _isDirtyField = true);
    } else {
      setState(() => _isDirtyField = false);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.purple,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Destinatários',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        color: AppColors.purple,
        onRefresh: () => _refreshOrders(context),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                hintText: 'Filtrar por nome',
                suffixIcon: IconButton(
                  onPressed: _isDirtyField
                      ? () async {
                          await clearFilter();
                        }
                      : null,
                  icon: _isDirtyField
                      ? Icon(PhosphorIconsRegular.xCircle)
                      : Icon(PhosphorIconsRegular.magnifyingGlass),
                ),
                controller: _searchController,
                textInputAction: TextInputAction.search,
                onFieldSubmitted: (value) async {
                  await filterOrders();
                },
              ),
              const SizedBox(height: 10),
              Consumer<RecipientsProvider>(
                builder: (ctx, recipientsProvider, child) {
                  if (recipientsProvider.isLoading) {
                    return Expanded(
                      child: const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.purple),
                      ),
                    );
                  }
                  if (recipientsProvider.recipients.isEmpty) {
                    return Expanded(
                      child: const Center(
                        child: Text('Não há destinatários para mostrar'),
                      ),
                    );
                  }
                  return Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                endIndent: 15,
                                color: Colors.grey.shade300,
                              ),
                            ),
                            Text(
                              '${recipientsProvider.recipients.length} destinatários',
                              style: TextStyle(color: AppColors.textLight),
                            ),
                            Expanded(
                              child: Divider(
                                height: 1,
                                thickness: 1,
                                indent: 15,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: ListView.separated(
                            itemCount: recipientsProvider.recipients.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 10),
                            itemBuilder: (ctx, index) {
                              final recipient =
                                  recipientsProvider.recipients[index];

                              return Card(
                                color: Colors.white,
                                child: ListTile(
                                  title: Text(
                                    recipient.name,
                                    style: TextStyle(
                                        fontSize: 15, color: AppColors.titles),
                                  ),
                                  subtitle: Text(
                                    '${recipient.street} - ${recipient.district}',
                                    style:
                                        TextStyle(color: AppColors.textLight),
                                  ),
                                  trailing:
                                      Icon(PhosphorIconsRegular.caretRight),
                                  onTap: () {},
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.purple,
        child: Icon(PhosphorIconsBold.plus, color: Colors.white),
        onPressed: () {
          Navigator.of(context).pushNamed(AppRoutes.newRecipientForm);
        },
      ),
    );
  }
}
