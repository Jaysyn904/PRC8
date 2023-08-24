//::///////////////////////////////////////////////
//:: Web
//:: NW_S0_Web.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Creates a mass of sticky webs that cling to
    and entangle target who fail a Reflex Save
    Those caught can make a new save every
    round.  Movement in the web is 1/6 normal.
    The higher the creatures Strength the faster
    they move out of the web.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Aug 8, 2001
//:://///////////////////////////////////////////

//:: modified by mr_bumpkin  Dec 4, 2003
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables including Area of Effect Object
    effect eAOE = EffectAreaOfEffect(AOE_PER_WEB);

    location lTarget = PRCGetSpellTargetLocation();
    int CasterLvl = PRCGetCasterLevel();
    int nDuration = CasterLvl / 2;
    int nMetaMagic = PRCGetMetaMagicFeat();
    //Make sure duration does no equal 0
    if (nDuration < 1)
    {
        nDuration = 1;
    }
    //Check Extend metamagic feat.
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
       nDuration = nDuration *2;    //Duration is +100%
    }
    //Create an instance of the AOE Object using the Apply Effect function
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_WEB");
    SetAllAoEInts(SPELL_WEB, oAoE, PRCGetSpellSaveDC(SPELL_WEB, SPELL_SCHOOL_CONJURATION), 0, CasterLvl);

    PRCSetSchool();
}

