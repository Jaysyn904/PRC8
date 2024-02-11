/////////////////////////////////////////////////
// Whip of Shar
// tm_s0_epwhipshar.nss
//-----------------------------------------------
// Created By: Nron Ksr
// Created On: 03/12/2004
// Description: Creates a magical whip from the goddess Shar herself.
//              (MAYBE, I'll create it alignment specific)
/////////////////////////////////////////////////
// Last Updated: 03/12/2004, Nron Ksr
/////////////////////////////////////////////////

#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"

void AddEffectsToWeapon( object oTarget, float fDuration, int iCasterLvl )
{
    /* If the spell is cast again, any previous itemproperties matching are removed.
       Declaring variables
       +1, per 3 caster lvls, Vampiric Regen: 12 pnts, OnHit: Blindness - DC:26,
       Piercing: 2d12, Slashing: 2d12, and OnHit: Darkness.
    */
    IPSafeAddItemProperty( oTarget,
        ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_PIERCING,
        IP_CONST_DAMAGEBONUS_2d12), fDuration,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oTarget,
        ItemPropertyDamageBonus(IP_CONST_DAMAGETYPE_SLASHING,
        IP_CONST_DAMAGEBONUS_2d12), fDuration,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oTarget,
        ItemPropertyVampiricRegeneration(12), fDuration,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oTarget,
        ItemPropertyEnhancementBonus(iCasterLvl / 3), fDuration,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oTarget,
        ItemPropertyOnHitProps(IP_CONST_ONHIT_BLINDNESS,
        IP_CONST_ONHIT_SAVEDC_26, IP_CONST_ONHIT_DURATION_50_PERCENT_2_ROUNDS),
        fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oTarget,
        ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_DARKNESS,
        iCasterLvl / 5), fDuration, X2_IP_ADDPROP_POLICY_REPLACE_EXISTING );
    IPSafeAddItemProperty( oTarget,
        ItemPropertyVisualEffect(ITEM_VISUAL_EVIL), fDuration,
        X2_IP_ADDPROP_POLICY_REPLACE_EXISTING,FALSE,TRUE );
    return;
}

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_EVOCATION);

    // Spell Cast Hook
    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_WHIP_SH))
    {

        //Declare major variables
        object oPC = PRCGetSpellTargetObject();

        // Visual effect only
        effect eVis = EffectVisualEffect( VFX_IMP_AURA_NEGATIVE_ENERGY );
        eVis = EffectLinkEffects( EffectVisualEffect(VFX_IMP_EVIL_HELP),eVis );
        eVis = EffectLinkEffects( EffectVisualEffect(VFX_IMP_PULSE_NEGATIVE),eVis );

        // Visual and substantial effects to caster
        effect ether = EffectVisualEffect( VFX_DUR_ETHEREAL_VISAGE );
        effect ultra = EffectVisualEffect( VFX_DUR_ULTRAVISION );
        effect eyes = EffectVisualEffect( VFX_DUR_MAGICAL_SIGHT );
        effect eDur = EffectVisualEffect( VFX_DUR_CESSATE_POSITIVE );
        effect conceal = EffectConcealment(33);
        effect vision = EffectUltravision();
        eDur = EffectLinkEffects( eDur, ether );
        eDur = EffectLinkEffects( eDur, ultra );
        eDur = EffectLinkEffects( eDur, eyes );
        eDur = EffectLinkEffects( eDur, conceal );
        eDur = EffectLinkEffects( eDur, vision );
        eDur = ExtraordinaryEffect(eDur);

        int iCasterLvl = GetTotalCastingLevel(OBJECT_SELF); // Bone - changed.
        int iDuration = iCasterLvl;
        itemproperty ipExoticFeat =
            PRCItemPropertyBonusFeat(IP_CONST_FEAT_WEAPON_PROF_EXOTIC);
        object oHide = GetPCSkin(oPC);
        object oWeapon = OBJECT_INVALID;

        /* Boneshank - Not required, since player must already have a hide item.
        if( !GetIsObjectValid(oHide) )
        {
            // Create a creature hide if the PC doesn't have one.
            oHide = CreateItemOnObject( "x2_it_emptyskin", oPC );
            // Need to ID the hide before we can put it on the PC
            SetIdentified( oHide, TRUE );
            AssignCommand( oPC, ActionEquipItem(oHide, INVENTORY_SLOT_CARMOUR) );
        }
         */
        if( GetIsObjectValid(oHide) )
        {
            // Adding the Exotic Feat to the caster via the oHide object.
            IPSafeAddItemProperty( oHide, ipExoticFeat,
                TurnsToSeconds(iDuration), X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
        }
        else
        { return; }

        oWeapon = GetItemPossessedBy( oPC, "WhipofShar" );

        // Have I cast "Whip of Shar" once already?
        if( GetLocalInt(oPC, "WhipOfShar") == 1 )
        {
            IPRemoveAllItemProperties( oWeapon );
        }
        else
        {
            if( oWeapon == OBJECT_INVALID )
            {
                // Create Shars whip for the caster.
                oWeapon = CreateItemOnObject( "whipofshar", oPC );
                SetDroppableFlag( oWeapon, FALSE );
            }
        }

        if( GetIsObjectValid(oWeapon) )
        {
            SignalEvent(oPC, EventSpellCastAt(OBJECT_SELF, GetSpellId(), FALSE));

            if( iDuration > 0 )
            {
                // Applying various effects to the Caster & Weapon.
                SPApplyEffectToObject( DURATION_TYPE_INSTANT, eVis, oPC );
                SPApplyEffectToObject( DURATION_TYPE_TEMPORARY, eDur, oPC,
                    TurnsToSeconds(iDuration), TRUE, -1, GetTotalCastingLevel(OBJECT_SELF) );
                AddEffectsToWeapon( oWeapon,
                    TurnsToSeconds(iDuration),iCasterLvl );
                //Add the Exotic Weapons feature to oHide temporarily.
                IPSafeAddItemProperty( oHide, ipExoticFeat,
                    TurnsToSeconds(iDuration),
                    X2_IP_ADDPROP_POLICY_KEEP_EXISTING );
            }
        }
        else
        { return; }

        // Darkness, centered on the caster.
        AssignCommand( oPC,
            ActionCastSpellAtLocation(SPELL_DARKNESS, PRCGetSpellTargetLocation(),
            METAMAGIC_ANY,TRUE, PROJECTILE_PATH_TYPE_DEFAULT, TRUE) );
        ActionDoCommand( AssignCommand(oPC,
            ActionEquipItem(oWeapon, INVENTORY_SLOT_RIGHTHAND)) );

        // Setting Locals to try to not allow exploitation of multicasts.
        if( GetLocalInt(oPC, "WhipOfShar") == 0 )
        {
            // To record if the spell was already cast or not.
            SetLocalInt( oPC, "WhipOfShar", 1 );
        }

        // Don't want to really destroy the object.
        // Does it make much sense?  The effects will wear off,
        // yes, but you don't want to be defenseless, do you?
        // You can't store the whip except in your
        // inventory though... trade offs.. trade offs...
        DelayCommand( TurnsToSeconds(iDuration),
            AssignCommand(GetModule(), DestroyObject(oWeapon)) );
        DelayCommand( TurnsToSeconds(iDuration),
            SetLocalInt(oPC, "WhipOfShar", 0) );
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}
