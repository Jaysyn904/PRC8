#include "prc_inc_burn"

void main()
{
    object oPC = OBJECT_SELF;
    int nBurn = BurnSpell(oPC);

    if(!nBurn)
    {
        //FloatingTextStringOnCreature("You do not have a spell of that level to burn", oPC, FALSE);
        return;
    }
    int nInq = GetLevelByClass(CLASS_TYPE_SHADOWBANE_INQUISITOR); 
    int nStk = GetLevelByClass(CLASS_TYPE_SHADOWBANE_STALKER);
    int nBonus = 4;
    if(nInq >= 7 || nStk >= 7)
        nBonus = 8;
        
    int nClass = nInq + nStk;

    effect eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_MOVE_SILENTLY, nBonus), EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
    eLink = EffectLinkEffects(EffectSkillIncrease(SKILL_HIDE, nBonus), eLink);
    eLink = SupernaturalEffect(eLink);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, 60.0 * (nBurn + nClass));
    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_AC_BONUS), oPC);
}