//::///////////////////////////////////////////////
//:: Draconic Aura Toggle - Marshal Auras
//:: prc_dracmars_tgl.nss
//::///////////////////////////////////////////////
/*
    Toggles draconic auras gained as Major Auras.
*/
//:://////////////////////////////////////////////
//:: Created By: xwarren
//:: Created On: Apr 2, 2011
//:://////////////////////////////////////////////

#include "prc_alterations"
void main()
{
    object oPC = OBJECT_SELF;
    int nSpellID = GetSpellId();
    int nAuraID, iElement;

    switch(nSpellID)
    {
        case SPELL_MARSHAL_AURA_PRESENCE:   nAuraID = SPELL_DRACONIC_AURA_PRESENCE; break;
        case SPELL_MARSHAL_AURA_TOUGHNESS:  nAuraID = SPELL_DRACONIC_AURA_TOUGHNESS; break;
        case SPELL_MARSHAL_AURA_SENSES:     nAuraID = SPELL_DRACONIC_AURA_SENSES; break;
        case SPELL_MARSHAL_AURA_INSIGHT:    nAuraID = SPELL_DRACONIC_AURA_INSIGHT; break;
        case SPELL_MARSHAL_AURA_RESOLVE:    nAuraID = SPELL_DRACONIC_AURA_RESOLVE; break;
        case SPELL_MARSHAL_AURA_STAMINA:    nAuraID = SPELL_DRACONIC_AURA_STAMINA; break;
        case SPELL_MARSHAL_AURA_SWIFTNESS:  nAuraID = SPELL_DRACONIC_AURA_SWIFTNESS; break;
        case SPELL_MARSHAL_AURA_RESISTACID: nAuraID = SPELL_DRACONIC_AURA_RESISTANCE; iElement = DAMAGE_TYPE_ACID; break;
        case SPELL_MARSHAL_AURA_RESISTCOLD: nAuraID = SPELL_DRACONIC_AURA_RESISTANCE; iElement = DAMAGE_TYPE_COLD; break;
        case SPELL_MARSHAL_AURA_RESISTELEC: nAuraID = SPELL_DRACONIC_AURA_RESISTANCE; iElement = DAMAGE_TYPE_ELECTRICAL; break;
        case SPELL_MARSHAL_AURA_RESISTFIRE: nAuraID = SPELL_DRACONIC_AURA_RESISTANCE; iElement = DAMAGE_TYPE_FIRE; break;
        case SPELL_MARSHAL_AURA_MAGICPOWER: nAuraID = SPELL_DRACONIC_AURA_MAGICPOWER; break;
        case SPELL_MARSHAL_AURA_ENERGYACID: nAuraID = SPELL_DRACONIC_AURA_ENERGY; iElement = DAMAGE_TYPE_ACID; break;
        case SPELL_MARSHAL_AURA_ENERGYCOLD: nAuraID = SPELL_DRACONIC_AURA_ENERGY; iElement = DAMAGE_TYPE_COLD; break;
        case SPELL_MARSHAL_AURA_ENERGYELEC: nAuraID = SPELL_DRACONIC_AURA_ENERGY; iElement = DAMAGE_TYPE_ELECTRICAL; break;
        case SPELL_MARSHAL_AURA_ENERGYFIRE: nAuraID = SPELL_DRACONIC_AURA_ENERGY; iElement = DAMAGE_TYPE_FIRE; break;
    }

    if(iElement)
        SetLocalInt(oPC, "DraconicAuraElement", iElement);

    ActionCastSpellAtObject(nAuraID, oPC, METAMAGIC_ANY, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE);
}