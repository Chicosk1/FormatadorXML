import sys
from pathlib import Path
from lxml import etree

def validar_estrutura_xml(caminho_do_arquivo: Path) -> bool:
    if not caminho_do_arquivo.exists():
        print(f"ERRO: O arquivo '{caminho_do_arquivo}' não foi encontrado.")
        return False

    try:
        etree.parse(str(caminho_do_arquivo))
        print(f"SUCESSO: A estrutura do XML '{caminho_do_arquivo.name}' é válida.")
        return True
        
    except etree.XMLSyntaxError as erro_sintaxe:
        print(f"ERRO DE SINTAXE: O XML '{caminho_do_arquivo.name}' é inválido. Detalhes: {erro_sintaxe}")
        return False
    except Exception as erro_inesperado:
        print(f"ERRO INESPERADO ao processar '{caminho_do_arquivo.name}': {erro_inesperado}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso correto: python xml_validator.py <caminho_do_arquivo_xml>")
        sys.exit(1)

    caminho_xml = Path(sys.argv[1])
    
    sucesso_na_validacao = validar_estrutura_xml(caminho_xml)
    
    if sucesso_na_validacao:
        sys.exit(0)
    else:
        sys.exit(1)