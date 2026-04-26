/*
18/02/19 by Stratovarius

Far Sight

Master, Eyes of the Night Sky
Level/School: 8th/Divination (Scrying) 
Range: See text 
Effect: Magical sensor 
Duration: 1 minute/level
Saving Throw: Will negates 
Spell Resistance: Yes

You alter your perceptions to see through any shadow, anywhere.

Far sight is similar to the spell greater scrying, with the modifications described here. This mystery allows you to see the subject’s true essence, as with the truth revealed mystery. 
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"
#include "inc_dynconv"

void ApplyScryEffects(object oPC)
{
    if(DEBUG) DoDebug("prc_inc_scry: ApplyScryEffects():\n"
                    + "oPC = '" + GetName(oPC) + "'"
                      );
    // The Scryer is not supposed to be visible, nor can he move or cast
    // He also can't take damage from scrying
        effect eLink    = EffectSpellImmunity(SPELL_ALL_SPELLS);
        // Damage immunities
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ACID,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_BLUDGEONING, 100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_COLD,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_DIVINE,      100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_ELECTRICAL,  100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_FIRE,        100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_MAGICAL,     100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_NEGATIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_PIERCING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_POSITIVE,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SLASHING,    100));
               eLink    = EffectLinkEffects(eLink, EffectDamageImmunityIncrease(DAMAGE_TYPE_SONIC,       100));
        // Specific immunities
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ABILITY_DECREASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_BLINDNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEAFNESS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_CRITICAL_HIT));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DEATH));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_DISEASE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_ENTANGLE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SLOW));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_KNOCKDOWN));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_NEGATIVE_LEVEL));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_PARALYSIS));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SILENCE));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_SNEAK_ATTACK));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_TRAP));
               eLink    = EffectLinkEffects(eLink, EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS));
       // Random stuff
               eLink      = EffectLinkEffects(eLink, EffectCutsceneGhost());
               eLink      = EffectLinkEffects(eLink, EffectCutsceneImmobilize());
               eLink      = EffectLinkEffects(eLink, EffectEthereal());
               eLink      = EffectLinkEffects(eLink, EffectAttackDecrease(50));
               eLink      = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CUTSCENE_INVISIBILITY));
               
        // True Seeing
                effect eTrueSee = EffectTrueSeeing();        
        
                // Adjust to PnP-like True Seeing
                if(GetPRCSwitch(PRC_PNP_TRUESEEING))
                {
                    eTrueSee  = EffectSeeInvisible();
                    int nSpot = GetPRCSwitch(PRC_PNP_TRUESEEING_SPOT_BONUS);
                    // Default to 15
                    if(nSpot == 0)
                        nSpot = 15;
                    effect eSpot = EffectSkillIncrease(SKILL_SPOT, nSpot);
                    eTrueSee     = EffectLinkEffects(eTrueSee , eSpot);
                }        
               eLink      = EffectLinkEffects(eLink, eTrueSee);                
               // Permanent until Scry ends
               ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oPC, GetLocalFloat(oPC, "ScryDuration") + 6.0);
               

                
    // Create array for storing a list of the nerfed weapons in
    array_create(oPC, "Scry_Nerfed");

    object oWeapon;
    itemproperty ipNoDam = ItemPropertyNoDamage();
    oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oPC);
    if(IPGetIsMeleeWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
        }
        // Check left hand only if right hand had a weapon
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oPC);
        if(IPGetIsMeleeWeapon(oWeapon)){
            if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
                //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
                AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
                array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
        }}
    }else if(IPGetIsRangedWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}

    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oPC);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oPC, "Scry_Nerfed", array_get_size(oPC, "Scry_Nerfed"), oWeapon);
    }}
}

void main()
{
    if(!ShadPreMystCastCode()) return;

    object oShadow      = OBJECT_SELF;
    object oTarget      = PRCGetSpellTargetObject();
    struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_EXTEND);
	
	// Check if current area blocks scrying  
	if(GetLocalInt(GetArea(oShadow), "SCRY_FROM_AREA_BLOCKED"))  
	{  
		FloatingTextStringOnCreature("This area prevents scrying.", oShadow, FALSE);  
		return;  
	}

    if(myst.bCanMyst)
    {
        myst.fDur = TurnsToSeconds(myst.nShadowcasterLevel);
        if(myst.bExtend) myst.fDur *= 2;      
        SetLocalInt(oShadow, "ScryCasterLevel", myst.nShadowcasterLevel);
        SetLocalInt(oShadow, "ScrySpellId", myst.nMystId);
        SetLocalInt(oShadow, "ScrySpellDC", GetShadowcasterDC(oShadow));
        SetLocalFloat(oShadow, "ScryDuration", myst.fDur);  
        
        StartDynamicConversation("prc_scry_conv", oShadow, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oShadow);
        
        // Apply the immunity effects
        ApplyScryEffects(oShadow);        
    }
}