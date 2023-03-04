extends Timer

var objects=[]
var size=1_000_000

# Called when the node enters the scene tree for the first time.
func _ready():
	objects.resize(size);
	
	var start=Time.get_ticks_msec();
	test_create();
	var diff=Time.get_ticks_msec()-start;
	print("create: ",diff,"ms");
	
	start=Time.get_ticks_msec();
	test_add();
	diff=Time.get_ticks_msec()-start;
	print("add: ",diff,"ms");
	
	start=Time.get_ticks_msec();
	test_connect();
	diff=Time.get_ticks_msec()-start;
	print("connect: ",diff,"ms");
	
	start=Time.get_ticks_msec();
	test_emit();
	diff=Time.get_ticks_msec()-start;
	print("emit: ",diff,"ms");
	
	start=Time.get_ticks_msec();
	test_disconnect();
	diff=Time.get_ticks_msec()-start;
	print("disconnect: ",diff,"ms");
	
	start=Time.get_ticks_msec();
	test_free();
	diff=Time.get_ticks_msec()-start;
	print("free: ",diff,"ms");
	
	get_tree().quit();

func test_create():
	for n in range(size):
		objects[n]=Node.new();

func test_add():
	for n in range(size):
		objects[n].add_user_signal("mysignal");

func test_connect():
	for n in range(size):
		objects[n].connect("mysignal",do_nothing);

func test_emit():
	for n in range(size):
		objects[n].emit_signal("mysignal");

func test_disconnect():
	for n in range(size):
		objects[n].disconnect("mysignal",do_nothing);

func test_free():
	for n in range(size):
		objects[n].free();

func do_nothing():
	pass
