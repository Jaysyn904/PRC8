#include "prc_inc_unarmed"

void main()
{
  //Declare main variables.
    object oPC = OBJECT_SELF;
    object oSkin = GetPCSkin(oPC);

    PRCRemoveEffectsFromSpell(OBJECT_SELF, SPELL_SACREDSPEED);

    int nClass = GetLevelByClass(CLASS_TYPE_SACREDFIST);
    int bSFAC = nClass / 5 + 1;
    int bSFSpeed = nClass > 2;

    object oItemL = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oPC);

    int iCode =  GetHasFeat(FEAT_SF_CODE);

    int iShield = GetBaseItemType(oItemL) == BASE_ITEM_TOWERSHIELD ||
                  GetBaseItemType(oItemL) == BASE_ITEM_LARGESHIELD ||
                  GetBaseItemType(oItemL) == BASE_ITEM_SMALLSHIELD;

    if (!iCode)
    {
        if(GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oPC) == OBJECT_INVALID)
        {
            if (!(oItemL == OBJECT_INVALID || GetBaseItemType(oItemL)==BASE_ITEM_TORCH || iShield))
            {
                AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SF_CODE),oSkin);
                iCode = TRUE;
                FloatingTextStringOnCreature("You lost all your Sacred Fist powers.", OBJECT_SELF, FALSE);
            }
        }
        else
        {
            AddItemProperty(DURATION_TYPE_PERMANENT,ItemPropertyBonusFeat(IP_CONST_FEAT_SF_CODE),oSkin);
            iCode = TRUE;
            FloatingTextStringOnCreature("You lost all your Sacred Fist powers.", OBJECT_SELF, FALSE);
        }
    }

    if(iCode)
    {
        SetCompositeBonus(oSkin, "SacFisAC", 0, ITEM_PROPERTY_AC_BONUS);

        if (GetHasSpellEffect(SPELL_SACREDSPEED, oPC))
            PRCRemoveSpellEffects(SPELL_SACREDSPEED, oPC, oPC);
        if (GetHasSpellEffect(SPELL_SACREDFLAME, oPC))
            PRCRemoveSpellEffects(SPELL_SACREDFLAME, oPC, oPC);
        if (GetHasSpellEffect(SPELL_INNERARMOR, oPC))
            PRCRemoveSpellEffects(SPELL_INNERARMOR, oPC, oPC);

        DeleteLocalInt(oSkin, "SacFisMv");

        while(GetHasFeat(FEAT_SF_SACREDFLAME1))
            DecrementRemainingFeatUses(oPC, FEAT_SF_SACREDFLAME1);
        while(GetHasFeat(FEAT_SF_INNERARMOR))
            DecrementRemainingFeatUses(oPC, FEAT_SF_INNERARMOR);
    }
    else
    {
        if(!(GetBaseAC(GetItemInSlot(INVENTORY_SLOT_CHEST,oPC)) > 3 || iShield))
        {
            SetCompositeBonus(oSkin, "SacFisAC", bSFAC, ITEM_PROPERTY_AC_BONUS);
            if(bSFSpeed)
                ActionCastSpellOnSelf(SPELL_SACREDSPEED);
        }
        else
            SetCompositeBonus(oSkin, "SacFisAC", 0, ITEM_PROPERTY_AC_BONUS);
    }

    //Evaluate The Unarmed Strike Feats
    //UnarmedFeats(oPC);
    SetLocalInt(OBJECT_SELF, CALL_UNARMED_FEATS, TRUE);

    //Evaluate Fists
    //UnarmedFists(oPC);
    SetLocalInt(OBJECT_SELF, CALL_UNARMED_FISTS, TRUE);
}