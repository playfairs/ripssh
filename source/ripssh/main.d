module ripssh.main;

import ripssh.cli.dispatcher : dispatch;

int main(string[] arguments) {
    if (arguments.length == 0) {
        return dispatch([]);
    }

    return dispatch(arguments[1 .. $]);
}
