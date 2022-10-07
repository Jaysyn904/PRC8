/*
    sp_natureavatar

    The target animal companion gains +10 to attack and
    damage rolls and add 1d8 temporary hit points per
    caster level, plus the effects of haste.

    By: ???
    Created: ???
    Modified: Jul 2, 2006
*/

#include "prc_sp_func"

//Implements the spell impact, put code here
//  if called in many places, return TRUE if
//  stored charges should be decreased
//  eg. touch attack hits
//
//  Variables passed may be changed if necessary
int DoSpell(object oCaster, object oTarget, int nCasterLevel, int nEvent)
{
    if(GetAssociate(ASSOCIATE_TYPE_ANIMALCOMPANION) == oTarget || (GetObjectByTag("hen_winterwolf") == oTarget && GetMaster(oTarget) == oCaster) || (GetObjectByTag("prc_shamn_cat") == oTarget && GetMaster(oTarget) == oCaster))
    {
        PRCSignalSpellEvent(oTarget, FALSE);
        effect eff = EffectAttackIncrease(10);
        eff = EffectLinkEffects(eff,EffectDamageIncrease(DAMAGE_BONUS_10,DAMAGE_TYPE_SLASHING));
        eff = EffectLinkEffects(eff, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));
        eff = EffectLinkEffects(eff, EffectHaste());

        int HP = PRCGetMetaMagicDamage(-1, nCasterLevel, 8);
        float fDuration = PRCGetMetaMagicDuration(TurnsToSeconds(nCasterLevel));
        PRCRemoveEffectsFromSpell(oTarget, PRCGetSpellId());
        // Apply effects and VFX to target
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(HP), oTarget, fDuration,TRUE,-1,nCasterLevel);
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eff, oTarget, fDuration,TRUE,-1,nCasterLevel);
        SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_HOLY_AID), oTarget);
    }

    return TRUE;    //return TRUE if spell charges should be decremented
}

void main()
{
    object oCaster = OBJECT_SELF;
    int nCasterLevel = PRCGetCasterLevel(oCaster);
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
    if (!X2PreSpellCastCode()) return;
    object oTarget = PRCGetSpellTargetObject();
    int nEvent = GetLocalInt(oCaster, PRC_SPELL_EVENT); //use bitwise & to extract flags
    if(!nEvent) //normal cast
    {
        if(GetLocalInt(oCaster, PRC_SPELL_HOLD) && oCaster == oTarget)
        {   //holding the charge, casting spell on self
            SetLocalSpellVariables(oCaster, 1);   //change 1 to number of charges
            return;
        }
        DoSpell(oCaster, oTarget, nCasterLevel, nEvent);
    }
    else
    {
        if(nEvent & PRC_SPELL_EVENT_ATTACK)
        {
            if(DoSpell(oCaster, oTarget, nCasterLevel, nEvent))
                DecrementSpellCharges(oCaster);
        }
    }
    PRCSetSchool();
}