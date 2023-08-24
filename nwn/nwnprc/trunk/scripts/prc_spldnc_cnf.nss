//::///////////////////////////////////////////////
//:: Spelldancer Confuse
//:://////////////////////////////////////////////
/*
    Creatures become confused
*/

#include "prc_inc_spells"  
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;
    
    //Declare major variables
    effect eImpact = EffectVisualEffect(VFX_FNF_LOS_NORMAL_20);
    effect eSleep =  PRCEffectConfused();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_SLEEP);
    int nDC = 10 + GetLevelByClass(CLASS_TYPE_SPELLDANCER, OBJECT_SELF) + GetAbilityModifier(ABILITY_CHARISMA, OBJECT_SELF);
    location lTarget = PRCGetSpellTargetLocation();

    effect eLink = EffectLinkEffects(eSleep, eMind);
    eLink = EffectLinkEffects(eLink, eDur);

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    int nDuration = GetLevelByClass(CLASS_TYPE_SPELLDANCER, OBJECT_SELF);
    int nPenetr = CasterLvl + SPGetPenetr();

    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, lTarget);

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_CONFUSION));
            //Get the distance between the explosion and the target to calculate delay
            float fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, CasterLvl, fDelay))
            {
                //Make Will Save to negate effect
                if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, nDuration*6.0, TRUE, PRCGetSpellId(), CasterLvl, OBJECT_SELF);
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                }    
            }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_MEDIUM, lTarget, TRUE, OBJECT_TYPE_CREATURE);
    }
       }
