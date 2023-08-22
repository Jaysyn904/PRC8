//::///////////////////////////////////////////////
//:: Name      Energy Ebb
//:: FileName  sp_energy_ebb.nss
//:://////////////////////////////////////////////
/** @file

    Energy Ebb
    Necromancy (Evil)
    Cleric 7, Sorc/Wiz 7
    Duration 1 round/level
    Saving throw: Fortitude negates

    This spell functions like enervation except that
    the creature struck gains negative levels over an
    extended period. You point your finger and utter
    the incantation, releasing a black needle of
    crackling negative energy that suppresses the life
    force of any living creature it strikes. You must
    make a ranged touch attack to hit. If the attack
    succeeds, the subject immediately gains one negative
    level, then continues to gain another each round
    thereafter as her life force slowly bleeds away. The
    drain can only be stopped by a successful Heal check
    (DC 23) or the application of a heal, restoration, or
    greater restoration spell.

    If the black needle strikes an undead creature, that
    creature gains 4d4 * 5 temporary hp that last for up
    to 1 hour.


    Author:    Tenjac
    Created:   12/07/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void Ebb(object oTarget, int nRounds)
{
    if(GetHasSpellEffect(SPELL_ENERGY_EBB, oTarget))
    {
        effect eLink = EffectLinkEffects(EffectNegativeLevel(1), EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE));

        //apply
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);

        //decrement duration
        nRounds--;

        //check duration
        if(nRounds)
            //Reapply after 1 round
            DelayCommand(6.0f, Ebb(oTarget, nRounds));
    }
}

void main()
{
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);

    //Spellhook
    if (!X2PreSpellCastCode()) return;

    object oTarget = PRCGetSpellTargetObject();

    //if undead
    if(MyPRCGetRacialType(oTarget) == RACIAL_TYPE_UNDEAD)
    {
        PRCSignalSpellEvent(oTarget, FALSE, SPELL_ENERGY_EBB, OBJECT_SELF);

        //roll temp hp
        int nHP = (d4(4) * 5);

        //give temp hp
        effect eHP = EffectTemporaryHitpoints(nHP);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eHP, oTarget, 3600.00);
    }
    //not undead
    else
    {
        PRCSignalSpellEvent(oTarget, TRUE, SPELL_ENERGY_EBB, OBJECT_SELF);
        int nDC = PRCGetSaveDC(oTarget, OBJECT_SELF);
        if(!GetIsImmune(oTarget, IMMUNITY_TYPE_NEGATIVE_LEVEL) && !PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
        {
            //Get duration
            int nLevel = PRCGetCasterLevel();
            int nRounds = nLevel;

            if(PRCGetMetaMagicFeat() & METAMAGIC_EXTEND)
                nRounds *= 2;

            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE)), oTarget, RoundsToSeconds(nRounds), TRUE, SPELL_ENERGY_EBB, nLevel);

            Ebb(oTarget, nRounds);
        }
    }

    //SPEvilShift(oPC);

    PRCSetSchool();
}