//::///////////////////////////////////////////////
//:: Drown
//:: [X0_S0_Drown.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
    if the creature fails a FORT throw.
    Does not work against Undead, Constructs, or Elementals.

January 2003:
 - Changed to instant kill the target.
May 2003:
 - Changed damage to 90% of current HP, instead of instant kill.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 26 2002
//:://////////////////////////////////////////////
//:: Last Update By: Andrew Nobbs May 01, 2003

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"


#include "prc_add_spell_dc"

void main()
{
DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);
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


    //Declare major variables
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLevel = PRCGetCasterLevel(OBJECT_SELF);
    int nDam = GetCurrentHitPoints(oTarget);
    //Set visual effect
    effect eVis = EffectVisualEffect(VFX_IMP_FROST_S);
    effect eDam;
    //Check faction of target
    nCasterLevel +=SPGetPenetr();
    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, 437));
        //Make SR Check
        if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nCasterLevel))
        {
            // * certain racial types are immune
            if ((MyPRCGetRacialType(oTarget) != RACIAL_TYPE_CONSTRUCT)
                &&(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                &&(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_ELEMENTAL))
            {
                //Make a fortitude save
                if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, (PRCGetSaveDC(oTarget,OBJECT_SELF))))
                {
                    nDam = FloatToInt(nDam * 0.9);
                    eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_BLUDGEONING);
                    //Apply the VFX impact and damage effect
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
                    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);

                }
            }
        }
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}





