import 'dart:io';

import 'package:apk_p3/service/auth_service.dart';
import 'package:apk_p3/service/horse_service.dart';
import 'package:apk_p3/model/horse_model.dart';
import 'package:apk_p3/view/components/my_horse_card.dart';
import 'package:apk_p3/view/horse_page.dart';
import 'package:apk_p3/view/welcome_page.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum OrderOptions { orderAZ, orderZA, orderWinsDesc, orderWinsAsc }

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HorseService horseService = HorseService();
  final AuthService authService = AuthService();

  List<Horse> _currentHorses = [];

  OrderOptions _currentOrder = OrderOptions.orderAZ;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Catálogo de Cavalos",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.brown,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.logout, color: Colors.white),
          onPressed: () async {
            await authService.signUserOut();
            if (!mounted) return;

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          },
        ),
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            icon: const Icon(Icons.sort, color: Colors.white),
            onSelected: (option) {
              _orderList(option);
            },
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderAZ,
                child: Text("Ordenar por Nome (A-Z)"),
              ),
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderZA,
                child: Text("Ordenar por Nome (Z-A)"),
              ),
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderWinsDesc,
                child: Text("Ordenar por Vitórias (Maior)"),
              ),
              const PopupMenuItem<OrderOptions>(
                value: OrderOptions.orderWinsAsc,
                child: Text("Ordenar por Vitórias (Menor)"),
              ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.brown[50],
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showHorsePage();
        },
        backgroundColor: Colors.brown,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Adicionar", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<List<Horse>>(
        stream: horseService.getAllHorses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("Erro ao carregar dados: ${snapshot.error}"),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Stack(
              children: <Widget>[
                Positioned.fill(
                  child: Lottie.asset(
                    'assets/horse_steps.json',
                    fit: BoxFit.cover,
                    repeat: true,
                  ),
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sentiment_dissatisfied,
                        size: 80,
                        color: Colors.grey[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Nenhum cavalo cadastrado.",
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                      Text(
                        "Toque no '+' para adicionar.",
                        style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          _currentHorses = snapshot.data!;
          _orderList(_currentOrder, setStateAfterOrder: false);

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _currentHorses.length,
            itemBuilder: (context, index) {
              final horse = _currentHorses[index];
              return HorseCardWidget(
                horse: horse,
                onTap: () {
                  _showOptions(context, index);
                },
              );
            },
          );
        },
      ),
    );
  }

  void _orderList(OrderOptions result, {bool setStateAfterOrder = true}) {
    _currentOrder = result;

    switch (result) {
      case OrderOptions.orderAZ:
        _currentHorses.sort((a, b) {
          final nameA = a.name;
          final nameB = b.name;
          return nameA.toLowerCase().compareTo(nameB.toLowerCase());
        });
        break;
      case OrderOptions.orderZA:
        _currentHorses.sort((a, b) {
          final nameA = a.name;
          final nameB = b.name;
          return nameB.toLowerCase().compareTo(nameA.toLowerCase());
        });
        break;
      case OrderOptions.orderWinsDesc:
        _currentHorses.sort((a, b) {
          final winsA = a.totalWins ?? 0;
          final winsB = b.totalWins ?? 0;
          return winsB.compareTo(winsA);
        });
        break;
      case OrderOptions.orderWinsAsc:
        _currentHorses.sort((a, b) {
          final winsA = a.totalWins ?? 0;
          final winsB = b.totalWins ?? 0;
          return winsA.compareTo(winsB);
        });
        break;
    }

    if (setStateAfterOrder) {
      setState(() {});
    }
  }

  void _showHorsePage({Horse? horse}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => HorsePage(horse: horse)),
    );
  }

  void _showOptions(BuildContext context, int index) {
    final horse = _currentHorses[index];

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) {
        return Container(
          color: Colors.brown[50],
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                horse.name,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.brown,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text(
                  "Editar Cadastro",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _showHorsePage(horse: horse);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  "Excluir Cavalo",
                  style: TextStyle(fontSize: 18.0),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _confirmDelete(context, index);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, int index) {
    final horse = _currentHorses[index];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar Exclusão"),
          content: Text(
            "Tem certeza que deseja excluir o cavalo ${horse.name}? Esta ação é irreversível.",
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "CANCELAR",
                style: TextStyle(color: Colors.blueGrey),
              ),
            ),
            TextButton(
              onPressed: () async {
                if (horse.id != null) {
                  final horseName = horse.name;

                  Navigator.pop(context);

                  await horseService.deleteHorse(horse.id!);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Cavalo $horseName excluído com sucesso!"),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Erro ao excluir: ID não encontrado no Firestore.",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );

                  Navigator.pop(context);
                }
              },
              child: const Text("EXCLUIR", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailChip({required IconData icon, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12.0, color: Colors.grey[600]),
        const SizedBox(width: 4.0),
        Flexible(
          child: Text(
            label,
            style: TextStyle(fontSize: 12.0, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildStatColumn({
    required IconData icon,
    required String count,
    required String label,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 16.0, color: Colors.brown[700]),
              const SizedBox(width: 4.0),
              Flexible(
                child: Text(
                  count,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[900],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2.0),
          Text(
            label,
            style: TextStyle(fontSize: 10.0, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
