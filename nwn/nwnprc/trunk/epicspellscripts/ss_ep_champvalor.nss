//:://////////////////////////////////////////////
//:: FileName: "ss_ep_champvalor"
/*   Purpose: Champion's Valor - grants the target immunity to mind-affecting
        spells, knockdown, sneak attacks, and critical hits for 20 hours.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 11, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_CHAMP_V))
    {
        object oTarget = PRCGetSpellTargetObject();
        int nCasterLvl = GetTotalCastingLevel(OBJECT_SELF);
        int nDuration = nCasterLvl / 4;
        if (nDuration < 5)
        nDuration = 5;
        float fDuration = TurnsToSeconds(nDuration);
        if(GetPRCSwitch(PRC_PNP_CHAMPIONS_VALOR))
        {
            fDuration = HoursToSeconds(20);
        }            
        effect eImm1 = EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN);
        effect eImm2 = EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK);
        effect eImm3 = EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT);
        effect eImm4 = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eVis = EffectVisualEffect(VFX_DUR_GLOW_WHITE);
        effect eVis2 = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MINOR );
        effect eLink = EffectLinkEffects(eImm1, eImm2);
        eLink = EffectLinkEffects(eLink, eImm3);
        eLink = EffectLinkEffects(eLink, eImm4);
        eLink = EffectLinkEffects(eLink, eDur);
        eLink = EffectLinkEffects(eLink, eVis);
        eLink = EffectLinkEffects(eLink, eVis2);
        eLink = ExtraordinaryEffect(eLink); // No dispelling it.

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget,
            fDuration, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF));
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

