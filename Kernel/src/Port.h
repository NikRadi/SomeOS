#ifndef SOMEOS_PORT_H
#define SOMEOS_PORT_H
#include "Types.h"


u8 ReadByte(u16 port);

void WriteByte(u16 port, u8 data);

#endif // SOMEOS_PORTS_H