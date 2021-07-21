import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class FlutterTextField extends StatefulWidget {
  const FlutterTextField({
    this.autoFocus = false,
    this.enabled = true,
    this.hintText = '',
    this.labelText = '',
    this.password = false,
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode,
    this.controller,
    this.focusNode,
    this.icon,
    this.inputFormatters,
    this.keyboardType,
    this.maxLength,
    this.nextFocus,
    this.onChanged,
    this.validator,
    this.onFieldSubmitted,
    this.initialText,
  });

  FlutterTextField.codigoValidacao({
    this.autoFocus = false,
    this.enabled = true,
    this.hintText = '',
    this.labelText = '',
    this.password = false,
    this.textInputAction = TextInputAction.next,
    this.controller,
    this.focusNode,
    this.icon,
    this.maxLength,
    this.autovalidateMode,
    this.nextFocus,
    this.onChanged,
    this.onFieldSubmitted,
    this.initialText,
  })  : inputFormatters = [
          FilteringTextInputFormatter.allow(RegExp('[0-9-]')),
        ],
        keyboardType = TextInputType.number,
        validator = FlutterTextFieldCore.validarCodigo;

  FlutterTextField.cpfCnpj({
    required FlutterTextEditingController this.controller,
    this.enabled = true,
    this.autoFocus = false,
    this.hintText = '',
    this.labelText = '',
    bool onlyCpf = false,
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode,
    this.focusNode,
    this.icon,
    this.nextFocus,
    this.onChanged,
    bool required = false,
    String? Function(String?)? validator,
    String? initialText,
    this.onFieldSubmitted,
  })  : validator = ((texto) => FlutterTextFieldCore.validarCpfCnpj(texto: texto, onlyCpf: onlyCpf, validator: validator, required: required)),
        password = false,
        initialText = FlutterTextFieldCore.numberMask(initialText, (tamanho) => tamanho > 11 && !onlyCpf ? '00.000.000/0000-00' : '000.000.000-00'),
        keyboardType = TextInputType.number,
        maxLength = null,
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.selection.baseOffset == 0) {
              return newValue;
            }
            if (newValue.selection.baseOffset > 14) {
              return oldValue;
            }
            controller.unmaskedText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
            final newText = FlutterTextFieldCore.numberMask(newValue.text, (tamanho) => tamanho > 11 && !onlyCpf ? '00.000.000/0000-00' : '000.000.000-00');
            controller.unmaskedText = newText.replaceAll(RegExp('[^0-9]'), '');
            return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
          })
        ] {
    (controller as FlutterTextEditingController?)?.unmaskedText = initialText != null ? initialText.replaceAll(RegExp('[^0-9]'), '') : '';
  }

  FlutterTextField.telefone({
    required FlutterTextEditingController this.controller,
    this.autoFocus = false,
    this.enabled = true,
    this.hintText = '',
    this.labelText = '',
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode,
    this.focusNode,
    this.icon,
    this.nextFocus,
    this.onChanged,
    bool required = false,
    FormFieldValidator<String>? validator,
    String? initialText,
    this.onFieldSubmitted,
  })  : validator = ((texto) => FlutterTextFieldCore.validarTelefone(texto: texto, validator: validator, required: required)),
        password = false,
        keyboardType = TextInputType.number,
        maxLength = null,
        initialText = FlutterTextFieldCore.numberMask(initialText, (tamanho) => tamanho > 10 ? '(00) 00000-0000' : '(00) 0000-0000'),
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.selection.baseOffset == 0) {
              return newValue;
            }
            if (newValue.selection.baseOffset > 14) {
              return oldValue;
            }
            controller.unmaskedText = newValue.text.replaceAll(RegExp('[^0-9]'), '');
            final newText = FlutterTextFieldCore.numberMask(newValue.text, (tamanho) => tamanho > 10 ? '(00) 00000-0000' : '(00) 0000-0000');
            return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
          })
        ] {
    (controller as FlutterTextEditingController?)?.unmaskedText = initialText != null ? initialText.replaceAll(RegExp('[^0-9]'), '') : '';
  }

  FlutterTextField.numero({
    this.autoFocus = false,
    this.enabled = true,
    this.hintText = '',
    this.labelText = '',
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode,
    this.controller,
    this.icon,
    this.focusNode,
    int? max,
    int? min,
    this.nextFocus,
    this.onChanged,
    bool required = false,
    FormFieldValidator<String>? validator,
    this.onFieldSubmitted,
    this.initialText,
  })  : validator = ((texto) => FlutterTextFieldCore.validarNumero(texto: texto, min: min, max: max, validator: validator, required: required)),
        password = false,
        keyboardType = TextInputType.number,
        maxLength = null,
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
        ];

  FlutterTextField.moeda({
    required FlutterTextEditingController this.controller,
    this.autoFocus = false,
    this.enabled = true,
    this.hintText = '',
    this.labelText = '',
    this.textInputAction = TextInputAction.next,
    this.autovalidateMode,
    this.icon,
    this.focusNode,
    int? max,
    int? min,
    this.nextFocus,
    this.onChanged,
    num? initialText,
    bool required = false,
    Function(double)? onValueChanged,
    FormFieldValidator<String>? validator,
    this.onFieldSubmitted,
  })  : validator = ((texto) => FlutterTextFieldCore.validarMoeda(texto: texto, min: min, max: max, validator: validator, required: required)),
        password = false,
        initialText = initialText != null ? NumberFormat('#,##0.00', 'pt_BR').format(initialText) : '',
        keyboardType = TextInputType.number,
        maxLength = null,
        inputFormatters = [
          FilteringTextInputFormatter.digitsOnly,
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.selection.baseOffset == 0) {
              return newValue;
            }
            final value = double.parse(newValue.text) / 100;
            if (onValueChanged != null) {
              onValueChanged(value);
            }
            controller.unmaskedText = value.toString();
            final formatter = NumberFormat('#,##0.00', 'pt_BR');
            final newText = 'R\$ ${formatter.format(value)}';
            return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
          })
        ];

  FlutterTextField.senha({
    this.autoFocus = false,
    this.enabled = true,
    this.hintText = '',
    this.labelText = '',
    this.autovalidateMode,
    this.controller,
    this.icon,
    this.focusNode,
    int? minLength,
    this.nextFocus,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    bool required = false,
    FormFieldValidator<String>? validator,
    this.onFieldSubmitted,
    this.initialText,
  })  : validator = ((texto) => FlutterTextFieldCore.validarSenha(
              texto: texto,
              minLength: minLength,
              validator: validator,
              required: required,
            )),
        password = true,
        keyboardType = null,
        maxLength = null,
        inputFormatters = [];

  FlutterTextField.email({
    this.autoFocus = false,
    this.enabled = true,
    this.hintText = '',
    this.labelText = '',
    this.autovalidateMode,
    this.controller,
    this.icon,
    this.focusNode,
    this.nextFocus,
    this.onChanged,
    this.textInputAction = TextInputAction.next,
    bool required = false,
    FormFieldValidator<String>? validator,
    this.onFieldSubmitted,
    this.initialText,
  })  : validator = ((texto) => FlutterTextFieldCore.validarEmail(texto: texto, validator: validator, required: required)),
        password = false,
        keyboardType = TextInputType.emailAddress,
        maxLength = null,
        inputFormatters = [];

  final bool autoFocus;
  final String labelText;
  final String hintText;
  final bool password;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final List<TextInputFormatter>? inputFormatters;
  final bool enabled;
  final int? maxLength;
  final Function(String?)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final Icon? icon;
  final Function(String)? onFieldSubmitted;
  final String? initialText;

  @override
  _FlutterTextFieldState createState() => _FlutterTextFieldState();
}

