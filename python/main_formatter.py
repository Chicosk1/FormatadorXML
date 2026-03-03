import sys
import json
from pathlib import Path
from lxml import etree

def formatar_valores_do_xml(caminho_xml_origem: Path, caminho_dados_json: Path, caminho_xml_destino: Path) -> bool:
    if not caminho_xml_origem.exists():
        print(f"ERRO: XML de origem '{caminho_xml_origem}' não encontrado.")
        return False
    if not caminho_dados_json.exists():
        print(f"ERRO: Arquivo JSON '{caminho_dados_json}' não encontrado.")
        return False

    try:
        with open(caminho_dados_json, 'r', encoding='utf-8') as arquivo_json:
            parametros_banco = json.load(arquivo_json)

        analisador = etree.XMLParser(remove_blank_text=True)
        arvore_xml = etree.parse(str(caminho_xml_origem), analisador)
        raiz_do_xml = arvore_xml.getroot()

        for nome_da_tag, novo_valor in parametros_banco.items():
            elementos_encontrados = raiz_do_xml.xpath(f"//*[local-name()='{nome_da_tag}']")

            if isinstance(novo_valor, list):

                for indice, elemento in enumerate(elementos_encontrados):
                    if indice < len(novo_valor):
                        elemento.text = str(novo_valor[indice])

            else:
                
                for elemento in elementos_encontrados:
                    elemento.text = str(novo_valor)

        arvore_xml.write(
            str(caminho_xml_destino), 
            encoding="utf-8", 
            xml_declaration=True, 
            pretty_print=True
        )
        
        print(f"SUCESSO: XML parametrizado salvo em '{caminho_xml_destino.name}'.")
        return True

    except Exception as erro:
        print(f"ERRO CRÍTICO na formatação do XML: {erro}")
        return False

if __name__ == "__main__":
    if len(sys.argv) < 4:
        print("Uso correto: python main_formatter.py <xml_origem> <json_dados> <xml_destino>")
        sys.exit(1)

    xml_entrada = Path(sys.argv[1])
    dados_json = Path(sys.argv[2])
    xml_saida = Path(sys.argv[3])

    sucesso_na_formatacao = formatar_valores_do_xml(xml_entrada, dados_json, xml_saida)

    if sucesso_na_formatacao:
        sys.exit(0)
    else:
        sys.exit(1)