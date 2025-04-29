extends Control

const expected_length := 54


func benchmark(fn: Callable, iterations: int) -> int:
    var t0 := Time.get_ticks_usec()
    fn.call(iterations)
    var t1 := Time.get_ticks_usec()
    return t1 - t0


# ---- return class benchmark -----------------------------------------------
class Results:
    var value: int
    var vector: Vector2
    var text: String
    func _init(v1: int, v2: Vector2, v3: String) -> void:
        value = v1
        vector = v2
        text = v3


func return_class() -> Results:
    return Results.new(42, Vector2(1.0, 2.0), "some fancy text")


func bench_class(iterations: int) -> void:
    for i in iterations:
        var ret := return_class()
        var s := "value: %d, vector: %s, text: \"%s\"" % [ret.value, ret.vector, ret.text]
        if len(s) != expected_length:
            print("string should be length %d but is %d instead" % [expected_length, len(s)])


# ---- return array benchmark -----------------------------------------------
func return_array() -> Array:
    return [42, Vector2(1.0, 2.0), "some fancy text"]


func bench_array(iterations: int) -> void:
    for i in iterations:
        var ret := return_array()
        var s := "value: %d, vector: %s, text: \"%s\"" % [ret[0], ret[1], ret[2]]
        if len(s) != expected_length:
            print("string should be length %d but is %d instead" % [expected_length, len(s)])


# ---- return dictionary benchmark ------------------------------------------
func return_dictionary() -> Dictionary:
    return {"value": 42, "vector": Vector2(1.0, 2.0), "text": "some fancy text"}


func bench_dictionary(iterations: int) -> void:
    for i in iterations:
        var ret := return_dictionary()
        var s := "value: %d, vector: %s, text: \"%s\"" % [ret["value"], ret["vector"], ret["text"]]
        if len(s) != expected_length:
            print("string should be length %d but is %d instead" % [expected_length, len(s)])


# ---- UI stuff -------------------------------------------------------------
var best_class_result := 9223372036854775807
var best_array_result := 9223372036854775807
var best_dictionary_result := 9223372036854775807


func run_benchmark_and_update_ui(benchmark_function: Callable, iterations: int, best_result: int, last_result_label: Node, best_result_label: Node) -> int:
    var t := benchmark(benchmark_function, iterations)
    (last_result_label as Label).text = "%d μs" % t
    if t < best_result:
        (best_result_label as Label).text = "best: %d μs" % t
        best_result = t
    return best_result


func _on_benchmark_class_button_pressed() -> void:
    best_class_result = run_benchmark_and_update_ui(bench_class, int((%IterationsLineEdit as LineEdit).text), best_class_result, %ResultsClassLabel, %BestResultClassLabel)


func _on_benchmark_array_button_pressed() -> void:
    best_array_result = run_benchmark_and_update_ui(bench_array, int((%IterationsLineEdit as LineEdit).text), best_array_result, %ResultsArrayLabel, %BestResultArrayLabel)


func _on_benchmark_dictionary_button_pressed() -> void:
    best_dictionary_result = run_benchmark_and_update_ui(bench_dictionary, int((%IterationsLineEdit as LineEdit).text), best_dictionary_result, %ResultsDictionaryLabel, %BestResultDictionaryLabel)


func _on_iterations_line_edit_text_changed(_new_text: String) -> void:
    best_class_result = 9223372036854775807
    best_array_result = 9223372036854775807
    best_dictionary_result = 9223372036854775807
    (%BestResultClassLabel as Label).text = ""
    (%BestResultArrayLabel as Label).text = ""
    (%BestResultDictionaryLabel as Label).text = ""
