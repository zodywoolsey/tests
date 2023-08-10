extends Control

var client = HTTPClient.new()
var request = HTTPRequest.new()
@onready var button = $Button

var downloadUrl = "https://incompetech.com/music/royalty-free/mp3-royaltyfree/Ancient%20Winds.mp3"

func _ready():
	button.pressed.connect(func():
		if client.get_status() == HTTPClient.STATUS_CONNECTED:
			print("pressed")
			var res = client.request(HTTPClient.METHOD_GET,downloadUrl,[])
			print('res: ',client.get_status())
			print('stuff: ',await readRequestBytes())
		)
	var res = await connect_to_host("https://incompetech.com")
	assert(res == OK)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func readRequestBytes():
	while client.get_status() == client.STATUS_REQUESTING:
		printraw('.')
		client.poll()
		await get_tree().process_frame
	var readbytes = PackedByteArray()
	while client.get_status() == client.STATUS_BODY:
		printraw('.')
		client.poll()
		var chunk = client.read_response_body_chunk()
		if chunk.size() == 0:
			pass
		else:
			readbytes = readbytes+chunk
		await get_tree().process_frame
	var msg = readbytes.get_string_from_ascii()
	print('bytes: ',readbytes.decode_var())
	return msg

func connect_to_host(url:String):
	var response = client.connect_to_host(url,443)
	assert(response == OK)
	while client.get_status() == client.STATUS_CONNECTING or client.get_status() == client.STATUS_RESOLVING:
		client.poll()
		await get_tree().process_frame
	return response
