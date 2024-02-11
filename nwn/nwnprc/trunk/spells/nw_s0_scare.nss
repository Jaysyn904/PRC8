//::///////////////////////////////////////////////
//:: [Scare]
//:: [NW_S0_Scare.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is scared for 1d4 rounds.
//:: NOTE THIS SPELL IS EQUAL TO **CAUSE FEAR** NOT SCARE.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 30, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Preston Watamaniuk, On: April 11, 2001
//:: Modified March 2003 to give -2 attack and damage penalties

//:: modified by mr_bumpkin Dec 4, 2003 for PRC stuff
// modified by fluffyamoeba to make scare and cause fear

/**
 * Cause Fear
 *
 * Necromancy [Fear, Mind-Affecting]
 * Level: Brd 1, Clr 1, Death 1, Sor/Wiz 1
 * Components: V, S
 * Casting Time: 1 standard action
 * Range: Close (25 ft. + 5 ft./2 levels)
 * Target: One living creature with 5 or fewer HD
 * Duration: 1d4 rounds or 1 round; see text
 * Saving Throw: Will partial
 * Spell Resistance: Yes
 *
 * The affected creature becomes frightened. If the subject succeeds on a Will save, it is shaken for 1 round.
 * Creatures with 6 or more Hit Dice are immune to this effect.
 *
 * Cause fear counters and dispels remove fear.
 *
 *
 * Scare
 * Necromancy [Fear, Mind-Affecting]
 * Level: Brd 2, Sor/Wiz 2
 * Components: V, S, M
 * Casting Time: 1 standard action
 * Range: Medium (100 ft. + 10 ft./level)
 * Targets: One living creature per three levels, no two of which can be more than 30 ft. apart
 * Duration: 1 round/level or 1 round; see text for cause fear
 * Saving Throw: Will partial
 * Spell Resistance: Yes
 *
 * This spell functions like cause fear, except that it causes all targeted creatures of less than 6 HD to become frightened.
 *
 * Material Component: A bit of bone from an undead skeleton, zombie, ghoul, ghast, or mummy.
 */

#include "prc_inc_spells"
#include "prc_add_spell_dc"




// If the target fails their will save they are frightened, otherwise they are shaken
void ApplyScare(object oTarget, int nDuration);

void main()
{
    // Set the spell school
    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
/*
  Spellcast Hook Code
  Added 2003-06-20 by Georg
  If you want to make changes to all spells,
  check x2_inc_spellhook.nss to find out more

*/

    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }

// End of Spell Cast Hook



    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nMetaMagic = PRCGetMetaMagicFeat();
    int nDuration = d4();
    int nSpellID   = PRCGetSpellId();
    //Do metamagic checks
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration *= 2;
    }

    //Check the Hit Dice of the creature
    if ((GetHitDice(oTarget) < 6) && GetObjectType(oTarget) == OBJECT_TYPE_CREATURE && PRCGetIsAliveCreature(oTarget))
    {
         // * added rep check April 2003
         if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
         {
             //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
            //Make SR check
            if(!PRCDoResistSpell(OBJECT_SELF, oTarget))
            {
                 ApplyScare(oTarget, nDuration);
            }
         }
     }

     if (nSpellID == SPELL_SCARE)
     {
         PRCSetSchool();
         return;
     }

     // how many creatures (we've done one already)
     int nCreatures = (CasterLvl/3)-1;
     if (nCreatures >= 1)
     {
         object oNextTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oTarget), TRUE); // only creatures
         int nCount;
         while (GetIsObjectValid(oNextTarget) && nCount < nCreatures)
         {
             if ((GetHitDice(oNextTarget) < 6) && (oNextTarget != oTarget) && spellsIsTarget(oNextTarget, SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF)
                 && oNextTarget != OBJECT_SELF && PRCGetIsAliveCreature(oNextTarget))
             {
                 //Fire cast spell at event for the specified target
                 SignalEvent(oNextTarget, EventSpellCastAt(OBJECT_SELF, nSpellID));
                 //Make SR check
                 if(!PRCDoResistSpell(OBJECT_SELF, oNextTarget))
                 {
                     ApplyScare(oNextTarget, nDuration);
                 }
                 nCount++;
             }
             oNextTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(oTarget), TRUE); // only creatures
         }
     }

     PRCSetSchool();
}

void ApplyScare(object oTarget, int nDuration)
{
    effect eScare = EffectFrightened();
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR);
    effect eLink = EffectLinkEffects(eMind, eScare);

    effect eShaken = EffectShaken();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);

    //Make Will save versus fear
    if(!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF)), SAVING_THROW_TYPE_FEAR))
    {
       //Apply frightened effect on failed save
       SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
    }
    else // apply shaken effect
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eShaken, oTarget, RoundsToSeconds(nDuration),TRUE,-1,CasterLvl);
}
