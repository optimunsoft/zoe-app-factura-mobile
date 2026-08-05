import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/nit_verification_digit.dart';
import '../../../../modules/third-party/domain/models/third_party_models.dart';
import '../../../../modules/third-party/domain/models/third_party.common.dart';
import '../../../../modules/third-party/store/common.store.dart';
import '../../../../modules/third-party/store/thirdparty.store.dart';
import '../../../atoms/app_button.dart';

/// Formulario para crear cliente (POST terceros) con catálogos de [CommonStore].
class CustomerCreateForm extends StatefulWidget {
  const CustomerCreateForm({
    super.key,
    required this.onCreated,
  });

  final ValueChanged<ThirdParty> onCreated;

  @override
  State<CustomerCreateForm> createState() => _CustomerCreateFormState();
}

class _CustomerCreateFormState extends State<CustomerCreateForm> {
  final _formKey = GlobalKey<FormState>();

  final _identificationCtrl = TextEditingController();
  final _verificationCtrl = TextEditingController();
  final _companyNameCtrl = TextEditingController();
  final _firstNameCtrl = TextEditingController();
  final _middleNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _secondLastNameCtrl = TextEditingController();
  final _contactPersonCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();
  final _municipalitySearchCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phone1Ctrl = TextEditingController();
  final _phone2Ctrl = TextEditingController();

  int? _documentTypeId;
  String? _personTypeCode;
  String? _vatRegimeCode;
  String? _fiscalRespCode;
  Municipality? _selectedMunicipality;

  bool _foreign = false;
  bool _freeZone = false;
  bool _zomac = false;
  bool _submitting = false;
  Timer? _municipalityDebounce;

