//::///////////////////////////////////////////////
//:: Dragon Knight
//:: X2_S2_DragKnght
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
     Summons an adult red dragon for you to
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
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_DRG_KNI))
    {
        //Declare major variables
        int nDuration = 20;
        string sSummon = "x2_s_drgred001";
        effect eSummon = EffectSummonCreature(sSummon,481,0.0f,TRUE);
        effect eVis = EffectVisualEffect(460);
        

        // * make it so dragon cannot be dispelled
        eSummon = ExtraordinaryEffect(eSummon);
        //Apply the summon visual and summon the dragon.
        MultisummonPreSummon();
        ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,PRCGetSpellTargetLocation(), RoundsToSeconds(nDuration));
        DelayCommand(1.0f,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis,PRCGetSpellTargetLocation()));

        DelayCommand(0.5, AugmentSummonedCreature(sSummon));
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}


