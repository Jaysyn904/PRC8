
#include "prc_alterations"
#include "prc_inc_spells"
#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if (!PreInvocationCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

    //Declare major variables
    object oTarget;
    object oPC = OBJECT_SELF;
    int CasterLvl = GetInvokerLevel(oPC, GetInvokingClass());
    int nPenetr = SPGetPenetrAOE(oPC);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis2 = EffectVisualEffect(VFX_IMP_DESTRUCTION);
    effect eVis = EffectVisualEffect(VFX_IMP_EVIL_HELP);
    
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    
    
    oTarget = GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oPC), TRUE,
                                    OBJECT_TYPE_CREATURE, GetPosition(oPC));
    while(GetIsObjectValid(oTarget))
    {

        int iHP = GetCurrentHitPoints(oTarget);
        int nBonus = GetHitDice(oTarget);
        if(nBonus > 10) nBonus = 10;
        effect eHP = EffectTemporaryHitpoints(nBonus);
        effect eLink = EffectLinkEffects(eHP, eDur);
    
        
        //Resist magic check
    
        if (iHP < 0)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(oPC, INVOKE_SOULREAVING_AURA));
            
            if(!PRCDoResistSpell(oPC, oTarget,nPenetr))
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(1), oTarget);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis2, oTarget);
                iHP--;
                
                if(iHP < -9)
                {
                        //Apply the bonuses to the PC
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(1),TRUE,-1,CasterLvl);
                    
                }
            }
    
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(10.0), GetLocation(oPC), TRUE,
                                    OBJECT_TYPE_CREATURE, GetPosition(oPC));
    }

}

