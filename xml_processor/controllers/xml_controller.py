import os
from services.xml_reader import ler_xml

class XmlController:

    def carregar_pasta(self, pasta: str):
        if not os.path.isdir(pasta):
            raise ValueError("Pasta inválida")

        return [
            f for f in os.listdir(pasta)
            if f.lower().endswith(".xml")
        ]

    def carregar_xml(self, caminho):
        nota = ler_xml(caminho)

        return {
            "emitente"     : nota.emitente,
            "destinatario" : nota.destinatario,
            "qtd_itens"    : nota.qtd_itens,
            "produtos"     : [
                {
                    "codigo"    : p.codigo,
                    "descricao" : p.descricao,
                    "ncm"       : p.ncm,
                    "cfop"      : p.cfop,
                }
                for p in nota.produtos
            ]
        }
