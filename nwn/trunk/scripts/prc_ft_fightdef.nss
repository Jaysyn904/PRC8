/* Fighting Defensively
-4 Attack, +2 AC
+1 extra AC if Tumble ranks >= 5
*/

#include "prc_alterations"

void main()
{
    object oPC = OBJECT_SELF;
    
    if (GetHasSpellEffect(PRCGetSpellId(), oPC))
        PRCRemoveSpellEffects(PRCGetSpellId(), oPC, oPC);
    else
    {
    	int nDuel = GetLevelByClass(CLASS_TYPE_DUELIST, oPC);
        int nAC = 2;
        if (GetSkillRank(SKILL_TUMBLE, oPC, TRUE) >= 5) nAC++;
        if (nDuel >= 7) nAC += nDuel;
        effect eLink = EffectLinkEffects(EffectACIncrease(nAC, AC_DODGE_BONUS), EffectAttackDecrease(4));
        eLink = ExtraordinaryEffect(eLink);
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
    }    
}