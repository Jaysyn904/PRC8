//::///////////////////////////////////////////////
//:: Baelnorn Touch
//:: prc_baeln_tch
//:://////////////////////////////////////////////
/**
    Touch attack for Baelnorn.
    1d8 +5 negative damage, will save for half.
    Permanent paralysis, fort save negates.

    DC for both is 10 + 1/2 HD + Charisma modifier


    Author: Tenjac
    Re-created again: 12/08/05
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////
#include "prc_inc_sp_tch"

void main()
{
    //define vars
    object oPC = OBJECT_SELF;

    object oSkin = GetPCSkin(oPC);
    object oTarget = PRCGetSpellTargetObject();
    int nLevel = GetLevelByClass(CLASS_TYPE_BAELNORN, oPC);

    int nDam;
    int nHD = GetHitDice(oPC);

    //DC is 10 + 1/2 HD + CHA mod
    int nDC = (10 + (nHD/2) + GetAbilityModifier(ABILITY_CHARISMA, oPC));

    float fDuration;

    //Make touch attack
    int nTouch = PRCDoMeleeTouchAttack(oTarget);

    // Gotta be a living critter
        int nType = MyPRCGetRacialType(oTarget);
        if ((nType == RACIAL_TYPE_CONSTRUCT) ||
            (nType == RACIAL_TYPE_UNDEAD) ||
            (nType == RACIAL_TYPE_ELEMENTAL))
            {
            return;
        }

    // if fails touch
    if(!nTouch)
    {
        return;
    }

    //Switch statement for levels
    switch(nLevel)
    {
        case 0: return;

        case 1:
        nDam = (5 + d6(1));
        fDuration = RoundsToSeconds(d4(1));
        break;

        case 2:
        nDam = (5 + d8(1));
        fDuration = IntToFloat(d4(1) * 60);
        break;

        case 3:
        nDam = (5 + d8(1));
        fDuration = IntToFloat(d4(1) * 3600);
        break;

        case 4:
        nDam = (5 + d8(1));
        break;

        default: return;
    }

    //check for save for 1/2 damage
    if(PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
    {
        nDam /= 2;
            if (GetHasMettle(oTarget, SAVING_THROW_WILL))
            // This script does nothing if it has Mettle, bail
                return;
    }

    //define effects

    effect eVis = EffectVisualEffect(VFX_IMP_HARM);
    effect ePar = EffectParalyze();

    //Apply Damage only
    ApplyTouchAttackDamage(oPC, oTarget, nTouch, nDam, DAMAGE_TYPE_NEGATIVE);

    //Fort save for paral
    if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE) || GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS))
    {
        return;
    }

    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

    //apply permanent

    if(nLevel == 4)
    {
        SPApplyEffectToObject(DURATION_TYPE_PERMANENT, ePar, oTarget);
        return;
    }

    //apply temp
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, ePar, oTarget, fDuration);

}



