try {
    var lines = [];
    var consoleLength = __CONSOLE_LINE_COUNT__;

    function print_msg(msg) {
        lines.push(msg);
        if (lines.length > consoleLength)
            lines.shift();

        for (var i = 0; i < lines.length; i++) {
            var row = lines[i];
            globalThis.getField("console_" + (i)).value = row;
        }
    }

    print_msg("===");
    print_msg("Welcome to llm.pdf!")
    print_msg("This is a proof-of-concept demo for running LLMs completely locally in a PDF.");
    print_msg("");
    print_msg("Begin by entering a prompt below.");
    print_msg(" - Press Ask to run inference with chat template.");
    print_msg(" - Press Complete to run a standard completion.");
    print_msg("");
    print_msg("Configuration:");
    print_msg(" - Tok Out: Max number of output tokens to inference (significantly increases processing time)");
    print_msg(" - Ctx Len: Context length to use");
    print_msg("");
    print_msg("Disclaimers:");
    print_msg(" - llm.pdf does not save chat history (Even if you use Ask). Each request is independent.");
    print_msg(" - Inference is very slow (up to 5 seconds per token input/output), so be patient!");
    print_msg(" - Q1 (fastest) and Q8 (fast) quantizations are most optimal, with all other options being slower.");
    print_msg("");
    print_msg("The current model file loaded is: __FILE_NAME__");
    print_msg("Powered by llama.cpp 3226 (dd047b47) built with emsdk 1.39.20");
    print_msg("===");

    function runLlamaCompletion() {
        runLlamaInference(globalThis.getField("promptInput").value)
    }

    function runLlamaAsk() {
        runLlamaInference("<|im_start|>user\n" + globalThis.getField("promptInput").value + "<|im_end|>\n<|im_start|>assistant\n")
    }



    function runLlamaInference(prompt) {
        var Module = {};

        print_msg("Started Processing");

        Module.print = function (msg) {
            print_msg(msg)
        }

        Module.printErr = function (msg) {
            print_msg(msg);
        }

        function write_file(filename, data) {
            let stream = FS.open("/" + filename, "w+");
            FS.write(stream, data, 0, data.length, 0);
            FS.close(stream);
            print_msg("Model loaded");
        }

        function b64_to_uint8array(str) {
            const lookupTable = new Uint8Array(123);
            "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/".split('').forEach((c, i) => {
                lookupTable[c.charCodeAt(0)] = i;
            });

            const resultLength = Math.floor(str.length / 4) * 3;
            const result = new Uint8Array(resultLength);
            let resultIndex = 0;

            for (let i = 0; i < str.length; i += 4) {
                const v1 = lookupTable[str.charCodeAt(i)];
                const v2 = lookupTable[str.charCodeAt(i + 1)];
                const v3 = lookupTable[str.charCodeAt(i + 2)];
                const v4 = lookupTable[str.charCodeAt(i + 3)];

                result[resultIndex++] = (v1 << 2) | (v2 >> 4);
                if (str[i + 2] !== '=') {
                    result[resultIndex++] = ((v2 & 15) << 4) | (v3 >> 2);
                    if (str[i + 3] !== '=') {
                        result[resultIndex++] = ((v3 & 3) << 6) | v4;
                    }
                }
            }

            return result.slice(0, resultIndex);
        }

        var file_name = "model.gguf";
        var file_data = b64_to_uint8array("__GGUF_FILE__");

        Module.arguments = ["-m", "model.gguf", "-p", prompt, "-c", String(globalThis.getField("context").value), "-n", String(globalThis.getField("tokenCount").value), "-fa", "--no-mmap", "--no-kv-offload", "--mlock", "--repeat-penalty", "1.0067", "--top-k", "2"];

        globalThis.getField("promptInput").value = "";

        // __MODULE_CODE__
    }
} catch (e) { app.alert(e.stack || e) }