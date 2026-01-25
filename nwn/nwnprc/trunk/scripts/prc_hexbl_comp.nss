/**
 * Hexblade: Dark Companion
 * 14/09/2005
 * Stratovarius
 * Type of Feat: Class Specific
 * Prerequisite: Hexblade level 4.
 * Specifics: The Hexblade gains a dark companion. It is an illusionary creature that does not engage in combat, but all monsters near it take a -2 penalty to AC and Saves.
 * Use: Selected.
 */
 
 //::
 //:: Updated by: Jaysyn
 //;; Updated on: 2026-01-16 00:11:27
 //:: 
 
#include "prc_inc_assoc"

void main()
{
    object oPC = OBJECT_SELF;
    object oCompanion = GetAssociateNPC(ASSOCIATE_TYPE_SUMMONED, oPC, NPC_DARK_COMPANION);

    //remove previously summoned companion
    if(GetIsObjectValid(oCompanion))
    {
        DestroyAssociate(oCompanion);
        return;
    }

    oCompanion = CreateLocalNPC(oPC, ASSOCIATE_TYPE_SUMMONED, "prc_hex_darkcomp", GetLocation(oPC), NPC_DARK_COMPANION);
    AddAssociate(oPC, oCompanion);

    effect eLink = EffectAreaOfEffect(VFX_PER_10_FT_INVIS, "prc_hexbl_comp_a", "prc_hexbl_comp_c", "");
           eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_GLOW_GREY));//VFX_DUR_PROT_PRC_SHADOW_ARMOR
           eLink = EffectLinkEffects(eLink, EffectCutsceneGhost());
           eLink = EffectLinkEffects(eLink, EffectEthereal());
		   eLink = TagEffect(eLink, "DARK_COMPANION");
           eLink = UnyieldingEffect(eLink);
		   

    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oCompanion);
}