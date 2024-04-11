// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_compras/main.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => Lista(),
    ),
  );
}

class Lista extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista',
      home: FolderListScreen(),
    );
  }
}

class FolderListScreen extends StatefulWidget {
  @override
  _FolderListScreenState createState() => _FolderListScreenState();
}

class _FolderListScreenState extends State<FolderListScreen> {
  List<String> folderNames = [];
  Map<String, List<Product>> folders = {};

  void _abrirLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Listas',
          style: TextStyle(
            fontSize: 30,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: ListView.builder(
        itemCount: folderNames.length,
        itemBuilder: (context, index) {
          final folderName = folderNames[index];
          final productList = folders[folderName]!;
          return Padding(
            padding: const EdgeInsets.all(3.0),
            child: Card(
              elevation: 4,
              child: ListTile(
                title: Text(folderName),
                onTap: () {
                  _showFolderOptionsDialog(context, folderName, productList);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateFolderDialog(context);
        },
        child: Icon(Icons.add),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: () {
            _abrirLogin();
          },
          child: Text('Sair'),
        ),
      ],
    );
  }

  void _showCreateFolderDialog(BuildContext context) {
    TextEditingController folderNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Criar Lista'),
          content: TextField(
            controller: folderNameController,
            decoration: InputDecoration(labelText: 'Nome da Lista'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final folderName = folderNameController.text;
                if (!folders.containsKey(folderName)) {
                  setState(() {
                    folderNames.add(folderName);
                    folders[folderName] = [];
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Criar'),
            ),
          ],
        );
      },
    );
  }

  void _showFolderOptionsDialog(
      BuildContext context, String folderName, List<Product> productList) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Opções da Lista'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Abrir Lista'),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductListScreen(
                        folderName: folderName,
                        products: productList,
                      ),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('Editar Nome da Lista'),
                onTap: () {
                  Navigator.of(context).pop();
                  _showEditFolderNameDialog(context, folderName);
                },
              ),
              ListTile(
                title: Text('Remover Lista'),
                onTap: () {
                  Navigator.of(context).pop();
                  _removeFolder(context, folderName);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditFolderNameDialog(BuildContext context, String folderName) {
    TextEditingController newFolderNameController =
        TextEditingController(text: folderName);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Nome da Lista'),
          content: TextField(
            controller: newFolderNameController,
            decoration: InputDecoration(labelText: 'Novo Nome da Lista'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                final newFolderName = newFolderNameController.text;
                if (newFolderName.isNotEmpty &&
                    newFolderName != folderName &&
                    !folders.containsKey(newFolderName)) {
                  setState(() {
                    int index = folderNames.indexOf(folderName);
                    folderNames[index] = newFolderName;
                    folders[newFolderName] = folders.remove(folderName)!;
                  });
                }
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _removeFolder(BuildContext context, String folderName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Remover Lista'),
          content: Text('Tem certeza que deseja remover esta lista?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  folderNames.remove(folderName);
                  folders.remove(folderName);
                });
                Navigator.of(context).pop();
              },
              child: Text('Remover'),
            ),
          ],
        );
      },
    );
  }
}

class ProductListScreen extends StatefulWidget {
  final String folderName;
  final List<Product> products;

  const ProductListScreen(
      {Key? key, required this.folderName, required this.products})
      : super(key: key);

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late List<Product> products;
  late List<Product> searchResults;
  void _abrirLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  void initState() {
    super.initState();
    products = widget.products;
    searchResults = List.from(products);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.folderName}',
          style: TextStyle(
            fontSize: 30,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              _showProductSearchDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: searchResults.length,
        itemBuilder: (context, index) {
          final product = searchResults[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 4),
            child: Card(
              elevation: 4,
              color: product.highlighted ? Colors.red : null,
              child: ListTile(
                title: Text('Produto: ${product.name}'),
                subtitle: Text('Quantidade: ${product.quantity}'),
                trailing: product.isBought ? Icon(Icons.check) : null,
                onTap: () {
                  _showProductOptionsDialog(context, product);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateProductDialog(context);
        },
        child: Icon(Icons.add),
      ),
      persistentFooterButtons: [
        TextButton(
          onPressed: () {
            _abrirLogin();
          },
          child: Text('Sair'),
        ),
      ],
    );
  }

  void _showCreateProductDialog(BuildContext context) {
    TextEditingController productNameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Adicionar Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Produto'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  products.add(Product(
                    name: productNameController.text,
                    quantity: int.parse(quantityController.text),
                  ));
                  _updateSearchResults('');
                });
                Navigator.of(context).pop();
              },
              child: Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _showProductOptionsDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Mudar Produto'),
                onTap: () {
                  Navigator.of(context).pop();
                  _editProduct(context, product);
                },
              ),
              ListTile(
                title: Text('Remover Produto'),
                onTap: () {
                  _removeProduct(context, product);
                },
              ),
              ListTile(
                title: Text(product.isBought
                    ? 'Desmarcar como Comprado'
                    : 'Marcar como Comprado'),
                onTap: () {
                  _toggleProductBoughtStatus(context, product);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editProduct(BuildContext context, Product product) {
    TextEditingController productNameController =
        TextEditingController(text: product.name);
    TextEditingController quantityController =
        TextEditingController(text: product.quantity.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Produto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(labelText: 'Nome do Produto'),
              ),
              TextField(
                controller: quantityController,
                decoration: InputDecoration(labelText: 'Quantidade'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  product.name = productNameController.text;
                  product.quantity = int.parse(quantityController.text);
                  _updateSearchResults('');
                });
                Navigator.of(context).pop();
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _removeProduct(BuildContext context, Product product) {
    setState(() {
      products.remove(product);
      _updateSearchResults('');
    });
    Navigator.of(context).pop();
  }

  void _toggleProductBoughtStatus(BuildContext context, Product product) {
    setState(() {
      product.isBought = !product.isBought;
    });
    Navigator.of(context).pop();
  }

  void _showProductSearchDialog(BuildContext context) {
    TextEditingController productNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Pesquisar Produtos'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: productNameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Produto',
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancelar'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      String query = productNameController.text;
                      _searchProducts(context, query);
                    },
                    child: Text('Procurar'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _searchProducts(BuildContext context, String query) {
    _updateSearchResults(query);
    Navigator.of(context).pop();
  }

  void _updateSearchResults(String query) {
    setState(() {
      searchResults.clear();
      searchResults.addAll(products.where((product) =>
          product.name.toLowerCase().contains(query.toLowerCase())));
      searchResults.forEach((product) => product.highlighted = false);
      if (query.isNotEmpty) {
        final foundProduct = searchResults.firstWhere(
            (product) => product.name.toLowerCase() == query.toLowerCase(),
            orElse: () => Product(name: '', quantity: 0));
        if (foundProduct.name.isNotEmpty) {
          foundProduct.highlighted = true;
        }
      }
    });
  }
}

class Product {
  late String name;
  late int quantity;
  bool isBought = false;
  bool highlighted = false;

  Product({required this.name, required this.quantity});
}

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: Text('This is the login screen'),
      ),
    );
  }
}
