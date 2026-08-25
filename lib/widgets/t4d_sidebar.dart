import 'package:flutter/material.dart';




class T4DColors {
  
  static const dorado = Color(0xFFD4A743);
  static const doradoOscuro = Color(0xFF8C6B3F);
  static const doradoClaro = Color(0xFFE7C98A);
  static const fondo = Color(0xFFF7F1E3);
  static const encabezado = Color(0xFF13202E);
  static const textoEncabezado = Color(0xFFE7C98A);

  
  static const background = encabezado;
  static const panelBackground = encabezado;
  static const cardBackground = Color(0xFF1B2A3D);

  
  static const gold = dorado;
  static const goldSoft = doradoClaro;

  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFFB9C2D4);
  static const textMuted = Color(0xFF7C879C);
  static const danger = Color(0xFFE0554F);
  static const divider = Color(0xFF24334A);
}

class T4DMenuItem {
  final IconData icon;
  final String label;

  const T4DMenuItem({required this.icon, required this.label});
}

class T4DSidebar extends StatelessWidget {
  final String userName;
  final String userEmail;
  final List<T4DMenuItem> menuItems;
  final int selectedIndex;
  final ValueChanged<int> onItemSelected;
  final VoidCallback onLogout;
  final double width;

  const T4DSidebar({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.menuItems,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
    this.width = 260,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: T4DColors.panelBackground,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            _buildLogoHeader(),
            const SizedBox(height: 20),
            _buildDivider(),
            const SizedBox(height: 16),
            _buildUserCard(),
            const SizedBox(height: 24),
            _buildSectionLabel('MENÚ PRINCIPAL'),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];
                  final isSelected = index == selectedIndex;
                  return _buildMenuItem(item, isSelected, index);
                },
              ),
            ),
            _buildLogoutButton(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: T4DColors.cardBackground,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: T4DColors.dorado.withOpacity(0.4)),
            ),
            child: const Icon(Icons.shield_outlined, color: T4DColors.dorado, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'T4D',
                  style: TextStyle(
                    color: T4DColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  'TECHNOLOGY FOR DEFENSE SAS',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: T4DColors.textoEncabezado,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: T4DColors.divider);
  }

  Widget _buildUserCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: T4DColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: T4DColors.dorado,
              child: const Icon(Icons.person, color: Colors.black87, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      color: T4DColors.textPrimary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    userEmail,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: T4DColors.textSecondary, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        label,
        style: const TextStyle(
          color: T4DColors.textMuted,
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildMenuItem(T4DMenuItem item, bool isSelected, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () => onItemSelected(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? T4DColors.dorado : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isSelected ? Colors.black87 : T4DColors.textSecondary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: isSelected ? Colors.black87 : T4DColors.textSecondary,
                      fontSize: 14,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(color: Colors.black87, shape: BoxShape.circle),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onLogout,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: T4DColors.danger.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: T4DColors.danger.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, color: T4DColors.danger, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'Cerrar sesión',
                  style: TextStyle(
                    color: T4DColors.danger,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}