//::///////////////////////////////////////////////
//:: Name      Convert Wand
//:: FileName  sp_convert_wand.nss
//:://////////////////////////////////////////////
/**@file Convert Wand
Transmutation
Level: Clr 5
Components: V, S
Casting Time: 1 standard action
Range: Touch
Target: Wand touched
Duration: 1 minute/level
Saving Throw: None
Spell Resistance: No

This spell temporarily transforms a magic wand of
any type into a healing wand with the same number
of charges remaining. At the end of the spell's
duration, the wand's original effect is restored,
and any charges that were depleted remain so. The
spell level of the wand determines how powerful a
healing instrument the wand becomes:

Spell Level   New Wand Type


 1st          Wand of cure light wounds

 2nd          Wand of cure moderate wounds

 3rd          Wand of cure serious wounds

 4th          Wand of cure critical wounds

Author:    Tenjac
Created:   7/3/06
*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "prc_inc_spells"

void WandCounter(object oPC, object oSkin, object oNewWand, int nCounter);

void main()
{
        if(!X2PreSpellCastCode()) return;

        PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);

        object oPC = OBJECT_SELF;
        object oTargetWand = PRCGetSpellTargetObject();
        int nLevel;
        string sWand;

        //Check to be sure the target is a wand.  If a creature, get first wand.
        if(GetObjectType(oTargetWand) == OBJECT_TYPE_CREATURE)
        {
                object oTest = GetFirstItemInInventory(oTargetWand);

                while(GetIsObjectValid(oTest))
                {
                        int nTestType = GetBaseItemType(oTest);
                        if(nTestType == BASE_ITEM_MAGICWAND || nTestType == 106)
                        {
                                oTargetWand = oTest;
                                oPC = GetItemPossessor(oTargetWand);
                                break;
                        }
                        oTest = GetNextItemInInventory(oTargetWand);
                }
        }

        //Make sure it's a wand
        int nType = GetBaseItemType(oTargetWand);
        if(nType != BASE_ITEM_MAGICWAND && nType != 106)
        {
                FloatingTextStringOnCreature("The target item is not a wand", oPC, FALSE);
                if(DEBUG) DoDebug("GetBaseItemType returns invalid type: " + IntToString(nType));
                return;
        }

        int nCasterLvl = PRCGetCasterLevel(oPC);
        float fDur = (60.0f * nCasterLvl);

        //Get spell level
        itemproperty ipTest = GetFirstItemProperty(oTargetWand);

        while(GetIsItemPropertyValid(ipTest))
        {
                if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
                {
                        //Get row
                        int nRow = GetItemPropertySubType(ipTest);
                        if(DEBUG) DoDebug("nRow = " + IntToString(nRow));
                        //Get spell level
                        nLevel = StringToInt(Get2DACache("iprp_spells", "InnateLvl", nRow));
                        if(DEBUG) DoDebug("Spell level read as" + IntToString(nLevel));
                }
                ipTest = GetNextItemProperty(oTargetWand);
        }

        //GetCharges
        int nCharges = GetItemCharges(oTargetWand);

        //Determine wand
        if(nLevel > 4) nLevel = 4;

        switch(nLevel)
        {
                case 0: sWand = "prc_cwand_cmw";
                        break;

                case 1: sWand = "prc_cwand_clw";
                        break;

                case 2: sWand = "prc_cwand_cmdw";
                        break;

                case 3: sWand = "prc_cwand_csw";
                        break;

                case 4: sWand = "prc_cwand_ccw";
                        break;

                default:
                FloatingTextStringOnCreature("No spell level data.", oPC, FALSE);
                break;
        }

        if(DEBUG) DoDebug("Spell level read as: " + IntToString(nLevel));

        DestroyObject(oTargetWand);
        if(DEBUG) DoDebug("Creating new wand with resref " + sWand);
        object oNewWand = CreateItemOnObject(sWand, oPC, 1);
        SetItemCharges(oNewWand, nCharges);
}