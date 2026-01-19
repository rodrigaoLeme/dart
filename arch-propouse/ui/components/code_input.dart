import 'package:flutter/material.dart';

import 'components.dart';

class VerificationCodeInput extends StatelessWidget {
  const VerificationCodeInput({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildCodeField(),
              _buildCodeField(),
              _buildCodeField(),
              const Text(
                '-',
                style: TextStyle(
                  fontSize: 36,
                  color: AdraColors.weLigth,
                  fontWeight: FontWeight.w500,
                ),
              ),
              _buildCodeField(),
              _buildCodeField(),
              _buildCodeField(),
            ],
          ),
        ),
        const SizedBox(height: 32),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Não recebeu o código?',
                style: TextStyle(
                  color: AdraColors.weBlackLight,
                  fontSize: 14.0,
                ),
              ),
              SizedBox(width: 5),
              Text(
                'Enviar novamente.',
                style: TextStyle(
                  color: AdraColors.weBlack,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  fontSize: 14.0,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCodeField() {
    return Container(
      width: 38,
      height: 64,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AdraColors.weClean,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AdraColors.weLigth),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 36,
          color: AdraColors.weLigth,
          fontWeight: FontWeight.w500,
        ),
        keyboardType: TextInputType.number,
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
        ),
      ),
    );
  }
}
