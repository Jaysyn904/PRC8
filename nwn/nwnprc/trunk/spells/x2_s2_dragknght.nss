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
// The error code 5 prevention entry. Comment out or uncomment as necessary. 
//Part Deux, Primogenitor 14/12/05
const int COMPILER_BREAKS_ON_ME_OR_NOT_AGAIN = 0xffffffff;

//:: modified by mr_bumpkin Dec 15, 2003 for PRC stuff
#include "prc_inc_spells"

#include "x2_inc_toollib"


void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_CONJURATION);
    /*
      Spellcast Hook Code
      Added 2003-06-20 by Georg
      If you want to make changes to all spells,
      check x2_inc_spellhook.nss to find out more
    */
    if (!X2PreSpellCastCode())
    {
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    }


    //Declare major variables
    int nDuration = 20;
    effect eSummon;
    effect eVis = EffectVisualEffect(460);
    eSummon = EffectSummonCreature("x2_s_drgred001",481,0.0f,TRUE);

    // * make it so dragon cannot be dispelled
    eSummon = ExtraordinaryEffect(eSummon);
    //Apply the summon visual and summon the dragon.
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon,PRCGetSpellTargetLocation(), RoundsToSeconds(nDuration));
    DelayCommand(1.0f,ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis,PRCGetSpellTargetLocation()));

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Getting rid of the local integer storing the spellschool name
}


