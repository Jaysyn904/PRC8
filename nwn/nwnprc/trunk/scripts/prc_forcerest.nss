// This script restores the PC's spell uses, feat, etc., as if rested (for debugging purposes).
// Called from debug console only.

#include "prc_inc_util"

void main()
{
    PRCForceRest(OBJECT_SELF);
}