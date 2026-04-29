import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isLogin = true;
  bool _loading = false;
  String? _error;

  Future<void> _submit() async {
    final email = _emailCtrl.text.trim();
    final pass = _passCtrl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      setState(() => _error = 'Preencha todos os campos.');
      return;
    }
    setState(() { _loading = true; _error = null; });
    try {
      if (_isLogin) {
        await signInWithEmail(email, pass);
      } else {
        await registerWithEmail(email, pass);
      }
      if (mounted) context.go('/');
    } on Exception catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _googleSignIn() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await signInWithGoogle();
      if (result != null && mounted) context.go('/');
    } on Exception catch (e) {
      setState(() => _error = _friendlyError(e.toString()));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _friendlyError(String e) {
    if (e.contains('user-not-found') || e.contains('wrong-password') || e.contains('invalid-credential'))
      return 'Email ou senha incorretos.';
    if (e.contains('email-already-in-use')) return 'Este email já está cadastrado.';
    if (e.contains('weak-password')) return 'Senha muito fraca (mínimo 6 caracteres).';
    if (e.contains('invalid-email')) return 'Email inválido.';
    return 'Erro ao autenticar. Tente novamente.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Row(
                children: [
                  Image.asset('assets/logo.png', height: 40),
                  const SizedBox(width: 10),
                  const Text.rich(
                    TextSpan(children: [
                      TextSpan(text: 'Fut', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 28)),
                      TextSpan(text: 'Vision', style: TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.bold, fontSize: 28)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              Text(
                _isLogin ? 'Bem-vindo de volta!' : 'Criar conta',
                style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                _isLogin ? 'Entre para acessar seus favoritos.' : 'Cadastre-se para salvar favoritos.',
                style: const TextStyle(color: Colors.white54, fontSize: 14),
              ),
              const SizedBox(height: 32),
              _field(_emailCtrl, 'Email', Icons.email_outlined, keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 12),
              _field(_passCtrl, 'Senha', Icons.lock_outline, obscure: true),
              const SizedBox(height: 8),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text('⚠️ $_error', style: const TextStyle(color: Colors.redAccent, fontSize: 13)),
                ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00E5FF),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: _loading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black))
                      : Text(_isLogin ? 'Entrar' : 'Cadastrar', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 16),
              Row(children: [
                const Expanded(child: Divider(color: Color(0xFF2A2A3E))),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('ou', style: TextStyle(color: Colors.white38))),
                const Expanded(child: Divider(color: Color(0xFF2A2A3E))),
              ]),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _loading ? null : _googleSignIn,
                  icon: const Text('G', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                  label: const Text('Entrar com Google', style: TextStyle(color: Colors.white)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    side: const BorderSide(color: Color(0xFF2A2A3E)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: GestureDetector(
                  onTap: () => setState(() { _isLogin = !_isLogin; _error = null; }),
                  child: Text.rich(
                    TextSpan(children: [
                      TextSpan(
                        text: _isLogin ? 'Não tem conta? ' : 'Já tem conta? ',
                        style: const TextStyle(color: Colors.white54),
                      ),
                      TextSpan(
                        text: _isLogin ? 'Cadastre-se' : 'Entrar',
                        style: const TextStyle(color: Color(0xFF00E5FF), fontWeight: FontWeight.w600),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String hint, IconData icon,
      {bool obscure = false, TextInputType? keyboardType}) =>
      TextField(
        controller: ctrl,
        obscureText: obscure,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          prefixIcon: Icon(icon, color: Colors.white38, size: 20),
          filled: true,
          fillColor: const Color(0xFF1A1A2E),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2A2A3E))),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF2A2A3E))),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Color(0xFF00E5FF))),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      );
}
