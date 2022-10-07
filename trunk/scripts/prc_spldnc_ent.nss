//::///////////////////////////////////////////////
//:: Enthrall
//:: sp_enthrall
//:://////////////////////////////////////////////
/*
    Fascinates all creatures in the area (supposed
    to enthrall them, but the effects are close 
    enough).
*/

#include "prc_inc_spells"  
#include "prc_add_spell_dc"

void DoConcLoop(object oPC, float fDur, int nCounter, object oTarget)
{
    if((nCounter == 0) || GetBreakConcentrationCheck(oPC) > 0)
    {
        PRCRemoveSpellEffects(SPELLDANCE_ENTHRALL, oPC, oTarget);
    }
    
    else
    {
        nCounter--;
        DelayCommand(6.0f, DoConcLoop(oPC, fDur, nCounter, oTarget));
    }
}

void main()
{
    if(!X2PreSpellCastCode()) return;
    
    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);

    //Declare major variables
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eSleep =  EffectFascinate();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_SPELLDANCER, OBJECT_SELF) + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);

    effect eLink = EffectLinkEffects(eSleep, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDuration = 1;
    int nPenetr = CasterLvl + SPGetPenetr();
    location lTarget = PRCGetSpellTargetLocation();
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) && oTarget != OBJECT_SELF)
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELLDANCE_ENTHRALL));
            //Get the distance between the explosion and the target to calculate delay
            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, CasterLvl, fDelay))
            {
                //Make Will Save to negate effect
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC+4, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, HoursToSeconds(nDuration), TRUE, PRCGetSpellId(), CasterLvl, OBJECT_SELF);
                    //Start conc monitor
                    DelayCommand(6.0f, DoConcLoop(OBJECT_SELF, HoursToSeconds(nDuration), 600, oTarget));
                }    
            }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
       
    PRCSetSchool();
}
