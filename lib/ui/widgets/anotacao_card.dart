// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import '../../domain/models/anotacao/anotacao.dart';
// import '../theme/app_theme.dart';
//
// class AnotacaoCard extends StatelessWidget {
//   final Anotacao registro;
//   final VoidCallback onTap;
//
//   const AnotacaoCard({
//     super.key,
//     required this.registro,
//     required this.onTap,
//   });
//
//   Color _activityColor(String? nome) {
//     final n = nome?.toLowerCase() ?? '';
//     if (n.contains('colheit')) return const Color(0xFFF59E0B);
//     if (n.contains('plant')) return const Color(0xFF22C55E);
//     if (n.contains('irrig')) return const Color(0xFF3B82F6);
//     if (n.contains('adub')) return const Color(0xFF14B8A6);
//     if (n.contains('preparo') || n.contains('solo')) return const Color(0xFF92400E);
//     if (n.contains('poda')) return const Color(0xFFEC4899);
//     return AppTheme.primaryGreen;
//   }
//
//   IconData _activityIcon(String? nome) {
//     final n = nome?.toLowerCase() ?? '';
//     if (n.contains('colheit')) return MdiIcons.barley;
//     if (n.contains('plant')) return MdiIcons.sprout;
//     if (n.contains('irrig')) return MdiIcons.waterPump;
//     if (n.contains('adub') || n.contains('nutri')) return MdiIcons.flask;
//     if (n.contains('preparo') || n.contains('solo')) return MdiIcons.shovel;
//     if (n.contains('poda')) return MdiIcons.scissorsCutting;
//     return MdiIcons.clipboardTextOutline;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final color = _activityColor(registro.nomeAtividade);
//
//     return Card(
//       margin: const EdgeInsets.only(bottom: 12),
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: onTap,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Row(
//             children: [
//               Container(
//                 width: 50,
//                 height: 50,
//                 decoration: BoxDecoration(
//                   color: color.withValues(alpha: 0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(_activityIcon(registro.nomeAtividade), color: color, size: 26),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Expanded(
//                           child: Text(
//                             registro.nomeAtividade ?? 'Atividade',
//                             style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ),
//                         Text(
//                           DateFormat('dd/MM').format(registro.dataCriacao),
//                           style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${registro.nomeLocal ?? ''} • ${registro.nomeArea ?? ''}',
//                       style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
//                     ),
//                     if (registro.nomeCultura != null || registro.quantidade > 0) ...[
//                       const SizedBox(height: 6),
//                       Row(
//                         children: [
//                           if (registro.nomeCultura != null) ...[
//                             Container(
//                               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
//                               decoration: BoxDecoration(
//                                 color: Colors.green.shade50,
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                               child: Text(
//                                 registro.nomeCultura!,
//                                 style: TextStyle(color: Colors.green.shade700, fontSize: 11, fontWeight: FontWeight.bold),
//                               ),
//                             ),
//                             const SizedBox(width: 8),
//                           ],
//                           if (registro.quantidade > 0)
//                             Text(
//                               registro.quantidade % 1 == 0
//                                   ? '${registro.quantidade.toInt()} ${registro.unidadeMedida ?? ''}'
//                                   : '${registro.quantidade} ${registro.unidadeMedida ?? ''}',
//                               style: TextStyle(color: Colors.grey.shade700, fontSize: 12, fontWeight: FontWeight.w600),
//                             ),
//                         ],
//                       ),
//                     ],
//                   ],
//                 ),
//               ),
//               Icon(Icons.chevron_right, color: Colors.grey.shade300),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
