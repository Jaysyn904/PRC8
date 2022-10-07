//::///////////////////////////////////////////////
//:: Fire Shield
//:: NW_S0_FireShld.nss
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Fire Shield for the Disciple of Mephistopheles
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 7, 2002
//:://////////////////////////////////////////////
//:: Created On: Aug 28, 2003, GZ: Fixed stacking issue

//Fixed several compile time errors.
//Aaon Graywolf - Jan 8, 2004
#include "prc_class_const"
#include "x2_inc_spellhook"
#include "prc_alterations"
void main()
{

/*
  Spellcast Hook Code
  Added 2003-06-23 by GeorgZ
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
    int nDuration = 600;
    int nMetaMagic = PRCGetMetaMagicFeat();
    object oTarget = OBJECT_SELF;
    object oArmour = GetItemInSlot(INVENTORY_SLOT_CHEST, OBJECT_SELF);
    effect eVis = EffectVisualEffect(VFX_DUR_INFERNO_CHEST);
    effect eDur = EffectVisualEffect(VFX_DUR_INFERNO_CHEST);
    effect eDR = EffectDamageResistance(10, DAMAGE_POWER_PLUS_ONE, 0);
    effect eFire = EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE, 100);
    itemproperty eShield = ItemPropertyOnHitCastSpell( IP_CONST_ONHIT_CASTSPELL_COMBUST, 15);

    //Link effects
    effect eLink = EffectLinkEffects(eDR, eFire);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eVis);

    //Enter Metamagic conditions
    if (nMetaMagic == METAMAGIC_EXTEND)
    {
        nDuration = nDuration *2; //Duration is +100%
    }
    //Apply the VFX impact and effects
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nDuration));
    AddItemProperty(DURATION_TYPE_TEMPORARY, eShield, oArmour, RoundsToSeconds(nDuration));
}

