class_name Threadpool

var threads=[];
var _queue=[];
var _delete=[];
var mutex=Mutex.new();
var kill:bool=false;

func add(task:Callable):
	mutex.lock();
	_queue.push_back(task);
	mutex.unlock();

func next():
	mutex.lock();
	if(_queue.is_empty()):
		mutex.unlock();
		return null;
	else:
		var ret=_queue[0];
		_queue.pop_front();
		mutex.unlock();
		return ret;

func loop():
	
	var killme=false;
	while(!killme):
		mutex.lock();
		killme=kill;
		mutex.unlock();
		var task=next();
		if(task!=null):
			task.call();
		else:
			OS.delay_msec(1);


func start():
	for n in range(8):
		var thread=Thread.new();
		thread.start(loop);
		threads.push_back(thread);

func stop():
	mutex.lock();
	kill=true;
	mutex.unlock();
	for thread in threads:
		thread.wait_to_finish();