  bool get _isNatural => _personTypeCode == '2';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CommonStore>().loadAll();
    });
  }

  @override
  void dispose() {
    _municipalityDebounce?.cancel();
    _identificationCtrl.dispose();
    _verificationCtrl.dispose();
    _companyNameCtrl.dispose();
    _firstNameCtrl.dispose();
    _middleNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _secondLastNameCtrl.dispose();
    _contactPersonCtrl.dispose();
    _observationsCtrl.dispose();
    _municipalitySearchCtrl.dispose();
    _addressCtrl.dispose();
    _emailCtrl.dispose();
    _phone1Ctrl.dispose();
    _phone2Ctrl.dispose();
    super.dispose();
  }

  void _onIdentificationChanged(String value) {
    final dv = NitVerificationDigit.calculateAsString(value);
    _verificationCtrl.text = dv ?? '';
  }

  void _onMunicipalitySearch(String value) {
    _municipalityDebounce?.cancel();

    if (_selectedMunicipality != null) {
      setState(() => _selectedMunicipality = null);
      context.read<CommonStore>().selectMunicipality(null);
    }

    final query = value.trim();
    if (query.length < 2) {
      context.read<CommonStore>().searchMunicipalities('');
      return;
    }

    _municipalityDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      context.read<CommonStore>().searchMunicipalities(query);
    });
  }

  String? _requiredText(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Requerido' : null;

  String? _requiredEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return 'Requerido';
    final ok = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
    return ok ? null : 'Correo inválido';
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    if (_documentTypeId == null ||
        _personTypeCode == null ||
        _vatRegimeCode == null ||
        _fiscalRespCode == null ||
        _selectedMunicipality == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Completa todos los campos obligatorios'),
        ),
      );
      return;
    }

    final observations = _observationsCtrl.text.trim();

    final payload = ThirdPartyPayload(
      typeThird: 'CLIENTE',
      foreign: _foreign,
      freeZone: _freeZone,
      zomac: _zomac,
      identificationNumber: _identificationCtrl.text.trim(),
      documentTypeId: _documentTypeId!,
      verificationDigit: _verificationCtrl.text.trim().isEmpty
          ? null
          : _verificationCtrl.text.trim(),
      personTypeCode: _personTypeCode,
      companyName: _isNatural ? '' : _companyNameCtrl.text.trim(),
      firstName: _isNatural ? _firstNameCtrl.text.trim() : '',
      middleName: _isNatural ? _middleNameCtrl.text.trim() : '',
      lastName: _isNatural ? _lastNameCtrl.text.trim() : '',
      secondLastName: _isNatural ? _secondLastNameCtrl.text.trim() : '',
      contactPerson: _contactPersonCtrl.text.trim(),
      observations:
          observations.isEmpty ? 'sin observaciones' : observations,
      municipalityId: _selectedMunicipality!.id,
      countryId: null,
      address: _addressCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone1: _phone1Ctrl.text.trim(),
      phone2: _phone2Ctrl.text.trim(),
      vatRegimeCode: _vatRegimeCode,
      fiscalRespCode: _fiscalRespCode,
    );

    setState(() => _submitting = true);
    final created = await context.read<ThirdPartyStore>().create(payload);
    if (!mounted) return;
    setState(() => _submitting = false);

    if (created == null) {
      final error = context.read<ThirdPartyStore>().error;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error ?? 'No se pudo crear el cliente')),
      );
      return;
    }

    widget.onCreated(created);
  }

  @override
  Widget build(BuildContext context) {
    final common = context.watch<CommonStore>();

    if (common.isLoading && !common.loaded) {
      return const Center(child: CircularProgressIndicator());
    }

    if (common.error != null && !common.loaded) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(common.error!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              AppButton(
                label: 'Reintentar',
                icon: Icons.refresh_rounded,
                onPressed: () => context.read<CommonStore>().loadAll(),
              ),
            ],
          ),
        ),
      );
    }

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        children: [
          _FormSection(
            title: 'Identificación',
            children: [
              DropdownButtonFormField<String>(
                value: _personTypeCode,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Tipo de persona *',
                ),
                items: common.personTypes
                    .map(
                      (p) => DropdownMenuItem(
                        value: p.code,
                        child: Text(
                          p.type,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _personTypeCode = v),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              DropdownButtonFormField<int>(
                value: _documentTypeId,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Tipo de documento *',
                ),
                items: common.documentTypes
                    .map(
                      (d) => DropdownMenuItem(
                        value: d.id,
                        child: Text(
                          d.type,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _documentTypeId = v),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      controller: _identificationCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'N° identificación *',
                      ),
                      onChanged: _onIdentificationChanged,
                      validator: _requiredText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _verificationCtrl,
                      readOnly: true,
                      maxLength: 1,
                      decoration: const InputDecoration(
                        labelText: 'DV',
                        counterText: '',
                        helperText: 'Auto',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _FormSection(
            title: _isNatural ? 'Nombres' : 'Empresa',
            children: [
              if (_isNatural) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _firstNameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Primer nombre *',
                        ),
                        validator: _requiredText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _middleNameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Segundo nombre',
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _lastNameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Primer apellido *',
                        ),
                        validator: _requiredText,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        controller: _secondLastNameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Segundo apellido',
                        ),
                      ),
                    ),
                  ],
                ),
              ] else
                TextFormField(
                  controller: _companyNameCtrl,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(
                    labelText: 'Razón social *',
                  ),
                  validator: _requiredText,
                ),
            ],
          ),
          _FormSection(
            title: 'Contacto',
            children: [
              TextFormField(
                controller: _contactPersonCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Persona de contacto *',
                ),
                validator: _requiredText,
              ),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo *'),
                validator: _requiredEmail,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phone1Ctrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Teléfono 1 *',
                      ),
                      validator: _requiredText,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _phone2Ctrl,
                      keyboardType: TextInputType.phone,
                      decoration:
                          const InputDecoration(labelText: 'Teléfono 2'),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _FormSection(
            title: 'Ubicación',
            children: [
              TextFormField(
                controller: _addressCtrl,
                decoration: const InputDecoration(labelText: 'Dirección *'),
                validator: _requiredText,
              ),
              _MunicipalitySearch(
                controller: _municipalitySearchCtrl,
                common: common,
                selected: _selectedMunicipality,
                onChanged: _onMunicipalitySearch,
                onClear: () {
                  _municipalitySearchCtrl.clear();
                  setState(() => _selectedMunicipality = null);
                  context.read<CommonStore>().selectMunicipality(null);
                  context.read<CommonStore>().searchMunicipalities('');
                },
                onSelect: (item) {
                  setState(() {
                    _selectedMunicipality = item;
                    _municipalitySearchCtrl.text = item.label;
                  });
                  context.read<CommonStore>().selectMunicipality(item);
                },
              ),
            ],
          ),
          _FormSection(
            title: 'Datos tributarios',
            children: [
              DropdownButtonFormField<String>(
                value: _vatRegimeCode,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Régimen especial *',
                ),
                items: common.regimesIva
                    .map(
                      (r) => DropdownMenuItem(
                        value: r.code,
                        child: Text(
                          r.regime,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _vatRegimeCode = v),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              DropdownButtonFormField<String>(
                value: _fiscalRespCode,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Responsabilidad tributaria / fiscal *',
                ),
                items: common.fiscalResponsibilities
                    .map(
                      (f) => DropdownMenuItem(
                        value: f.code,
                        child: Text(
                          f.responsibility,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => _fiscalRespCode = v),
                validator: (v) => v == null ? 'Requerido' : null,
              ),
              TextFormField(
                controller: _observationsCtrl,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Observaciones',
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
          _FormSection(
            title: 'Condiciones',
            children: [
              _FlagTile(
                label: 'Extranjero *',
                value: _foreign,
                onChanged: (v) => setState(() => _foreign = v),
              ),
              _FlagTile(
                label: 'Zona franca',
                value: _freeZone,
                onChanged: (v) => setState(() => _freeZone = v),
              ),
              _FlagTile(
                label: 'ZOMAC',
                value: _zomac,
                onChanged: (v) => setState(() => _zomac = v),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AppButton(
            label: _submitting ? 'Guardando…' : 'Guardar y continuar',
            icon: Icons.check_rounded,
            onPressed: _submitting ? null : _submit,
          ),
        ],
      ),
    );
  }
}

class _FormSection extends StatelessWidget {
  const _FormSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: AppTextStyles.h3.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 20, color: AppColors.border),
          ..._withGaps(children, 16),
        ],
      ),
    );
  }

  List<Widget> _withGaps(List<Widget> items, double gap) {
    if (items.isEmpty) return const [];
    final out = <Widget>[items.first];
    for (var i = 1; i < items.length; i++) {
      out.add(SizedBox(height: gap));
      out.add(items[i]);
    }
    return out;
  }
}

