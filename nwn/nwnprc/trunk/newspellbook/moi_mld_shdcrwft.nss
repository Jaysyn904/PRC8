/*
11/1/20 by Stratovarius

Shedu Crown

Descriptors: Good, mind-affecting  
Classes: Totemist 
Chakra: Heart (totem) 
Saving Throw: See text

Glowing argent incarnum forms a shining crown that hovers slightly above your head. Its presence lends a regal air to your bearing, and you feel yourself become more calm, more dignified, and more stable—emotionally and even physically grounded.

You are immune to being pushed back as the result of a bull rush.

Essentia: You gain a competence bonus on saving throws against mind-affecting spells and effects equal to the number of points of essentia you invest in your shedu crown. 

Chakra Bind (Heart) 

The appearance of your shedu crown is unchanged, but when you use the power of this chakra bind, it briefly flares with brilliant silver light. 

You can shift from the Material Plane to the Ethereal Plane as a standard action. The effect lasts for a number of rounds equal to your meldshaper level. You can do this once per day.

Chakra Bind (Totem) 

Your hair grows into a bushy mane beneath your crown. If you are male, your beard likewise grows. Your body looks and feels more solid and strong.

You gain the ability to make a trample attack. As a full-round action, you can move up to twice your speed and literally run over any creature equal to your own size or smaller. Your trample attack deals 1d8 points of bludgeoning damage (or 1d6 points if you are Small) plus 1-1/2 times your Strength modifier. Opponents have a Reflex save for half damage.
*/
//::////////////////////////////////////////////////////////
//::
//:: Updated by: Jaysyn
//:: Updated on: 2026-02-20 10:25:22
//::
//:: Double Chakra Bind support added
//::
//::////////////////////////////////////////////////////////
#include "moi_inc_moifunc"

void main()  
{  
    object oMeldshaper = OBJECT_SELF;  
    int nMeldId = MELD_SHEDU_CROWN;  
  
    // Check if bound to Heart chakra (regular or double)  
    int nBoundToHeart = FALSE;  
    if (GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_HEART)) == nMeldId ||  
        GetLocalInt(oMeldshaper, "BoundMeld" + IntToString(CHAKRA_DOUBLE_HEART)) == nMeldId)  
        nBoundToHeart = TRUE;  
  
    if (nBoundToHeart)  
    {  
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectEthereal()), oMeldshaper, RoundsToSeconds(GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_SHEDU_CROWN)));  
    }  
}

/* void main()
{
	object oMeldshaper = OBJECT_SELF;
	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectEthereal()), oMeldshaper, RoundsToSeconds(GetMeldshaperLevel(oMeldshaper, CLASS_TYPE_TOTEMIST, MELD_SHEDU_CROWN)));
} */