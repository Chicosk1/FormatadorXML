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
