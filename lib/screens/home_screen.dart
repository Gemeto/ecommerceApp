import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/product.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../widgets/product_card.dart';
import '../widgets/category_filter_dropdown.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});
  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  User? _currentUser;

  List<Product> _products = [];
  String _errorMessage = '';
  bool _isLoadingProducts = true;
  List<String> _allCategories = [];
  String? _selectedCategory;
  bool _isLoadingCategories = true;

  @override
  void initState() {
    super.initState();
    _authService.authStateChanges.listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    setState(() {
      _isLoadingCategories = true;
      _errorMessage = '';
    });
    try {
      final categories = await _apiService.fetchCategories();
      setState(() {
        _allCategories = ["All Categories", ...categories];
        _selectedCategory = "All Categories";
        _isLoadingCategories = false;
      });
      await _fetchProducts();
    } catch (e) {
      setState(() {
        _errorMessage = 'Error loading categories: $e';
        _isLoadingCategories = false;
        _isLoadingProducts = false;
      });
    }
  }

  Future<void> _fetchProducts() async {
    setState(() {
      _isLoadingProducts = true;
      _errorMessage = _errorMessage.contains('categories') ? _errorMessage : '';
    });
    try {
      final products = await _apiService.fetchProducts(
        category: _selectedCategory,
      );
      setState(() {
        _products = products;
        _isLoadingProducts = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage =
            _errorMessage.isNotEmpty && !_errorMessage.contains('products')
            ? '$_errorMessage Error loading products: $e'
            : 'Error loading products: $e';
        _isLoadingProducts = false;
      });
    }
  }

  List<Product> get _filteredProducts {
    return _products;
  }

  void _showAuthDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Autenticación'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                child: const Text('Iniciar Sesión'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _showSignInDialog(context);
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                child: const Text('Registrarse'),
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  _showSignUpDialog(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSignInDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool _isSigningIn = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Iniciar Sesión'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Por favor, introduce un email válido.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: _isSigningIn
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                ),
                ElevatedButton(
                  onPressed: _isSigningIn
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setStateDialog(() {
                              _isSigningIn = true;
                            });
                            try {
                              await _authService.signInWithEmailAndPassword(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              if (Navigator.of(dialogContext).canPop()) {
                                Navigator.of(dialogContext).pop();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Inicio de sesión exitoso!'),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error al iniciar sesión: ${e.message ?? "Error desconocido"}',
                                  ),
                                ),
                              );
                            } finally {
                              if (dialogContext.mounted) {
                                setStateDialog(() {
                                  _isSigningIn = false;
                                });
                              }
                            }
                          }
                        },
                  child: _isSigningIn
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Iniciar Sesión'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSignUpDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    bool _isSigningUp = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Registrarse'),
              content: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            !value.contains('@')) {
                          return 'Por favor, introduce un email válido.';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Contraseña',
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.length < 6) {
                          return 'La contraseña debe tener al menos 6 caracteres.';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: _isSigningUp
                      ? null
                      : () => Navigator.of(dialogContext).pop(),
                ),
                ElevatedButton(
                  onPressed: _isSigningUp
                      ? null
                      : () async {
                          if (formKey.currentState!.validate()) {
                            setStateDialog(() {
                              _isSigningUp = true;
                            });
                            try {
                              await _authService.signUpWithEmailAndPassword(
                                emailController.text.trim(),
                                passwordController.text.trim(),
                              );
                              if (Navigator.of(dialogContext).canPop()) {
                                Navigator.of(dialogContext).pop();
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Registro exitoso! Por favor, inicia sesión.',
                                  ),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Error al registrarse: ${e.message ?? "Error desconocido"}',
                                  ),
                                ),
                              );
                            } finally {
                              if (dialogContext.mounted) {
                                setStateDialog(() {
                                  _isSigningUp = false;
                                });
                              }
                            }
                          }
                        },
                  child: _isSigningUp
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text('Registrarse'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(
        children: [
          if (_currentUser != null && _currentUser!.email != null)
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Hola, ${_currentUser!.email}!',
                style: textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          if (!_isLoadingCategories && _allCategories.isNotEmpty)
            Padding(
              padding: EdgeInsets.fromLTRB(
                12.0,
                _currentUser != null ? 0 : 12.0,
                12.0,
                12.0,
              ),
              child: CategoryFilterDropdown(
                categories: _allCategories,
                selectedCategory: _selectedCategory,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                    _fetchProducts();
                  });
                },
              ),
            )
          else if (_isLoadingCategories)
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
            ),

          if (_isLoadingProducts && _filteredProducts.isEmpty)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_errorMessage.isNotEmpty && _filteredProducts.isEmpty)
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    _errorMessage,
                    textAlign: TextAlign.center,
                    style: textTheme.bodyLarge?.copyWith(
                      color: Colors.red[700],
                    ),
                  ),
                ),
              ),
            )
          else if (_filteredProducts.isEmpty &&
              !_isLoadingProducts &&
              !_isLoadingCategories)
            Expanded(
              child: Center(
                child: Text(
                  _selectedCategory == null ||
                          _selectedCategory == "All Categories"
                      ? 'No products found.'
                      : 'No products found in $_selectedCategory.',
                  style: textTheme.bodyLarge,
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ProductCard(product: product);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentUser == null) {
            _showAuthDialog(context);
          } else {
            _authService.signOut();
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(const SnackBar(content: Text('Sesión cerrada.')));
          }
        },
        tooltip: _currentUser == null
            ? 'Iniciar Sesión / Registrarse'
            : 'Cerrar Sesión',
        child: Icon(_currentUser == null ? Icons.login : Icons.logout),
      ),
    );
  }
}
