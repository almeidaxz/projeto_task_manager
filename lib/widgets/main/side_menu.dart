import 'package:flutter/material.dart';

class SideMenu extends StatelessWidget {
  final VoidCallback onToggleTheme;
  final VoidCallback onLogout;
  final VoidCallback onEditProfile;
  final bool isDarkTheme;

  const SideMenu({
    super.key,
    required this.onToggleTheme,
    required this.onLogout,
    required this.onEditProfile,
    required this.isDarkTheme,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor = isDarkTheme
        ? const Color.fromARGB(255, 49, 49, 49)
        : const Color.fromARGB(255, 255, 241, 253);

    return Container(
      color: bgColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const DrawerHeader(
            child: Text(
              "Menu",
              style: TextStyle(fontSize: 24),
            ),
          ),
          ListTile(
            title: const Text("Perfil"),
            leading: const Icon(Icons.account_circle_outlined),
            onTap: onEditProfile,
          ),
          ListTile(
            title: const Text("Alterar Tema"),
            leading: Icon(
              isDarkTheme ? Icons.light_mode : Icons.dark_mode,
            ),
            onTap: onToggleTheme,
          ),
          ListTile(
            title: const Text("Logout"),
            leading: const Icon(Icons.logout),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}
