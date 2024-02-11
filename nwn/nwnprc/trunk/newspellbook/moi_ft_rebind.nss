#include "moi_inc_moifunc" 
#include "inc_dynconv"

int RebindFeatToChakra(int nSpellId)
{
	int nReturn = -1;
	if (nSpellId == 18977) nReturn = CHAKRA_CROWN;
	else if (nSpellId == 18978) nReturn = CHAKRA_FEET     ;
	else if (nSpellId == 18979) nReturn = CHAKRA_HANDS    ;
	else if (nSpellId == 18980) nReturn = CHAKRA_ARMS     ;
	else if (nSpellId == 18981) nReturn = CHAKRA_BROW     ;
	else if (nSpellId == 18982) nReturn = CHAKRA_SHOULDERS;
	else if (nSpellId == 18983) nReturn = CHAKRA_THROAT   ;
	else if (nSpellId == 18984) nReturn = CHAKRA_WAIST    ;
	else if (nSpellId == 18985) nReturn = CHAKRA_HEART    ;
	else if (nSpellId == 18986) nReturn = CHAKRA_SOUL     ;
	else if (nSpellId == 18987) nReturn = CHAKRA_TOTEM    ;
	
	return nReturn;
}

void main()
{
	object oMeldshaper = OBJECT_SELF;
	int nClass = GetPrimaryIncarnumClass(oMeldshaper);
	int nChakra = RebindFeatToChakra(GetSpellId());
	int nMeld =	GetIsChakraBound(oMeldshaper, nChakra);
	
	// The meld to swap to has to be bound to either the regular chakra or the double chakra
	int nTest = GetIsChakraUsed(oMeldshaper, nChakra, nClass);
	int nTest2 = GetIsChakraUsed(oMeldshaper, nChakra+11, nClass); // Double is the regular one plus 11
	
	// We switch to the other one here
	int nSwap = nTest2;
	if (nMeld == nTest2) nSwap = nTest;
	
	// Unbind the meld, then bind it
	DeleteLocalInt(oMeldshaper, "BoundMeld"+IntToString(nChakra));
	BindMeldToChakra(oMeldshaper, nSwap, nChakra, nClass);
	
	// Shape them both
	ShapeSoulmeld(oMeldshaper, nMeld);
	ShapeSoulmeld(oMeldshaper, nSwap);
	
/*	if (GetLocalInt(oMeldshaper, "PerfectMeldshaper")) return;
    AssignCommand(oMeldshaper, ClearAllActions(TRUE));
    SetLocalInt(oMeldshaper, "RebindSoulmeldCnv", GetSpellId());
    StartDynamicConversation("moi_rebindcnv", oMeldshaper, DYNCONV_EXIT_NOT_ALLOWED, FALSE, TRUE, oMeldshaper); */  
}
