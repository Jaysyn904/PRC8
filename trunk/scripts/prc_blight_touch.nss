/*
  Talonas Blight.

*/

const int DISEASE_TALONAS_BLIGHT = 52;

#include "prc_alterations"
#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int iDC = GetLevelByClass(CLASS_TYPE_BLIGHTLORD) + GetAbilityModifier(ABILITY_WISDOM, oPC) + 10;
    effect eDisease = EffectDisease(DISEASE_TALONAS_BLIGHT);
    int iPenalty = d4(1);


    if (TouchAttackMelee(oTarget) > 0)
    {
        //Make a saving throw check
        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, iDC, SAVING_THROW_TYPE_SPELL))
        {
            SetLocalInt(oTarget, "BlightDC", iDC);
            SetLocalObject(oTarget, "BlightspawnCreator", oPC);
            //The effect is permament because the disease subsystem has its own internal resolution
            //system in place.
            SPApplyEffectToObject(DURATION_TYPE_PERMANENT, eDisease, oTarget,0.0f,TRUE,-1,iDC);
        }
    }
}
