#include "VGA.h"
#include "Port.h"

#define VGA_START 0xb8000
#define VGA_WIDTH 80
#define VGA_SIZE (VGA_WIDTH * 25)

#define CURSOR_PORT_COMMAND ((u16) 0x3d4)
#define CURSOR_PORT_DATA    ((u16) 0x3d5)


typedef struct __attribute__((packed)) {
    char character;
    char style;
} VGAChar;


static VGAChar *text_area = (VGAChar *) VGA_START;


static u8 ToColor(u8 background_color, u8 cursor_color) {
    return (background_color << 4) | (cursor_color & 0x0f);
}

static u16 GetCursorPosition() {
    u16 position = 0;
    WriteByte(CURSOR_PORT_COMMAND, 0xf);
    // position |= ReadByte(CURSOR_PORT_DATA);
    // WriteByte(CURSOR_PORT_COMMAND, 0xe);
    // position |= ReadByte(CURSOR_PORT_DATA);
    return position;
}

static void AdvanceCursor() {
    u16 cursor_position = GetCursorPosition();
}

void ClearText(u8 background_color, u8 cursor_color) {
    VGAChar clear_char;
    clear_char.character = ' ';
    clear_char.style = ToColor(background_color, cursor_color);
    for (u32 i = 0; i < VGA_SIZE; ++i) {
        text_area[i] = clear_char;
    }
}

void WriteText(char *str, u8 background_color, u8 cursor_color) {
    VGAChar char_info;
    char_info.style = ToColor(background_color, cursor_color);
    for(u32 i = 0; str[i] != '\0'; ++i){
        if (i >= VGA_SIZE) {
            break;
        }

        char_info.character = str[i];
        text_area[i] = char_info;
        AdvanceCursor();
    }
}