class _FlutterTextFieldState extends State<FlutterTextField> {
  final visivelNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    // TODO: implement initState
    if (widget.initialText != null) {
      widget.controller?.text = widget.initialText!;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: visivelNotifier,
        builder: (context, visivel, _) {
          return TextFormField(
            onChanged: widget.onChanged,
            autovalidateMode: widget.autovalidateMode,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            inputFormatters: widget.inputFormatters,
            autofocus: widget.autoFocus,
            controller: widget.controller,
            obscureText: widget.password && !visivel,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            focusNode: widget.focusNode,
            onFieldSubmitted: (String text) {
              if (widget.nextFocus != null) {
                FocusScope.of(context).requestFocus(widget.nextFocus);
              }
              if (widget.onFieldSubmitted != null) {
                widget.onFieldSubmitted!(text);
              }
            },
            decoration: InputDecoration(
              prefixIcon: widget.icon,
              suffixIcon: widget.password
                  ? InkWell(
                      onTap: () => visivelNotifier.value = !visivel,
                      borderRadius: BorderRadius.circular(50),
                      child: Icon(visivel ? Icons.visibility_off : Icons.visibility),
                    )
                  : null,
              labelText: widget.labelText,
              hintText: widget.hintText,
            ),
          );
        });
  }
}

class FlutterTextFieldCore {
  static String? validarCodigo(String? texto) {
    if (texto != null) {
      if (texto.isEmpty) {
        return 'Código obrigatório.';
      }
      final partes = texto.split('-');
      if (partes.length == 2) {
        if (partes[1].isEmpty) {
          return 'Digite a segunda parte do código.';
        }
        return null;
      } else {
        return 'Código com formato inválido.';
      }
    }
    return 'Campo obrigatório.';
  }

