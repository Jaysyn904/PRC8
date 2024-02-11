//:://////////////////////////////////////////////
//:: FileName: "ss_ep_gem_cage"
/*   Purpose: Gem Cage - You attempt to trap the target into a gem. The spell
        first looks at the HD of the target creature, then looks for a gem
        valuable enough to entrap the target in. If successful, you will then be
        able to release that creature again at some other place and time.
*/
//:://////////////////////////////////////////////
//:: Created By: Boneshank
//:: Last Updated On: March 12, 2004
//:://////////////////////////////////////////////
#include "prc_alterations"
//#include "x2_inc_spellhook"
#include "inc_epicspells"

int GetNeededGemValue(int nHD);

void main()
{
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);

    if (!X2PreSpellCastCode())
    {
        DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
        return;
    }
    if (GetCanCastSpell(OBJECT_SELF, SPELL_EPIC_GEMCAGE))
    {
        object oTarget = PRCGetSpellTargetObject();
        if (!GetPlotFlag(oTarget) &&   // Plot creatures cannot be Caged, ever.
            !GetIsDM(oTarget) &&       // Neither can DM's.
            !GetIsPC(oTarget))         // And neither can other players.
        {
            int nHD = GetHitDice(oTarget);
            int nTestVal, nCurrentVal, nTargVal;
            // How valuable of a gem do we need to Gem Cage the target?
            nTargVal = GetNeededGemValue(nHD);
            string sTarget = GetResRef(oTarget);
            string sName = GetName(oTarget);
            if (sTarget == "") sTarget = "";

            itemproperty ipGemCage =
                ItemPropertyCastSpell(IP_CONST_CASTSPELL_UNIQUE_POWER,
                    IP_CONST_CASTSPELL_NUMUSES_SINGLE_USE);
            object oGem, oCopy;

            // Look for an appropriate gem in the caster's inventory.
            object oItem = GetFirstItemInInventory(OBJECT_SELF);
            while (oItem != OBJECT_INVALID)
            {   // Is the item a gem?
                if (GetBaseItemType(oItem) == BASE_ITEM_GEM)
                {
                    int nStack = GetNumStackedItems(oItem);
                    // What's the value of the gem?
                    int nTestVal = GetGoldPieceValue(oItem) /nStack;
                    // Is the gem's value greater than the target value?
                    if(nTestVal >= nTargVal)
                    {   // If this is the first viable gem, state it.
                        if (oGem == OBJECT_INVALID) oGem = oItem;
                        else // If not the first viable gem, compare them.
                        {   // What's the value of least valuable but still
                                                            // viable gem?
                            nCurrentVal = GetGoldPieceValue(oGem);
                            // Is the new gem less valuable? If so, use it.
                            if (nTestVal <= nCurrentVal)
                                oGem = oItem;
                        }
                    }
                }
                oItem = GetNextItemInInventory(OBJECT_SELF);
            }
            if (oGem != OBJECT_INVALID)
            {   // Onward! Cast the spell on the target.
                // Spell Resistance check:
                if (!PRCDoResistSpell(OBJECT_SELF, oTarget, GetTotalCastingLevel(OBJECT_SELF)+SPGetPenetr(OBJECT_SELF), 1.0))
                {   // Will Saving Throw.
                    if (!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, GetEpicSpellSaveDC(OBJECT_SELF, oTarget)))
                    {   // Choose the Gem Cage VFX based on gem value.
                        int nStack = GetNumStackedItems(oGem);
                        int nVis = 799;
                        if (GetGoldPieceValue(oGem) > 1600) nVis = 800;
                        if (GetGoldPieceValue(oGem) > 3500) nVis = 798;
                        effect eVis = EffectVisualEffect(nVis);
                        effect eImp = EffectVisualEffect(VFX_IMP_DESTRUCTION);
                        // Do fancy visual.
                        SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis,
                            oTarget);
                        DelayCommand(0.2,
                            SPApplyEffectToObject
                                (DURATION_TYPE_INSTANT, eImp, oTarget));
                        DelayCommand(1.2,
                            SPApplyEffectToObject
                                (DURATION_TYPE_INSTANT, eImp, oTarget));
                        DelayCommand(2.2,
                            SPApplyEffectToObject
                                (DURATION_TYPE_INSTANT, eImp, oTarget));
                        // Cage the target.
                        DelayCommand(2.8, DestroyObject(oTarget));
                        if (nStack > 1)
                        DelayCommand(2.6, SetItemStackSize (oGem, --nStack));
                        else
                        DelayCommand(2.6, DestroyObject(oGem));
                        // Create the new item, readying it for use later.
                        oCopy = CreateItemOnObject
                            ("it_gemcage_gem", OBJECT_SELF);
                        SetLocalString(oCopy, "sCagedCreature", sTarget);
                        SetLocalString(oCopy, "sNameOfCreature", sName);
                        // Debug message
                        SendMessageToPC(OBJECT_SELF,
                            GetLocalString(oCopy, "sCagedCreature"));
                    }
                }
            }
            else
                FloatingTextStringOnCreature("*Spell failed! No viable gems.*",
                    OBJECT_SELF, FALSE);
        }
        else
            FloatingTextStringOnCreature("*Spell failed! Invalid target.*",
                OBJECT_SELF, FALSE);
    }
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
}

int GetNeededGemValue(int nHD)
{
    int nValue;
    switch (nHD)
    {
        case 1: case 2:
            nValue = 250;
            break;
        case 3: case 4: case 5: case 6:
            nValue = 1000;
            break;
        case 7: case 8: case 9:
            nValue = 1500;
            break;
        case 10: case 11: case 12:
            nValue = 2000;
            break;
        case 13: case 14: case 15: case 16: case 17:
            nValue = 3000;
            break;
        case 18: case 19: case 20: case 21:
            nValue = 4000;
            break;
        case 22: case 23: case 24:
            nValue = 6000;
            break;
        default:
            nValue = 10000;
            break;
    }
    return nValue;
}
