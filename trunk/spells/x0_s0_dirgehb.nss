//::///////////////////////////////////////////////
//:: Dirge: Heartbeat
//:: x0_s0_dirgeHB.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: May 17, 2001
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"

//::///////////////////////////////////////////////
//::
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Applies the ability score damage of the dirge effect.

    March 2003
    Because ability score penalties do not stack, I need
    to store the ability score damage done
    and increment each round.
    To that effect I am going to update the description and
    remove the dirge effects if the player leaves the area of effect.

*/
//:://////////////////////////////////////////////
//:: Created By:
//:: Created On:
//:://////////////////////////////////////////////

void main()
{
    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oCaster = GetAreaOfEffectCreator();
    int nPenetr = SPGetPenetrAOE(oCaster);

    //Start cycling through the AOE Object for viable targets including doors and placable objects.
    object oTarget = GetFirstInPersistentObject(OBJECT_SELF);
    while(GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, oCaster))
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_DIRGE));
            //Spell resistance check
            if(!PRCDoResistSpell(oCaster, oTarget, nPenetr))
            {
                //Make a Fortitude Save to avoid the effects of the movement hit.
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, PRCGetSaveDC(oTarget, oCaster), SAVING_THROW_ALL, oCaster))
                {
                    int nGetLastPenalty = GetLocalInt(oTarget, "X0_L_LASTPENALTY");
                    // * increase penalty by 2
                    nGetLastPenalty = nGetLastPenalty + 2;

                    //effect eStr = EffectAbilityDecrease(ABILITY_STRENGTH, nGetLastPenalty);
                    //effect eDex = EffectAbilityDecrease(ABILITY_DEXTERITY, nGetLastPenalty);
                    //change from sonic effect to bard song...
                    effect eVis =    EffectVisualEffect(VFX_FNF_SOUND_BURST);
                    //effect eLink = EffectLinkEffects(eDex, eStr);

                    //Apply damage and visuals
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    //ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                    ApplyAbilityDamage(oTarget, ABILITY_STRENGTH, nGetLastPenalty, DURATION_TYPE_PERMANENT, TRUE);
                    ApplyAbilityDamage(oTarget, ABILITY_DEXTERITY, nGetLastPenalty, DURATION_TYPE_PERMANENT, TRUE);
                    SetLocalInt(oTarget, "X0_L_LASTPENALTY", nGetLastPenalty);
                }
            }
        }
        //Get next target.
        oTarget = GetNextInPersistentObject(OBJECT_SELF);
    }
    PRCSetSchool();
}