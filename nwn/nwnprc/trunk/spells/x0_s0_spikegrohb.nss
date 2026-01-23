//::///////////////////////////////////////////////
//:: Spike Growth: On Heartbeat
//:: x0_s0_spikegroHB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    All creatures within the AoE take 1d4 acid damage
    per round
*/
//:://////////////////////////////////////////////
//:: Created By: Brent Knowles
//:: Created On: September 6, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_spells"
#include "prc_add_spell_dc"

//::///////////////////////////////////////////////
//:: PRCDoSpikeGrowthEffect
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    1d4 damage, plus a 24 hr slow if take damage.
*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void PRCDoSpikeGrowthEffect(object oTarget,int nPenetr)
{
    float fDelay = PRCGetRandomDelay(1.0, 2.2);
    if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, GetAreaOfEffectCreator()))
    {
        //Fire cast spell at event for the target
        SignalEvent(oTarget, EventSpellCastAt(GetAreaOfEffectCreator(), 453));
        //Spell resistance check
        if(!PRCDoResistSpell(GetAreaOfEffectCreator(), oTarget,nPenetr, fDelay))
        {
            int nMetaMagic = PRCGetMetaMagicFeat();
            int nDam = PRCMaximizeOrEmpower(4, 1, nMetaMagic);
            //nDam += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF);

            effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_PIERCING);
            effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);
            //effect eLink = eDam;
            //Apply damage and visuals
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
            DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam/*eLink*/, oTarget));

           // * only apply a slow effect from this spell once
           if (GetHasSpellEffect(453, oTarget) == FALSE)
           {
                //Make a Reflex Save to avoid the effects of the movement hit.
                if(!PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, PRCGetSaveDC(oTarget,GetAreaOfEffectCreator()), SAVING_THROW_ALL, GetAreaOfEffectCreator(), fDelay))
                {
                    effect eSpeed = EffectMovementSpeedDecrease(30);
                    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eSpeed, oTarget, HoursToSeconds(24));
                }
           }
        }
    }
}

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    int nPenetr = SPGetPenetrAOE(GetAreaOfEffectCreator());


    object oTarget;
    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
     PRCDoSpikeGrowthEffect(oTarget,nPenetr);
        //Get next target.
    oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }


DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}
