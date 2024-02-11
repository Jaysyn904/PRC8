#include "tetris_inc"
void main()
{
    SignalEvent(GetArea(OBJECT_SELF),
        EventUserDefined(TETRIS_EVENT_RIGHT));
}
