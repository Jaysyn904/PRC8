//::///////////////////////////////////////////////
//:: Name:     Lahm's Finger Darts
//:: Filename: sp_lahms_fd.nss
//::///////////////////////////////////////////////
/**@file Lahm's Finger Darts
Transmutation [Evil]
Level: Corrupt 2
Components: V S, Corrupt
Casting Time: 1 action
Range: Medium (100 ft. + 10 ft./level)
Targets: Up to five creatures, no two of which can
be more than 15 ft. apart
Duration: Instantaneous
Saving Throw: None
Spell Resistance: Yes

The caster's finger becomes a dangerous projectile
that flies from her hand and unerringly strikes its
target. The dart deals 1d4 points of Dexterity
damage. Creatures without fingers cannot cast this
spell.

The dart strikes unerringly, even if the target is
in melee or has partial cover or concealment.
Inanimate objects (locks, doors, and so forth)
cannot be damaged by the spell.

For every three caster levels beyond 1st, the caster
gains an additional dart by losing an additional
finger: two at 4th level, three at 7th level, four
at 10th level, and the maximum of five darts at 13th
level or higher. If the caster shoots multiple darts,
she can have them strike a single creature or several
creatures. A single dart can strike only one creature.
The caster must designate targets before checking for
spell resistance or damage.

Fingers lost to this spell grow back when the
corruption cost is healed, at the rate of one finger
per point of Strength damage healed.

Corruption Cost: 1 point of Strength damage per dart,
plus the loss of one finger per dart. A hand with one
or no fingers is useless.

@author Written By: Tenjac
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Spellhook
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nLFingers = (GetPersistantLocalInt(oPC, "FINGERS_LEFT_HAND") - 1);
    int nRFingers = (GetPersistantLocalInt(oPC, "FINGERS_RIGHT_HAND")- 1);
    int nCasterLvl = PRCGetCasterLevel(oPC);
    int nFingers = 1;
    int nDam;
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eDam = EffectAbilityDecrease(ABILITY_DEXTERITY, nDam);
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
    location lTarget = PRCGetSpellTargetLocation();

    PRCSignalSpellEvent(oTarget,TRUE, SPELL_LAHMS_FINGER_DARTS, oPC);

    //Set up fingers if it hasn't been done before
    if (GetPersistantLocalInt(oPC, "FINGERS_LEFT_HAND") < 1)
    {
        SetPersistantLocalInt(oPC, "FINGERS_LEFT_HAND", 6);
        SetPersistantLocalInt(oPC, "FINGERS_RIGHT_HAND", 6);
        nLFingers = 5;
        nRFingers = 5;
    }

    //Spell Resistance, no save
    if(!PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr()))
    {
        //Calculate fingers used
        if(nCasterLvl > 3) nFingers++;
        if(nCasterLvl > 6) nFingers++;
        if(nCasterLvl > 9) nFingers++;
        if(nCasterLvl > 12) nFingers++;

        //gotta set up a new counter because nFingers is used later
        int nCounter = nFingers;

        //Determine which hand to screw up
        if(nLFingers >= nFingers)
        {
            nLFingers -= nFingers;
            SetPersistantLocalInt(oPC, "FINGERS_LEFT_HAND", nLFingers);
        }

        else if(nRFingers >= nFingers)
        {
            nRFingers -= nFingers;
            SetPersistantLocalInt(oPC, "FINGERS_RIGHT_HAND", nRFingers);
        }

        else
        {
            SendMessageToPC(oPC, "You do not have enough fingers left to cast this spell");
            nCounter = 0;
        }

        //Damage loop
        while(nCounter > 0)
        {
            nDam = d4(1);

            //Apply the MIRV and damage effect
            DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget));
            DelayCommand(fDelay2, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
            DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));

            // Play the sound of a dart hitting
            DelayCommand(fTime, PlaySound("cb_ht_dart1"));

            //decrement nCounter to handle loop termination
            nCounter--;
        }

        //Determine usefullness of remaining stumps
        if(nLFingers < 2)
        {
            //mark left hand useless
            SetPersistantLocalInt(oPC, "LEFT_HAND_USELESS", 1);
        }

        if(nRFingers < 2)
        {
            //mark right hand useless
            SetPersistantLocalInt(oPC, "RIGHT_HAND_USELESS", 1);
        }
    }

    //Corrupt spells get mandatory 10 pt evil adjustment, regardless of switch
    AdjustAlignment(oPC, ALIGNMENT_EVIL, 10, FALSE);

    //SPEvilShift(oPC);
    DoCorruptionCost(oPC, ABILITY_STRENGTH, nFingers, 0);
    PRCSetSchool();
}