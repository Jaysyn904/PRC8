/*
12/10/19 by Stratovarius

Trail of Haze

Apprentice, Night's Long Fingers 
Level/School: 2nd/Transmutation 
Range: Personal 
Target: You 
Duration: Instantaneous

Upon casting, the target seems almost to leak smoke. A tiny plume of jet-black mist emerges from his flesh, first in a trickle, then an ever-increasing stream.

Acts as per the Locate Creature spell 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {              
        myst.fDur = 60.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;

        SetLocalInt(oShadow, "ScryCasterLevel", myst.nShadowcasterLevel);
        SetLocalInt(oShadow, "ScrySpellId", myst.nMystId);
        SetLocalInt(oShadow, "ScrySpellDC", myst.nSaveDC);
        SetLocalFloat(oShadow, "ScryDuration", myst.fDur);       
        
        StartDynamicConversation("prc_scry_conv", oShadow, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oShadow);             
    }
}