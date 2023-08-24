#include "prc_inc_sp_tch"

void main()
{

    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    effect eSun = EffectVisualEffect(VFX_IMP_SUNSTRIKE);
    effect eBolt;

    int iDice = GetHitDice(GetMaster())/5+GetLevelByClass(CLASS_TYPE_SOLDIER_OF_LIGHT,GetMaster());

      //Make a saving throw check
    if (PRCDoRangedTouchAttack(oTarget))
    {
        eBolt = EffectDamage(d8(1),DAMAGE_TYPE_POSITIVE);
        eBolt = SupernaturalEffect(eBolt);
        //Apply the VFX impact and effects
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eSun, oTarget);
    }

}
