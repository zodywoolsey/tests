extends GraphEdit

@export var root : Node
var prevRoot : Node

var tree = {}

func _ready():
	if !root:
		root = get_tree().get_first_node_in_group('scriptRoot')
		print('got script root')
	getNodeTree(root)
	prevRoot = root
	connection_request.connect(func(fnode,fport,tnode,tport):
		connect_node(fnode,fport,tnode,tport)
		
#		print(get_connection_list())
		)
	disconnection_request.connect(func(fnode,fport,tnode,tport):
		disconnect_node(fnode,fport,tnode,tport)
		
#		print(get_connection_list())
		)

func _process(delta):
	if prevRoot != root:
		getNodeTree(root)

func getNodeTree(startNode:Node):
	for a in startNode.get_children():
		print(a)
