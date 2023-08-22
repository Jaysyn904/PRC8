//::///////////////////////////////////////////////
//:: [Acrobatic Attack]
//:: [prc_s_acroatk.nss]
//:://////////////////////////////////////////////
//:: Leaps at a target. Inflicting d6 / 2 duelist
//:: levels + dex bonus damage and knockdown for
//:: 1 round.  Reflex save verus 10 + duelist
//:: level + dex bonus for half damage and no
//:: knockdown.
//::
//:: Attack/Damage bonus of +2 or +4 for 1 round
//::
//:://////////////////////////////////////////////
//:: Created By: Aaon Graywolf
//:: Created On: Dec 21, 2003
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    //Declare major variables
    int nWis = GetAbilityModifier(ABILITY_WISDOM);
    int nDC = 15 + nWis;
    int nBonus = nWis;
    int nDamage;

    if(GetHasFeat(FEAT_FREE_KI_2, OBJECT_SELF)){
        nDC += nWis;
        nBonus += nWis;
    }
    if(GetHasFeat(FEAT_FREE_KI_3, OBJECT_SELF)){
        nDC += nWis;
        nBonus += nWis;
    }
    if(GetHasFeat(FEAT_FREE_KI_4, OBJECT_SELF)){
        nDC += nWis;
        nBonus += nWis;
    }

    location lTargetLocation = GetSpellTargetLocation();
    object oTarget;
    effect eDamage;
    effect eVis = EffectVisualEffect(VFX_IMP_SONIC);

    //Get first target in spell area
    oTarget = GetFirstObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        nDamage = d6(3) + nBonus;
        if(!GetIsReactionTypeFriendly(oTarget) && oTarget != OBJECT_SELF)
        {
            //Determine effect delay
            float fDelay = GetDistanceBetween(OBJECT_SELF, oTarget)/20;
            if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS, OBJECT_SELF, fDelay))
            {
			if (GetHasMettle(oTarget, SAVING_THROW_FORT))
			// This script does nothing if it has Mettle, bail
				nDamage = 0;              
                nDamage /= 2;
            }

            eDamage = EffectDamage(nDamage, DAMAGE_TYPE_SONIC, DAMAGE_POWER_ENERGY);

            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
            DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
        }
        //Get next target in spell area
        oTarget = GetNextObjectInShape(SHAPE_SPELLCONE, 10.0, lTargetLocation, TRUE);
    }
}
