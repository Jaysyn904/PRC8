//:://////////////////////////////////////////////
//:: FileName: "ss_ep_audi_stone"
/*   Purpose: Audience of Stone - all enemies in the spell's radius makes a
        FORT save or else turn to stone.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 13, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
//#include "x2_inc_spellhook"
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
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_A_STONE))
    {
        float fDelay;
        effect eExplode = EffectVisualEffect(VFX_FNF_NATURES_BALANCE);
        effect eVis = EffectVisualEffect(VFX_COM_CHUNK_STONE_MEDIUM);
        effect eStone = EffectPetrify();
        effect eLink = EffectLinkEffects(eVis, eStone);
        location lTarget = PRCGetSpellTargetLocation();

        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
            RADIUS_SIZE_LARGE, lTarget);
        while (GetIsObjectValid(oTarget))
        {
            if (oTarget != OBJECT_SELF && !GetIsDM(oTarget) &&
                !GetFactionEqual(oTarget) && spellsIsTarget(oTarget,
                SPELL_TARGET_STANDARDHOSTILE, OBJECT_SELF))
            {
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                    PRCGetSpellId()));
                fDelay = PRCGetRandomDelay(1.5, 2.5);
                if(!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF), fDelay))
                {
//Use bioware petrify command
                    PRCDoPetrification(PRCGetCasterLevel(), OBJECT_SELF, oTarget, PRCGetSpellId(), GetEpicSpellSaveDC(OBJECT_SELF, oTarget));
/*
                    if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget),
                        SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
                    {
                        DelayCommand(fDelay, SPApplyEffectToObject
                            (DURATION_TYPE_INSTANT, eLink, oTarget));
                    }
*/
                }
            }
           oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                RADIUS_SIZE_LARGE, lTarget);
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
