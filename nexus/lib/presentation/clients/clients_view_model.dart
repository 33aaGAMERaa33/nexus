import 'package:flutter/material.dart';
import 'package:nexus/core/models/operation_result.dart';
import 'package:nexus/features/clients/domain/entities/client_entity.dart';
import 'package:nexus/features/clients/domain/repositories/clients_repository.dart';

class ClientsViewModel with ChangeNotifier {
  final ClientsRepository _clientRepository;
  new({required this._clientRepository});

  bool _initialized = false;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<ClientEntity> clients = [];

  ClientError ? _error;
  ClientError ? get error => _error;

  int _page = 1;
  final int _limit = 20;
  bool _hasMoreClients = true;
  final ScrollController scrollController = ScrollController();

  void updateClient(ClientEntity oldClientData, ClientEntity newClientData) {
    final int index = clients.indexOf(oldClientData);
    clients[index] = newClientData;
    notifyListeners();
  }
  
  Future<void> getClients() async {
    if(_isLoading || !_hasMoreClients) return;
    _error = null;
    _isLoading = true;
    _resetPagination();
    notifyListeners();

    try {
      final OperationResult<List<ClientEntity>, ClientError> result = await _clientRepository.getClients(
        offset: 0, limit: _limit - 1
      );
      
      if(!result.success) {
        _error = result.error;
      }else {
        clients = result.data;
      }

      notifyListeners();
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _resetPagination() {
    clients = [];

    _page = 1;
    _hasMoreClients = true;
  }

  Future<void> init() async {
    if(_initialized) return;
    _initialized = true;

    scrollController.addListener(_onScroll);
    await getClients();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void _onScroll() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if(scrollController.position.pixels >= scrollController.position.maxScrollExtent / 4) {
        await _loadMore();
      }
    });
  }

  Future<void> _loadMore() async {
    if(_isLoading || !_hasMoreClients) return;
    _isLoading = true;
    notifyListeners();

    try {
      final OperationResult<List<ClientEntity>, ClientError> result = await _clientRepository.getClients(
        limit: _limit - 1,
        offset: _page * _limit,
      );

      if(!result.success) {
        _error = result.error;
      }else {
        _hasMoreClients = result.data.length >= _limit;
        clients.addAll(result.data.where((element) => !clients.contains(element)));

        if(_hasMoreClients) {
          _page++;
        }
      }
    }finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}