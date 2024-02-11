//::///////////////////////////////////////////////
//:: Name      Curse of Despair
//:: FileName  inv_curseofdesp.nss
//::///////////////////////////////////////////////
/*

Lesser Invocation
4th Level Spell

You curse a single creature you touch as the Bestow
Curse spell. If they make their will save, then
they still take a -1 on all their attacks for one
minute.

*/
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{
    if(!PreInvocationCastCode()) return;

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int CasterLvl = GetInvokerLevel(oCaster, GetInvokingClass());
    int nPenetr = CasterLvl + SPGetPenetr();
    int iAttackRoll = PRCDoMeleeTouchAttack(oTarget);
    int dec = 2 * iAttackRoll;//4 on Critical Hit
    effect eVis = EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE);
    effect eCurse = EffectCurse(dec, dec, dec, dec, dec, dec);
    effect eDespair = EffectAttackDecrease(1);

    //Make sure that curse is of type supernatural not magical
    eCurse = SupernaturalEffect(eCurse);

    if(iAttackRoll > 0)
    {
        //Signal spell cast at event
        SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_CURSE_OF_DESPAIR));
         //Make SR Check
         if (!PRCDoResistSpell(oCaster, oTarget, nPenetr))
         {
            //Make Will Save
            if (!/*Will Save*/ PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetInvocationSaveDC(oTarget, oCaster)))
            {
                //Apply Effect and VFX
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eCurse, oTarget, 0.0f, TRUE, -1, CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
            else
            {
                //Apply Effect and VFX
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDespair, oTarget, TurnsToSeconds(1), TRUE, -1, CasterLvl);
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
            }
        }
    }
}