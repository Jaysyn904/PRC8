//////////////////////////////////////////////////////////////////////
/* Dark Speech [Vile]
You learn a smattering of the language of truly dark power.
Prerequisites: Will save bonus +5, Int 15, Cha 15.
Benefit: You can use the Dark Speech to bring loathing and fear to others, to help cast evil spells and create evil magic
items, and to weaken physical objects.

Dread: Whenever you use Dark Speech in this manner,
you take 1d4 points of Charisma damage, and every other
creature in a 30-foot radius must attempt a Will save (DC 10
+ 1/2 your character level + your Cha modifier). The result of
a failed save by a listener depends on the listener’s character
level and alignment, as detailed in the table below.
Level (Alignment) Result
1st-4th (non-evil) Listener is shaken for 10 rounds and must flee from you until you are out of sight.
1st-4th (evil) Listener cowers in fear for 10 rounds.
5th-10th (non-evil) Listener is shaken for 10 rounds.
5th-10th (evil) Listener is charmed by you (as charm monster) for 10 rounds.
11th+ (non-evil) Listener is filled with loathing for you but is not otherwise influenced.
11th+ (evil) Listener is impressed, and you gain a +2 competence bonus on attempts to change its attitude in the future.

Power: Whenever you use Dark Speech in this manner,
you take 1d4 points of Charisma damage. By incorporating
the Dark Speech into the verbal component of a spell, you
increase its effective caster level by 1. 

Special: You gain a +4 circumstance bonus on saving
throws made when someone uses the Dark Speech against
you.

Special: If you cannot take ability damage, you cannot
select this feat.
*/
//////////////////////////////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
	ApplyAbilityDamage(OBJECT_SELF, ABILITY_CHARISMA, d4(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
}