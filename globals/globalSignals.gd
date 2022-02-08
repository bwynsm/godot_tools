extends Node


# keeps track of the emitters that have been registered
var _emitters = {}

# Keeps track of what listeners have been registered.
var _listeners = {}


# add a new global emitter
func add_emitter(signal_name: String, emitter: Object) -> void:
	var emitter_data = { 'object': emitter, 'object_id': emitter.get_instance_id() }

	if not _emitters.has(signal_name):
		_emitters[signal_name] = {}

	_emitters[signal_name][emitter.get_instance_id()] = emitter_data

	if _listeners.has(signal_name):
		_connect_emitter_to_listeners(signal_name, emitter)


# Adds a new global listener.
func add_listener(signal_name: String, listener: Object, method: String) -> void:
	var listener_data = { 'object': listener, 'object_id': listener.get_instance_id(), 'method': method }
	if not _listeners.has(signal_name):
		_listeners[signal_name] = {}
	
	_listeners[signal_name][listener.get_instance_id()] = listener_data

	if _emitters.has(signal_name):
		_connect_listener_to_emitters(signal_name, listener, method)



# Connect an emitter to existing listeners of its signal.
func _connect_emitter_to_listeners(signal_name: String, emitter: Object) -> void:
	var listeners = _listeners[signal_name]
	for listener in listeners.values():
		var error = emitter.connect(signal_name, listener.object, listener.method)
		if error != 0:
			print("We have an error connecting listeners")
  
  
# Connect a listener to emitters who emit the signal it's listening for.
func _connect_listener_to_emitters(signal_name: String, listener: Object, method: String) -> void:
	var emitters = _emitters[signal_name]
	for emitter in emitters.values():
		emitter.object.connect(signal_name, listener, method)



# Remove registered emitter and disconnect any listeners connected to it.
func remove_emitter(signal_name: String, emitter: Object) -> void:
	if not _emitters.has(signal_name): 
		return
	if not _emitters[signal_name].has(emitter.get_instance_id()): 
		return  
	  
	_emitters[signal_name].erase(emitter.get_instance_id())
	  
	if _listeners.has(signal_name):
		for listener in _listeners[signal_name].values():
			if emitter.is_connected(signal_name, listener.object, listener.method):
				emitter.disconnect(signal_name, listener.object, listener.method)
  
  
# Remove registered listener and disconnect it from any emitters it was listening to.
func remove_listener(signal_name: String, listener: Object, method: String) -> void:
	if not _listeners.has(signal_name): 
		return
	if not _listeners[signal_name].has(listener.get_instance_id()): 
		return  
	
	_listeners[signal_name].erase(listener.get_instance_id())
	
	if _emitters.has(signal_name):
		for emitter in _emitters[signal_name].values():
			if emitter.object.is_connected(signal_name, listener, method):
				emitter.object.disconnect(signal_name, listener, method)
