//::///////////////////////////////////////////////
//:: Sicken Evil: On Enter
//:: sp_sickn_evilA.nss
//:: 
//:://////////////////////////////////////////////
/*
    
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac 
//:: Created On: 6/30/06
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        object oTarget = GetEnteringObject();
        object oPC = GetAreaOfEffectCreator();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        
        //if valid                     and not caster
        if(GetIsObjectValid(oTarget) && oTarget != oPC)
        {
                if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
                {
                        //Spell resistance
                        if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
                        {
                                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectSickened(), oTarget);
                                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_SLOW), oTarget);
                        }
                }
        }
}
                                
                                
                        
                        
                