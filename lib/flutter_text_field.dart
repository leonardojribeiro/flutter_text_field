library flutter_text_field;

import 'package:email_validator/email_validator.dart';
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
    this.onChange,
    this.validator,
  });

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
    this.onChange,
    bool required = false,
    String? Function(String?)? validator,
  })  : validator = ((texto) => validarCpfCnpj(
            texto: texto,
            onlyCpf: onlyCpf,
            validator: validator,
            required: required)),
        password = false,
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
            controller.unmaskedText =
                newValue.text.replaceAll(RegExp('[^0-9]'), '');
            final newText = _numberMask(
                newValue.text,
                (tamanho) => tamanho > 11 && !onlyCpf
                    ? '00.000.000/0000-00'
                    : '000.000.000-00');
            return newValue.copyWith(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length));
          })
        ];

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
    this.onChange,
    bool required = false,
    FormFieldValidator<String>? validator,
  })  : validator = ((texto) => _validarTelefone(
            texto: texto, validator: validator, required: required)),
        password = false,
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
            controller.unmaskedText =
                newValue.text.replaceAll(RegExp('[^0-9]'), '');
            final newText = _numberMask(
                newValue.text,
                (tamanho) =>
                    tamanho > 10 ? '(00) 00000-0000' : '(00) 0000-0000');
            return newValue.copyWith(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length));
          })
        ];

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
    this.onChange,
    bool required = false,
    FormFieldValidator<String>? validator,
  })  : validator = ((texto) => _validarNumero(
            texto: texto,
            min: min,
            max: max,
            validator: validator,
            required: required)),
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
    this.onChange,
    bool required = false,
    Function(double)? onValueChanged,
    FormFieldValidator<String>? validator,
  })  : validator = ((texto) => _validarMoeda(
            texto: texto,
            min: min,
            max: max,
            validator: validator,
            required: required)),
        password = false,
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
            return newValue.copyWith(
                text: newText,
                selection: TextSelection.collapsed(offset: newText.length));
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
    this.onChange,
    this.textInputAction,
    bool required = false,
    FormFieldValidator<String>? validator,
  })  : validator = ((texto) => _validarSenha(
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
    this.onChange,
    this.textInputAction,
    bool required = false,
    FormFieldValidator<String>? validator,
  })  : validator = ((texto) => _validarEmail(
            texto: texto, validator: validator, required: required)),
        password = false,
        keyboardType = null,
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
  final Function(String?)? onChange;
  final AutovalidateMode? autovalidateMode;
  final Icon? icon;

  @override
  _FlutterTextFieldState createState() => _FlutterTextFieldState();

  static String? _validarEmail(
      {String? texto, String? Function(String?)? validator, bool? required}) {
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

  static String? _validarSenha(
      {String? texto,
      int? minLength,
      String? Function(String?)? validator,
      bool? required}) {
    if (required == true) {
      if (texto == null || texto.isEmpty) {
        return 'Esse campo é obrigatório.';
      }
    }
    if (texto != null && minLength != null) {
      if (texto.length < minLength) {
        return 'Deve ter pelo menos $minLength caracteres.';
      }
    }
    if (validator != null) {
      return validator(texto);
    }
    return null;
  }

  static String? _validarNumero(
      {String? texto,
      int? min,
      int? max,
      String? Function(String?)? validator,
      bool? required}) {
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

  static String? _validarMoeda(
      {String? texto,
      int? min,
      int? max,
      String? Function(String?)? validator,
      bool? required}) {
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

  static String? _validarTelefone(
      {String? texto, String? Function(String?)? validator, bool? required}) {
    if (required == true) {
      if (texto == null || texto.isEmpty) {
        return 'Esse campo é obrigatório.';
      }
    }
    if (texto != null) {
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

  static String? validarCpfCnpj({
    String? texto,
    required bool onlyCpf,
    String? Function(String?)? validator,
    bool? required,
  }) {
    if (required == true) {
      if (texto == null || texto.isEmpty) {
        return 'Esse campo é obrigatório.';
      }
    }
    if (texto != null) {
      //sobrescreve todos os caracteres não numéricos
      final cpfCnpjDigitos = texto.replaceAll(RegExp('[^0-9]'), '');
      //se o tamanho é 11, valida como CPF
      if (cpfCnpjDigitos.length == 11) {
        if (!_validarCpf(cpfCnpjDigitos)) {
          return 'CPF inválido!';
        }
        if (validator != null) {
          return validator(texto);
        }
        return null;
      }
      //se o tamanho é 14, valida como CNPJ
      if (cpfCnpjDigitos.length == 14) {
        if (!_validarCnpj(cpfCnpjDigitos)) {
          return 'CNPJ inválido!';
        }
        if (validator != null) {
          return validator(texto);
        }
        return null;
      }
      return onlyCpf == true
          ? 'Deve ter exatamente 11 dígitos'
          : 'Deve ter exatamente 11 ou 14 dígitos';
    }
    if (validator != null) {
      return validator(texto);
    }
    return null;
  }

  static bool _validarCpf(String? cpf) {
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
    return dv1 == int.parse(cpf.substring(9, 10)) &&
        dv2 == int.parse(cpf.substring(10, 11));
  }

  static bool _validarCnpj(String? cnpj) {
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
    return dv1 == int.parse(cnpj.substring(12, 13)) &&
        dv2 == int.parse(cnpj.substring(13, 14));
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

class _FlutterTextFieldState extends State<FlutterTextField> {
  bool visivel = false;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChange,
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
      },
      style: const TextStyle(
        fontSize: 22,
      ),
      decoration: InputDecoration(
        icon: widget.icon,
        suffixIcon: widget.password
            ? InkWell(
                onTap: () => setState(() => visivel = !visivel),
                borderRadius: BorderRadius.circular(50),
                child: Icon(visivel ? Icons.visibility_off : Icons.visibility),
              )
            : null,
        labelText: widget.labelText,
        hintText: widget.hintText,
      ),
    );
  }
}

class FlutterTextEditingController extends TextEditingController {
  String unmaskedText = '';
}
