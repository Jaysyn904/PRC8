//:://////////////////////////////////////////////
//:: FileName: "ss_ep_dullblades"
/*   Purpose: Dullblades - grants 100% protection against slashing
        damage for 24 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////

#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ABJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_DULBLAD))
    {
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = GetTotalCastingLevel(OBJECT_SELF);
        int nDuration = 10 + nCasterLvl;
        float fDuration = RoundsToSeconds(nDuration);
        effect eVis = EffectVisualEffect(VFX_IMP_AC_BONUS);
        effect eDur = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
        effect eProt = EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING, 50);
        if(GetPRCSwitch(PRC_PNP_DULLBLADES))
        {
            eProt = EffectDamageImmunityIncrease
                (DAMAGE_TYPE_SLASHING, 100);
            fDuration = HoursToSeconds(20);
        }            
        effect eLink = EffectLinkEffects(eProt, eDur);
        // if this option has been enabled, the caster will take backlash damage
        if (GetPRCSwitch(PRC_EPIC_BACKLASH_DAMAGE) == TRUE)
        {
            int nDamage = d6(10);
            effect eDamVis = EffectVisualEffect(VFX_IMP_SONIC);
            effect eDam = EffectDamage(nDamage, DAMAGE_TYPE_MAGICAL);
            DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                eDamVis, OBJECT_SELF));
            DelayCommand(2.0, SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                eDam, OBJECT_SELF));
        }
        if(GetIsReactionTypeFriendly(oTarget) || GetFactionEqual(oTarget))
        {
            //Fire spell cast at event for target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId(),
                FALSE));
            SPApplyEffectToObject(DURATION_TYPE_INSTANT,
                eVis, oTarget);
            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,
                eLink, oTarget, fDuration, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF));
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