  static String? validarEmail({String? texto, String? Function(String?)? validator, bool? required}) {
    if (required == true) {
      if (texto == null || texto.isEmpty) {
        return 'Esse campo é obrigatório.';
      }
    }
    if (texto != null) {
      if (!EmailValidator.validate(texto)) {
        return '$texto tem o formato de email inválido.';
      }
    }
    if (validator != null) {
      return validator(texto);
    }
    return null;
  }

  static String? validarSenha({String? texto, int? minLength, String? Function(String?)? validator, bool? required}) {
    if (required == true) {
      if (texto == null || texto.isEmpty) {
        return 'Esse campo é obrigatório.';
      }
    }
    if (texto != null && minLength != null && texto.isNotEmpty) {
      if (texto.length < minLength) {
        return 'Deve ter pelo menos $minLength caracteres.';
      }
    }
    if (validator != null) {
      return validator(texto);
    }
    return null;
  }

  static String? validarNumero({String? texto, int? min, int? max, String? Function(String?)? validator, bool? required}) {
    if (required == true) {
      if (texto == null || texto.isEmpty) {
        return 'Esse campo é obrigatório.';
      }
    }
    if (texto != null && texto != '') {
      final numero = num.parse(texto.replaceAll(RegExp('[^0-9]'), ''));
      if (min != null && max != null) {
        if (numero >= min && numero <= max) {
          if (validator != null) {
            return validator(texto);
          }
          return null;
        }
        return 'Deve ser entre $min e $max.';
      }
      if (min != null) {
        if (numero >= min) {
          if (validator != null) {
            return validator(texto);
          }
          return null;
        }
        return 'Deve ser maior ou igual a $min.';
      }
      if (max != null) {
        if (numero <= max) {
          if (validator != null) {
            return validator(texto);
          }
          return null;
        }
        return 'Deve ser menor ou igual a $max.';
      }
    }
    if (validator != null) {
      return validator(texto);
    }
    return null;
  }

  static String? validarMoeda({String? texto, int? min, int? max, String? Function(String?)? validator, bool? required}) {
    if (required == true) {
      if (texto == null || texto.isEmpty) {
        return 'Esse campo é obrigatório.';
      }
    }
    if (texto != null && texto != '') {
      final numero = num.parse(texto.replaceAll(RegExp('[^0-9]'), ''));
      if (min != null && max != null) {
        if (numero >= min && numero <= max) {
          if (validator != null) {
            return validator(texto);
          }
          return null;
        }
        return 'Deve ser entre R\$ $min e R\$ $max.';
      }
      if (min != null) {
        if (numero >= min) {
          if (validator != null) {
            return validator(texto);
          }
          return null;
        }
        return 'Deve ser maior ou igual a R\$ $min.';
      }
      if (max != null) {
        if (numero <= max) {
          if (validator != null) {
            return validator(texto);
          }
          return null;
        }
        return 'Deve ser menor ou igual a R\$ $max.';
      }
    }
    if (validator != null) {
      return validator(texto);
    }
    return null;
  }

