import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/entities/alpina_digital_prev_access.dart';
import '../../../../../core/entities/system_status.dart';
import '../../../../../core/value_objects/status_group_type.dart';

class AlpinaAccessDetail extends StatelessWidget {
  final DateTime applicationDate;
  final SystemStatus systemStatus;
  final DateTime desiredStartDate;
  final String? comment;
  final AlpinaDigitalPrevAccess alpinaDigitalPrevAccess;
  final bool agreementAcceptance;

  const AlpinaAccessDetail({
    super.key,
    required this.applicationDate,
    required this.systemStatus,
    required this.desiredStartDate,
    this.comment,
    required this.alpinaDigitalPrevAccess,
    required this.agreementAcceptance,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Status badge
        _buildStatusBadge(),
        const SizedBox(height: 8),

        // Application date
        Text(
          'от ${DateFormat('dd.MM.yyyy').format(applicationDate)}',
          style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
        ),
        const SizedBox(height: 24),

        // Title
        const Text(
          'Предоставление доступа к «Альпина Диджитал»',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 24),

        // Срок получение
        _buildDetailRow(
          label: 'Срок получение',
          value: DateFormat('dd.MM.yyyy').format(desiredStartDate),
        ),
        const SizedBox(height: 16),

        // Был ли ранее вам предоставлен доступ?
        _buildDetailRow(
          label: 'Был ли ранее вам предоставлен доступ?',
          value: alpinaDigitalPrevAccess.name,
        ),
        const SizedBox(height: 16),

        // Comment (if not empty)
        if (comment?.isNotEmpty ?? false) ...[
          _buildDetailRow(label: 'Комментарий', value: comment ?? ''),
          const SizedBox(height: 16),
        ],

        // Agreement info box
        const _InfoBox(
          text:
              'Вам придет письмо со ссылкой для активации доступа к Alpina Digital — перейдите по ней в течении 24 часов, после она станет недействительной. Аккаунт удаляется, если вы не пользуетесь библиотекой более 3 месяцев.',
        ),
      ],
    );
  }

  Widget _buildStatusBadge() {
    final statusColor = _getStatusColor(systemStatus.statusGroup);
    final backgroundColor = statusColor.withValues(alpha: 0.1);

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          systemStatus.name,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: statusColor,
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Color(0xFF757575)),
        ),
      ],
    );
  }

  Color _getStatusColor(StatusGroupType statusGroup) {
    switch (statusGroup) {
      case StatusGroupType.active:
        return const Color(0xFF2196F3); // Blue
      case StatusGroupType.agreement:
        return const Color(0xFF4CAF50); // Green
      case StatusGroupType.completed:
        return const Color(0xFF757575); // Gray
      case StatusGroupType.rejected:
        return const Color(0xFFF44336); // Red
      case StatusGroupType.canceled:
        return const Color(0xFF9E9E9E); // Gray
    }
  }
}

class _InfoBox extends StatelessWidget {
  final String text;

  const _InfoBox({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, size: 20, color: Color(0xFF757575)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF757575),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
