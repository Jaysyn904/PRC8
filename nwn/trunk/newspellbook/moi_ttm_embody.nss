/*
Totem Embodiment (Su): For the duration of this ability, your normal essentia capacity of any soulmeld bound to your totem chakra is doubled. 
Every point of essentia invested in a soulmeld bound to your totem chakra counts as 2 points of essentia. Activating this ability is a free 
action that does not provoke attacks of opportunity. It can be used once per day and lasts for a number of minutes equal to your Constitution bonus (minimum 1). 
*/

#include "moi_inc_moifunc"

void main()
{
    object oMeldshaper  = OBJECT_SELF;
	int nTotem = GetIsChakraBound(oMeldshaper, CHAKRA_TOTEM);
	SetLocalInt(oMeldshaper, "TotemEmbodiment", nTotem);
	// Remove the meld then reapply it
	ShapeSoulmeld(oMeldshaper, nTotem);
	DelayCommand(60.0 * GetAbilityModifier(ABILITY_CONSTITUTION, oMeldshaper), DeleteLocalInt(oMeldshaper, "TotemEmbodiment"));
	
	if (GetHasFeat(FEAT_DOUBLE_CHAKRA_TOTEM, oMeldshaper))
	{
		int nTotem2 = GetIsChakraBound(oMeldshaper, CHAKRA_DOUBLE_TOTEM);	
		SetLocalInt(oMeldshaper, "TotemEmbodiment2", nTotem2);		
		ShapeSoulmeld(oMeldshaper, nTotem2);
		DelayCommand(60.0 * GetAbilityModifier(ABILITY_CONSTITUTION, oMeldshaper), DeleteLocalInt(oMeldshaper, "TotemEmbodiment2"));
	}
}