  static String? validarTelefone({String? texto, String? Function(String?)? validator, bool? required}) {
    if (required == true) {
      if (texto == null || texto.isEmpty) {
        return 'Esse campo é obrigatório.';
      }
    }
    if (texto != null && texto.isNotEmpty) {
      //sobrescreve todos os caracteres não numéricos
      final telefoneDigitos = texto.replaceAll(RegExp('[^0-9]'), '');
      if (telefoneDigitos.length == 10 || telefoneDigitos.length == 11) {
        if (validator != null) {
          return validator(texto);
        }
        return null;
      }
      return 'Deve ter exatamente 10 ou 11 dígitos';
    }
    if (validator != null) {
      return validator(texto);
    }
    return null;
  }

  static String? validarCpfCnpj({String? texto, required bool onlyCpf, String? Function(String?)? validator, bool? required}) {
    if (required == true) {
      if (texto == null || texto.isEmpty) {
        return 'Esse campo é obrigatório.';
      }
    }
    if (texto != null && texto.isNotEmpty) {
      //sobrescreve todos os caracteres não numéricos
      final cpfCnpjDigitos = texto.replaceAll(RegExp('[^0-9]'), '');
      //se o tamanho é 11, valida como CPF
      if (cpfCnpjDigitos.length == 11) {
        if (!validarCpf(cpfCnpjDigitos)) {
          return 'CPF inválido!';
        }
        if (validator != null) {
          return validator(texto);
        }
        return null;
      }
      //se o tamanho é 14, valida como CNPJ
      if (cpfCnpjDigitos.length == 14) {
        if (!validarCnpj(cpfCnpjDigitos)) {
          return 'CNPJ inválido!';
        }
        if (validator != null) {
          return validator(texto);
        }
        return null;
      }
      return onlyCpf == true ? 'Deve ter exatamente 11 dígitos' : 'Deve ter exatamente 11 ou 14 dígitos';
    }
    if (validator != null) {
      return validator(texto);
    }
    return null;
  }

  static bool validarCpf(String? cpf) {
    var soma = 0;
    var peso = 10;
    int resto;
    int dv1;
    int dv2;
    if (cpf == null) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cpf)) return false;
    //valida o primeiro dígito
    for (var i = 0; i < 9; i++) {
      soma += int.parse(cpf.substring(i, i + 1)) * peso;
      peso--;
    }
    resto = 11 - (soma % 11);
    dv1 = (resto == 10 || resto == 11) ? 0 : resto;
    //valida o segundo digito
    soma = 0;
    peso = 11;
    for (var i = 0; i < 10; i++) {
      soma += int.parse(cpf.substring(i, i + 1)) * peso;
      peso--;
    }
    resto = 11 - (soma % 11);
    dv2 = (resto == 10 || resto == 11) ? 0 : resto;
    return dv1 == int.parse(cpf.substring(9, 10)) && dv2 == int.parse(cpf.substring(10, 11));
  }

  static bool validarCnpj(String? cnpj) {
    var soma = 0;
    var peso = 5;
    int resto;
    int dv1;
    int dv2;

    if (cnpj == null) return false;
    if (RegExp(r'^(\d)\1*$').hasMatch(cnpj)) return false;
    for (var i = 0; i < 12; i++) {
      soma += int.parse(cnpj.substring(i, i + 1)) * peso;
      peso--;
      if (peso < 2) {
        peso = 9;
      }
    }
    resto = soma % 11;
    dv1 = (resto < 2) ? 0 : 11 - resto;
    soma = 0;
    peso = 6;
    for (var i = 0; i < 13; i++) {
      soma += int.parse(cnpj.substring(i, i + 1)) * peso;
      peso--;
      if (peso < 2) {
        peso = 9;
      }
    }
    resto = soma % 11;
    dv2 = (resto < 2) ? 0 : 11 - resto;
    return dv1 == int.parse(cnpj.substring(12, 13)) && dv2 == int.parse(cnpj.substring(13, 14));
  }

  static String numberMask(String? texto, String Function(int tamanho) mask) {
    if (texto != null) {
      final somenteDigitos = texto.replaceAll(RegExp('[^0-9]'), '');
      final mascara = mask(somenteDigitos.length);
      var textoMascarado = '';
      var counter = 0;
      for (var i = 0; i < mascara.length; i++) {
        final character = mascara[i];
        if (character == '0') {
          if (counter < somenteDigitos.length) {
            textoMascarado = textoMascarado + somenteDigitos[counter];
            counter++;
          } else {
            break;
          }
        } else {
          if (counter < somenteDigitos.length) {
            textoMascarado = textoMascarado + character;
          }
        }
      }
      return textoMascarado;
    }
    return '';
  }
}

