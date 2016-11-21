extends Node

signal timer_end

func _wait( seconds ):
    self._create_timer(self, seconds, true, "_emit_timer_end_signal")
    yield(self, "timer_end")

func _emit_timer_end_signal():
    emit_signal("timer_end")

func _create_timer(object_target, float_wait_time, bool_is_oneshot, string_function):
    var timer = Timer.new()
    timer.set_one_shot(bool_is_oneshot)
    timer.set_timer_process_mode(0)
    timer.set_wait_time(float_wait_time)
    timer.connect("timeout", object_target, string_function)
    self.add_child(timer)
    timer.start()
