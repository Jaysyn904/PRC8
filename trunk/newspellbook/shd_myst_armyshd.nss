/*
18/02/19 by Stratovarius

Army of Shadow

Master, Shadow Calling 
Level/School: 9th/Conjuration (Summoning) 
Range: Close (25 ft. + 5 ft./2 levels) 
Effect: One summoned creature
Duration: 1 minute/ level

Reality seems to tear open, revealing a dark rift. From the blackness, a shadow elemental emerges. 

This mystery functions like the spell summon monster I, except as noted here. You can summon one Elder shadow elemental.
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
        
        MultisummonPreSummon();
        // Duration Effects
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, EffectSummonCreature("shd_shdelem_eldr", VFX_FNF_SUMMON_NATURES_ALLY_1), PRCGetSpellTargetLocation(), myst.fDur);             
        
        DelayCommand(0.5, AugmentSummonedCreature("shd_shdelem_eldr"));
    }
}