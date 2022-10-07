///////////////////////////////////
//  Discharge Crown
//  sp_disc_crown.nss
////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    object oHelm = GetItemInSlot(INVENTORY_SLOT_HEAD, oPC);
    string sResRef = GetResRef(oHelm);

    if(sResRef == "prc_crown_mght")
    {
        //+8 STR 1 round
        effect eLink = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
        eLink = EffectLinkEffects(eLink, EffectAbilityIncrease(ABILITY_STRENGTH, 8));

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(1), TRUE, SPELL_CROWN_OF_MIGHT, -1);
        object oCrown = GetItemPossessedBy(oPC, "prc_crown_might");
        if (GetIsObjectValid(oCrown)) DestroyObject(oCrown);
    }

    else if(sResRef == "prc_crown_prot")
    {
        //4 deflection bonus to AC and a +4 resistance bonus on saves for 1 round
        effect eLink = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE);
        eLink = EffectLinkEffects(eLink, EffectACIncrease(4, AC_DEFLECTION_BONUS));
        eLink = EffectLinkEffects(eLink, EffectSavingThrowIncrease(SAVING_THROW_ALL, 4, SAVING_THROW_TYPE_ALL));

        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oPC, RoundsToSeconds(1), TRUE, SPELL_CROWN_OF_PROTECTION, -1);
        object oCrown = GetItemPossessedBy(oPC, "prc_crown_prot");
        if (GetIsObjectValid(oCrown)) DestroyObject(oCrown);        
    }

    //Remove the helm
    DestroyObject(oHelm);
}