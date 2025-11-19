import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icongrega/theme/app_colors.dart';
import 'package:icongrega/ui/widgets/modals/donation_error_modal.dart';
import 'package:icongrega/ui/widgets/modals/donation_success_modal.dart';
import 'package:image_picker/image_picker.dart';

void showOverlayMessage(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  final entry = OverlayEntry(
    builder: (context) => Positioned(
      top: MediaQuery.of(context).size.height * 0.36,
      left: MediaQuery.of(context).size.width * 0.32,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.green[600],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message, style: const TextStyle(color: Colors.white)),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future.delayed(const Duration(seconds: 2), () => entry.remove());
}

// disenho items de iCoins
Widget _icoins({
  required String icoins,
  bool active = false,
  VoidCallback? onTap,
  required BuildContext context,
}) {
  return Container(
    decoration: BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: const Color.fromARGB(10, 0, 0, 0),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      borderRadius: BorderRadius.circular(20),
    ),
    child: TextButton.icon(
      onPressed: onTap,
      icon: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage('assets/icons/logo-amarillo-blanco.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
      label: Padding(
        padding: const EdgeInsets.only(right: 10),
        child: Text(
          icoins,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.background,
          ),
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: active
            ? AppColors.primaryLight
            : Theme.of(context).colorScheme.surface,
        side: BorderSide(color: AppColors.primaryLight),
        padding: EdgeInsets.symmetric(horizontal: 4),
      ),
    ),
  );
}

class DonacionBottomSheet extends StatefulWidget {
  const DonacionBottomSheet({super.key});

  @override
  State<DonacionBottomSheet> createState() => _DonacionBottomSheetState();
}

class _DonacionBottomSheetState extends State<DonacionBottomSheet> {
  int step = 0; // 0 = petición, 1 = pago, 2 = confirmación
  String _selectedIcoins = "10";

  @override
  Widget build(BuildContext context) {
    return AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 36,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
            child: _buildStep(),
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (step) {
      case 0:
        return _PeticionStep(
          onNext: (icoins) {
            setState(() {
              _selectedIcoins = icoins;
              step = 1;
            });
          },
        );
      case 1:
        return _PagoStep(
          monto: _selectedIcoins,
          onNext: () => setState(() => step = 2),
        );
      case 2:
        return _ConfirmacionStep(
          monto: _selectedIcoins,
          onFinish: () => Navigator.pop(context),
        );
      default:
        return const SizedBox();
    }
  }
}

// Paso 1 - Petición
class _PeticionStep extends StatefulWidget {
  final ValueChanged<String> onNext;
  const _PeticionStep({required this.onNext});

  @override
  State<_PeticionStep> createState() => _PeticionStepState();
}

class _PeticionStepState extends State<_PeticionStep> {
  String? _selectedIcoins;
  bool _showCustom = false;
  final TextEditingController _customController = TextEditingController();

  final List<String> _opciones = [
    '10',
    '15',
    '20',
    '30',
    '50',
    '70',
    '100',
    '120',
    '200',
  ];

  @override
  Widget build(BuildContext context) {
    bool _isValidSelection() {
      if (_showCustom) {
        final v = int.tryParse(_customController.text.trim());
        return v != null && v > 0;
      }
      return _selectedIcoins != null;
    }

    return Column(
      key: const ValueKey("peticion"),
      children: [
        Text(
          "Haz una Donación",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 20),

        // Opciones de icoins
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 10,
            children: _opciones.map((icoins) {
              return _icoins(
                icoins: icoins,
                active: !_showCustom && _selectedIcoins == icoins,
                context: context,
                onTap: () {
                  setState(() {
                    _selectedIcoins = icoins;
                    _showCustom = false;
                  });
                },
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 8),

        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _icoins(
                onTap: () {
                  setState(() {
                    _showCustom = true;
                    _selectedIcoins = 'custom';
                  });
                },
                icoins: 'Otra cantidad',
                active: _showCustom,
                context: context,
              ),
              if (_showCustom) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _customController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      hintText: 'Monto',
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ],
          ),
        ),

        Divider(color: Theme.of(context).colorScheme.shadow),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Deja una petición (opcional)',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Peticion
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            maxLines: 6,
            style: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 14),
            decoration: InputDecoration(
              hintText: "Escribe tu petición de oración aquí...",
              hintStyle: GoogleFonts.inter(
                letterSpacing: 0,
                color: AppColors.neutralMidDark,
                fontSize: 14,
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Botón continuar
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: _isValidSelection()
                ? () {
                    final value = _showCustom
                        ? _customController.text.trim()
                        : (_selectedIcoins ?? "0");
                    widget.onNext(value);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: Text(
              "Continuar",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _isValidSelection() ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Paso 2 - Pago
class _PagoStep extends StatefulWidget {
  final String monto;
  final VoidCallback onNext;
  const _PagoStep({required this.monto, required this.onNext});

  @override
  State<_PagoStep> createState() => _PagoStepState();
}

class _PagoStepState extends State<_PagoStep> {
  String _metodoSeleccionado = "Seleccionar método de pago";

  // Mapa con datos de cada método de pago
  final Map<String, List<Map<String, String>>> _metodosPago = {
    "Seleccionar método de pago": [],
    "Pago Movil": [
      {"etiqueta": "Nombre del banco", "valor": "Banco de Venezuel (0102)"},
      {"etiqueta": "Cédula o RIF", "valor": "V-27364738"},
      {"etiqueta": "Número de teléfono", "valor": "+58 414 1762736"},
    ],
    "Paypal": [
      {"etiqueta": "Cuenta Paypal", "valor": "paypaluser@ejemplo.com"},
    ],
  };

  Widget _campoTexto(String valor, String etiqueta) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(text: valor),
        decoration: InputDecoration(
          focusColor: AppColors.primaryLight,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          suffixIcon: IconButton(
            onPressed: () {
              // copiar valor en el portapapeles
              Clipboard.setData(ClipboardData(text: valor));

              // alerta de texto copiado
              showOverlayMessage(context, "Texto copiado");
            },
            icon: Icon(Icons.copy, color: AppColors.neutralMidDark),
          ),
          border: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black12),
          ),
          labelStyle: TextStyle(color: AppColors.neutralMidDark),
          labelText: etiqueta,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final campos = _metodosPago[_metodoSeleccionado] ?? [];
    final bool canContinue =
        _metodoSeleccionado != "Seleccionar método de pago";

    return Column(
      key: const ValueKey("pago"),
      children: [
        const SizedBox(height: 8),

        // Selector de método de pago
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: DropdownButtonFormField<String>(
            initialValue: _metodoSeleccionado,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: AppColors.neutralMidDark,
              ),
              focusColor: AppColors.primaryLight,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
            items: _metodosPago.keys.map((metodo) {
              return DropdownMenuItem(value: metodo, child: Text(metodo));
            }).toList(),
            onChanged: (value) {
              setState(() {
                _metodoSeleccionado = value!;
              });
            },
          ),
        ),

        const SizedBox(height: 8),

        // Campos dinámicos según el método
        ...campos.map(
          (campo) => _campoTexto(campo["valor"]!, campo["etiqueta"]!),
        ),

        const SizedBox(height: 16),

        // Campo de monto (común a todos)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 42),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 42),
            child: TextFormField(
              readOnly: true,
              initialValue: '\$ ${widget.monto},00',
              decoration: InputDecoration(
                focusColor: AppColors.primaryLight,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    // copiar texto
                    Clipboard.setData(
                      ClipboardData(text: '\$ ${widget.monto},00'),
                    );

                    // alerta de texto copiado
                    showOverlayMessage(context, "Texto copiado");
                  },
                  icon: Icon(Icons.copy, color: AppColors.neutralMidDark),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),
                ),
                labelStyle: TextStyle(color: AppColors.neutralMidDark),
                labelText: "Monto",
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // Botón principal
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: canContinue ? widget.onNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: Text(
              "Pago realizado",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: canContinue ? Colors.black : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Paso 3 - Confirmación
class _ConfirmacionStep extends StatefulWidget {
  final VoidCallback onFinish;
  final String monto;

  const _ConfirmacionStep({required this.onFinish, required this.monto});

  @override
  State<_ConfirmacionStep> createState() => _ConfirmacionStepState();
}

class _ConfirmacionStepState extends State<_ConfirmacionStep> {
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  File? _paymentProof;
  final TextEditingController _refController = TextEditingController();

  void _validarPago(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    // Simular un proceso de validación
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    widget.onFinish();

    bool esExitoso = Random().nextBool();

    // Mostrar modal
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Confirmación",
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, anim1, anim2) {
        return esExitoso ? DonationSuccessModal(monto: widget.monto, ref: _refController.text) : DonationErrorModal();
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return FadeTransition(
          opacity: anim1,
          child: ScaleTransition(scale: anim1, child: child),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey("confirmacion"),
      children: [
        Text(
          "Comprobante de pago",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),

        SizedBox(height: 16),

        Divider(color: Theme.of(context).colorScheme.shadow),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Número de referencia',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),

        SizedBox(height: 8),

        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: Theme.of(context).colorScheme.outline),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _refController,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              color: AppColors.neutralMidDark,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Theme.of(context).colorScheme.surfaceContainer,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              hintText: 'Número de referencia',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),

        SizedBox(height: 8),

        Divider(color: Theme.of(context).colorScheme.shadow),

        SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Adjuntar capture del pago',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
            ],
          ),
        ),

        SizedBox(height: 8),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            spacing: 8,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                  image: _paymentProof != null
                      ? DecorationImage(
                          image: FileImage(_paymentProof!),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.4),
                            BlendMode.darken,
                          ),
                        )
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.add_circle_outline,
                        color: _paymentProof != null
                            ? Colors.white
                            : AppColors.primaryLight,
                        size: 32,
                      ),
                      onPressed: () async {
                        final XFile? picked = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (picked != null) {
                          setState(() {
                            _paymentProof = File(picked.path);
                          });
                        }
                      },
                    ),
                    Text(
                      'Subir',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _paymentProof != null
                            ? Colors.white
                            : Theme.of(context).colorScheme.background,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      'Comprobante',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _paymentProof != null
                            ? Colors.white
                            : Theme.of(context).colorScheme.background,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Botón principal
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 0,
                offset: const Offset(0, 0),
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed:
                _isLoading ||
                    _paymentProof == null ||
                    _refController.text.trim().isEmpty
                ? null
                : () => _validarPago(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryLight,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 18),
            ),
            child: Text(
              "Validar pago",
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color:
                    _paymentProof == null ||
                        _refController.text.trim().isEmpty
                    ? Colors.white
                    : Colors.black87,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
