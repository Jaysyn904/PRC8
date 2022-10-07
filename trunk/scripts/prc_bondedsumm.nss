//#include "inc_newspellbook"
#include "prc_inc_spells"

void main()
{
    //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    int iType = GetHasFeat(FEAT_BONDED_AIR, oPC) ? IP_CONST_DAMAGETYPE_ELECTRICAL:
                GetHasFeat(FEAT_BONDED_EARTH, oPC) ? IP_CONST_DAMAGETYPE_ACID:
                GetHasFeat(FEAT_BONDED_FIRE, oPC) ? IP_CONST_DAMAGETYPE_FIRE:
                GetHasFeat(FEAT_BONDED_WATER, oPC) ? IP_CONST_DAMAGETYPE_COLD:
                0;

    int bResisEle = GetHasFeat(FEAT_IMMUNITY_ELEMENT, oPC) ? IP_CONST_DAMAGERESIST_500:
                    GetHasFeat(FEAT_RESISTANCE_ELE20, oPC) ? IP_CONST_DAMAGERESIST_20:
                    GetHasFeat(FEAT_RESISTANCE_ELE15, oPC) ? IP_CONST_DAMAGERESIST_15:
                    GetHasFeat(FEAT_RESISTANCE_ELE10, oPC) ? IP_CONST_DAMAGERESIST_10:
                    GetHasFeat(FEAT_RESISTANCE_ELE5, oPC) ? IP_CONST_DAMAGERESIST_5:
                    0;

    if(bResisEle)
        IPSafeAddItemProperty(oSkin, ItemPropertyDamageResistance(iType, bResisEle));
    if(GetHasFeat(FEAT_IMMUNITY_SNEAKATK, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_BACKSTAB));
    if(GetHasFeat(FEAT_IMMUNITY_CRITIK, oPC))
        IPSafeAddItemProperty(oSkin, ItemPropertyImmunityMisc(IP_CONST_IMMUNITYMISC_CRITICAL_HITS));

    if(GetHasFeat(FEAT_TYPE_ELEMENTAL, oPC))
    {
        if(iType == IP_CONST_DAMAGETYPE_ELECTRICAL)
        {
            PRCRemoveEffectsFromSpell(OBJECT_SELF, SPELL_SACREDSPEED);
            ActionCastSpellOnSelf(SPELL_SACREDSPEED);
        }
        else if(iType == IP_CONST_DAMAGETYPE_FIRE)
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_COLD,IP_CONST_DAMAGEVULNERABILITY_50_PERCENT));
        else if(iType == IP_CONST_DAMAGETYPE_COLD)
            IPSafeAddItemProperty(oSkin, ItemPropertyDamageVulnerability(IP_CONST_DAMAGETYPE_FIRE,IP_CONST_DAMAGEVULNERABILITY_50_PERCENT));
    }
}
