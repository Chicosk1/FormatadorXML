from controllers.xml_controller import XmlController

if __name__ == "__main__":
    controller = XmlController()
    
    pasta = r"E:\XMLs"
    arquivos = controller.carregar_pasta(pasta)
    print("Arquivos encontrados:", arquivos)

    if arquivos:
        dados = controller.carregar_xml(f"{pasta}\\{arquivos[0]}")
        print("Informações extraídas:")
        print(dados)
