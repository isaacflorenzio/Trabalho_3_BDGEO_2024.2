import requests
import mysql.connector

# Conexão com o banco de dados MySQL
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="gBY58#QHJvop$WGV9*8mHJ0",
    database="bd_voosolo"
)
cursor = db.cursor()

# Tabela de estados com siglas (exemplo de dados para inserção)
estados = [
    {"nome": "Acre", "uf": "AC"},
    {"nome": "Alagoas", "uf": "AL"},
    {"nome": "Amapá", "uf": "AP"},
    {"nome": "Amazonas", "uf": "AM"},
    {"nome": "Bahia", "uf": "BA"},
    {"nome": "Ceará", "uf": "CE"},
    {"nome": "Distrito Federal", "uf": "DF"},
    {"nome": "Espírito Santo", "uf": "ES"},
    {"nome": "Goiás", "uf": "GO"},
    {"nome": "Maranhão", "uf": "MA"},
    {"nome": "Mato Grosso", "uf": "MT"},
    {"nome": "Mato Grosso do Sul", "uf": "MS"},
    {"nome": "Minas Gerais", "uf": "MG"},
    {"nome": "Pará", "uf": "PA"},
    {"nome": "Paraíba", "uf": "PB"},
    {"nome": "Paraná", "uf": "PR"},
    {"nome": "Pernambuco", "uf": "PE"},
    {"nome": "Piauí", "uf": "PI"},
    {"nome": "Rio de Janeiro", "uf": "RJ"},
    {"nome": "Rio Grande do Norte", "uf": "RN"},
    {"nome": "Rio Grande do Sul", "uf": "RS"},
    {"nome": "Rondônia", "uf": "RO"},
    {"nome": "Roraima", "uf": "RR"},
    {"nome": "Santa Catarina", "uf": "SC"},
    {"nome": "São Paulo", "uf": "SP"},
    {"nome": "Sergipe", "uf": "SE"},
    {"nome": "Tocantins", "uf": "TO"}
]

# 1. Inserir estados na tabela 'estado'
for estado in estados:
    cursor.execute("INSERT INTO estado (uf) VALUES (%s)", (estado['uf'],))
db.commit()
print("Estados inseridos com sucesso!")

# 2. Buscar estados do banco para associar o ID
cursor.execute("SELECT id, uf FROM estado")
estados_db = cursor.fetchall()
estado_dict = {uf: id for id, uf in estados_db}  # Dicionário de UF -> ID do estado

# 3. Preencher a tabela 'cidade' usando a API do IBGE
for uf, estado_id in estado_dict.items():
    print(f"Buscando cidades para o estado: {uf}")
    API_URL = f"https://servicodados.ibge.gov.br/api/v1/localidades/estados/{uf}/municipios"
    response = requests.get(API_URL)
    
    if response.status_code == 200:
        municipios = response.json()
        for municipio in municipios:
            nome_cidade = municipio['nome']
            cursor.execute("INSERT INTO cidade (nome, estado_id) VALUES (%s, %s)", 
                           (nome_cidade, estado_id))
        db.commit()
        print(f"Cidades do estado {uf} inseridas com sucesso!")
    else:
        print(f"Erro ao buscar cidades para {uf}: {response.status_code}")

# Fechar conexões
cursor.close()
db.close()
print("Dados inseridos com sucesso!")
