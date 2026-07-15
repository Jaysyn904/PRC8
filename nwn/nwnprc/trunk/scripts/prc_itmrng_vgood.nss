//::///////////////////////////////////////////////
//:: Ring of Virtuous Good
//:: prc_itmrng_vgood
//::///////////////////////////////////////////////
/*
    Equip (good/neutral):  Permanent, undispellable
                           mind-spell immunity and SR 25
                           vs evil + on-hit blindness
                           vs evil attackers via skin.
    Equip (evil):          Permanent, undispellable
                           negative level.
    Unequip:               Both effects removed.
 
    Note: +4 deflection AC and +4 resistance saves
    are handled as itemprops in craft_ring.2da.
 
    Registered via PRC8 event hook system —
    works for PCs and NPCs alike.
*/
//::///////////////////////////////////////////////
#include "prc_inc_spells"
#include "prc_inc_skin"
#include "inc_eventhook"
 
const string RING_HOLY_AURA_TAG     = "PRC_RING_HOLY_AURA";
const string RING_HOLY_AURA_NL      = "PRC_RING_HOLY_AURA_NL";
const string RING_HOLY_AURA_ONHIT   = "PRC_RING_HOLY_AURA_OH";
const string RING_VIRTUOUS_GOOD_TAG = "PRC_ITMRNG_VGOOD";
 
// -------------------------------------------------------------------
// On-hit blindness handler — routed via PRC event system
// -------------------------------------------------------------------
void OnHitHolyAura(object oPC)
{
    object oAttacker = GetSpellTargetObject();
 
    if (!GetIsObjectValid(oAttacker))                       return;
    if (GetAlignmentGoodEvil(oAttacker) != ALIGNMENT_EVIL) return;
 
    int nDC = 10 + 8 + GetAbilityModifier(ABILITY_WISDOM, oPC);
 
    if (!PRCMySavingThrow(SAVING_THROW_FORT, oAttacker, nDC,
            SAVING_THROW_TYPE_SPELL, oPC))
    {
        effect eBlind = SupernaturalEffect(EffectBlindness());
        ApplyEffectToObject(DURATION_TYPE_PERMANENT, eBlind, oAttacker);
        ApplyEffectToObject(DURATION_TYPE_INSTANT,
            EffectVisualEffect(VFX_IMP_BLIND_DEAF_M), oAttacker);
    }
}
 
// -------------------------------------------------------------------
// Skin on-hit property management
// -------------------------------------------------------------------
void AddOnHitToSkin(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    itemproperty ip = ItemPropertyOnHitCastSpell(
        IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
    ip = TagItemProperty(ip, RING_HOLY_AURA_ONHIT);
    IPSafeAddItemProperty(oSkin, ip, 0.0, X2_IP_ADDPROP_POLICY_KEEP_EXISTING);
    SetLocalString(oPC, RING_HOLY_AURA_ONHIT, "prc_itmrng_vgood");
}
 
void RemoveOnHitFromSkin(object oPC)
{
    object oSkin = GetPCSkin(oPC);
    itemproperty ip = GetFirstItemProperty(oSkin);
    while (GetIsItemPropertyValid(ip))
    {
        if (GetItemPropertyTag(ip) == RING_HOLY_AURA_ONHIT)
            RemoveItemProperty(oSkin, ip);
        ip = GetNextItemProperty(oSkin);
    }
    DeleteLocalString(oPC, RING_HOLY_AURA_ONHIT);
}
 
// -------------------------------------------------------------------
// Aura and penalty application/removal
// -------------------------------------------------------------------
void ApplyHolyAura(object oPC)
{
    // Strip any existing ring aura to prevent stacking on re-equip
    effect e = GetFirstEffect(oPC);
    while (GetIsEffectValid(e))
    {
        if (GetEffectTag(e) == RING_HOLY_AURA_TAG)
            RemoveEffect(oPC, e);
        e = GetNextEffect(oPC);
    }
 
    effect eImmune = EffectImmunity(IMMUNITY_TYPE_MIND_SPELLS);
    effect eSR     = EffectSpellResistanceIncrease(25);
    effect eDur    = EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR);
    effect eDur2   = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);
 
    eImmune = VersusAlignmentEffect(eImmune, ALIGNMENT_ALL, ALIGNMENT_EVIL);
    eSR     = VersusAlignmentEffect(eSR,     ALIGNMENT_ALL, ALIGNMENT_EVIL);
 
    effect eLink = EffectLinkEffects(eImmune, eSR);
    eLink = EffectLinkEffects(eLink, eDur);
    eLink = EffectLinkEffects(eLink, eDur2);
 
    eLink = TagEffect(eLink, RING_HOLY_AURA_TAG);
    eLink = SupernaturalEffect(eLink);
    eLink = UnyieldingEffect(eLink);
 
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oPC);
    ApplyEffectToObject(DURATION_TYPE_INSTANT,
        EffectVisualEffect(VFX_DUR_PROTECTION_GOOD_MAJOR), oPC);
 
    AddOnHitToSkin(oPC);
}
 
void ApplyEvilPenalty(object oPC)
{
    effect e = GetFirstEffect(oPC);
    while (GetIsEffectValid(e))
    {
        if (GetEffectTag(e) == RING_HOLY_AURA_NL)
            RemoveEffect(oPC, e);
        e = GetNextEffect(oPC);
    }
 
    effect eNL = EffectNegativeLevel(1);
    eNL = TagEffect(eNL, RING_HOLY_AURA_NL);
    eNL = SupernaturalEffect(eNL);
    eNL = UnyieldingEffect(eNL);
 
    ApplyEffectToObject(DURATION_TYPE_PERMANENT, eNL, oPC);
}
 
void RemoveRingEffects(object oPC)
{
    effect e = GetFirstEffect(oPC);
    while (GetIsEffectValid(e))
    {
        string sTag = GetEffectTag(e);
        if (sTag == RING_HOLY_AURA_TAG || sTag == RING_HOLY_AURA_NL)
            RemoveEffect(oPC, e);
        e = GetNextEffect(oPC);
    }
    RemoveOnHitFromSkin(oPC);
}
 
// -------------------------------------------------------------------
// Event handlers
// -------------------------------------------------------------------
void OnEquip()
{
    object oPC   = GetPCItemLastEquippedBy();
    object oItem = GetPCItemLastEquipped();
 
    if (GetTag(oItem) != RING_VIRTUOUS_GOOD_TAG) return;
 
    if (GetAlignmentGoodEvil(oPC) == ALIGNMENT_EVIL)
        ApplyEvilPenalty(oPC);
    else
        ApplyHolyAura(oPC);
}
 
void OnUnequip()
{
    object oPC   = GetPCItemLastUnequippedBy();
    object oItem = GetPCItemLastUnequipped();
 
    if (GetTag(oItem) != RING_VIRTUOUS_GOOD_TAG) return;
 
    RemoveRingEffects(oPC);
}
 
void main()
{
    int nEvent = GetRunningEvent();
 
    switch (nEvent)
    {
        case EVENT_ONPLAYEREQUIPITEM:   OnEquip();                   	break;
        case EVENT_ONPLAYERUNEQUIPITEM: OnUnequip();                 	break;
        case EVENT_ONHIT:      			OnHitHolyAura(OBJECT_SELF); 	break;
    }
}