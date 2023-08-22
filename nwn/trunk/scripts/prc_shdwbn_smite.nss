#include "prc_inc_smite"

void Shadowsmite(object oPC, object oTarget, int nClass)
{
    if (GetLocalInt(oTarget, "PRCCombat_StruckByAttack")) 
    {    
        if (nClass >= 5)
        {
            SetLocalInt(oTarget, "MercilessPurity", TRUE);
            SetLocalObject(oTarget, "Shadowbane", oPC);
        }    
    
        if (nClass >= 8)
        {
            int nRace = MyPRCGetRacialType(oTarget);
            effect eAttack = EffectAttackIncrease(1);
            effect eAC = EffectDamageIncrease(DAMAGE_BONUS_1, DAMAGE_TYPE_DIVINE);
    
            eAttack = VersusRacialTypeEffect(eAttack, nRace);
            eAC = VersusRacialTypeEffect(eAC, nRace);

            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAttack, oPC, RoundsToSeconds(10));
            ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eAC, oPC, RoundsToSeconds(10)); 
        }    
    }
}    

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    DoSmite(oPC, oTarget, SMITE_TYPE_SHADOWBANE);
    int nClass = GetLevelByClass(CLASS_TYPE_SHADOWBANE_INQUISITOR, oPC);
    Shadowsmite(oPC, oTarget, nClass);
}