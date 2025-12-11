# **Formatador de XML – NFe 4.00**

Ferramenta composta por dois módulos — **Python + Delphi** — desenvolvida para automatizar o processo de leitura, análise e substituição de dados de arquivos XML de Notas Fiscais eletrônicas (NFe).  
O objetivo é padronizar informações dos documentos com base em dados oficiais presentes em banco de dados corporativos, garantindo consistência e integridade fiscal.

---

## **Arquitetura Geral**

O projeto é dividido em duas camadas principais:

---

### **1. Módulo Python – Leitura e Interpretação de XML**

Responsável por:

- Ler automaticamente arquivos XML em uma pasta configurada  
- Interpretar tags principais (emitente, destinatário, produtos, pagamentos etc.)  
- Tratar XMLs da NFe 4.00  
- Estruturar as informações usando arquitetura **MVC**  
- Enviar os dados extraídos ao servidor Delphi para validação e substituição  

---

### **2. Servidor Delphi – Consulta e Substituição de Dados**

Responsável por:

- Receber via API os dados interpretados pelo módulo Python  
- Coletar informações corretas em banco de dados (Oracle ou outro configurado)  
- Validar CNPJ, produtos, CFOP, pagamentos, estabelecimentos etc.  
- Devolver os dados atualizados para o Python  
- Garantir a consistência fiscal da nota antes da regravação  

---

## **Fluxo do Processo**

1. Python monitora uma pasta e identifica XMLs disponíveis  
2. Cada XML é interpretado e convertido em estrutura de dados  
3. Os dados lidos são enviados ao servidor Delphi  
4. Delphi consulta o banco de dados e retorna as informações corretas  
5. Python substitui no XML os valores inconsistentes  
6. O sistema salva o XML ajustado em uma nova pasta  

---

## **Arquitetura do Projeto Python**

```
xml_processor/
│
├── controllers/
│   └── xml_controller.py
│
├── services/
│   ├── xml_reader.py
│   └── xml_utils.py
│
├── models/
│   └── nfe_models.py
│
└── main.py
```

---

## **Arquitetura do Projeto Delphi**

```
DelphiApp/
│
├── Controllers/
│   └── MainController.pas
│
├── Models/
│
├── Services/
│   └── ConnectionService.pas
│
├── Views/
│   └── MainForm.pas
│
└── DelphiApp.dpr
```

### **O servidor Delphi:**

- expõe endpoints REST  
- recebe dados do XML  
- consulta banco Oracle/Firebird/SQL Server  
- devolve dados oficiais  
- atua como backend fiscal de validação  

---

## **Tecnologias Utilizadas**

### **Python**
- XML ElementTree  
- Arquitetura MVC  
- Programação orientada a objetos  

### **Delphi**
- RAD Studio  
- MVC adaptado  
- FireDAC  
- Servidor REST (Horse, DMVCFramework ou equivalente)

### **Bancos de Dados**
- Oracle (principal)  
- Possibilidade de expansão para outros bancos  

---

## **Como Executar o Projeto Python**

1. Clone o repositório:

 - git clone https://github.com/Chicosk1/FormatadorXML

2. Entre na pasta:

 - cd formatador-xml/xml_processor

3. Execute o script principal:

 - python main.py


4. Escolha uma pasta com XMLs válidos da NFe 4.00.

---

## **Como Executar o Servidor Delphi**

1. Abra o projeto `DelphiApp.dpr` no RAD Studio  
2. Configure a conexão de banco em `ConnectionService.pas`  
3. Compile e execute  
4. O servidor ficará disponível para receber dados do Python  

---

## **Pontos Fortes do Projeto**

- Estrutura modular e extensível  
- Separação clara de responsabilidades  
- Fácil manutenção  
- Fácil inclusão de novos campos
- Integração direta com banco de dados  
- Processo automatizado para reescrita do XML  
- Fluxo limpo entre leitura, validação e substituição  

---

## **Roadmap**

- Implementar cache de consultas para melhorar performance  
- Tratar XMLs rejeitados ou incompletos  
- Adicionar logs estruturados  
- Criar testes unitários e testes integrados  
- Suporte ao CT-e e MDF-e