class FlutterTextEditingController extends TextEditingController {
  String unmaskedText = '';
}

class CustomDateField extends StatefulWidget {
  CustomDateField({
    Key? key,
    required DateTime initialDate,
    required DateTime firstDate,
    required DateTime lastDate,
    required this.controller,
    this.onDateSubmitted,
    this.errorFormatText,
    this.autofocus = false,
    this.autoFocus = false,
    this.labelText,
    this.hintText,
    this.validator,
    this.textInputAction,
    this.focusNode,
    this.nextFocus,
    this.enabled = true,
    this.onChanged,
    this.autovalidateMode,
    this.icon,
  })  : initialDate = DateUtils.dateOnly(initialDate),
        firstDate = DateUtils.dateOnly(firstDate),
        lastDate = DateUtils.dateOnly(lastDate),
        super(key: key) {
    assert(
      !this.lastDate.isBefore(this.firstDate),
      'lastDate ${this.lastDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isBefore(this.firstDate),
      'initialDate ${this.initialDate} must be on or after firstDate ${this.firstDate}.',
    );
    assert(
      !this.initialDate.isAfter(this.lastDate),
      'initialDate ${this.initialDate} must be on or before lastDate ${this.lastDate}.',
    );
  }

  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;
  final ValueChanged<DateTime>? onDateSubmitted;
  final String? errorFormatText;
  final bool autofocus;
  final bool autoFocus;
  final String? labelText;
  final String? hintText;
  final FlutterTextEditingController controller;
  final FormFieldValidator<String>? validator;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final FocusNode? nextFocus;
  final bool enabled;
  final Function(DateTime?)? onChanged;
  final AutovalidateMode? autovalidateMode;
  final Icon? icon;

