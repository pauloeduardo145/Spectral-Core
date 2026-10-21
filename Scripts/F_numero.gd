extends Label

func _process(_delta):
    var player = get_node_or_null("/root/Main/Player")

    if player != null:
        text = str(Global.fantasmas_eliminados)