//::///////////////////////////////////////////////
//:: Thrall of Orcus Carrion Stench
//:: prc_to_carrionA.nss
//:://////////////////////////////////////////////
/*
    Creatures entering the area around the Thrall
    must save or be cursed with Doom
*/
//:://////////////////////////////////////////////
//:: Created By: Stratovarius
//:: Created On: July 11, 2004
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    object oTarget = GetEnteringObject();
    effect eVis = EffectVisualEffect(VFX_IMP_DOOM);
    effect eLink = EffectShaken();

    int nDC = (10 + GetLevelByClass(CLASS_TYPE_ORCUS, GetAreaOfEffectCreator()) + GetAbilityModifier(ABILITY_CONSTITUTION, GetAreaOfEffectCreator()));
    int nDur = GetLevelByClass(CLASS_TYPE_ORCUS, GetAreaOfEffectCreator());

            if(GetIsEnemy(oTarget, GetAreaOfEffectCreator()))
            {
                //Make a saving throw check
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
                {
                    //Apply the VFX impact and effects
                    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink , oTarget, RoundsToSeconds(nDur));
                }
            }
}
