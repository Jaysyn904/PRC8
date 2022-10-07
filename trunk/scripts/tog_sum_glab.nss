//:://////////////////////////////////////////////
/*
Summons the demon for the player
*/
//:://////////////////////////////////////////////
//:: Created By: Oni5115
//:://////////////////////////////////////////////

#include "prc_alterations"
#include "x2_inc_spellhook"
#include "inc_utility"
 
void main()
{
    float fDelay = 3.0;
    int nLevel = GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_A, OBJECT_SELF) + GetLevelByClass(CLASS_TYPE_THRALL_OF_GRAZZT_D, OBJECT_SELF);
    int nDuration = PRCGetCasterLevel(OBJECT_SELF);

    if(nLevel < 15)
    {
         string sMes = "You must be at least a level 15 Thrall of Graz'zt to summon this type of demon.";
         SendMessageToPC(OBJECT_SELF, sMes);
         
         IncrementRemainingFeatUses(OBJECT_SELF, FEAT_TOG_SUMMON_DEMON);
         return;
    }

    effect eSummon = EffectSummonCreature("TOG_GLABREZU",VFX_FNF_SUMMON_GATE, fDelay);
    
    float fDuration = HoursToSeconds(24);
    if(GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL))
            fDuration = RoundsToSeconds(nDuration*GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL));
    
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, GetSpellTargetLocation(), fDuration);
}
