import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../presentation/providers/user_provider.dart';
import '../../../data/models/users_model.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _searchQuery = '';
  String _filterRole = 'Todos';

  @override
  void initState() {
    super.initState();
    // Cargamos los usuarios de la API al abrir la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<UserProvider>(context, listen: false).loadUsers();
    });
    _searchCtrl.addListener(() {
      setState(() => _searchQuery = _searchCtrl.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // Filtra la lista de usuarios por búsqueda y rol
  List<UserModel> _filteredUsers(List<UserModel> all) {
    return all.where((u) {
      final matchSearch = _searchQuery.isEmpty ||
          u.name.toLowerCase().contains(_searchQuery) ||
          u.email.toLowerCase().contains(_searchQuery) ||
          u.role.toLowerCase().contains(_searchQuery);
      final matchRole = _filterRole == 'Todos' ||
          u.role.toLowerCase().contains(_filterRole.toLowerCase());
      return matchSearch && matchRole;
    }).toList();
  }

  // Colores del badge según el rol
  Color _tagColor(String role) {
    final r = role.toLowerCase();
    if (r.contains('gerente')) return const Color(0xFFF7EBE1);
    if (r.contains('admin')) return const Color(0xFFEFEFEF);
    if (r.contains('mesero') || r.contains('salón') || r.contains('salon')) {
      return const Color(0xFFEBF5EE);
    }
    return const Color(0xFFEFEFEF);
  }

  Color _tagTextColor(String role) {
    final r = role.toLowerCase();
    if (r.contains('gerente')) return const Color(0xFFB57049);
    if (r.contains('admin')) return const Color(0xFF666666);
    if (r.contains('mesero') || r.contains('salón') || r.contains('salon')) {
      return const Color(0xFF427A59);
    }
    return const Color(0xFF666666);
  }

  Color _sideAccentColor(String role) {
    final r = role.toLowerCase();
    if (r.contains('gerente')) return const Color(0xFFDCA887);
    if (r.contains('admin')) return const Color(0xFFCCCCCC);
    if (r.contains('mesero') || r.contains('salón') || r.contains('salon')) {
      return const Color(0xFFA2C7B3);
    }
    return const Color(0xFFCCCCCC);
  }

  // Iniciales de un nombre
  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (parts.isNotEmpty && parts[0].isNotEmpty) return parts[0][0].toUpperCase();
    return '?';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F0),
      body: SafeArea(
        child: Consumer<UserProvider>(
          builder: (context, provider, _) {
            final allUsers = provider.users;
            final filtered = _filteredUsers(allUsers);

            // Conteos para las métricas
            final gerentes = allUsers.where((u) =>
                u.role.toLowerCase().contains('gerente') ||
                u.role.toLowerCase().contains('admin')).length;
            final meseros = allUsers.where((u) =>
                u.role.toLowerCase().contains('mesero') ||
                u.role.toLowerCase().contains('salón') ||
                u.role.toLowerCase().contains('salon')).length;

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Encabezado Superior ---
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.transparent,
                              backgroundImage:
                                  AssetImage('assets/images/mimi2.png'),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'El Rancho La Mimí',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C1E18),
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'En línea',
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(width: 12),
                            const Icon(Icons.notifications_none,
                                color: Colors.black54),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // --- Título ---
                        Text(
                          'SEGURIDAD Y ACCESO',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Gestión de Usuarios',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2C1E18),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Administra los roles, permisos y accesos del personal',
                          style:
                              TextStyle(fontSize: 13, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 16),

                        // --- Buscador ---
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchCtrl,
                            decoration: const InputDecoration(
                              hintText:
                                  'Buscar por nombre, usuario o rol...',
                              hintStyle:
                                  TextStyle(color: Colors.grey, fontSize: 13),
                              prefixIcon:
                                  Icon(Icons.search, color: Colors.grey),
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // --- Botón Nuevo Usuario ---
                        SizedBox(
                          width: double.infinity,
                          height: 44,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF322018),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                            onPressed: () => _showAddUserDialog(context, provider),
                            icon: const Icon(Icons.add,
                                color: Colors.white, size: 18),
                            label: const Text(
                              'Nuevo Usuario',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // --- Métricas ---
                        if (provider.isLoading)
                          const Center(child: CircularProgressIndicator())
                        else ...[
                          Row(
                            children: [
                              Expanded(
                                child: _buildMetricCard(
                                  label: 'Usuarios activos',
                                  value: '${allUsers.length}',
                                  subtitle: 'Personal registrado',
                                  dark: true,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _buildMetricCard(
                                  label: 'Gerentes / Admins',
                                  value: '$gerentes',
                                  subtitle: 'Acceso administrativo',
                                  dark: false,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          FractionallySizedBox(
                            widthFactor: 0.48,
                            child: _buildMetricCard(
                              label: 'Meseros / Salón',
                              value: '$meseros',
                              subtitle: 'Roles operativos',
                              dark: false,
                            ),
                          ),
                        ],

                        const SizedBox(height: 16),

                        // --- Filtros ---
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _buildFilterChip('Todos'),
                            _buildFilterChip('Gerente',
                                icon: Icons.person_outline),
                            _buildFilterChip('Administrador',
                                icon: Icons.verified_outlined),
                            _buildFilterChip('Mesero',
                                icon: Icons.person_outline),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // --- Lista de usuarios ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'PERSONAL REGISTRADO',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const Text(
                                  'Equipo de trabajo',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C1E18),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              '${filtered.length} cuentas',
                              style: TextStyle(
                                  fontSize: 12, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Error message
                        if (provider.errorMessage.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              provider.errorMessage,
                              style: const TextStyle(color: Colors.red, fontSize: 12),
                            ),
                          ),

                        // Tarjetas de usuario
                        if (!provider.isLoading)
                          ...filtered.map((u) => _buildUserCard(
                                initials: _initials(u.name),
                                name: u.name,
                                email: u.email,
                                role: u.role.isNotEmpty ? u.role : 'Sin rol',
                                tagColor: _tagColor(u.role),
                                tagTextColor: _tagTextColor(u.role),
                                sideAccentColor: _sideAccentColor(u.role),
                              )),

                        if (!provider.isLoading && filtered.isEmpty)
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: Text(
                                'No se encontraron usuarios',
                                style: TextStyle(color: Colors.grey[500]),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  // Diálogo para agregar usuario con los campos requeridos por el backend
  void _showAddUserDialog(BuildContext ctx, UserProvider provider) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController();
    final userCtrl = TextEditingController();
    final passCtrl = TextEditingController();
    int selectedRolId = 2; // Por defecto Mesero
    String selectedRolNombre = 'Mesero';
    bool obscurePass = true;
    bool isSaving = false;

    // Roles estándar del sistema
    final rolesDisponibles = [
      {'id': 1, 'nombre': 'Administrador'},
      {'id': 2, 'nombre': 'Mesero'},
      {'id': 3, 'nombre': 'Gerente'},
      {'id': 4, 'nombre': 'Cajero'},
    ];

    showDialog(
      context: ctx,
      barrierDismissible: false,
      builder: (dialogCtx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: const [
                Icon(Icons.person_add_alt_1_rounded, color: Color(0xFF322018)),
                SizedBox(width: 8),
                Text(
                  'Nuevo Usuario',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ingresa los datos para dar de alta al personal en el sistema:',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const SizedBox(height: 14),

                    // Nombre Completo
                    TextFormField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        labelText: 'Nombre Completo',
                        hintText: 'Ej. Juan Pérez',
                        prefixIcon: const Icon(Icons.badge_outlined, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el nombre' : null,
                    ),
                    const SizedBox(height: 12),

                    // Nombre de Usuario / Login
                    TextFormField(
                      controller: userCtrl,
                      decoration: InputDecoration(
                        labelText: 'Nombre de Usuario',
                        hintText: 'Ej. jperez',
                        prefixIcon: const Icon(Icons.alternate_email_rounded, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Ingresa el usuario de login' : null,
                    ),
                    const SizedBox(height: 12),

                    // Contraseña
                    TextFormField(
                      controller: passCtrl,
                      obscureText: obscurePass,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        hintText: 'Mínimo 4 caracteres',
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePass ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                            size: 20,
                          ),
                          onPressed: () => setDialogState(() => obscurePass = !obscurePass),
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      validator: (v) => (v == null || v.trim().length < 3) ? 'Ingresa una contraseña válida' : null,
                    ),
                    const SizedBox(height: 12),

                    // Selector de Rol
                    DropdownButtonFormField<int>(
                      initialValue: selectedRolId,
                      decoration: InputDecoration(
                        labelText: 'Rol en el sistema',
                        prefixIcon: const Icon(Icons.admin_panel_settings_outlined, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      items: rolesDisponibles.map((r) {
                        return DropdownMenuItem<int>(
                          value: r['id'] as int,
                          child: Text(r['nombre'] as String),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() {
                            selectedRolId = val;
                            selectedRolNombre = rolesDisponibles.firstWhere((r) => r['id'] == val)['nombre'] as String;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: isSaving ? null : () => Navigator.pop(dialogCtx),
                child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF322018),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: isSaving
                    ? null
                    : () async {
                        if (!formKey.currentState!.validate()) return;
                        setDialogState(() => isSaving = true);

                        final messenger = ScaffoldMessenger.of(ctx);
                        final exito = await provider.addUser(
                          UserModel(
                            id: 0,
                            name: nameCtrl.text.trim(),
                            email: userCtrl.text.trim(),
                            role: selectedRolNombre,
                            rolId: selectedRolId,
                            password: passCtrl.text.trim(),
                          ),
                        );

                        if (dialogCtx.mounted) {
                          Navigator.pop(dialogCtx);
                        }

                        messenger.clearSnackBars();
                        messenger.showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                Icon(
                                  exito ? Icons.check_circle : Icons.error_outline,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    exito
                                        ? 'Usuario ${userCtrl.text.trim()} creado exitosamente'
                                        : (provider.errorMessage.isNotEmpty
                                            ? provider.errorMessage
                                            : 'Error al registrar el usuario en la API'),
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: exito ? const Color(0xFF322018) : Colors.redAccent,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                child: isSaving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Guardar', style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMetricCard({
    required String label,
    required String value,
    required String subtitle,
    required bool dark,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: dark ? const Color(0xFF322018) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: TextStyle(
                  color: dark ? Colors.white70 : Colors.black54,
                  fontSize: 11)),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: dark ? Colors.white : Colors.black87,
                  fontSize: 22,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(
                  color: dark ? Colors.white54 : Colors.black38,
                  fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {IconData? icon}) {
    final isSelected = _filterRole == label;
    return GestureDetector(
      onTap: () => setState(() => _filterRole = label),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF322018) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                isSelected ? const Color(0xFF322018) : Colors.grey.shade300,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon,
                  size: 14,
                  color: isSelected ? Colors.white : Colors.black54),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserCard({
    required String initials,
    required String name,
    required String email,
    required String role,
    required Color tagColor,
    required Color tagTextColor,
    required Color sideAccentColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            children: [
              Container(width: 4, color: sideAccentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor:
                                sideAccentColor.withValues(alpha: 0.3),
                            child: Text(
                              initials,
                              style: TextStyle(
                                color:
                                    sideAccentColor.withValues(alpha: 1.0),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2C1E18),
                                  ),
                                ),
                                Text(
                                  email,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: tagColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              role,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: tagTextColor,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.edit_outlined,
                                  size: 18, color: Colors.grey),
                              const SizedBox(width: 8),
                              Transform.scale(
                                scale: 0.7,
                                child: Switch(
                                  value: true,
                                  onChanged: (val) {},
                                  thumbColor:
                                      WidgetStateProperty.all(Colors.white),
                                  trackColor: WidgetStateProperty.all(
                                      const Color(0xFF322018)),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}