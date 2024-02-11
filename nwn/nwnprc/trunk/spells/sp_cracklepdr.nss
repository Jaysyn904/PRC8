///////////////////////////////////////////////////////////////
// Crackle Powder
// sp_cracklepdr.nss
///////////////////////////////////////////////////////////////
/*
Crackle Powder: This alchemical powder creates a loud
crackling noise, like a broomstick breaking, whenever it is
jostled or struck. A single packet covers a 5-foot-radius area;
applying the powder requires a full-round action. Once in
place, the powder remains active for 1 hour and imposes a
-10 penalty on Move Silently checks made when traversing
the area.*/

#include "prc_inc_spells"

void main()
{
        location lLoc = PRCGetSpellTargetLocation();
        effect eAoE = EffectAreaOfEffect(AOE_PER_CRACKLEPOWDER);
        
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DUST_EXPLOSION), lLoc);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAoE, lLoc, HoursToSeconds(1));
}       