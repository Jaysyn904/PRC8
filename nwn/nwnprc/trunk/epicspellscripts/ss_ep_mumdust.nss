//::///////////////////////////////////////////////
//:: Mummy Dust
//:: X2_S2_MumDust
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Summons a strong warrior mummy for you to
     command.
*/
//:://////////////////////////////////////////////
//:: Created By: Andrew Nobbs
//:: Created On: Feb 07, 2003
//:://////////////////////////////////////////////
/*
    Altered by Boneshank, for purposes of the Epic Spellcasting project.
*/
#include "prc_alterations"
#include "inc_epicspells"
void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_NECROMANCY);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_MUMDUST))
    {
        effect eSummon;
        eSummon = EffectSummonCreature("X2_S_MUMMYWARR",496,1.0f);
        eSummon = ExtraordinaryEffect(eSummon);
        //Apply the summon visual and summon the undead.
        MultisummonPreSummon();
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eSummon, PRCGetSpellTargetLocation());
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


