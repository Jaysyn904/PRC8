/*
    Warlock epic feat
    Master of the Elements dominating
*/
#include "prc_inc_racial"
#include "inv_inc_invfunc"

void main()
{
    object oTarget = PRCGetSpellTargetObject();
    int nRacialType = MyPRCGetRacialType(oTarget);

    if(nRacialType != RACIAL_TYPE_ELEMENTAL)
        return;

    int CasterLvl = GetInvokerLevel(OBJECT_SELF, CLASS_TYPE_WARLOCK);
    effect eDom = EffectCutsceneDominated();    // Allows multiple dominated creatures
    eDom = PRCGetScaledEffect(eDom, oTarget);
    effect eMind = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_DOMINATED);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    effect eVis = EffectVisualEffect(VFX_IMP_DOMINATE_S);

    //Link domination and persistant VFX
    effect eLink = EffectLinkEffects(eMind, eDom);
    eLink = EffectLinkEffects(eLink, eDur);

    int nDuration = 3 + CasterLvl/2;
    nDuration = PRCGetScaledDuration(nDuration, oTarget);
    CasterLvl +=SPGetPenetr();

    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_DOMINATE_MONSTER, FALSE));

    //Make sure the target is a monster
    if(!GetIsReactionTypeFriendly(oTarget))
    {
          //Make SR Check
          if (!PRCDoResistSpell(OBJECT_SELF, oTarget, CasterLvl))
          {
               //Make a Will Save
               if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_MIND_SPELLS))
               {
                   //Apply linked effects and VFX Impact
                   SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
                   SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
               }
          }
    }
}
