//::///////////////////////////////////////////////
//:: Wall of Frost
//:: SP_WallFrost.nss
//:: 
//:://////////////////////////////////////////////
/*
    Creates a wall of ice that chills any creature
    entering the area around the wall.  Those moving
    through the AOE are frostbitten for 4d6 cold damage
*/
//:://////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);
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

// End of Spell Cast Hook


    //Declare Area of Effect object using the appropriate constant
    effect eAOE = EffectAreaOfEffect(AOE_PER_WALLFROST);
    //Get the location where the wall is to be placed.
    location lTarget = PRCGetSpellTargetLocation();
    int nCasterLevel = PRCGetCasterLevel();
    int nDuration = nCasterLevel / 2;
    if(nDuration == 0)
    {
        nDuration = 1;
    }
    int nMetaMagic = PRCGetMetaMagicFeat();

        //Check for metamagic
        if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
        {
            nDuration = nDuration *2;   //Duration is +100%
        }
    //Create the Area of Effect Object declared above.
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eAOE, lTarget, RoundsToSeconds(nDuration));

    object oAoE = GetAreaOfEffectObject(lTarget, "VFX_PER_WALLFROST");
    SetAllAoEInts(GetSpellId(), oAoE, PRCGetSpellSaveDC(GetSpellId(), SPELL_SCHOOL_EVOCATION), 0, nCasterLevel);
	SetLocalObject(oAoE, "ExtraordinarySpellAim_Caster", OBJECT_SELF);

	DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
	// Getting rid of the integer used to hold the spells spell school
}
