//::///////////////////////////////////////////////
//:: Etherealness
//:: x0_s0_ether.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Like sanctuary except almost always guaranteed
    to work.
    Lasts one turn per level.
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff
#include "prc_inc_spells"
#include "prc_add_spell_dc"
#include "prc_inc_teleport"

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
    effect eVis = EffectVisualEffect(VFX_DUR_SANCTUARY);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
    effect eSanc = EffectEthereal();

    effect eLink = EffectLinkEffects(eVis, eSanc);
    eLink = EffectLinkEffects(eLink, eDur);

    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int nDuration = CasterLvl;
    //Enter Metamagic conditions
    int nMetaMagic = PRCGetMetaMagicFeat();
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND))
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Fire cast spell at event for the specified target
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_ETHEREALNESS, FALSE));

    // Make a check to see nothing is preventing extra-dimensional movement
    if(GetCanTeleport(oTarget, GetLocation(oTarget), FALSE, TRUE))
    {
        //Apply the VFX impact and effects
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, TurnsToSeconds(nDuration),TRUE,-1,CasterLvl);
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}



