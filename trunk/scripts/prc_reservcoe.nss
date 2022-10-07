//Spell script for reserve feat Clutch of Earth
//prc_reservcoe
//by ebonfowl
//Dedicated to Edgar, the real Ebonfowl

#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"
#include "prc_inc_spells"

int EFIsFlying(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bFlying = FALSE;
    switch(nAppearance)
    {
        case APPEARANCE_TYPE_ALLIP:
        case APPEARANCE_TYPE_BAT:
        case APPEARANCE_TYPE_BAT_HORROR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_FAERIE_DRAGON:
        case APPEARANCE_TYPE_FALCON:
        case APPEARANCE_TYPE_FAIRY:
        case APPEARANCE_TYPE_HELMED_HORROR:
        case APPEARANCE_TYPE_IMP:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case APPEARANCE_TYPE_MEPHIT_AIR:
        case APPEARANCE_TYPE_MEPHIT_DUST:
        case APPEARANCE_TYPE_MEPHIT_EARTH:
        case APPEARANCE_TYPE_MEPHIT_FIRE:
        case APPEARANCE_TYPE_MEPHIT_ICE:
        case APPEARANCE_TYPE_MEPHIT_MAGMA:
        case APPEARANCE_TYPE_MEPHIT_OOZE:
        case APPEARANCE_TYPE_MEPHIT_SALT:
        case APPEARANCE_TYPE_MEPHIT_STEAM:
        case APPEARANCE_TYPE_MEPHIT_WATER:
        case APPEARANCE_TYPE_QUASIT:
        case APPEARANCE_TYPE_RAVEN:
        case APPEARANCE_TYPE_SHADOW:
        case APPEARANCE_TYPE_SHADOW_FIEND:
        case APPEARANCE_TYPE_SPECTRE:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_WRAITH:
        case APPEARANCE_TYPE_WYRMLING_BLACK:
        case APPEARANCE_TYPE_WYRMLING_BLUE:
        case APPEARANCE_TYPE_WYRMLING_BRASS:
        case APPEARANCE_TYPE_WYRMLING_BRONZE:
        case APPEARANCE_TYPE_WYRMLING_COPPER:
        case APPEARANCE_TYPE_WYRMLING_GOLD:
        case APPEARANCE_TYPE_WYRMLING_GREEN:
        case APPEARANCE_TYPE_WYRMLING_RED:
        case APPEARANCE_TYPE_WYRMLING_SILVER:
        case APPEARANCE_TYPE_WYRMLING_WHITE:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        case 401: //beholder
        case 402: //beholder
        case 403: //beholder
        case 419: // harpy
        case 430: // Demi Lich
        case 472: // Hive mother
        bFlying = TRUE;
    }
    return bFlying;
}

void main()
{
	object oPC= OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    int nBonus = 50 + (GetLocalInt(oPC, "ClutchOfEarthBonus")*5);
    int nDC = 10 + GetLocalInt(oPC, "ClutchOfEarthBonus") + GetDCAbilityModForClass(GetPrimarySpellcastingClass(oPC), oPC);
    
    effect eVis = EffectVisualEffect(VFX_IMP_HEAD_NATURE);
    effect eEffect = EffectMovementSpeedDecrease(nBonus);
           eEffect = SupernaturalEffect(eEffect);

    if (!GetLocalInt(oPC, "ClutchOfEarthBonus"))
    {
        FloatingTextStringOnCreature("You do not have a spell available of adequate level or type", oPC, FALSE);
        return;
    }

    if (EFIsFlying(oTarget) == TRUE)
    {
        FloatingTextStringOnCreature("Clutch of Earth does not affect flying enemies", oPC, FALSE);
        return;
    }

    if (GetLocalInt(oTarget, "ClutchOfEarthSaved") == TRUE)
    {
        FloatingTextStringOnCreature("This creature cannot be affected by Touch of Earth for 24 hours", oPC, FALSE);
        return;
    }

    if (!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC))
    {
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eEffect, oTarget, 1.0);
    }
    else SetLocalInt(oTarget, "ClutchOfEarthSaved", TRUE);
}