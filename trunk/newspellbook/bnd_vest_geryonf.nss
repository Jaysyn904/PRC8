/*
12/03/21 by Stratovarius

Geryon, the Deposed Lord
  
Once a devil of great power, Geryon now exists only as a vestige. He gives binders powers associated with his eyes, as well as the ability to fly at a moment’s notice.

Vestige Level: 5th
Binding DC: 25
Special Requirement: Geryon answers the calls of only those summoners who show an understanding of the relationship between souls and the planes. Thus, you must have at least 5 ranks in Lore to summon him.

Influence: While influenced by Geryon, you become overly trusting of and loyal to those you see as allies, even in the face of outright treachery. Because he values trust, if you make a Sense Motive check or use any ability to read thoughts or detect lies, you rebel against Geryon’s influence.

Granted Abilities: 
Geryon gives you his eyes and his baleful gaze, as well as the ability to fly.

Swift Flight: You can fly for 1 round by using the Jump ability. Once you have used swift flight, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_GERYON)) return;
    SetLocalInt(oBinder, "GeryonFlight", TRUE);
    DelayCommand(6.0, DeleteLocalInt(oBinder, "GeryonFlight"));
}