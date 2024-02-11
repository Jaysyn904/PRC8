#include "true_inc_trufunc"
//#include "prc_alterations"
#include "inc_dynconv"

void ApplyScryEffects(object oTrueSpeaker)
{
    if(DEBUG) DoDebug("prc_inc_scry: ApplyScryEffects():\n"
                    + "oTrueSpeaker = '" + GetName(oTrueSpeaker) + "'"
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
       	       // Permanent until Scry ends
       	       ApplyEffectToObject(DURATION_TYPE_TEMPORARY, ExtraordinaryEffect(eLink), oTrueSpeaker, GetLocalFloat(oTrueSpeaker, "ScryDuration") + 6.0);

    // Create array for storing a list of the nerfed weapons in
    array_create(oTrueSpeaker, "Scry_Nerfed");

    object oWeapon;
    itemproperty ipNoDam = ItemPropertyNoDamage();
    oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oTrueSpeaker);
    if(IPGetIsMeleeWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oTrueSpeaker, "Scry_Nerfed", array_get_size(oTrueSpeaker, "Scry_Nerfed"), oWeapon);
        }
        // Check left hand only if right hand had a weapon
        oWeapon = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oTrueSpeaker);
        if(IPGetIsMeleeWeapon(oWeapon)){
            if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
                //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
                AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
                array_set_object(oTrueSpeaker, "Scry_Nerfed", array_get_size(oTrueSpeaker, "Scry_Nerfed"), oWeapon);
        }}
    }else if(IPGetIsRangedWeapon(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oTrueSpeaker, "Scry_Nerfed", array_get_size(oTrueSpeaker, "Scry_Nerfed"), oWeapon);
    }}

    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_B, oTrueSpeaker);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oTrueSpeaker, "Scry_Nerfed", array_get_size(oTrueSpeaker, "Scry_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_L, oTrueSpeaker);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oTrueSpeaker, "Scry_Nerfed", array_get_size(oTrueSpeaker, "Scry_Nerfed"), oWeapon);
    }}
    oWeapon = GetItemInSlot(INVENTORY_SLOT_CWEAPON_R, oTrueSpeaker);
    if(GetIsObjectValid(oWeapon)){
        if(!GetItemHasItemProperty(oWeapon, ITEM_PROPERTY_NO_DAMAGE)){
            //SetLocalInt(oWeapon, "BaelnornProjection_NoDamage", TRUE);
            AddItemProperty(DURATION_TYPE_PERMANENT, ipNoDam, oWeapon);
            array_set_object(oTrueSpeaker, "Scry_Nerfed", array_get_size(oTrueSpeaker, "Scry_Nerfed"), oWeapon);
    }}
}

void main()
{
        object oTrueSpeaker = OBJECT_SELF;
        
        //Declare major variables
        object oTarget;
        float fDur = 12.0;
        
        SetLocalFloat(oTrueSpeaker, "ScryDuration", fDur);       
        SetLocalInt(oTrueSpeaker, "SeeTheNamed", TRUE);  
        DelayCommand(30.0, DeleteLocalInt(oTrueSpeaker, "SeeTheNamed"));
        
        //AssignCommand(oTrueSpeaker, ClearAllActions(TRUE));
        if (DEBUG) DoDebug("true_tru_seename: Starting Dynamic Convo");
        StartDynamicConversation("prc_scry_conv", oTrueSpeaker, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oTrueSpeaker);
        
        // Apply the immunity effects
        ApplyScryEffects(oTrueSpeaker);
}