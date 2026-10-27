#include <aqua/aqua.h>

static void greeting(aqua_call *call) {
    aqua_return_cstring(call, "Hello from a native SDK library! / 原生函式庫向你問好！");
}
static void echo(aqua_call *call) {
    aqua_return(call, aqua_arg(call, 0));
}
static void sum(aqua_call *call) {
    aqua_runtime *rt = aqua_call_runtime(call);
    aqua_value items = aqua_arg(call, 0);
    double result = 0;
    for (uint32_t i = 0; i < aqua_array_length(rt, items); ++i) {
        aqua_value item = aqua_array_get(rt, items, i);
        if (!aqua_is_number(item)) { aqua_fail(call, "Sum expects numeric array elements"); return; }
        result += item.number;
    }
    aqua_return_double(call, result);
}
AQUA_LIBRARY(showcase) {
    aqua_class *module = aqua_define_module(library, "Showcase|動態連結範例");
    aqua_define_function(module, "Greeting|問候", greeting, "");
    aqua_define_function(module, "Echo|回音", echo, "s");
    aqua_define_function(module, "Sum|總和", sum, "a");
}
