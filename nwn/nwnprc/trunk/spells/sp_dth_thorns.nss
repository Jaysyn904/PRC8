//::///////////////////////////////////////////////
//:: Name      Death by Thorns
//:: FileName  sp_dth_thorns.nss
//:://////////////////////////////////////////////
/**@file Death by Thorns
Conjuration (Creation) [Evil, Death]
Level: Corrupt 7
Components: V, S, Corrupt
Casting Time: 1 action
Range: Touch
Targets: Up to three creatures, no two of which can
be more than 15 ft. apart
Duration: Instantaneous
Saving Throw: Fortitude partial
Spell Resistance: Yes

The caster causes thorns to sprout from the insides
of the subject creatures, which writhe in agony for
1d4 rounds, incapacitated, before dying. A wish or
miracle spell cast on a subject during this time can
eliminate the thorns and save that creature.
Creatures that succeed at their Fortitude saving
throws are still incapacitated for 1d4 rounds in
horrible agony, taking 1d6 points of damage per round.
At the end of the agony, however, the thorns disappear.

Corruption Cost: 1d3 points of Wisdom drain.

Author:    Tenjac
Created:
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void DamageLoop(object oTarget, int nCount, object oPC)
{
	int nDam = SpellDamagePerDice(oPC, 1) + d6(1);
    effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);
    nCount--;

    if(nCount > 0)
    {
        DelayCommand(6.0f, DamageLoop(oTarget, nCount, oPC));
    }
}

void main()
{
    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    // Run the spellhook.
    if (!X2PreSpellCastCode()) return;

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nTargetCount;
    location lTarget = GetLocation(oTarget);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nDC = PRCGetSaveDC(oTarget, oPC);
    int nDelay;
    float fDuration;
    effect ePar = EffectCutsceneImmobilize();
    effect eDeath = EffectDeath();

    PRCSignalSpellEvent(oTarget, TRUE, SPELL_DEATH_BY_THORNS, oPC);

    //Check Spell Resistance
    if (!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        //loop the thorn giving              max 3 targets
        while(GetIsObjectValid(oTarget) && nTargetCount < 3)
        {

        //if target isn't a friend
        if(!GetIsFriend(oTarget, oPC))
        {
            nDelay = d4(1);
            fDuration = RoundsToSeconds(nDelay);

            //Immobilize target
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, fDuration);

            //Loop torture animation
            ActionPlayAnimation(ANIMATION_LOOPING_SPASM, 1.0, fDuration);

            //Give thorns if spell if failed save
            if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_DEATH))
            {
                DeathlessFrenzyCheck(oTarget);
                DelayCommand(fDuration, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDeath, oTarget));
            }

            else
            {
                if(!GetHasMettle(oTarget, SAVING_THROW_FORT))
                {
                    int nCount = nDelay;
                    DamageLoop(oTarget, nCount, oPC);
                }
            }

            //Increment targets
            nTargetCount++;
        }

            //Get next creature within 15 ft
            oTarget = GetNextObjectInShape(SHAPE_SPHERE, 7.5f, lTarget, FALSE, OBJECT_TYPE_CREATURE);
        }
    }

    //Corruption cost

    DoCorruptionCost(oPC, ABILITY_WISDOM, d3(1), 1);

    //Alignment Shift
    //SPEvilShift(oPC);

    //Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
    AdjustAlignment(oPC, ALIGNMENT_EVIL, 10, FALSE);

    PRCSetSchool();
}
