#include "VGA.h"


int main() {
    SetCursorPosition(0, 0);
    ClearText(COLOR_BLACK, COLOR_WHITE);
    WriteText("Hi", COLOR_BLACK, COLOR_WHITE);
    WriteText("Hello", COLOR_BLACK, COLOR_WHITE);
    return 0;
}
