/*
4/1/20 by Stratovarius

Gorgon Mask

Descriptors: None
Classes: Totemist
Chakra: Throat (totem)
Saving Throw: See text

Incarnum forms a mask resembling the head of a steel-plated bull, complete with long, arcing silver horns. The mask’s eyes are empty black pits.

While wearing a gorgon mask, you gain a +1 resistance bonus on Fortitude saves and a +2 resistance bonus on any check or saving throw to resist being bull rushed, tripped, overrun, or trampled. 

Essentia: Every point of essentia you invest in your gorgon mask increases your resistance bonuses by 1.

Chakra Bind (Throat)

The dusky, metallic scales of your gorgon mask extend down your neck, forming a sharp ridge along your upper spine. Wisps of green smoke escape from your mouth.

You gain the ability to breathe a cloud of petrifying gas on an adjacent foe. If the target fails a Fortitude save, it turns to stone, as the flesh to stone spell. You can use this ability once per day.

Chakra Bind (Totem) 

The metallic scales of your gorgon mask extend down over your shoulders, lending bulk and solidity to your frame. You feel strength coursing through your legs in particular, giving you the ability to run down your foes and crush them beneath your feet.

You gain the ability to make a trample attack. As a full-round action, you can move up to twice your speed and literally run over any creature equal to your own size or smaller. Your trample attack deals 1d8 points of bludgeoning damage (or 1d6 points if you are Small) plus 1-1/2 times your Strength modifier. Opponents have a Reflex save for half damage.
*/

#include "moi_inc_moifunc"
#include "prc_inc_combmove"

void main()
{
	// This is also used for the Shedu Crown, since it's identical
	DoTrample(OBJECT_SELF, PRCGetSpellTargetObject(), PRCGetSpellTargetLocation()); 
}