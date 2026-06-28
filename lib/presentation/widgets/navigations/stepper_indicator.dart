import 'package:flutter/material.dart';
import 'package:haphap_fe/core/theme/app_colors.dart';

class HapHapStepperIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final List<String> labels;

  const HapHapStepperIndicator({
    super.key,
    required this.currentStep,
    this.totalSteps = 3,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
      child: Column(
        children: [
          Row(
            children: List.generate(totalSteps * 2 - 1, (index) {
              final stepIndex = index ~/ 2;
              final isLine = index % 2 != 0;

              if (isLine) {
                final isCompleted = currentStep > stepIndex;
                return Expanded(
                  child: Container(
                    height: 2,
                    color: isCompleted ? AppColors.primary : AppColors.greyLight,
                  ),
                );
              }

              final isCompleted = currentStep > stepIndex;
              final isActive = currentStep == stepIndex;

              return Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isActive || isCompleted
                      ? AppColors.primary
                      : AppColors.white,
                  border: Border.all(
                    color: isActive || isCompleted
                        ? AppColors.primary
                        : AppColors.greyLight,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(
                          Icons.check,
                          color: AppColors.white,
                          size: 18,
                        )
                      : Text(
                          '${stepIndex + 1}',
                          style: TextStyle(
                            color: isActive
                                ? AppColors.white
                                : AppColors.greyLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              );
            }),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(totalSteps, (index) {
              final isActive = currentStep == index;
              return Expanded(
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: isActive ? AppColors.black : AppColors.greyDark,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
