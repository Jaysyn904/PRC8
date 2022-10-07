/*
18/02/19 by Stratovarius

Ephemeral Image

Master, Dark Metamorphosis 
Level/School: 7th/Illusion (Shadow) 
Effect: One shadow duplicate 
Duration: 1 minute/level 
Saving Throw: None 
Spell Resistance: No

You detach your own shadow and animate it with extraplanar energies, creating a dark-hued, hazy duplicate of yourself.

This mystery functions like the spell project image, except as noted above. 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "prc_inc_scry"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.fDur = TurnsToSeconds(myst.nShadowcasterLevel);
        if(myst.bExtend) myst.fDur *= 2;      
        SetLocalInt(oShadow, "ScryCasterLevel", myst.nShadowcasterLevel);
        SetLocalInt(oShadow, "ScrySpellId", myst.nMystId);
        SetLocalInt(oShadow, "ScrySpellDC", GetShadowcasterDC(oShadow));
        SetLocalFloat(oShadow, "ScryDuration", myst.fDur);  
        
        ScryMain(oShadow, oShadow);
    }
}