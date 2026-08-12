import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/utils/nit_verification_digit.dart';
import '../../../modules/third-party/domain/crear_cliente_payload_builder.dart';
import '../../../modules/third-party/domain/models/third_party.common.dart';
import '../../../modules/third-party/domain/models/third_party_models.dart';
import '../../../modules/third-party/store/common.store.dart';
import '../../../modules/third-party/store/thirdparty.store.dart';
import '../../atoms/app_button.dart';
import 'widgets/seccion_condiciones.dart';
import 'widgets/seccion_contacto.dart';
import 'widgets/seccion_identificacion.dart';
import 'widgets/seccion_nombres_empresa.dart';
import 'widgets/seccion_tributaria.dart';
import 'widgets/seccion_ubicacion.dart';

/// Formulario de la ventana Crear cliente (orquesta secciones).
class CrearClienteForm extends StatefulWidget {
  const CrearClienteForm({
    super.key,
    required this.onCreated,
  });

  final ValueChanged<ThirdParty> onCreated;

  @override
  State<CrearClienteForm> createState() => _CrearClienteFormState();
}

/// Alias legacy.
typedef CustomerCreateForm = CrearClienteForm;

class _CrearClienteFormState extends State<CrearClienteForm> {
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

    final payload = CrearClientePayloadBuilder.build(
      foreign: _foreign,
      freeZone: _freeZone,
      zomac: _zomac,
      identificationNumber: _identificationCtrl.text,
      documentTypeId: _documentTypeId!,
      verificationDigit: _verificationCtrl.text,
      personTypeCode: _personTypeCode,
      isNatural: _isNatural,
      companyName: _companyNameCtrl.text,
      firstName: _firstNameCtrl.text,
      middleName: _middleNameCtrl.text,
      lastName: _lastNameCtrl.text,
      secondLastName: _secondLastNameCtrl.text,
      contactPerson: _contactPersonCtrl.text,
      observations: _observationsCtrl.text,
      municipality: _selectedMunicipality!,
      address: _addressCtrl.text,
      email: _emailCtrl.text,
      phone1: _phone1Ctrl.text,
      phone2: _phone2Ctrl.text,
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
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(common.error!, textAlign: TextAlign.center),
              const SizedBox(height: AppSpacing.lg),
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
          SeccionIdentificacion(
            personTypes: common.personTypes,
            documentTypes: common.documentTypes,
            personTypeCode: _personTypeCode,
            documentTypeId: _documentTypeId,
            identificationCtrl: _identificationCtrl,
            verificationCtrl: _verificationCtrl,
            onPersonTypeChanged: (v) => setState(() => _personTypeCode = v),
            onDocumentTypeChanged: (v) => setState(() => _documentTypeId = v),
            onIdentificationChanged: _onIdentificationChanged,
            requiredText: _requiredText,
          ),
          SeccionNombresEmpresa(
            isNatural: _isNatural,
            companyNameCtrl: _companyNameCtrl,
            firstNameCtrl: _firstNameCtrl,
            middleNameCtrl: _middleNameCtrl,
            lastNameCtrl: _lastNameCtrl,
            secondLastNameCtrl: _secondLastNameCtrl,
            requiredText: _requiredText,
          ),
          SeccionContacto(
            contactPersonCtrl: _contactPersonCtrl,
            emailCtrl: _emailCtrl,
            phone1Ctrl: _phone1Ctrl,
            phone2Ctrl: _phone2Ctrl,
            requiredText: _requiredText,
            requiredEmail: _requiredEmail,
          ),
          SeccionUbicacion(
            addressCtrl: _addressCtrl,
            municipalitySearchCtrl: _municipalitySearchCtrl,
            common: common,
            selectedMunicipality: _selectedMunicipality,
            onMunicipalitySearch: _onMunicipalitySearch,
            onMunicipalityClear: () {
              _municipalitySearchCtrl.clear();
              setState(() => _selectedMunicipality = null);
              context.read<CommonStore>().selectMunicipality(null);
              context.read<CommonStore>().searchMunicipalities('');
            },
            onMunicipalitySelect: (item) {
              setState(() {
                _selectedMunicipality = item;
                _municipalitySearchCtrl.text = item.label;
              });
              context.read<CommonStore>().selectMunicipality(item);
            },
            requiredText: _requiredText,
          ),
          SeccionTributaria(
            regimesIva: common.regimesIva,
            fiscalResponsibilities: common.fiscalResponsibilities,
            vatRegimeCode: _vatRegimeCode,
            fiscalRespCode: _fiscalRespCode,
            observationsCtrl: _observationsCtrl,
            onVatRegimeChanged: (v) => setState(() => _vatRegimeCode = v),
            onFiscalRespChanged: (v) => setState(() => _fiscalRespCode = v),
          ),
          SeccionCondiciones(
            foreign: _foreign,
            freeZone: _freeZone,
            zomac: _zomac,
            onForeignChanged: (v) => setState(() => _foreign = v),
            onFreeZoneChanged: (v) => setState(() => _freeZone = v),
            onZomacChanged: (v) => setState(() => _zomac = v),
          ),
          const SizedBox(height: AppSpacing.sm),
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
