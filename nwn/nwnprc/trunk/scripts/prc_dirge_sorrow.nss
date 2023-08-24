/*
    Dirgesinger's Song of Sorrow
*/

#include "prc_inc_combat"

void main()
{
    if (!GetHasFeat(FEAT_BARD_SONGS, OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85587,OBJECT_SELF); // no more bardsong uses left
        return;
    }

    DecrementRemainingFeatUses(OBJECT_SELF, FEAT_BARD_SONGS);

    if (PRCGetHasEffect(EFFECT_TYPE_SILENCE,OBJECT_SELF))
    {
        FloatingTextStrRefOnCreature(85764,OBJECT_SELF); // not useable when silenced
        return;
    }

    //Declare major variables
    object oPC = OBJECT_SELF;
    int nDuration = 10;
    int nDC = 10 + GetSkillRank(SKILL_PERFORM, oPC);
    int nDamageType;
    object oItem;
    effect eDam;

    effect eWill = EffectSavingThrowDecrease(SAVING_THROW_WILL, 2);
    effect eAB = EffectAttackDecrease(2);
    effect eLink = EffectLinkEffects(eAB, eWill);

    effect eVis = EffectVisualEffect(VFX_DUR_BARD_SONG);

    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    eLink = EffectLinkEffects(eLink, eDur);

    effect eImpact = EffectVisualEffect(VFX_IMP_HEAD_SONIC);
    effect eFNF = EffectVisualEffect(VFX_FNF_LOS_EVIL_30);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eFNF, GetLocation(OBJECT_SELF));

    object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));

    while(GetIsObjectValid(oTarget))
    {
        // * GZ Oct 2003: If we are silenced, we can not benefit from bard song
        if (!PRCGetHasEffect(EFFECT_TYPE_SILENCE,oTarget) && !PRCGetHasEffect(EFFECT_TYPE_DEAF,oTarget))
        {
            if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    // This part of the song grants a -2 penalty to damage, and its using this toget the proper damage type.
                    oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
                    if (GetIsObjectValid(oItem))
                    {
                        nDamageType = GetWeaponDamageType(oItem);
                    }
                    else // Get the claw
                    {
                        oItem = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R);
                        if (GetIsObjectValid(oItem))
                    {
                    nDamageType = GetWeaponDamageType(oItem);
                        }
                    }

                    eDam = EffectDamageDecrease(2, nDamageType);
                    eLink = EffectLinkEffects(eLink, eDam);
                eLink = ExtraordinaryEffect(eLink);

                //Apply the VFX impact and effects
                    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
                }

            }
        }
        oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF));
    }
}
