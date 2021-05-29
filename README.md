# flutter_text_field

Um pacote de campos textos personalizados, capazes de receber entradas no formato de CPF, CNPJ, email, Senha, Telefone, R$ e Números inteiros.

## Demonstração

![demonstração](preview.gif) 

## Principais recursos

 - [X] Campo de CPF ou CNPJ com validação aritmética e máscara.
 - [X] Campo de telefone com máscara e validação por quantidade de dígitos.
 - [X] Campo de moeda com formatação brasileira por meio da biblioteca [intl](https://pub.dev/packages/intl).
 - [X] Campo de senha com possibilidade de visualização.
 - [X] Campo de email com validação por meio da biblioteca [email_validator](https://pub.dev/packages/email_validator).
 - [X] Campo numérico com validação de mínimo e máximo inteiro.
 - [ ] Campo de data e hora.
 - [ ] Campo numérico com ponto flutuante

 ## Exemplo
``flutter
FutterTextField.cpfCnpj(
    autovalidateMode: AutovalidateMode.onUserInteraction,
    labelText: 'CPF / CNPJ',
    hintText: 'Digite seu CPF ou CNPJ',
    controller: controllerCpfCnpj,
),
``

