import 'dart:io';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zoom_provider/generated/locale_keys.g.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/show_pretty_snack.dart';
import '../../../app_section/presentation/view/app_section.dart';
import '../../data/model/products_in_orders.dart';
import '../view_model/complete_order/complete_order_cubit.dart';
import '../view_model/complete_order/complete_order_state.dart';
import '../view_model/completed_paid/completed_paid_cubit.dart';
import '../view_model/completed_paid/completed_paid_state.dart';
import '../view_model/products_in_orders/products_in_orders_cubit.dart';
import '../view_model/products_in_orders/products_in_orders_state.dart';
import '../view_model/suspend_order/suspend_order_cubit.dart';
import '../view_model/suspend_order/suspend_order_state.dart';
import '../view_model/suspend_with_goods_returned/suspend_with_goods_returned_cubit.dart';
import '../view_model/suspend_with_goods_returned/suspend_with_goods_returned_state.dart';
import '../view_model/installation_not_done/installation_not_done_cubit.dart';
import '../view_model/installation_not_done/installation_not_done_state.dart';
import '../widgets/custom_input_field.dart';
import '../widgets/status_card.dart';
import 'store_screen.dart';

class StatusUpdateScreen extends StatefulWidget {
  final int orderId;
  final String customerName;
  final List<int> servicesIds;

  const StatusUpdateScreen({
    super.key,
    required this.orderId,
    required this.customerName,
    required this.servicesIds,
  });

  @override
  State<StatusUpdateScreen> createState() => _StatusUpdateScreenState();
}

