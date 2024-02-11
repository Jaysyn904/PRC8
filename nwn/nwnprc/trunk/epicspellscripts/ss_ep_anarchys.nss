//:://////////////////////////////////////////////
//:: FileName: "ss_ep_anarchys"
/*   Purpose: Anarchy's Call - all non-chaotic targets are confused, and all
        chaotic targets get 5 attacks per round and +10 saves vs. law.
     Non-chaotic casters have alignment shift to law by d10, and spell fails.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "inc_epicspells"
//#include "prc_add_spell_dc"
//#include "x2_inc_spellhook"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_ENCHANTMENT);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_ANARCHY))
    {
        int nCasterLevel = GetTotalCastingLevel(OBJECT_SELF);
        float fDuration = RoundsToSeconds(20);
        effect eVis = EffectVisualEffect(VFX_FNF_HOWL_MIND );
        effect eConf = PRCEffectConfused();
        effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
        effect eAtt = EffectModifyAttacks(5);
        effect eST = EffectSavingThrowIncrease(SAVING_THROW_ALL, 10,
            SAVING_THROW_TYPE_LAW);
        effect eDur2 = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
        effect eLink = EffectLinkEffects(eVis, eConf);
        eLink = EffectLinkEffects(eLink, eDur);
        effect eLink2 = EffectLinkEffects(eAtt, eVis);
        eLink2 = EffectLinkEffects(eLink2, eDur2);
        eLink2 = EffectLinkEffects(eLink2, eST);
        float fDelay;
        // Chaotic casters cast normally. All others go to ELSE.
        if (GetAlignmentLawChaos(OBJECT_SELF) == ALIGNMENT_CHAOTIC)
        {
            object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
                RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
            while(GetIsObjectValid(oTarget))
            {
                fDelay = PRCGetRandomDelay();
                if (GetAlignmentLawChaos(oTarget) != ALIGNMENT_CHAOTIC)
                {
                    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                        SPELL_CONFUSION));
                    if(!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF), fDelay))
                    {
                        int nSaveDC = GetEpicSpellSaveDC(OBJECT_SELF, oTarget, SPELL_EPIC_ANARCHY);       
                        if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nSaveDC,
                            SAVING_THROW_TYPE_NONE, OBJECT_SELF, fDelay))
                        {
                            DelayCommand(fDelay, SPApplyEffectToObject
                                (DURATION_TYPE_TEMPORARY, eLink, oTarget,
                                fDuration, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
                        }
                    }
                }
                else
                    DelayCommand(fDelay, SPApplyEffectToObject
                        (DURATION_TYPE_TEMPORARY, eLink2, oTarget, fDuration, TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));

                oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                    RADIUS_SIZE_COLOSSAL, GetLocation(OBJECT_SELF), TRUE);
            }
        }
        else // A non-chaotic caster will sway towards chaos on a casting.
        {
            FloatingTextStringOnCreature("*Spell fails. You are not chaotic*",
                OBJECT_SELF, FALSE);
            AdjustAlignment(OBJECT_SELF, ALIGNMENT_CHAOTIC, d10(), FALSE);
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

