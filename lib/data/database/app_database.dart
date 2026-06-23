import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'culturas_seed.dart';

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
      version: 2,
      onCreate: (db, version) async {
        await _createTables(db);
        await _seedDatabase(db);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('''
      ALTER TABLE anotacao ADD COLUMN plantio_id INTEGER REFERENCES anotacao(id)
    ''');
        }
      },
      onOpen: (db) async {
        await db.execute("PRAGMA foreign_keys = ON");
      },

    );
  }

  Future<void> _createTables(Database db) async {
    // Tabela usuario
    await db.execute('''
      CREATE TABLE usuario (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        email TEXT NOT NULL,
        password TEXT NOT NULL
      )
    ''');

    // Tabela propriedade
    await db.execute('''
      CREATE TABLE propriedade (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        observacao TEXT,
        cep TEXT NOT NULL,
        cidade TEXT NOT NULL,
        estado TEXT NOT NULL,
        area_total REAL NOT NULL,
        area_propria REAL NOT NULL,
        area_arrendada REAL,
        is_deleted INTEGER DEFAULT 0,
        area_producao_vegetal REAL
      )
    ''');

    // Tabela local
    await db.execute('''
      CREATE TABLE local (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        tipo TEXT NOT NULL,
        area_em_metros REAL NOT NULL,
        quebra_vento INTEGER NOT NULL,
        area_sensivel INTEGER NOT NULL,
        observacoes TEXT,
        propriedade_id INTEGER NOT NULL,
        is_deleted INTEGER DEFAULT 0,
        FOREIGN KEY (propriedade_id) REFERENCES propriedade (id)
      )
    ''');

    // Tabela area_cultivo
    await db.execute('''
      CREATE TABLE area_cultivo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        local_id INTEGER,
        is_deleted INTEGER DEFAULT 0,
        FOREIGN KEY (local_id) REFERENCES local (id)
      )
    ''');

    // Tabela atividade
    await db.execute('''
      CREATE TABLE atividade (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        descricao TEXT NOT NULL,
        tipo TEXT NOT NULL
      )
    ''');

    // Tabela cultura
    await db.execute('''
      CREATE TABLE cultura (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT NOT NULL,
        categoria TEXT NOT NULL
      )
    ''');

    // Tabela insumo
    await db.execute('''
      CREATE TABLE insumo (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produto TEXT NOT NULL,
        fornecedor TEXT NOT NULL,
        data_aquisicao TEXT NOT NULL,
        is_deleted INTEGER DEFAULT 0,
        propriedade_id INTEGER,
        FOREIGN KEY (propriedade_id) REFERENCES propriedade (id)
      )
    ''');

    // Tabela colheita
    await db.execute('''
      CREATE TABLE colheita (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        anotacao_id INTEGER NOT NULL UNIQUE,
        unidade_medida TEXT NOT NULL,
        quantidade REAL NOT NULL,
        is_deleted INTEGER DEFAULT 0
      )
    ''');




    // Tabela anotacao
    await db.execute('''
      CREATE TABLE anotacao (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        area_cultivo_id INTEGER,
        data_criacao TEXT NOT NULL,
        unidade_medida TEXT,
        quantidade REAL NOT NULL,
        atividade_id INTEGER NOT NULL,
        insumo_id INTEGER,
        cultura_id INTEGER,
        colheita_id INTEGER,
        plantio_id INTEGER,

        canal_escoamento_id INTEGER,
        observacao TEXT,
        is_deleted INTEGER DEFAULT 0,
        FOREIGN KEY (area_cultivo_id) REFERENCES area_cultivo (id),
        FOREIGN KEY (atividade_id) REFERENCES atividade (id),
        FOREIGN KEY (insumo_id) REFERENCES insumo (id),
        FOREIGN KEY (cultura_id) REFERENCES cultura (id)
        FOREIGN KEY (colheita_id) REFERENCES colheita (id)
        FOREIGN KEY (canal_escoamento_id) REFERENCES canal_escoamento (id)
        FOREIGN KEY (plantio_id) REFERENCES anotacao (id)
      )
    ''');

    // Tabela produtor
    await db.execute('''
      CREATE TABLE produtor (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        usuario_id INTEGER NOT NULL UNIQUE,
        nome TEXT NOT NULL,
        FOREIGN KEY (usuario_id) REFERENCES usuario (id)
      )
    ''');

    // Tabela mecanismo_controle
    await db.execute('''
      CREATE TABLE mecanismo_controle (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produtor_id INTEGER NOT NULL UNIQUE,
        tipo TEXT NOT NULL,
        valor TEXT NOT NULL,
        is_deleted INTEGER DEFAULT 0,
        FOREIGN KEY (produtor_id) REFERENCES produtor (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE canal_escoamento (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        produtor_id INTEGER NOT NULL,
        tipo TEXT NOT NULL,
        nome TEXT NOT NULL,
        is_deleted INTEGER DEFAULT 0,
        FOREIGN KEY (produtor_id) REFERENCES produtor (id)
      )
    ''');

    // Tabela produtor_propriedade
    await db.execute('''
      CREATE TABLE produtor_propriedade (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        propriedade_id INTEGER NOT NULL,
        produtor_id INTEGER NOT NULL,
        papel TEXT NOT NULL,
        FOREIGN KEY (propriedade_id) REFERENCES propriedade (id),
        FOREIGN KEY (produtor_id) REFERENCES produtor (id)
      )
    ''');
  }

  Future<void> _seedDatabase(Database db) async {

    await db.insert('usuario', {
      'email': 'admin@campo.com',
      'password': 'password123'
    });

    await db.insert('produtor', {
      'usuario_id': 1,
      'nome': 'Produtor Modelo'
    });

    await db.insert('propriedade', {
      'nome': 'Fazenda Modelo',
      'cep': '97000-000',
      'cidade': 'Santa Maria',
      'estado': 'RS',
      'area_total': 100.0,
      'area_propria': 80.0
    });

    await db.insert('produtor_propriedade', {
      'produtor_id': 1,
      'propriedade_id': 1,
      'papel': 'proprietário'
    });

    await db.insert('local', {
      'nome': 'Canteiro Norte',
      'tipo': 'Campo Aberto',
      'area_em_metros': 500.0,
      'quebra_vento': 1,
      'area_sensivel': 0,
      'propriedade_id': 1
    });

    await db.insert('atividade', {
      'nome': 'Preparo do solo',
      'descricao': 'Preparo e condicionamento do solo para o cultivo',
      'tipo': 'Preparo do solo'
    });

    await db.insert('atividade', {
      'nome': 'Destinar colheita',
      'descricao': 'Informa para onde foi a colheita',
      'tipo': 'gerenciamento'
    });

    await db.insert('atividade', {
      'nome': 'Plantio',
      'descricao': 'Semeadura ou transplante de mudas na área de cultivo',
      'tipo': 'Plantio'
    });

    await db.insert('atividade', {
      'nome': 'Adubação',
      'descricao': 'Aplicação de fertilizantes e corretivos no solo ou na planta',
      'tipo': 'Adubação'
    });

    await db.insert('atividade', {
      'nome': 'Irrigação',
      'descricao': 'Fornecimento de água para a cultura',
      'tipo': 'Irrigação'
    });

    await db.insert('atividade', {
      'nome': 'Capina',
      'descricao': 'Remoção de plantas daninhas da área de cultivo',
      'tipo': 'Capina'
    });

    await db.insert('atividade', {
      'nome': 'Raleio',
      'descricao': 'Eliminação do excesso de frutos ou plantas para melhorar o desenvolvimento',
      'tipo': 'Raleio'
    });

    await db.insert('atividade', {
      'nome': 'Poda',
      'descricao': 'Remoção de galhos, folhas ou partes da planta para manejo e produção',
      'tipo': 'Poda'
    });

    await db.insert('atividade', {
      'nome': 'Colheita',
      'descricao': 'Coleta e armazenamento da cultura',
      'tipo': 'Colheita'
    });

    await db.insert('atividade', {
      'nome': 'Cobertura do solo',
      'descricao': 'Aplicação de material orgânico ou sintético para proteção do solo',
      'tipo': 'Cobertura do solo'
    });

    await db.insert('atividade', {
      'nome': 'Aplicação de bioinsumo',
      'descricao': 'Aplicação de produtos biológicos para controle fitossanitário ou nutrição',
      'tipo': 'Aplicação de bioinsumo'
    });

    for (final cultura in culturasSeed) {
      await db.insert('cultura', cultura);
    }

  }
}
