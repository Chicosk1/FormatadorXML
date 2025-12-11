import xml.etree.ElementTree as ET
from services.xml_utils import get, get_list
from models.nfe_model import Produto, NotaFiscal

def parse_produto(node):
    prod_node = node.find("nfe:prod", {"nfe": "http://www.portalfiscal.inf.br/nfe"})
    return Produto(
        codigo    = prod_node.findtext("nfe:cProd", None, {"nfe": "http://www.portalfiscal.inf.br/nfe"}),
        descricao = prod_node.findtext("nfe:xProd", None, {"nfe": "http://www.portalfiscal.inf.br/nfe"}),
        ncm       = prod_node.findtext("nfe:NCM"  , None, {"nfe": "http://www.portalfiscal.inf.br/nfe"}),
        cfop      = prod_node.findtext("nfe:CFOP" , None, {"nfe": "http://www.portalfiscal.inf.br/nfe"}),
    )

def ler_xml(caminho) -> NotaFiscal:
    tree = ET.parse(caminho)
    root = tree.getroot()

    emitente       = get(root, "emit/CNPJ")
    destinatario   = get(root, "dest/CNPJ", "dest/CPF")

    produtos_nodes = get_list(root, "det")
    produtos       = [parse_produto(n) for n in produtos_nodes]

    return NotaFiscal(emitente, destinatario, produtos)
