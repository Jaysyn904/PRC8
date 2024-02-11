//::///////////////////////////////////////////////
//:: Epic Ward
//:: X2_S2_EpicWard.
//:: Copyright (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Makes the caster invulnerable to damage
    (equals damage reduction 50/+20)
    Lasts 1 round per level
*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: Aug 12, 2003
//:://////////////////////////////////////////////
/*
    Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/

#include "inc_epicspells"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    object oCaster = OBJECT_SELF;
    if(GetCanCastSpell(oCaster, SPELL_EPIC_EP_WARD))
    {
        object oTarget = PRCGetSpellTargetObject();
        int nDuration = GetTotalCastingLevel(oCaster);
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, GetSpellId(), FALSE));
        int nLimit = 50*nDuration;
        effect eDur = EffectVisualEffect(495);
        effect eProt = EffectDamageReduction(50, DAMAGE_POWER_PLUS_TWENTY, nLimit);
        effect eLink = EffectLinkEffects(eDur, eProt);
               eLink = EffectLinkEffects(eLink, eDur);

        // * Brent, Nov 24, making extraodinary so cannot be dispelled
        eLink = ExtraordinaryEffect(eLink);

        PRCRemoveEffectsFromSpell(oCaster, GetSpellId());
        //Apply the armor bonuses and the VFX impact
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration), TRUE, -1, nDuration);
    }
    PRCSetSchool();
}