class _StatusUpdateScreenState extends State<StatusUpdateScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  int _selectedStatus = 0;

  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _materialsController = TextEditingController();

  final List<XFile> _depositReceipts = [];

  final List<ReturnedProductInput> _returnedProducts = [
    ReturnedProductInput(),
  ];

  String? _selectedDepositAccountType;

  static const List<Map<String, String>> _depositAccountOptions = [
    {
      'label': LocaleKeys.status_update_company_transfer,
      'value': 'company_transfer',
    },
    {
      'label': LocaleKeys.status_update_employee_transfer,
      'value': 'employee_transfer',
    },
    {
      'label': LocaleKeys.status_update_cash_transfer,
      'value': 'cash',
    },
  ];

  bool get _isCompletedWithPayment => _selectedStatus == 0;
  bool get _isCompletedWithoutPayment => _selectedStatus == 1;
  bool get _isGoodsLeftWithCustomer => _selectedStatus == 2;
  bool get _isInstallationNotDone => _selectedStatus == 3;
  bool get _isGoodsReturned => _selectedStatus == 4;
  bool get _isNotesRequired => _isGoodsLeftWithCustomer || _isInstallationNotDone;

  @override
  void dispose() {
    _notesController.dispose();
    _amountController.dispose();
    _materialsController.dispose();

    for (final item in _returnedProducts) {
      item.dispose();
    }

    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    showPrettySnack(context, message, success: !isError);
  }

  void _navigateToMainLayout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainLayout()),
          (route) => false,
    );
  }

  double? _parseDouble(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    return double.tryParse(normalized);
  }

  Future<void> _pickDepositReceipts() async {
    try {
      final pickedFiles = await _picker.pickMultiImage();

      if (pickedFiles.isNotEmpty) {
        setState(() {
          _depositReceipts.addAll(pickedFiles);
        });
      }
    } catch (e) {
      _showMessage(e.toString(), isError: true);
    }
  }

  void _resetConditionalFields() {
    _notesController.clear();
    _amountController.clear();
    _materialsController.clear();

    _depositReceipts.clear();
    _selectedDepositAccountType = null;

    for (final item in _returnedProducts) {
      item.dispose();
    }

    _returnedProducts
      ..clear()
      ..add(ReturnedProductInput());
  }

  void _onStatusSelected(int index) {
    setState(() {
      _selectedStatus = index;
      _resetConditionalFields();
    });

    if (_isGoodsReturned) {
      context.read<ProductsInOrdersCubit>().getProductsInOrders(widget.orderId);
    }

    _formKey.currentState?.validate();
  }

  String? _validateAmount(String? value) {
    if (!_isCompletedWithPayment) return null;

    final amountText = value?.trim() ?? '';

    if (amountText.isEmpty) {
      return LocaleKeys.status_update_error_amount_empty.tr();
    }

    final amount = _parseDouble(amountText);

    if (amount == null || amount <= 0) {
      return LocaleKeys.status_update_error_amount_invalid.tr();
    }

    return null;
  }

  String? _validateMaterials(String? value) {
    if (!_isCompletedWithPayment) return null;

    final materialsText = value?.trim() ?? '';

    if (materialsText.isEmpty) return null;

    final materials = _parseDouble(materialsText);

    if (materials == null || materials < 0) {
      return LocaleKeys.status_update_error_materials_invalid.tr();
    }

    return null;
  }

  String? _validateNotes(String? value) {
    if (!_isNotesRequired) return null;

    final note = value?.trim() ?? '';

    if (note.isEmpty) {
      return LocaleKeys.status_update_error_note_required.tr();
    }

    return null;
  }

  void _addReturnedProduct() {
    setState(() {
      _returnedProducts.add(ReturnedProductInput());
    });
  }

  void _removeReturnedProduct(int index) {
    if (_returnedProducts.length <= 1) return;

    setState(() {
      _returnedProducts[index].dispose();
      _returnedProducts.removeAt(index);
    });
  }

  bool _validateReturnedProductsManually() {
    if (!_isGoodsReturned) return true;

    for (final item in _returnedProducts) {
      final quantity = int.tryParse(item.quantityController.text.trim());

      if (item.product == null || quantity == null || quantity <= 0) {
        return false;
      }
    }

    return true;
  }

  void _submit() {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) {
      _showMessage(
        LocaleKeys.status_update_error_review_fields.tr(),
        isError: true,
      );
      return;
    }

    if (_isCompletedWithPayment) {
      if (widget.servicesIds.isEmpty) {
        _showMessage(
          LocaleKeys.status_update_error_services_empty.tr(),
          isError: true,
        );
        return;
      }

      if (_selectedDepositAccountType == null) {
        _showMessage(
          LocaleKeys.status_update_error_select_deposit_account.tr(),
          isError: true,
        );
        return;
      }

      if (_depositReceipts.isEmpty) {
        _showMessage(
          LocaleKeys.status_update_error_upload_deposit_receipt.tr(),
          isError: true,
        );
        return;
      }

      final amount = _parseDouble(_amountController.text.trim())!;
      final materialsText = _materialsController.text.trim();
      final materials = materialsText.isEmpty ? null : _parseDouble(materialsText);

      context.read<CompletedPaidCubit>().completedPaid(
        orderId: widget.orderId,
        amount: amount,
        servicesIds: widget.servicesIds,
        materials: materials,
        depositReceipts: _depositReceipts,
        depositAccountType: _selectedDepositAccountType!,
      );

      return;
    }

    if (_isCompletedWithoutPayment) {
      context.read<CompleteOrderCubit>().completeOrder(widget.orderId);
      return;
    }

    if (_isGoodsLeftWithCustomer) {
      context.read<SuspendOrderCubit>().suspendOrder(
        widget.orderId,
        _notesController.text.trim(),
      );

      return;
    }

    if (_isInstallationNotDone) {
      context.read<InstallationNotDoneCubit>().installationNotDone(
        widget.orderId,
        _notesController.text.trim(),
      );

      return;
    }

    if (_isGoodsReturned) {
      final validReturnedProducts = _validateReturnedProductsManually();

      if (!validReturnedProducts) {
        _showMessage(
          LocaleKeys.status_update_error_review_fields.tr(),
          isError: true,
        );
        return;
      }

      final formMap = <String, dynamic>{};

      for (int i = 0; i < _returnedProducts.length; i++) {
        final item = _returnedProducts[i];
        final quantity = int.parse(item.quantityController.text.trim());

        formMap['products[$i][id]'] = item.product!.productId;
        formMap['products[$i][quantity]'] = quantity;

        final productNote = item.noteController.text.trim();

        if (productNote.isNotEmpty) {
          formMap['products[$i][notes]'] = productNote;
        }
      }

      final generalNote = _notesController.text.trim();

      if (generalNote.isNotEmpty) {
        formMap['notes'] = generalNote;
      }

      final formData = FormData.fromMap(formMap);

      context
          .read<SuspendWithGoodsReturnedCubit>()
          .suspendWithGoodsReturned(widget.orderId, formData);

      return;
    }
  }

  Widget _buildDepositSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<String>(
          value: _selectedDepositAccountType,
          decoration: InputDecoration(
            hintText: LocaleKeys.status_update_company_transfer.tr(),
            hintStyle: TextStyle(fontSize: 12),
            filled: true,
            counterStyle: TextStyle(fontSize: 14),
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.accentRed),
            ),
          ),
          items: _depositAccountOptions.map((item) {
            return DropdownMenuItem<String>(
              value: item['value'],
              child: Text(item['label']!.tr(),style: TextStyle(fontSize: 14),),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              _selectedDepositAccountType = value;
            });
          },
        ),
        const SizedBox(height: 14),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: _pickDepositReceipts,
            icon: const Icon(Icons.upload_file),
            label: Text(
              LocaleKeys.status_update_upload_deposit_receipt.tr(),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.accentRed,
              side: const BorderSide(color: AppColors.accentRed),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
        if (_depositReceipts.isNotEmpty) ...[
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(_depositReceipts.length, (index) {
              final image = _depositReceipts[index];

              return Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(image.path),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _depositReceipts.removeAt(index);
                        });
                      },
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        padding: const EdgeInsets.all(4),
                        child: const Icon(
                          Icons.close,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
          ),
        ],
      ],
    );
  }

  Widget _buildReturnedProductsSection() {
    return BlocBuilder<ProductsInOrdersCubit, ProductsInOrdersState>(
      builder: (context, state) {
        if (state is ProductsInOrdersLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ProductsInOrdersFailure) {
          return Text(
            state.apiError?.getLocalizedMessage(context) ??
                LocaleKeys.status_update_failed_suspend.tr(),
            style: const TextStyle(
              color: Colors.red,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          );
        }

        if (state is ProductsInOrdersSuccess) {
          final products = state.productsInOrders.data ?? [];

          if (products.isEmpty) {
            return Center(
              child: Text(
                LocaleKeys.status_update_error_select_product.tr(),
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...List.generate(_returnedProducts.length, (index) {
                final item = _returnedProducts[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${LocaleKeys.status_update_select_product.tr()} ${index + 1}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          if (_returnedProducts.length > 1)
                            IconButton(
                              onPressed: () => _removeReturnedProduct(index),
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<ProductData>(
                        value: item.product,
                        decoration: InputDecoration(
                          hintText: LocaleKeys.status_update_select_product.tr(),
                          filled: true,
                          fillColor: Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(color: Colors.grey.shade200),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.accentRed,
                            ),
                          ),
                        ),
                        items: products.map((product) {
                          return DropdownMenuItem<ProductData>(
                            value: product,
                            child: Text(
                              product.name ?? '',
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            item.product = value;
                          });
                        },
                        validator: (_) {
                          if (!_isGoodsReturned) return null;

                          if (item.product == null) {
                            return LocaleKeys.status_update_error_select_product
                                .tr();
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomInputField(
                        controller: item.quantityController,
                        hintText: LocaleKeys.status_update_quantity.tr(),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (!_isGoodsReturned) return null;

                          final quantity = int.tryParse(value?.trim() ?? '');

                          if (quantity == null || quantity <= 0) {
                            return LocaleKeys
                                .status_update_error_enter_quantity
                                .tr();
                          }

                          return null;
                        },
                      ),
                      const SizedBox(height: 12),
                      CustomInputField(
                        controller: item.noteController,
                        hintText: LocaleKeys.status_update_add_note.tr(),
                        maxLines: 2,
                      ),
                    ],
                  ),
                );
              }),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _addReturnedProduct,
                  icon: const Icon(Icons.add),
                  label:  Text( LocaleKeys.addProduct.tr()),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accentRed,
                    side: const BorderSide(color: AppColors.accentRed),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CompleteOrderCubit, CompleteOrderState>(
          listener: (context, state) {
            if (state is CompleteOrderSuccess) {
              _showMessage(LocaleKeys.status_update_success_complete.tr());
              _navigateToMainLayout();
            } else if (state is CompleteOrderFailure) {
              _showMessage(
                state.apiError?.getLocalizedMessage(context) ??
                    LocaleKeys.status_update_failed_complete.tr(),
                isError: true,
              );
            }
          },
        ),
        BlocListener<SuspendOrderCubit, SuspendOrderState>(
          listener: (context, state) {
            if (state is SuspendOrderSuccess) {
              _showMessage(LocaleKeys.status_update_success_suspend.tr());
              _navigateToMainLayout();
            } else if (state is SuspendOrderFailure) {
              _showMessage(
                state.apiError?.getLocalizedMessage(context) ??
                    LocaleKeys.status_update_failed_suspend.tr(),
                isError: true,
              );
            }
          },
        ),
        BlocListener<CompletedPaidCubit, CompletedPaidState>(
          listener: (context, state) {
            if (state is CompletedPaidSuccess) {
              final successMessage = state.data.getLocalizedMessage(context);
              _showMessage(successMessage);
              _navigateToMainLayout();
            } else if (state is CompletedPaidFailure) {
              _showMessage(state.message, isError: true);
            }
          },
        ),
        BlocListener<SuspendWithGoodsReturnedCubit,
            SuspendWithGoodsReturnedState>(
          listener: (context, state) {
            if (state is SuspendWithGoodsReturnedSuccess) {
              _showMessage(LocaleKeys.status_update_success_suspend.tr());
              _navigateToMainLayout();
            } else if (state is SuspendWithGoodsReturnedFailure) {
              _showMessage(
                state.apiError?.getLocalizedMessage(context) ??
                    LocaleKeys.status_update_failed_suspend.tr(),
                isError: true,
              );
            }
          },
        ),
        BlocListener<InstallationNotDoneCubit, InstallationNotDoneState>(
          listener: (context, state) {
            if (state is InstallationNotDoneSuccess) {
              _showMessage(LocaleKeys.status_update_success_suspend.tr());
              _navigateToMainLayout();
            } else if (state is InstallationNotDoneFailure) {
              _showMessage(
                state.apiError?.getLocalizedMessage(context) ??
                    LocaleKeys.status_update_failed_suspend.tr(),
                isError: true,
              );
            }
          },
        ),
      ],
      child: BlocBuilder<CompleteOrderCubit, CompleteOrderState>(
        builder: (context, completeState) {
          return BlocBuilder<SuspendOrderCubit, SuspendOrderState>(
            builder: (context, suspendState) {
              return BlocBuilder<CompletedPaidCubit, CompletedPaidState>(
                builder: (context, completedPaidState) {
                  return BlocBuilder<SuspendWithGoodsReturnedCubit,
                      SuspendWithGoodsReturnedState>(
                    builder: (context, suspendWithGoodsReturnedState) {
                      return BlocBuilder<InstallationNotDoneCubit, InstallationNotDoneState>(
                        builder: (context, installationNotDoneState) {
                          final isLoading =
                              completeState is CompleteOrderLoading ||
                                  suspendState is SuspendOrderLoading ||
                                  completedPaidState is CompletedPaidLoading ||
                                  suspendWithGoodsReturnedState
                                  is SuspendWithGoodsReturnedLoading ||
                                  installationNotDoneState is InstallationNotDoneLoading;

                          return Scaffold(
                            backgroundColor: AppColors.surface,
                            body: SafeArea(
                              bottom: false,
                              child: Column(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 20),
                                    child: Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => Navigator.pop(context),
                                          icon: const Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                          padding: EdgeInsets.zero,
                                          constraints: const BoxConstraints(),
                                        ),
                                        Expanded(
                                          child: Text(
                                            LocaleKeys.status_update_title.tr(),
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => const StoreScreen(),
                                              ),
                                            );
                                          },
                                          child: SvgPicture.asset(
                                            'assets/svg/shopping_cart.svg',
                                            colorFilter: const ColorFilter.mode(
                                              Colors.white,
                                              BlendMode.srcIn,
                                            ),
                                            width: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: AppColors.scaffoldBackground,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(30),
                                          topRight: Radius.circular(30),
                                        ),
                                        child: SingleChildScrollView(
                                          padding: const EdgeInsets.all(20),
                                          child: Form(
                                            key: _formKey,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    LocaleKeys
                                                        .status_update_select_result
                                                        .tr(
                                                      args: [widget.customerName],
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                StatusCard(
                                                  index: 0,
                                                  selectedStatus: _selectedStatus,
                                                  icon: '✅',
                                                  title: LocaleKeys
                                                      .status_update_completed_paid
                                                      .tr(),
                                                  description: '',
                                                  onTap: () =>
                                                      _onStatusSelected(0),
                                                ),
                                                if (_isCompletedWithPayment) ...[
                                                  const SizedBox(height: 20),
                                                  Center(
                                                    child: Text(
                                                      LocaleKeys
                                                          .status_update_amount_collected
                                                          .tr(),
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  CustomInputField(
                                                    controller: _amountController,
                                                    hintText: LocaleKeys
                                                        .status_update_set_amount
                                                        .tr(),
                                                    keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                      decimal: true,
                                                    ),
                                                    validator: _validateAmount,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Center(
                                                    child: Text(
                                                      LocaleKeys
                                                          .status_update_materials_amount
                                                          .tr(),
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13,
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 10),
                                                  CustomInputField(
                                                    controller:
                                                    _materialsController,
                                                    hintText: LocaleKeys
                                                        .status_update_set_materials_amount
                                                        .tr(),
                                                    keyboardType:
                                                    const TextInputType
                                                        .numberWithOptions(
                                                      decimal: true,
                                                    ),
                                                    validator: _validateMaterials,
                                                  ),
                                                  const SizedBox(height: 16),
                                                  _buildDepositSection(),
                                                ],
                                                const SizedBox(height: 20),
                                                StatusCard(
                                                  index: 1,
                                                  selectedStatus: _selectedStatus,
                                                  icon: '🔧',
                                                  title: LocaleKeys
                                                      .status_update_completed_unpaid
                                                      .tr(),
                                                  description: LocaleKeys
                                                      .status_update_completed_unpaid_desc
                                                      .tr(),
                                                  onTap: () =>
                                                      _onStatusSelected(1),
                                                ),
                                                const SizedBox(height: 20),
                                                StatusCard(
                                                  index: 2,
                                                  selectedStatus: _selectedStatus,
                                                  icon: '📦',
                                                  title: LocaleKeys
                                                      .status_update_suspended_left
                                                      .tr(),
                                                  description: LocaleKeys
                                                      .status_update_suspended_left_desc
                                                      .tr(),
                                                  onTap: () =>
                                                      _onStatusSelected(2),
                                                ),
                                                const SizedBox(height: 20),
                                                StatusCard(
                                                  index: 3,
                                                  selectedStatus: _selectedStatus,
                                                  icon: '🚫',
                                                  title: LocaleKeys
                                                      .status_update_installation_not_done
                                                      .tr(),
                                                  description: LocaleKeys
                                                      .status_update_installation_not_done_desc
                                                      .tr(),
                                                  onTap: () =>
                                                      _onStatusSelected(3),
                                                ),
                                                const SizedBox(height: 20),
                                                StatusCard(
                                                  index: 4,
                                                  selectedStatus: _selectedStatus,
                                                  icon: '↩️',
                                                  title: LocaleKeys
                                                      .status_update_suspended_returned
                                                      .tr(),
                                                  description: LocaleKeys
                                                      .status_update_suspended_returned_desc
                                                      .tr(),
                                                  onTap: () =>
                                                      _onStatusSelected(4),
                                                ),
                                                if (_isGoodsReturned) ...[
                                                  SizedBox(height: 20.h),
                                                  _buildReturnedProductsSection(),
                                                ],
                                                const SizedBox(height: 24),
                                                Center(
                                                  child: RichText(
                                                    text: TextSpan(
                                                      text: LocaleKeys
                                                          .status_update_additional_notes
                                                          .tr(),
                                                      style: TextStyle(
                                                        color: Colors.grey.shade700,
                                                        fontSize: 13,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                      children: [
                                                        if (_isNotesRequired)
                                                          const TextSpan(
                                                            text: ' *',
                                                            style: TextStyle(
                                                              color: Colors.red,
                                                              fontWeight:
                                                              FontWeight.bold,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                CustomInputField(
                                                  controller: _notesController,
                                                  hintText: _isNotesRequired
                                                      ? LocaleKeys
                                                      .status_update_add_note_required
                                                      .tr()
                                                      : LocaleKeys
                                                      .status_update_add_note
                                                      .tr(),
                                                  maxLines: 3,
                                                  validator: _validateNotes,
                                                ),
                                                const SizedBox(height: 24),
                                                SizedBox(
                                                  width: double.infinity,
                                                  child: ElevatedButton(
                                                    onPressed:
                                                    isLoading ? null : _submit,
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor:
                                                      AppColors.accentRed,
                                                      foregroundColor: Colors.white,
                                                      disabledBackgroundColor:
                                                      AppColors.accentRed
                                                          .withOpacity(0.6),
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 16,
                                                      ),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                          20,
                                                        ),
                                                      ),
                                                      elevation: 0,
                                                    ),
                                                    child: isLoading
                                                        ? const SizedBox(
                                                      height: 20,
                                                      width: 20,
                                                      child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 2,
                                                      ),
                                                    )
                                                        : Text(
                                                      LocaleKeys
                                                          .status_update_submit
                                                          .tr(),
                                                      style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(height: 40),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

class ReturnedProductInput {
  ProductData? product;
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  void dispose() {
    quantityController.dispose();
    noteController.dispose();
  }
}