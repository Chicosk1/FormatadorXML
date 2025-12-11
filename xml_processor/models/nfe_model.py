class Produto:
    def __init__(self, codigo, descricao, ncm, cfop):
        self.codigo    = codigo
        self.descricao = descricao
        self.ncm       = ncm
        self.cfop      = cfop


class NotaFiscal:
    def __init__(self, emitente, destinatario, produtos):
        self.emitente     = emitente
        self.destinatario = destinatario
        self.produtos     = produtos

    @property
    def qtd_itens(self):
        return len(self.produtos)
