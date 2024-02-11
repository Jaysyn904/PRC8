//Learn spell from scroll function for witch class.

#include "inc_newspellbook"

void main()
{
    if(GetPRCSwitch(PRC_WITCH_DISABLE_SPELL_LEARN))
    {
        SendMessageToPC(OBJECT_SELF, "Spell-learning for Witch class has been disabled in this module");
        return;
    }

    object oScroll = GetSpellTargetObject();
    if(GetItemPossessor(oScroll) != OBJECT_SELF)
        return;

    int nItemType = GetBaseItemType(oScroll);
    if(GetIdentified(oScroll) && nItemType != BASE_ITEM_SCROLL && nItemType != BASE_ITEM_SPELLSCROLL && nItemType != BASE_ITEM_ENCHANTED_SCROLL)
    {
        PlaySound("gui_failspell");
        SendMessageToPC(OBJECT_SELF, GetStringByStrRef(53309));//"You cannnot learn anything from that item."
        return;
    }

    int nSpellID = -1;
    itemproperty ipTest = GetFirstItemProperty(oScroll);
    while(GetIsItemPropertyValid(ipTest))
    {
        if(GetItemPropertyType(ipTest) == ITEM_PROPERTY_CAST_SPELL)
        {
            nSpellID = StringToInt(Get2DACache("iprp_spells", "SpellIndex", GetItemPropertySubType(ipTest)));
            break;
        }
        ipTest = GetNextItemProperty(oScroll);
    }

    if(nSpellID > -1)
    {
        //look for the spellID in spell book
        int nSpellbookID = RealSpellToSpellbookID(CLASS_TYPE_WITCH, nSpellID);

        //it's not in the spell book
        if(nSpellbookID == -1)
        {
            PlaySound("gui_failspell");
            SendMessageToPC(OBJECT_SELF, GetStringByStrRef(16789885));//"You can only learn Witch spells."
            return;
        }

        //check spell level
        string sFile = "cls_spell_witch";
        int nSpellLevel = StringToInt(Get2DACache(sFile, "Level", nSpellbookID));
        int nCasterLevel = GetCasterLevelByClass(CLASS_TYPE_WITCH, OBJECT_SELF);
        int nSpellLevelMax = GetMaxSpellLevelForCasterLevel(CLASS_TYPE_WITCH, nCasterLevel);

        if(nSpellLevel > nSpellLevelMax)
        {
            PlaySound("gui_failspell");
            SendMessageToPC(OBJECT_SELF, GetStringByStrRef(68612));//"You have not achieved the required level to learn that spell."
            return;
        }
        if(nSpellLevel > (GetAbilityScore(OBJECT_SELF, ABILITY_WISDOM) - 10))
        {
            PlaySound("gui_failspell");
            SendMessageToPC(OBJECT_SELF, GetStringByStrRef(68613));//"You do not have the minimum attribute required to learn this spell."
            return;
        }
        int nXPCost = 75*nSpellLevel;
        if(!nXPCost) nXPCost = 25;

        if(!GetHasXPToSpend(OBJECT_SELF, nXPCost))
        {
            PlaySound("gui_failspell");
            SendMessageToPC(OBJECT_SELF, "Not enough XP to learn this spell.");
            return;
        }

        //check if OBJECT_SELF doesn't have the spell and can learn it
        object oToken = GetHideToken(OBJECT_SELF);
        string sSpellBook = "Spellbook" + IntToString(CLASS_TYPE_WITCH);//GetSpellsKnown_Array(CLASS_TYPE_WITCH);

        // Create spells known persistant array  if it is missing
        int nSize = array_get_size(oToken, sSpellBook);
        if (nSize < 0)
        {
            array_create(oToken, sSpellBook);
            nSize = 0;
        }

        if(array_has_int(oToken, sSpellBook, nSpellbookID) != -1)
        {
            PlaySound("gui_failspell");
            SendMessageToPC(OBJECT_SELF, GetStringByStrRef(53308));//"You already have that spell in your spellbook."
            return;
        }

        //destroy the scroll
        int nStack = GetNumStackedItems(oScroll);
        if (nStack > 1)
            SetItemStackSize(oScroll, --nStack);
        else
            DestroyObject(oScroll);

        //make a spellcraft check
        if(!GetIsSkillSuccessful(OBJECT_SELF, SKILL_SPELLCRAFT, 10 + nSpellLevel))
        {
            PlaySound("gui_failspell");
            SendMessageToPC(OBJECT_SELF, "You failed to learn this spell.");
            return;
        }

        //add the spell
        PlaySound("gui_learnspell");
        int nIPFeatID = StringToInt(Get2DACache(sFile, "IPFeatID", nSpellbookID));
        int nFeatID   = StringToInt(Get2DACache(sFile, "FeatID", nSpellbookID));
        array_set_int(oToken, sSpellBook, nSize, nSpellbookID);
        AddSpellUse(OBJECT_SELF, nSpellbookID, CLASS_TYPE_WITCH, sFile, "NewSpellbookMem_" + IntToString(CLASS_TYPE_WITCH), SPELLBOOK_TYPE_SPONTANEOUS, GetPCSkin(OBJECT_SELF), nFeatID, nIPFeatID);
        SpendXP(OBJECT_SELF, nXPCost);

        string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
        SendMessageToPC(OBJECT_SELF, ReplaceChars(GetStringByStrRef(53307), "<CUSTOM0>", sName));//"<CUSTOM0> has been added to your spellbook."
    }
}
