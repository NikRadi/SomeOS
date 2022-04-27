#ifndef SOMEOS_VGA_H
#define SOMEOS_VGA_H
#include "Types.h"

#define COLOR_BLACK         0
#define COLOR_BLUE          1
#define COLOR_GREEN         2
#define COLOR_CYAN          3
#define COLOR_RED           4
#define COLOR_PURPLE        5
#define COLOR_BROWN         6
#define COLOR_GRAY          7
#define COLOR_DARKGRAY      8
#define COLOR_LIGHTBLUE     9
#define COLOR_LIGHTGREEN    10
#define COLOR_LIGHTCYAN     11
#define COLOR_LIGHTRED      12
#define COLOR_LIGHTPURPLE   13
#define COLOR_YELLOW        14
#define COLOR_WHITE         15


void ClearText(u8 background_color, u8 cursor_color);

void WriteText(char *str, u8 background_color, u8 cursor_color);

#endif // SOMEOS_VGA_H