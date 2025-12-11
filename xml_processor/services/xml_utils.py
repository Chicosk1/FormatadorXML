NFE_NS = {"nfe": "http://www.portalfiscal.inf.br/nfe"}

def path(tag: str) -> str:
    return ".//" + "/".join(f"nfe:{p}" for p in tag.split("/"))

def get(root, *tags):
    for tag in tags:
        node = root.find(path(tag), NFE_NS)
        if node is not None and node.text:
            return node.text.strip()
    return None

def get_list(root, tag):
    return root.findall(path(tag), NFE_NS)
