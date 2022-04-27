#include "VGA.h"


int main() {
    SetCursorPosition(0, 0);
    ClearText(COLOR_BLACK, COLOR_WHITE);
    WriteText("Hi0\n", COLOR_BLACK, COLOR_WHITE);
    WriteText("Hi1\n", COLOR_BLACK, COLOR_WHITE);
    WriteText("Hi2\n", COLOR_BLACK, COLOR_WHITE);
    WriteText("Hi3\n", COLOR_BLACK, COLOR_WHITE);
    WriteText("Hi4\n", COLOR_BLACK, COLOR_WHITE);

    return 0;
}
