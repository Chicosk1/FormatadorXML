# 📄 FormatadorXML - Engenharia de Integração

Um utilitário de alta performance projetado para processamento em lote de arquivos XML (como NF-e e afins). O sistema atua lendo diretórios, extraindo dados atualizados de bancos de dados Oracle e reescrevendo as tags XML utilizando rotinas em Python via *background process*.

![Delphi](https://img.shields.io/badge/Delphi-VCL-red)
![Python](https://img.shields.io/badge/Python-3.x-blue)
![Oracle](https://img.shields.io/badge/Database-Oracle-lightgrey)
![Architecture](https://img.shields.io/badge/Architecture-MVC%20%2B%20Clean-brightgreen)

## 📌 Regra de Negócio

O objetivo principal deste sistema é viabilizar a "Engenharia Reversa" e o transbordo de XMLs entre bases de dados de clientes diferentes. O fluxo funciona da seguinte forma:

1. **Leitura Visual:** O usuário seleciona um diretório contendo dezenas ou centenas de arquivos `.xml`.
2. **Identificação:** O sistema lê cada arquivo e extrai sua Chave de Acesso.
3. **Consulta SQL:** Com base na chave, o Delphi se conecta ao banco de dados Oracle do cliente de destino e busca as informações reais (Ex: Dados do Destinatário, CFOP, Impostos, etc).
4. **Parametrização:** Um arquivo `.json` temporário é gerado com a instrução exata das tags a serem substituídas.
5. **Formatação Otimizada:** Um *core* em Python lê a estrutura do XML original, busca os Namespaces dinamicamente e injeta os novos dados do Oracle sem quebrar a assinatura e validade do documento.
6. **Entrega:** O novo lote de XMLs formatados é salvo na pasta `Formatados`.

## 🏗️ Arquitetura e Padrões (Stack Técnica)

O projeto foi construído utilizando um rigoroso padrão **MVC (Model-View-Controller)** aliado aos princípios **SOLID** e **Injeção de Dependência**.

### Front-End & Core (Delphi)
* **Camada Visual:** Delphi VCL + UI DevExpress (`TcxGrid` otimizado com `DataController.Values` para alta velocidade).
* **Comunicação DB:** Driver DBExpress devidamente parametrizado via algoritmos nativos de criptografia (`TCryptoUtils`) para arquivos `.conexoes`.
* **Orquestrador:** A classe `Service.ExtratorDados` atua como Maestro, consultando o banco e repassando o payload para interfaces sem travar a thread gráfica (uso de Callbacks/Métodos Anônimos).

### Worker/Manipulação (Python)
* **Por que Python?** XMLs de NF-e possuem complexidades com namespaces (`xmlns="http://www.portalfiscal.inf.br/nfe"`). A biblioteca `lxml` no Python manipula `XPath` de forma extremamente superior e tolerante a falhas.
* A ponte Delphi-Python é feita consumindo a API nativa do Windows (`CreateProcess` em `SW_HIDE`), garantindo processamento invisível e baseando-se em `Exit Codes` para rastrear sucesso ou falhas.

---

## ⚙️ Pré-requisitos e Instalação

### 1. Configuração do Ambiente Python
O executável Delphi depende que o ambiente virtual do Python esteja criado e as bibliotecas instaladas.

Abra o terminal na pasta raiz do projeto e execute:
```bash
# Acesse a pasta python
cd python

# Crie o ambiente virtual (venv)
python -m venv venv

# Ative o ambiente
# No Windows:
venv\Scripts\activate

# Instale as dependências contidas no requirements.txt
pip install -r requirements.txt
```

### 2. Configuração do Arquivo de Conexões (.conexoes)
O sistema lê parâmetros do banco a partir de um arquivo `FormatadorXML.conexoes` no padrão INI. 
Coloque este arquivo na raiz de execução ou no diretório mapeado. 

Exemplo de estrutura:
```ini
[NOME_DO_CLIENTE]
DriverName=DevartOracleDirect
Database=127.0.0.1:30100:ORCL
User_Name=VIASOFTMERC
Password=330370080770270981721821921721821921721821921721821921721821921721821921721620580960470980760861921721821921721821921721821921721821921721821921721821120660
```

### 3. Compilação (Delphi)
1. Abra o arquivo `FormatadorXML.dproj` em uma IDE Delphi compatível.
2. Certifique-se de que as bibliotecas DevExpress estão instaladas no seu ambiente.
3. Compile o projeto para a plataforma alvo (Win32/Win64).

---

## 4. 🚀 Como Usar

1. Execute o `FormatadorXML.exe`.
2. No painel superior, selecione a **Conexão de Banco** desejada.
3. No campo **Diretório dos XMLs**, navegue até a pasta base que contém os XMLs a serem formatados. O Grid será carregado imediatamente.
4. Clique em **Processar XMLs**.
5. Acompanhe a barra de progresso e o status no Grid sendo atualizados em tempo real (MVC Callbacks).
6. Os arquivos resultantes estarão em uma subpasta chamada `Formatados` dentro do diretório original escolhido.

---

## 5. 🛠️ Manutenção da Engenharia Reversa (Mapeamento de Tags)
Para adicionar uma nova tag na regra de substituição (Ex: Inserir um CFOP novo):

1. Vá até a unit `Service.ExtratorDados.pas` no Delphi.
2. Adicione a coluna necessária no `SELECT` da instrução `TSQLQuery`.
3. Utilize a *Fluent Interface* do `GeradorJSON` para incluir a tag mapeando o retorno do banco:

```pascal
oGeradorJSON
  .AdicionarTag('xNome'        , oQuery.FieldByName('xNome').AsString          )
  .AdicionarTag('NOVA_TAG_AQUI', oQuery.FieldByName('NOVA_COLUNA_SQL').AsString);
```
4. Apenas compile o projeto Delphi. O script Python processará a nova regra de forma 100% dinâmica e automática.

---
📝 *Desenvolvido com foco em escalabilidade, manutenibilidade e Clean Architecture.*
