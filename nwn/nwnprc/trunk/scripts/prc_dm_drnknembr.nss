#include "prc_inc_combmove"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    AdjustReputation(oPC, oTarget, -100);
    AdjustReputation(oTarget, oPC, -100);

    //              Base Attack Bonus                    Strength Modifier                Size Modifier   Drunken Embrace Bonus
    int nPCRoll = GetBaseAttackBonus(oPC) + GetAbilityModifier(ABILITY_STRENGTH, oPC) + PRCGetSizeModifier(oPC) + 4;
    int nNPCRoll = GetBaseAttackBonus(oTarget) + GetAbilityModifier(ABILITY_STRENGTH, oTarget) + PRCGetSizeModifier(oTarget);

    if(nPCRoll > nNPCRoll)
    {//oTarget is grappled for next 3 rounds
        effect eGrappled = EffectKnockdown();
        //if(GetIsImmune(oTarget, IMMUNITY_TYPE_PARALYSIS, oPC))
        //    {
        //    eGrappled = EffectCutsceneParalyze();
        //    }
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eGrappled, oTarget, RoundsToSeconds(3));
        FloatingTextStringOnCreature("Target is grappled", oPC);
        SendMessageToPC(oPC, "Drunken Embrace was sucessful");
    }
    else
    {SendMessageToPC(oPC, "Drunken Embrace was unsucessful");}

}