  @override
  _CustomDateFieldState createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  DateTime? _selectedDate;
  String? _inputText;
  bool _autoSelected = false;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateValueForSelectedDate();
  }

  @override
  void didUpdateWidget(CustomDateField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      // Can't update the form field in the middle of a build, so do it next frame
      WidgetsBinding.instance!.addPostFrameCallback((Duration timeStamp) {
        setState(() {
          _selectedDate = widget.initialDate;
          _updateValueForSelectedDate();
        });
      });
    }
  }

  void _updateValueForSelectedDate() {
    if (_selectedDate != null) {
      final MaterialLocalizations localizations = MaterialLocalizations.of(context);
      _inputText = localizations.formatCompactDate(_selectedDate!);
      TextEditingValue textEditingValue = widget.controller.value.copyWith(text: _inputText);
      // Select the new text if we are auto focused and haven't selected the text before.
      if (widget.autofocus && !_autoSelected) {
        textEditingValue = textEditingValue.copyWith(
            selection: TextSelection(
          baseOffset: 0,
          extentOffset: _inputText!.length,
        ));
        _autoSelected = true;
      }
      widget.controller.value = textEditingValue;
      if (_isValidAcceptableDate(_selectedDate)) {
        widget.controller.unmaskedText = _selectedDate.toString();
        if (widget.onChanged != null) {
          widget.onChanged!(_selectedDate);
        }
      }
    } else {
      _inputText = '';
      widget.controller.value = widget.controller.value.copyWith(text: _inputText);
    }
  }

  DateTime? _parseDate(String? text) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    return localizations.parseCompactDate(text);
  }

  bool _isValidAcceptableDate(DateTime? date) {
    return date != null && !date.isBefore(widget.firstDate) && !date.isAfter(widget.lastDate);
  }

  String? _validateDate(String? text) {
    final DateTime? date = _parseDate(text);
    if (date == null) {
      return widget.errorFormatText ?? MaterialLocalizations.of(context).invalidDateFormatLabel;
    } else if (!_isValidAcceptableDate(date)) {
      return MaterialLocalizations.of(context).dateOutOfRangeLabel;
    }
    return null;
  }

  void _updateDate(String? text, ValueChanged<DateTime>? callback) {
    final DateTime? date = _parseDate(text);
    if (_isValidAcceptableDate(date)) {
      _selectedDate = date;
      _inputText = text;
      callback?.call(_selectedDate!);
    }
  }

  void _handleSubmitted(String text) {
    _updateDate(text, widget.onDateSubmitted);
    if (widget.nextFocus != null) {
      FocusScope.of(context).requestFocus(widget.nextFocus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final MaterialLocalizations localizations = MaterialLocalizations.of(context);
    final InputDecorationTheme inputTheme = Theme.of(context).inputDecorationTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: inputTheme.filled,
            hintText: widget.hintText ?? localizations.dateHelpText,
            prefixIcon: widget.icon,
            labelText: widget.labelText ?? localizations.dateInputLabel,
            suffixIcon: InkWell(
              onTap: () async {
                final data = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? widget.initialDate,
                  firstDate: widget.firstDate,
                  lastDate: widget.lastDate,
                );
                if (data != null) {
                  setState(() {
                    _selectedDate = data;
                    _updateValueForSelectedDate();
                  });
                }
              },
              borderRadius: BorderRadius.circular(50),
              child: const Icon(Icons.date_range),
            )),
        inputFormatters: [
          TextInputFormatter.withFunction((oldValue, newValue) {
            if (newValue.selection.baseOffset == 0) {
              return newValue;
            }
            final DateTime? date = _parseDate(newValue.text);
            if (_isValidAcceptableDate(date)) {
              setState(() {
                _selectedDate = date;
              });
              widget.controller.unmaskedText = _selectedDate.toString();
              if (widget.onChanged != null) {
                widget.onChanged!(_selectedDate);
              }
            }
            final newText = _numberMask(newValue.text, (tamanho) => '00/00/0000');
            return newValue.copyWith(text: newText, selection: TextSelection.collapsed(offset: newText.length));
          }),
        ],
        validator: _validateDate,
        keyboardType: TextInputType.datetime,
        onFieldSubmitted: _handleSubmitted,
        autofocus: widget.autofocus,
        controller: widget.controller,
        autovalidateMode: widget.autovalidateMode,
        enabled: widget.enabled,
        textInputAction: widget.textInputAction,
        focusNode: widget.focusNode,
        style: const TextStyle(
          fontSize: 22,
        ),
      ),
    );
  }

  static String _numberMask(String? texto, String Function(int tamanho) mask) {
    if (texto != null) {
      final somenteDigitos = texto.replaceAll(RegExp('[^0-9]'), '');
      final mascara = mask(somenteDigitos.length);
      var textoMascarado = '';
      var counter = 0;
      for (var i = 0; i < mascara.length; i++) {
        final character = mascara[i];
        if (character == '0') {
          if (counter < somenteDigitos.length) {
            textoMascarado = textoMascarado + somenteDigitos[counter];
            counter++;
          } else {
            break;
          }
        } else {
          if (counter < somenteDigitos.length) {
            textoMascarado = textoMascarado + character;
          }
        }
      }
      return textoMascarado;
    }
    return '';
  }
}
