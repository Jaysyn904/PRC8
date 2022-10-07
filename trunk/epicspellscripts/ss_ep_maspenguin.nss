//:://////////////////////////////////////////////
//:: FileName: "ss_ep_maspenguin"
/*   Purpose: Mass Penguin - turns all creatures in the target area into
        penguins!
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
#include "pnp_shft_poly"
#include "inc_epicspells"
#include "prc_compan_inc"

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_MASSPEN))
    {
        float fDelay;
        int nDuration = 20;

        effect eExplode = EffectVisualEffect(VFX_FNF_MYSTICAL_EXPLOSION);
        effect eDuration = EffectVisualEffect(VFX_DUR_PIXIEDUST);
        effect eVis = EffectVisualEffect(VFX_IMP_POLYMORPH);
        effect ePolymorph = EffectPolymorph(POLYMORPH_TYPE_PENGUIN, TRUE);
        effect eLink = EffectLinkEffects(eDuration, ePolymorph);
        location lTarget = PRCGetSpellTargetLocation();
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eDuration,
            lTarget, 10.0);
        object oTarget = GetFirstObjectInShape(SHAPE_SPHERE,
            RADIUS_SIZE_LARGE, lTarget);
        // Cycle through the targets within the spell shape
        //      until an invalid object is captured.
        while (GetIsObjectValid(oTarget))
        {
            if (oTarget != OBJECT_SELF)
            {
                //Fire cast spell at event for the specified target
                SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF,
                    PRCGetSpellId()));
                fDelay = PRCGetRandomDelay(1.5, 2.5);
                if(!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF), fDelay) && PRCGetIsAliveCreature(oTarget))
                {
                    if(PRCGetCreatureSize(oTarget) == CREATURE_SIZE_TINY ||
                        PRCGetCreatureSize(oTarget) == CREATURE_SIZE_SMALL ||
                        PRCGetCreatureSize(oTarget) == CREATURE_SIZE_MEDIUM)
                    {

                        // Targets all get a Fortitude saving throw
                        if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget),
                            SAVING_THROW_TYPE_SPELL, OBJECT_SELF, fDelay))
                        {
                            //this command will make shore that polymorph plays nice with the shifter
                            ShifterCheck(oTarget);
                            //companion has multi-sized penguins :)
                            if(GetPRCSwitch(MARKER_PRC_COMPANION))
                            {
                                int nRandom = d100();
                                if(nRandom < 25)
                                    ePolymorph = EffectPolymorph(POLYMORPH_TYPE_PENGUIN, TRUE);
                                else if(nRandom < 40)
                                    ePolymorph = EffectPolymorph(PRC_COMP_POLYMORPH_TYPE_PENGUIN_150, TRUE);
                                else if(nRandom < 55)
                                    ePolymorph = EffectPolymorph(PRC_COMP_POLYMORPH_TYPE_PENGUIN_200, TRUE);
                                else if(nRandom < 70)
                                    ePolymorph = EffectPolymorph(PRC_COMP_POLYMORPH_TYPE_PENGUIN_300, TRUE);
                                else if(nRandom < 85)
                                    ePolymorph = EffectPolymorph(PRC_COMP_POLYMORPH_TYPE_PENGUIN_400, TRUE);
                                else
                                    ePolymorph = EffectPolymorph(PRC_COMP_POLYMORPH_TYPE_PENGUIN_500, TRUE);    
                                eLink = EffectLinkEffects(eDuration, ePolymorph);
                            }
                            
                            // Apply effects to the currently selected target.
                            DelayCommand(fDelay, SPApplyEffectToObject
                                (DURATION_TYPE_TEMPORARY, eLink, oTarget,
                                HoursToSeconds(nDuration), TRUE, -1, GetTotalCastingLevel(OBJECT_SELF)));
                            DelayCommand(fDelay, SPApplyEffectToObject
                                (DURATION_TYPE_INSTANT, eVis, oTarget));
                        }
                    }
                 }
            }
           //Select the next target within the spell shape.
           oTarget = GetNextObjectInShape(SHAPE_SPHERE,
                RADIUS_SIZE_LARGE, lTarget);
        }
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
