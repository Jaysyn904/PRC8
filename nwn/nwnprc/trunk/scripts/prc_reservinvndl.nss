//Spell script for reserve feat Invisible Needle
//prc_reservinvndl
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_sp_func"
#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

void main()
{
    //Declare major variables  ( fDist / (3.0f * log( fDist ) + 2.0f) )
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nBonus = GetLocalInt(oPC, "InvisibleNeedleBonus");
    int nDamage = d4(nBonus);
    int nAttack = GetAttackRoll(oTarget, oPC, OBJECT_INVALID);
    effect eMissile = EffectVisualEffect(VFX_IMP_MIRV);
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    float fDist = GetDistanceBetween(oPC, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;

    fTime = fDelay;
    fDelay2 += 0.1;
    fTime += fDelay2;

    if (!GetLocalInt(oPC, "InvisibleNeedleBonus")) 
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    //Do ranged attack
    if (nAttack)
    {
        //Doube damage on a crit
        if (nAttack == 2) nDamage = nDamage*2;
        
        //Apply the MIRV and damage effect
        effect eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_MAGICAL);
        DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
        DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,0.0f,FALSE));
        DelayCommand(fDelay2, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
    }
}