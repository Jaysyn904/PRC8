//::///////////////////////////////////////////////
//:: Turns player into a wolf
//:: prc_wwformwolf
//:: Copyright (c) 2004 Shepherd Soft
//:://////////////////////////////////////////////
/*

*/
//:://////////////////////////////////////////////
//:: Created By: Russell S. Ahlstrom
//:: Created On: May 11, 2004
//:://////////////////////////////////////////////

#include "pnp_shft_poly"
#include "prc_inc_template"
#include "prc_inc_wwolf"

void main()
{
    object oPC = OBJECT_SELF;
    int nPoly;
    int bTemplate = PRCWWHasTemplate(oPC);
    int bDirectTemplateChange = bTemplate
        && GetLocalInt(oPC, PRC_WW_FORM_SWITCH_RESUME) == PRC_WW_FORM_WOLF;

    if(GetLocalInt(oPC, "WWWolf") != TRUE)
    {
        if(GetLocalInt(oPC, "WWHybrid"))
        {
            if(!bTemplate)
            {
                FloatingTextStringOnCreature(
                    "Return to humanoid form before assuming wolf form.",
                    oPC, FALSE);
                return;
            }

            // D&D 3.0 permits animal <-> hybrid as one voluntary standard
            // action. The helper rolls once, genuinely restores true form,
            // then applies this destination after the engine teardown settles.
            PRCWWStartFormSwitch(oPC, PRC_WW_FORM_WOLF);
            return;
        }

        if(bTemplate && !bDirectTemplateChange
        && !PRCWWCanChange(oPC, FALSE))
            return;

        if(bTemplate)
        {
            // The _2s form has the D&D 3.0 wolf adjustments: +2 Str,
            // +4 Dex, +4 Con and +2 natural armor. The helper replaces
            // the staged DR and installs the remaining template traits.
            nPoly = PRC_WW_POLYMORPH_WOLF;
        }
        else
        {
            // Preserve the old staged-class forms for existing characters.
            nPoly = POLYMORPH_TYPE_WOLF_0;

            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1))
                nPoly = POLYMORPH_TYPE_WOLF_1;
            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2))
                nPoly = POLYMORPH_TYPE_WOLF_2;
            if(GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2))
                nPoly = POLYMORPH_TYPE_WOLF_0s;
            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1)
            && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2))
                nPoly = POLYMORPH_TYPE_WOLF_1s;
            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2)
            && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_2))
                nPoly = POLYMORPH_TYPE_WOLF_2s;
            if(GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
                nPoly = POLYMORPH_TYPE_WOLF_0l;
            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_1)
            && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
                nPoly = POLYMORPH_TYPE_WOLF_1l;
            if(GetHasFeat(FEAT_PRESTIGE_WOLFCLASS_2)
            && GetHasFeat(FEAT_PRESTIGE_WEREWOLFCLASS_3))
                nPoly = POLYMORPH_TYPE_WOLF_2l;
        }

        if(bTemplate)
        {
            PRCWWBeginFormTransition(oPC);
            LycanthropePoly(oPC, nPoly, FALSE, TRUE);
        }
        else
            LycanthropePoly(oPC, nPoly, !bTemplate);

        if(bTemplate)
        {
            object oFormSkin = GetItemInSlot(INVENTORY_SLOT_CARMOUR, oPC);
            if(!GetIsObjectValid(oFormSkin)
            || GetResRef(oFormSkin) != "werewolfskin2s")
            {
                if(bDirectTemplateChange)
                {
                    SetLocalInt(oPC, PRC_WW_FORM_SWITCH_FAILED, TRUE);
                    FloatingTextStringOnCreature(
                        "Wolf form failed; restoring your previous form.",
                        oPC, FALSE);
                }
                else
                {
                    ExecuteScript("prc_wwunpoly", oPC);
                    DeleteLocalInt(oPC, PRC_WW_VOLUNTARY_TRANSITION);
                    PRCWWQueueFormTransitionEval(oPC);
                    FloatingTextStringOnCreature(
                        "Wolf form failed; transformation cancelled.",
                        oPC, FALSE);
                }
                return;
            }
        }

        SetLocalInt(oPC, "WWWolf", TRUE);

        if(bTemplate)
        {
            // A staged Hybrid -> Wolf handoff is not committed until its
            // post-apply settle check proves the destination remained valid.
            if(!bDirectTemplateChange)
                PRCWWOnAssumeForm(oPC);
            PRCWWApplyFormProperties(oPC, FALSE);
            DelayCommand(0.1, PRCWWRefreshWolfForm(oPC));
            PRCWWQueueFormTransitionEval(oPC);
        }
    }
    else
    {
        if(bTemplate && !PRCWWCanChange(oPC, TRUE))
            return;

        ExecuteScript("prc_wwunpoly", oPC);
        if(bTemplate && PRCWWHasTemplateFormEffect(oPC))
            return;

        DeleteLocalInt(oPC, "WWWolf");
        if(bTemplate)
            PRCWWOnReturnHumanoid(oPC);
    }
}
