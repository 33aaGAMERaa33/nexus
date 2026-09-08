import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final MaskTextInputFormatter cpfMaskTextInputFormatter = MaskTextInputFormatter(
  mask: '###.###.###-##',
  filter: {"#": RegExp(r'[0-9]')},
);

final MaskTextInputFormatter cnpjMaskTextInputFormatrer = MaskTextInputFormatter(
  mask: '##.###.###/####-##',
  filter: {"#": RegExp(r'[0-9]')},
);

final MaskTextInputFormatter cepMaskTextInputFormatter = MaskTextInputFormatter(
  mask: '#####-###',
  filter: {"#": RegExp(r'[0-9]')},
);

class PhoneMaskFormatter extends TextInputFormatter {
  final MaskTextInputFormatter _mask = MaskTextInputFormatter(
    mask: '(##) ####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');

    if (digits.length <= 10) {
      _mask.updateMask(mask: '(##) ####-####');
    } else {
      _mask.updateMask(mask: '(##) #####-####');
    }

    return _mask.formatEditUpdate(oldValue, newValue);
  }
}