#include "inv_inc_invfunc"

void main()
{
    int nSpellID = GetSpellId();
    int nBlast;

    switch(nSpellID)
    {
        case INVOKE_HELLFIRE_BLAST:  nBlast = INVOKE_ELDRITCH_BLAST;  break;
        case INVOKE_HELLFIRE_SPEAR:  nBlast = INVOKE_ELDRITCH_SPEAR;  break;
        case INVOKE_HELLFIRE_GLAIVE: nBlast = INVOKE_ELDRITCH_GLAIVE; break;
        case INVOKE_HELLFIRE_BLOW:   nBlast = INVOKE_HIDEOUS_BLOW;    break;
        case INVOKE_HELLFIRE_CHAIN:  nBlast = INVOKE_ELDRITCH_CHAIN;  break;
        case INVOKE_HELLFIRE_CONE:   nBlast = INVOKE_ELDRITCH_CONE;   break;
        case INVOKE_HELLFIRE_LINE:   nBlast = INVOKE_ELDRITCH_LINE;   break;
        case INVOKE_HELLFIRE_DOOM:   nBlast = INVOKE_ELDRITCH_DOOM;   break;
        default: return;
    }

    SetLocalInt(OBJECT_SELF, "INV_HELLFIRE", TRUE);
    UseInvocation(nBlast, CLASS_TYPE_WARLOCK);
}