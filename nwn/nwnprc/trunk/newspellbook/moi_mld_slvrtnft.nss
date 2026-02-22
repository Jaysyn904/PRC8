/*
11/1/20 by Stratovarius

Silvertongue Mask

Descriptors: None  
Classes: Incarnate, Soulborn 
Chakra: Brow or throat 
Saving Throw: See text

A plain silver mask conceals your lower face while exposing your eyes. The mask is initially featureless, with a simple horizontal slot at your mouth, but subtle images shift across its surface as you interact with others.

You shape incarnum into a silver-blue mask that you wear over your face. Your silvertongue mask grants you a +2 insight bonus on Bluff and Diplomacy checks. 

Essentia: Every point of essentia you invest in your silvertongue mask increases the insight bonus by 2. 

Chakra Bind (Brow) 

Blue crystalline lenses grow out from the mask, covering your eyes. These lenses enhance your sensitivity to body language and mannerisms.

You gain an insight bonus on Sense Motive checks equal to the bonus granted on Bluff and Diplomacy checks by the mask. 

Chakra Bind (Throat) 

The silver mask melds into your face and neck, from your cheekbones down to your collar, as if your skin were turned to silver. When you attempt to compel a creature, that creature sees a face that is recognizable, but not quite familiar.

When bound to the throat chakra, the silvertongue mask allows you to cast charm person at will. A creature targeted by this ability, regardless of whether or not it succeeds on its save, can’t be targeted again by the same ability for 24 hours.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 12:23:13
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_SILVERTONGUE_MASK;  
  
    // Check if bound to Throat chakra (regular or double)  
    int nBoundToThroat = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_THROAT)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_THROAT)) == nMeldId)  
        nBoundToThroat = TRUE;  
  
    if (!nBoundToThroat) return; // Exit if not bound to Throat  
  
    object oTarget = PRCGetSpellTargetObject();  
      
    if (!GetLocalInt(oTarget, "SilvertongueLimit"))  
    {  
        // Which class created this  
        int nClass = GetMeldShapedClass(oMeldshaper, MELD_SILVERTONGUE_MASK);  
        int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, nClass, MELD_SILVERTONGUE_MASK);  
        int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_SILVERTONGUE_MASK);      
        ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));  
        ActionCastSpell(SPELL_CHARM_PERSON, nMeldshaperLvl, 0, nDC, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);  
        ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA"));   
        SetLocalInt(oTarget, "SilvertongueLimit", TRUE);  
    }  
}


/* void main()
{
    object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    
    if (!GetLocalInt(oTarget, "SilvertongueLimit"))
    {
    	// Which class created this
    	int nClass = GetMeldShapedClass(oMeldshaper, MELD_SILVERTONGUE_MASK);
		int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, nClass, MELD_SILVERTONGUE_MASK);
		int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_SILVERTONGUE_MASK);    
    	ActionDoCommand(SetLocalInt(oMeldshaper, "SpellIsSLA", TRUE));
    	ActionCastSpell(SPELL_CHARM_PERSON, nMeldshaperLvl, 0, nDC, METAMAGIC_NONE, CLASS_TYPE_INVALID, FALSE, FALSE, OBJECT_INVALID, FALSE);
    	ActionDoCommand(DeleteLocalInt(oMeldshaper, "SpellIsSLA")); 
    	SetLocalInt(oTarget, "SilvertongueLimit", TRUE);
    	
    }
} */