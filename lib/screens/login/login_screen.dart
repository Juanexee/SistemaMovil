import 'package:flutter/material.dart';

// Lo converti a StatefulWidget porque necesitamos cambiar el estado del ojito de la contraseña
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Controladores (mezcle un poco los nombres xd)
  TextEditingController user_ctrl = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool _ocultarPassword = true; // Para el evento onPressed del icono

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SingleChildScrollView para que no de error de overflow cuando salga el teclado
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 26.0, vertical: 60.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start, // alinear todo a la izquierda
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

                const SizedBox(height: 50),

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

                const SizedBox(height: 45),

                // INPUT DE USUARIO
                const Text(
                  'Usuario',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                // Aqui use un container para el fondo (primer intento de diseño)
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
                      border: InputBorder.none, // Quitamos la linea fea
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
                // Para este me di cuenta que InputDecoration ya traia fill color lol
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

                const SizedBox(height: 40),

                // BOTON DE INGRESO
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // print('Validado'); // para probar en consola
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(
                        0xFF38231c,
                      ), // Mismo cafe oscuro
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
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

                const SizedBox(height: 60),

                // FOOTER DE AYUDA
                Center(
                  child: Column(
                    children: [
                      Text(
                        '¿Necesitas ayuda para iniciar sesión?',
                        style: TextStyle(color: Colors.grey[500], fontSize: 13),
                      ),
                      const SizedBox(
                        height: 2,
                      ), // lo baje un poco para que respire
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
}
