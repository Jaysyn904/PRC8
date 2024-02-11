#include "prc_inc_clsfunc"

void main()
{
object oPC = OBJECT_SELF;
object oTarget = PRCGetSpellTargetObject();
int nDexMod = GetAbilityModifier(ABILITY_DEXTERITY, oTarget);
int nHumanoid = 0;
effect eACDec = EffectACDecrease(nDexMod);
effect eVFX = EffectVisualEffect(VFX_COM_SPECIAL_RED_ORANGE);

if(GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) < 3)
    {nHumanoid = -8;}
if(!PRCAmIAHumanoid(oTarget))
    {nHumanoid = -4;}

//PC Roll:     roll  +   Bluff Skill Points      + Lurch Bonus
int nPCRoll  = d20() + GetSkillRank(SKILL_BLUFF) +     4;
//NPC Roll:                     Int Modifier                  +             Chr Modifier                   + Non-Humaniod penalty
int nNPCRoll = GetAbilityScore(oTarget, ABILITY_INTELLIGENCE) + GetAbilityScore(oTarget, ABILITY_CHARISMA) + nHumanoid;

SendMessageToPC(oPC, "PC Lurch Roll: " + IntToString(nPCRoll) + " vs NPC roll: " + IntToString(nNPCRoll));

if(nPCRoll > nNPCRoll)
    {
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eACDec, oTarget, RoundsToSeconds(2));
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVFX, oTarget, RoundsToSeconds(2));
    FloatingTextStringOnCreature("Your Lurch was sucessful", oPC);
    }
else
    {
    FloatingTextStringOnCreature("Your Lurch was unsucessful", oPC);
    }
}
