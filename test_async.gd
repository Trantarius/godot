extends Node

var mutex:Mutex=Mutex.new();
var task_starts=0;
var task_ends=0;
var roll_count=0;
var pool:Threadpool=Threadpool.new();

signal winner;

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.timeout.connect(func():print(str(task_starts).rpad(8),str(task_ends)));

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
	mutex.lock();
	task_starts+=1;
	mutex.unlock();
	
	if(randi()%100==0):
		winner.emit();
		await get_tree().physics_frame;
		mutex.lock();
		task_ends+=1;
		roll_count=0;
		mutex.unlock();
	else:
		await winner;
		mutex.lock();
		roll_count+=1;
		task_ends+=1;
		mutex.unlock();
	
