extends Node

var mutex:Mutex=Mutex.new();
var roll_count=0;
var pool:Threadpool=Threadpool.new();

signal winner;
var counter:Counter=Counter.new();

class Counter extends Node:
	var value=0;
	var mutex=Mutex.new();
	
	func inc():
		mutex.lock();
		value+=1;
		mutex.unlock();
	
	func val():
		mutex.lock();
		var ret=value;
		mutex.unlock;
		return ret;

# Called when the node enters the scene tree for the first time.
func _ready():
	winner.connect(func():print("winner! took ",counter.val()," attempts"))

func _enter_tree():
	pool.start();
func _exit_tree():
	pool.stop();

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pool.add(task)
	

var last_timeout=0;

func report():
	var now=Time.get_ticks_msec();
	var took=now-last_timeout;
	last_timeout=now;
	print(roll_count,":",took);

func task():
	
	if(randi()%1000==0):
		winner.emit();
		get_tree().physics_frame.connect(func():
			counter.queue_free();
			counter=Counter.new();
		,CONNECT_ONE_SHOT);
	else:
		winner.connect(func():counter.inc(),CONNECT_ONE_SHOT);
	
