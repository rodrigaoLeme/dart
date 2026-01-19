import 'dart:ui';

import '../../../domain/entities/share/generic_error_entity.dart';
import '../../../ui/components/adra_colors.dart';
import '../../../ui/helpers/i18n/resources.dart';

enum StatusCardState {
  success,
  pending,
  error,
}

class StatusCardViewModel {
  final StatusCardState state;
  final GenericErrorEntity? error;

  StatusCardViewModel({
    required this.state,
    this.error,
  });

  String get iconAsset {
    switch (state) {
      case StatusCardState.success:
        return 'lib/ui/assets/images/icon/circle-check-solid.svg';
      case StatusCardState.pending:
        return 'lib/ui/assets/images/icon/wifi-slash.svg';
      case StatusCardState.error:
        return 'lib/ui/assets/images/icon/exclamation-circle.svg';
    }
  }

  String get title {
    switch (state) {
      case StatusCardState.success:
        return R.string.shippedItems;
      case StatusCardState.pending:
        return R.string.waitingForRecipient;
      case StatusCardState.error:
        return R.string.pendingIssues;
    }
  }

  String get description {
    switch (state) {
      case StatusCardState.success:
        return R.string.messageSuccess;
      case StatusCardState.pending:
        return R.string.messagePending;
      case StatusCardState.error:
        return R.string.messagePendingIssues;
    }
  }

  Color get iconColor {
    switch (state) {
      case StatusCardState.success:
        return AdraColors.primary;
      case StatusCardState.pending:
        return AdraColors.orange;
      case StatusCardState.error:
        return AdraColors.indicatorColor;
    }
  }

  Color get textColor {
    switch (state) {
      case StatusCardState.success:
        return AdraColors.primary;
      case StatusCardState.pending:
        return AdraColors.orange;
      case StatusCardState.error:
        return AdraColors.indicatorColor;
    }
  }
}
