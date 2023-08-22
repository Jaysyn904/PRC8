//::///////////////////////////////////////////////
//:: Glyph of Warding
//:: X2_S0_GlphWard
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    The caster creates a trapped area which detects
    the entrance of enemy creatures into 3 m area
    around the spell location.  When tripped it
    causes a sonic explosion that does 1d8 per
    two caster levels up to a max of 5d8 damage.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Dec 04, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
    if(!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_ABJURATION);

    object oCaster = OBJECT_SELF;
    object oGlyph = CreateObject(OBJECT_TYPE_PLACEABLE, "x2_plc_glyph", PRCGetSpellTargetLocation());
    object oTest = GetNearestObjectByTag("X2_PLC_GLYPH",oGlyph);

    if(GetIsObjectValid(oTest) && GetDistanceBetween(oGlyph, oTest) <5.0f)
    {
        FloatingTextStrRefOnCreature(84612, oCaster);
        DestroyObject(oGlyph);
        return;
    }

    // Store the caster
    SetLocalObject(oGlyph, "X2_PLC_GLYPH_CASTER", oCaster);

    // Store the caster level
    SetLocalInt(oGlyph, "X2_PLC_GLYPH_CASTER_LEVEL", PRCGetCasterLevel(oCaster));

    // Store Meta Magic
    SetLocalInt(oGlyph, "X2_PLC_GLYPH_CASTER_METAMAGIC", PRCGetMetaMagicFeat());

    // This spell (default = line 764 in spells.2da) will run when someone enters the glyph
    SetLocalInt(oGlyph, "X2_PLC_GLYPH_SPELL", 764);

    // Store the spell id for differen glyph types
    SetLocalInt(oGlyph, "X2_PLC_GLYPH_SPELLID", GetSpellId());

    // Tell the system that this glyph was player and not toolset created
    SetLocalInt(oGlyph, "X2_PLC_GLYPH_PLAYERCREATED", TRUE);

    // Tell the game the glyph is not a permanent one
    DeleteLocalInt(oGlyph, "X2_PLC_GLYPH_PERMANENT");

    // Force first hb
    ExecuteScript("x2_o0_glyphhb", oGlyph);

    PRCSetSchool();
}