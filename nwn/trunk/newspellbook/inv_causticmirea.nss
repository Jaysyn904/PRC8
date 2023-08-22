//::///////////////////////////////////////////////
//:: Name      Caustic Mire - OnEnter
//:: FileName  inv_causticmirea.nss
//::///////////////////////////////////////////////

#include "inv_inc_invfunc"
#include "inv_invokehook"

void main()
{

    //Declare major variables
    object oCaster = GetAreaOfEffectCreator();
    object oTarget = GetEnteringObject();

    int nCasterLvl = GetInvokerLevel(oCaster, CLASS_TYPE_WARLOCK);
    int nPenetr = SPGetPenetrAOE(oCaster, nCasterLvl);

    effect eSlow = EffectMovementSpeedDecrease(33);
    if((spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster)) && oTarget != oCaster)
    {
        if(!GetCreatureFlag(oTarget, CREATURE_VAR_IS_INCORPOREAL))
        {
            //Fire cast spell at event for the target
            SignalEvent(oTarget, EventSpellCastAt(oCaster, INVOKE_CAUSTIC_MIRE));
            //Spell resistance check
            if(!PRCDoResistSpell(oCaster, oTarget,nPenetr))
            {
                //Slow down the creature within the mire
                SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eSlow, oTarget);
            }
            SetLocalLocation(oTarget, "LastMirePos", GetLocation(oTarget));
        }
    }
}