class _FlagTile extends StatelessWidget {
  const _FlagTile({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12),
      tileColor: AppColors.surfaceAlt,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(label, style: AppTextStyles.label),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _MunicipalitySearch extends StatelessWidget {
  const _MunicipalitySearch({
    required this.controller,
    required this.common,
    required this.selected,
    required this.onChanged,
    required this.onClear,
    required this.onSelect,
  });

  final TextEditingController controller;
  final CommonStore common;
  final Municipality? selected;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;
  final ValueChanged<Municipality> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          textCapitalization: TextCapitalization.characters,
          decoration: InputDecoration(
            labelText: 'Municipio *',
            hintText: 'Escribe al menos 2 letras…',
            helperText: selected == null
                ? 'Se buscan municipios mientras escribes'
                : 'Seleccionado: ${selected!.label}',
            suffixIcon: common.isLoadingMunicipalities
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    tooltip: 'Limpiar',
                    onPressed: onClear,
                    icon: const Icon(Icons.clear_rounded),
                  ),
          ),
          onChanged: onChanged,
          validator: (_) =>
              selected == null ? 'Selecciona un municipio' : null,
        ),
        if (common.municipalityError != null) ...[
          const SizedBox(height: 8),
          Text(
            common.municipalityError!,
            style: AppTextStyles.bodySmall.copyWith(color: AppColors.danger),
          ),
        ],
        if (common.municipalities.isNotEmpty) ...[
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 180),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: common.municipalities.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, color: AppColors.border),
                  itemBuilder: (context, index) {
                    final item = common.municipalities[index];
                    final isSelected = selected?.id == item.id;
                    return ListTile(
                      dense: true,
                      selected: isSelected,
                      tileColor: AppColors.surface,
                      selectedTileColor: AppColors.primaryLight,
                      title: Text(
                        item.nombre,
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text(
                        item.departamento,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded, size: 18)
                          : null,
                      onTap: () => onSelect(item),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
