//:://////////////////////////////////////////////
//:: FileName: "ss_ep_armyunfall"
/*   Purpose: Army Unfallen epic spell - heals/resurrects all allies.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On:
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"
#include "nw_i0_generic"

void main()
{
    // Set up the spell school context
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    // Standard pre-cast check
    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }

    // Check if caster can cast the spell
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ARMY_UN))
    {
        int nAlly = 0;
        int nBLD;
        int nX;

        // Prepare visual effects
        effect eVis  = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
        effect eVis2 = EffectVisualEffect(VFX_FNF_PWSTUN);
        effect eVis3 = EffectVisualEffect(VFX_IMP_HEALING_G);
        effect eRez, eHeal, eLink, eBLD;

        // === Handle caster (OBJECT_SELF) first ===
        nX = GetMaxHitPoints(OBJECT_SELF) - GetCurrentHitPoints(OBJECT_SELF);
        if (nX < 0) nX = 0;

        if (nX && !MatchNonliving(MyPRCGetRacialType(OBJECT_SELF)))
        {
            eRez  = EffectResurrection();
            eHeal = EffectHeal(nX);
            eLink = EffectLinkEffects(eHeal, eVis);
            eLink = EffectLinkEffects(eLink, eVis2);
            eLink = EffectLinkEffects(eLink, eVis3);

            if (GetIsDead(OBJECT_SELF))
            {
                SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, OBJECT_SELF);
                ExecuteScript("prc_pw_armyunfall", OBJECT_SELF);

                if (GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(OBJECT_SELF))
                    SetPersistantLocalInt(OBJECT_SELF, "persist_dead", FALSE);
            }

            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, OBJECT_SELF);
            nAlly++;
        }

        // === Handle other allies in faction ===
        object oTarget = GetFirstFactionMember(OBJECT_SELF, FALSE);
        while (GetIsObjectValid(oTarget))
        {
            if (oTarget != OBJECT_SELF)
            {
                nX = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
                if (nX < 0) nX = 0;

                if (nX && !MatchNonliving(MyPRCGetRacialType(oTarget)))
                {
                    eRez  = EffectResurrection();
                    eHeal = EffectHeal(nX);
                    eLink = EffectLinkEffects(eHeal, eVis);
                    eLink = EffectLinkEffects(eLink, eVis2);
                    eLink = EffectLinkEffects(eLink, eVis3);

                    if (GetIsDead(oTarget))
                    {
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oTarget);
                        ExecuteScript("prc_pw_armyunfall", oTarget);

                        if (GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
                            SetPersistantLocalInt(oTarget, "persist_dead", FALSE);
                    }

                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                    nAlly++;
                }
            }

            oTarget = GetNextFactionMember(OBJECT_SELF, FALSE);
        }

        // === Apply backlash damage if enabled ===
        if (GetPRCSwitch(PRC_EPIC_BACKLASH_DAMAGE) == TRUE)
        {
            nBLD = d6(nAlly);
            eBLD = EffectDamage(nBLD);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBLD, OBJECT_SELF);
        }
    }

    // Clean up spell school variable
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


/* void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ARMY_UN))
    {
        effect eRez, eHeal, eBLD, eLink;
        effect eVis = EffectVisualEffect(VFX_FNF_LOS_HOLY_10);
        effect eVis2 = EffectVisualEffect(VFX_FNF_PWSTUN);
        effect eVis3 = EffectVisualEffect(VFX_IMP_HEALING_G);
        int nX, nAlly, nBLD;
        object oTarget = GetFirstFactionMember(OBJECT_SELF, FALSE);
        while (GetIsObjectValid(oTarget))
        {
            nX = GetMaxHitPoints(oTarget) - GetCurrentHitPoints(oTarget);
            if(nX < 0) //account for temporary HP
                nX = 0;
            eRez = EffectResurrection();
            eHeal = EffectHeal(nX);
            eLink = EffectLinkEffects(eHeal, eVis);
            eLink = EffectLinkEffects(eLink, eVis2);
            eLink = EffectLinkEffects(eLink, eVis3);
            if (nX && //make sure they can be healed
                !MatchNonliving(MyPRCGetRacialType(oTarget)))
            {
                if (nX > 0)
                {
                    if (GetIsDead(oTarget))
                    {
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eRez, oTarget);
                        ExecuteScript("prc_pw_armyunfall", oTarget);
                        if(GetPRCSwitch(PRC_PW_DEATH_TRACKING) && GetIsPC(oTarget))
                            SetPersistantLocalInt(oTarget, "persist_dead", FALSE);
                    }                        
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eLink, oTarget);
                    nAlly++;
                }
            }
            oTarget = GetNextFactionMember(OBJECT_SELF, FALSE);
        }
        if (GetPRCSwitch(PRC_EPIC_BACKLASH_DAMAGE) == TRUE)
        {
            nBLD = d6(nAlly);
            eBLD = EffectDamage(nBLD);
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBLD, oTarget);
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
} */