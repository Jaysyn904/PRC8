//Learn spell from scroll function for archivist class.

#include "inc_newspellbook"

void SortSpellbook()
{
    object oToken = GetHideToken(OBJECT_SELF);
    int i;
    for(i = 0; i < 10; i++)
    {
        float fDelay = i*0.1f;
        string sSpellBook = GetSpellsKnown_Array(CLASS_TYPE_ARCHIVIST, i);
        if(persistant_array_exists(oToken, sSpellBook))
        {
            DelayCommand(fDelay, CountingSortInt(oToken, sSpellBook));
        }
    }
}

void main()
{
    object oPC = OBJECT_SELF;
    object oScroll = GetSpellTargetObject();

    if(GetItemPossessor(oScroll) != oPC)
        return;

    int nItemType = GetBaseItemType(oScroll);
    if(GetIdentified(oScroll) && nItemType != BASE_ITEM_SCROLL && nItemType != BASE_ITEM_SPELLSCROLL && nItemType != BASE_ITEM_ENCHANTED_SCROLL)
    {
        PlaySound("gui_failspell");
        SendMessageToPC(oPC, GetStringByStrRef(53309));//"You cannnot learn anything from that item."
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
        int nSpellbookID = RealSpellToSpellbookID(CLASS_TYPE_ARCHIVIST, nSpellID);

        //it's not in the spell book
        if(nSpellbookID == -1)
        {
            PlaySound("gui_failspell");
            SendMessageToPC(oPC, GetStringByStrRef(16789885));//"You can only learn Divine spells."
            return;
        }

        //check spell level
        string sFile = "cls_spell_archv";
        int nSpellLevel = StringToInt(Get2DACache(sFile, "Level", nSpellbookID));
        int nCasterLevel = GetCasterLevelByClass(CLASS_TYPE_ARCHIVIST, oPC);
        int nSpellLevelMax = GetMaxSpellLevelForCasterLevel(CLASS_TYPE_ARCHIVIST, nCasterLevel);

        if(nSpellLevel > nSpellLevelMax)
        {
            PlaySound("gui_failspell");
            SendMessageToPC(oPC, GetStringByStrRef(68612));//"You have not achieved the required level to learn that spell."
            return;
        }
        if(nSpellLevel > (GetAbilityScore(oPC, ABILITY_INTELLIGENCE) - 10))
        {
            PlaySound("gui_failspell");
            SendMessageToPC(oPC, GetStringByStrRef(68613));//"You do not have the minimum attribute required to learn this spell."
            return;
        }

        //check if oPC doesn't have the spell and can learn it
        //object oToken = GetHideToken(oPC);
        string sSpellBook = GetSpellsKnown_Array(CLASS_TYPE_ARCHIVIST, nSpellLevel);

        // Create spells known persistant array  if it is missing
        int nSize = persistant_array_get_size(oPC, sSpellBook);
        if (nSize < 0)
        {
            persistant_array_create(oPC, sSpellBook);
            nSize = 0;
        }

        if(IsIntSet(oPC, sSpellBook, nSpellbookID) != -1)
        {
            PlaySound("gui_failspell");
            SendMessageToPC(oPC, GetStringByStrRef(53308));//"You already have that spell in your spellbook."
            return;
        }

        //destroy the scroll
        int nStack = GetNumStackedItems(oScroll);
        if (nStack > 1)
            SetItemStackSize(oScroll, --nStack);
        else
            DestroyObject(oScroll);

        //add the spell
        persistant_array_set_int(oPC, sSpellBook, nSize, nSpellbookID);
        PlaySound("gui_learnspell");

        string sName = GetStringByStrRef(StringToInt(Get2DACache("spells", "Name", nSpellID)));
        SendMessageToPC(oPC, ReplaceChars(GetStringByStrRef(53307), "<CUSTOM0>", sName));//"<CUSTOM0> has been added to your spellbook."
    }
    //SortSpellbook(); Causing TMIs - disabled at the moment
}
