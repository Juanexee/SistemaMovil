import 'package:flutter/material.dart';
import '../main/manager_screen.dart';
import '../main/waiter_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/di/injection.dart';
import '../../../services/auth_service.dart';
import '../../../presentation/providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController user_ctrl = TextEditingController();
  final TextEditingController passController = TextEditingController();

  bool _ocultarPassword = true;

  @override
  void initState() {
    super.initState();
    _verificarSesionExistente();
  }

  Future<void> _verificarSesionExistente() async {
    try {
      final authService = sl<AuthService>();
      final loggedIn = await authService.isLoggedIn();
      if (!loggedIn || !mounted) return;
      final role = (await authService.getUserRole() ?? '').toLowerCase();
      if (!mounted || role.isEmpty) return;
      _navegarPorRol(Navigator.of(context), role);
    } catch (_) {}
  }

  void _navegarPorRol(NavigatorState navigator, String rol) {
    final r = rol.trim().toLowerCase();
    if (r.contains('gerente') ||
        r.contains('admin') ||
        r.contains('super')) {
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => ManagerScreen(role: r),
        ),
      );
    } else {
      navigator.pushReplacement(
        MaterialPageRoute(
          builder: (_) => const WaiterScreen(),
        ),
      );
    }
  }

  @override
  void dispose() {
    user_ctrl.dispose();
    passController.dispose();
    super.dispose();
  }

  void _autocompletarCredencial(String user, String pass) {
    setState(() {
      user_ctrl.text = user;
      passController.text = pass;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 60.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // HEADER: Logo y Textos
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        'assets/images/mimi2.png',
                        width: 55,
                        height: 55,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 15),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'El Rancho La Mimi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          'RESTAURANTE POS',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // TEXTOS PRINCIPALES
                const Text(
                  'ENCANTADO DE VERTE',
                  style: TextStyle(
                    color: Color(0xFFa67c52),
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Bienvenido de Nuevo',
                  style: TextStyle(
                    fontSize: 38,
                    color: Colors.black87,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Inicia sesión para gestionar tus,\nMetricas diarias.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    height: 1.3,
                  ),
                ),

                const SizedBox(height: 35),

                // INPUT DE USUARIO
                const Text(
                  'Usuario',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: TextFormField(
                    controller: user_ctrl,
                    decoration: const InputDecoration(
                      hintText: 'Ingresa tu usuario',
                      hintStyle: TextStyle(color: Colors.black38),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.black38,
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 18),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Porfavor ingresa tu usuario';
                      }
                      return null;
                    },
                  ),
                ),

                const SizedBox(height: 25),

                // INPUT DE CONTRASEÑA
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Contraseña',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      '¿Olvidaste tu contraseña?',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.brown[600],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: passController,
                  obscureText: _ocultarPassword,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    hintText: 'Ingresa tu contraseña',
                    hintStyle: const TextStyle(color: Colors.black38),
                    prefixIcon: const Icon(
                      Icons.lock_outline,
                      color: Colors.black38,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _ocultarPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.black38,
                      ),
                      onPressed: () {
                        setState(() {
                          _ocultarPassword = !_ocultarPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Porfavor ingresa tu contraseña';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // SELECTOR RÁPIDO DE PERFILES POR ROL
                Text(
                  'Perfiles de acceso rápido (Toca para autocompletar):',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildQuickRoleChip(
                      label: 'Gerente (BI)',
                      icon: Icons.analytics_outlined,
                      onTap: () => _autocompletarCredencial(
                          'gerente_movil', 'Gerente123*'),
                    ),
                    _buildQuickRoleChip(
                      label: 'Supervisor',
                      icon: Icons.monitor_heart_outlined,
                      onTap: () => _autocompletarCredencial(
                          'supervisor_movil', 'Super123*'),
                    ),
                    _buildQuickRoleChip(
                      label: 'Administrador',
                      icon: Icons.admin_panel_settings_outlined,
                      onTap: () =>
                          _autocompletarCredencial('admin_movil', 'Admin123*'),
                    ),
                    _buildQuickRoleChip(
                      label: 'Mesero (Salón)',
                      icon: Icons.table_restaurant_outlined,
                      onTap: () => _autocompletarCredencial(
                          'mesero_movil', 'Mesero123*'),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                // BOTON DE INGRESO
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final authProvider = Provider.of<AuthProvider>(
                                context,
                                listen: false,
                              );
                              final messenger = ScaffoldMessenger.of(context);
                              final navigator = Navigator.of(context);

                              bool exito = await authProvider.login(
                                user_ctrl.text.trim(),
                                passController.text.trim(),
                              );

                              if (!mounted) return;
                              messenger.clearSnackBars();

                              if (exito) {
                                final rol =
                                    authProvider.loginResponse?.role ?? '';
                                _navegarPorRol(navigator, rol);
                              } else {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(authProvider.errorMessage),
                                    backgroundColor: Colors.redAccent,
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 4),
                                  ),
                                );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38231c),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Iniciar Sesión',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                Center(
                  child: Text(
                    'Pide a tu manager que reinicie tu contraseña.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                ),

                const SizedBox(height: 40),

                // FOOTER DE AYUDA
                Center(
                  child: Column(
                    children: [
                      Text(
                        '¿Necesitas ayuda para iniciar sesión?',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Contacta a tu manager',
                        style: TextStyle(
                          color: Colors.brown[600],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickRoleChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F5F0),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.brown.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 15, color: const Color(0xFF38231c)),
            const SizedBox(width: 5),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF38231c),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
