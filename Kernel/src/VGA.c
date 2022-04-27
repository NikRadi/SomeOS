#include "VGA.h"
#include "Port.h"

#define VGA_START 0xb8000
#define VGA_HEIGHT 25
#define VGA_WIDTH 80
#define VGA_SIZE (VGA_WIDTH * VGA_HEIGHT)

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
    position |= ReadByte(CURSOR_PORT_DATA);
    WriteByte(CURSOR_PORT_COMMAND, 0xe);
    position |= ReadByte(CURSOR_PORT_DATA);
    return position;
}

static void AdvanceCursor() {
    u16 cursor_position = GetCursorPosition();
    cursor_position += 1;
    if (cursor_position >= VGA_SIZE) {
        cursor_position = VGA_SIZE - 1;
    }

    WriteByte(CURSOR_PORT_COMMAND, 0xf);
    WriteByte(CURSOR_PORT_DATA, (u8) (cursor_position & 0xff));

    WriteByte(CURSOR_PORT_COMMAND, 0xe);
    WriteByte(CURSOR_PORT_DATA, (u8) ((cursor_position >> 8) & 0xff));
}

static void ScrollLine() {
    for (u16 i = 1; i < VGA_HEIGHT; ++i) {
        for (u16 j = 0; j < VGA_WIDTH; ++j) {
            u16 from_position = j + (i * VGA_WIDTH);
            u16 to_position = j + ((i - 1) * VGA_WIDTH);
            text_area[to_position] = text_area[from_position];
        }
    }

    u16 i = VGA_HEIGHT - 1;
    for (u16 j = 0; j < VGA_WIDTH; ++j) {
        u16 position = j + (i * VGA_WIDTH);
        VGAChar current_char = text_area[position];
        VGAChar clear_char;
        clear_char.character = ' ';
        clear_char.style = current_char.style;
        text_area[position] = clear_char;
    }

    SetCursorPosition(0, VGA_HEIGHT - 1);
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

        u16 cursor_position = GetCursorPosition();
        char c = str[i];
        if (c == '\n') {
            u8 current_row = 1 + (u8) (cursor_position / VGA_WIDTH);
            if (current_row >= VGA_HEIGHT) {
                ScrollLine();
            }
            else {
                SetCursorPosition(0, current_row);
            }
        }
        else {
            char_info.character = str[i];
            text_area[cursor_position] = char_info;
            AdvanceCursor();
        }
    }
}

void SetCursorPosition(u8 x, u8 y) {
    u16 cursor_position = x + ((u16) VGA_WIDTH * y);
    if (cursor_position >= VGA_SIZE) {
        cursor_position = VGA_SIZE - 1;
    }

    WriteByte(CURSOR_PORT_COMMAND, 0xf);
    WriteByte(CURSOR_PORT_DATA, (u8) (cursor_position & 0xff));

    WriteByte(CURSOR_PORT_COMMAND, 0xe);
    WriteByte(CURSOR_PORT_DATA, (u8) ((cursor_position >> 8) & 0xff));
}
