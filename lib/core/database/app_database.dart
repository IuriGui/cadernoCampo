import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  static Database? _db;

  factory AppDatabase() => _instance;

  AppDatabase._internal();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDatabase();
    return _db!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'caderno_de_campo.db');
    return openDatabase(
      path,
      version: 5, // Versão 5: Remove usuarioId de locais e adiciona propriedadeId
      onCreate: (db, version) async {
        await _createTables(db);
        await _seedDatabase(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE propriedades ADD COLUMN usuarioId INTEGER REFERENCES users(id)');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE registros_atividades ADD COLUMN unidadeInsumo TEXT');
        }
        if (oldVersion < 4) {
          // Versão 4 antiga adicionava usuarioId. Vamos ignorar ou remover depois.
          try {
            await db.execute('ALTER TABLE locais ADD COLUMN usuarioId INTEGER REFERENCES users(id)');
          } catch (_) {}
        }
        if (oldVersion < 5) {
          await db.execute('ALTER TABLE locais ADD COLUMN propriedadeId INTEGER REFERENCES propriedades(id)');
          // SQLite não suporta remover colunas facilmente (DROP COLUMN), 
          // então usuarioId continuará existindo mas será ignorada pelo modelo.
        }
      },
    );
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        email TEXT,
        password TEXT,
        papel TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE propriedades(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuarioId INTEGER,
        nome TEXT,
        municipio TEXT,
        cep TEXT,
        estado TEXT,
        areaTotal REAL,
        areaPropria REAL,
        areaArrendada REAL,
        areaProducaoVegetal REAL,
        observacoes TEXT,
        FOREIGN KEY (usuarioId) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE locais(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        propriedadeId INTEGER,
        nome TEXT,
        areaM2 REAL,
        tipo TEXT,
        quebra_vento INTEGER,
        area_sensivel INTEGER,
        observacoes TEXT,
        FOREIGN KEY (propriedadeId) REFERENCES propriedades (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE areas_cultivo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        local_id INTEGER,
        titulo TEXT,
        data_criacao TEXT,
        FOREIGN KEY (local_id) REFERENCES locais (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE insumos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produto TEXT,
        fornecedor TEXT,
        dataAquisicao TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE destinos(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE culturas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        categoria TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE atividades(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        descricao TEXT,
        tipo TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE registros_atividades(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        dataOcorrencia TEXT NOT NULL,
        areaCultivoId INTEGER,
        quantidade INTEGER,
        atividadeId INTEGER NOT NULL,
        culturaId INTEGER,
        destinacaoId INTEGER,
        tempoEstimadoMin INTEGER,
        observacoes TEXT,
        insumoId INTEGER,
        unidadeInsumo TEXT,
        responsavelId INTEGER,
        FOREIGN KEY (areaCultivoId) REFERENCES areas_cultivo (id),
        FOREIGN KEY (atividadeId) REFERENCES atividades (id),
        FOREIGN KEY (culturaId) REFERENCES culturas (id),
        FOREIGN KEY (destinacaoId) REFERENCES destinos (id),
        FOREIGN KEY (insumoId) REFERENCES insumos (id),
        FOREIGN KEY (responsavelId) REFERENCES users (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE colheitas(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        registroAtividadeId INTEGER,
        medida TEXT,
        quantidade INTEGER,
        destinoId INTEGER,
        FOREIGN KEY (registroAtividadeId) REFERENCES registros_atividades (id),
        FOREIGN KEY (destinoId) REFERENCES destinos (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE programa_comercializacao(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE produtor(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        mecanismo_controle TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE programa_produtor(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produtor_id INTEGER,
        programa_id INTEGER,
        FOREIGN KEY (produtor_id) REFERENCES produtor (id) ON DELETE CASCADE,
        FOREIGN KEY (programa_id) REFERENCES programa_comercializacao (id) ON DELETE CASCADE
      )
    ''');
  }

  Future<void> _seedDatabase(Database db) async {
    // Nota: Em um app real, o id deve existir para os seeds funcionarem.
    // Propriedade 1 vinculada ao Usuário 1 (se existir)
    await db.insert('propriedades', {
      'usuarioId': 1,
      'nome': 'Fazenda Modelo',
      'municipio': 'Santa Maria',
      'estado': 'RS',
      'areaTotal': 10.0
    });

    await db.insert('locais', {
      'propriedadeId': 1,
      'nome': 'Roça do Fundo',
      'areaM2': 2500.0,
      'tipo': 'Campo Aberto',
      'quebra_vento': 1,
      'area_sensivel': 0,
      'observacoes': 'Área principal de plantio'
    });
    
    await db.insert('areas_cultivo', {
      'local_id': 1,
      'titulo': 'Canteiro A1',
      'data_criacao': DateTime.now().toIso8601String()
    });

    await db.insert('atividades', {'nome': 'Plantio', 'descricao': '...', 'tipo': 'Manual'});
    await db.insert('atividades', {'nome': 'Irrigação', 'descricao': '...', 'tipo': 'Automática'});
    await db.insert('atividades', {'nome': 'Adubação', 'descricao': '...', 'tipo': 'Manual'});
    await db.insert('atividades', {'nome': 'Colheita', 'descricao': '...', 'tipo': 'Manual'});

    await db.insert('culturas', {'nome': 'Alface', 'categoria': 'Hortaliça'});
    await db.insert('culturas', {'nome': 'Tomate', 'categoria': 'Fruto'});
    await db.insert('culturas', {'nome': 'Cenoura', 'categoria': 'Raiz'});

    await db.insert('insumos', {'produto': 'Adubo Orgânico', 'fornecedor': 'BioFertil', 'dataAquisicao': '2023-10-01'});

    await db.insert('programa_comercializacao', {'nome': 'PNAE'});
    await db.insert('programa_comercializacao', {'nome': 'PAA'});
    await db.insert('programa_comercializacao', {'nome': 'Feira Local'});
  }
}
