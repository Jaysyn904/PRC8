/*
14/3/21

Haures, the Dreaming Duke
  
Haures grants his summoners the power to create illusions, protect their thoughts, and move through objects like a ghost.

Vestige Level: 6th
Binding DC: 25
Special Requirement: No

Influence: When influenced by Haures, you become an eccentric, often speaking to yourself and to imaginary friends. In addition, Haures requires that if you encounter and disbelieve an illusion not of your own making, you must not voluntarily enter its area.

Granted Abilities: 
Haures shields your mind with his madness, allows you to move like a ghost, gives you the power to fool the senses, and grants you the ability to kill others with their deepest fears.

Phantasmal Killer: This ability functions like the phantasmal killer spell. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_HAURES)) return;
    DoRacialSLA(SPELL_PHANTASMAL_KILLER, GetBinderLevel(oBinder, VESTIGE_HAURES), GetBinderDC(oBinder, VESTIGE_HAURES));    
}
        