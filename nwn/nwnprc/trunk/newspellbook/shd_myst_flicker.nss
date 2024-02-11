/*
13/02/19 by Stratovarius

Flicker

Apprentice, Ebon Whispers 
Level/School: 3rd/Conjuration (Teleportation) 
Range: Personal 
Target: You 
Duration: 1 round/level

You flash through the conduits and pathways of the Plane of Shadow, manifesting in multiple locations in the real world.

Once per round, as an immediate action, you can instantly transfer yourself from your current location to any other spot within a close distance. 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "spinc_dimdoor"

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);

    if(myst.bCanMyst)
    {
        myst.fDur = 6.0 * myst.nShadowcasterLevel;       
        if(myst.bExtend) myst.fDur *= 2;
        // Duration Effects
        object oSkin = GetPCSkin(oShadow);
        itemproperty ipFlick = ItemPropertyBonusFeat(IP_CONST_FEAT_MYST_FLICKER);
        ActionDoCommand(AddItemProperty(DURATION_TYPE_TEMPORARY, ipFlick, oSkin, myst.fDur));
        //IPSafeAddItemProperty(oSkin, ipFlick, myst.fDur, X2_IP_ADDPROP_POLICY_KEEP_EXISTING, FALSE, FALSE);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectVisualEffect(PSI_DUR_TEMPORAL_ACCELERATION), oTarget, myst.fDur, TRUE, myst.nMystId, myst.nShadowcasterLevel);               
    }
}