//::///////////////////////////////////////////////
//:: Name      Energize Potion
//:: FileName  sp_energz_ptn.nss
//:://////////////////////////////////////////////
/**@file Energize Potion
Transmutation
Level: Cleric 3, druid 3, sorc/wizard 2, Wrath 2
Components: V,S,M
Casting Time: 1 standard action
Range: Close
Effect: 10ft radius
Duration: Instantaneous
Saving Throw: Reflex half
Spell Resistance: Yes

This spell transforms a magic potion into a volatile
substance that can be hurled out to the specified
range. The spell destroys the potion and releases
a 10-foot-radius burst of energy at the point of
impact. The caster must specify the energy type
(acid, cold, electricity, fire, or sonic) when the
spell is cast.

The potion deals 1d6 points of damage (of the
appropriate energy type) per spell level of the
potion (maximum 3d6). For example, a potion of
displacement transformed by this spell deals 3d6
points of damage. An energized potion set to deal
fire damage ignites combustibles within the burst
radius.

Author:    Tenjac
Created:   7/6/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);
        object oPC = OBJECT_SELF;
        object oPotion = PRCGetSpellTargetObject();
        int nSpell = PRCGetSpellId();
        int nCasterLvl = PRCGetCasterLevel(oPC);
        int nDC = GetSpellSaveDC();
        string sDamageType;

        if(GetBaseItemType(oPotion) != BASE_ITEM_POTIONS)
        {
                FloatingTextStringOnCreature("Invalid item type.", oPC, FALSE);
                return;
        }

        //Get spell level
        int nLevel = 0; //define it outside the loop
        itemproperty ipTest = GetFirstItemProperty(oPotion);

        while(GetIsItemPropertyValid(ipTest))
        {
                if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
                {
                        //Get row
                        int nRow = GetItemPropertySubType(ipTest);

                        //Get spell level
                        nLevel = StringToInt(Get2DACache("iprp_spells", "InnateLvl", nRow));
                        if(DEBUG) DoDebug("Spell level read as: " + IntToString(nLevel));

                        //no need to check rest of the ips
                        break;
                }
                ipTest = GetNextItemProperty(oPotion);
        }

        //Remove potion being converted
        int nStack = GetItemStackSize(oPotion);

        if(nStack > 1) SetItemStackSize(oPotion, (nStack - 1));

        else DestroyObject(oPotion);

        //Create the grenade
        object oGrenade = CreateItemOnObject("prc_it_enrgpot", oPC, 1);

        if(nSpell == SPELL_ENERGIZE_POTION_ACID)
        {
                SetLocalInt(oGrenade, "PRC_GrenadeDamageType", DAMAGE_TYPE_ACID);
                SetLocalInt(oGrenade, "PRC_EnergizedPotionSave", SAVING_THROW_TYPE_ACID);
                sDamageType = "Acid";
        }

        else if(nSpell == SPELL_ENERGIZE_POTION_COLD)
        {
                SetLocalInt(oGrenade, "PRC_GrenadeDamageType", DAMAGE_TYPE_COLD);
                SetLocalInt(oGrenade, "PRC_EnergizedPotionSave", SAVING_THROW_TYPE_COLD);
                sDamageType = "Cold";
        }

        else if(nSpell == SPELL_ENERGIZE_POTION_ELECTRICITY)
        {
                SetLocalInt(oGrenade, "PRC_GrenadeDamageType", DAMAGE_TYPE_ELECTRICAL);
                SetLocalInt(oGrenade, "PRC_EnergizedPotionSave", SAVING_THROW_TYPE_ELECTRICITY);
                sDamageType = "Electrical";
        }

        else if(nSpell == SPELL_ENERGIZE_POTION_FIRE)
        {
                SetLocalInt(oGrenade, "PRC_GrenadeDamageType", DAMAGE_TYPE_FIRE);
                SetLocalInt(oGrenade, "PRC_EnergizedPotionSave", SAVING_THROW_TYPE_FIRE);
                sDamageType = "Fire";
        }

        else if(nSpell == SPELL_ENERGIZE_POTION_SONIC)
        {
                SetLocalInt(oGrenade, "PRC_GrenadeDamageType", DAMAGE_TYPE_SONIC);
                SetLocalInt(oGrenade, "PRC_EnergizedPotionSave", SAVING_THROW_TYPE_SONIC);
                sDamageType = "Sonic";
        }
        nLevel = min(3, nLevel);
        SetLocalInt(oGrenade, "PRC_GrenadeLevel", nLevel);
        SetLocalInt(oGrenade, "PRC_EnPotSaveDC", nDC);

        string sStrength;

        //Get strength string
        switch(nLevel)
        {
                case 0: break;

                case 1: sStrength = "Weak";
                        break;
                case 2: sStrength = "Moderate";
                        break;
                case 3: sStrength = "Strong";
                        break;
        }

        SetName(oGrenade, sStrength + " " + "Energized" + " " + sDamageType + " " + "Potion");

        PRCSetSchool();
}