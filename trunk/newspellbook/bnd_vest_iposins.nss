/*
14/03/21 by Stratovarius

Ipos, Prince of Fools
  
Binders call Ipos the Prince of Fools because of the crown he wears and the sad legend of his transformation into a vestige. He grants his summoners cold iron claws with which to rend foes, 
the power to see creatures and objects as they are, and a fraction of his charisma.

Vestige Level: 6th
Binding DC: 26
Special Requirement: Ipos refuses to answer the call of any summoner who, in his judgment, has not taken a serious enough interest in occult studies. Anyone wishing to bind Ipos must 
have at least 5 ranks in Lore and 5 ranks in Spellcraft.

Influence: You think highly of your intellect and show contempt toward those who question your assumptions or conclusions. If you encounter a creature that shows interest in a topic 
about which you have knowledge, Ipos requires that you truthfully edify that individual.

Granted Abilities: 
Ipos grants you his discerning sight and commanding presence, as well as claws of cold iron with which to rend the veil of ignorance.

Flash of Insight: As a swift action, you gain a true seeing effect (as the spell) for a duration of 1 round. Once you have used this ability, you cannot do so again for 5 rounds.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    if(!TakeSwiftAction(oBinder)) return;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_IPOS)) return;
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectTrueSeeing()), oBinder, 6.0);
}