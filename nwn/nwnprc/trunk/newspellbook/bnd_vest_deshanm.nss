/*
16/03/21 by Stratovarius

Desharis, the Sprawling Soul
  
The first of the "city-born fey," represented today by such creatures as the zeitgeist and the gray jester, Desharis is a boon to those who work to spread civilization, and anathema to most fey and worshipers of the wild. He grants binders shelter against the dangers of the wild, and he provides powers to carve out their own niche against nature.

Vestige Level: 6th
Binding DC: 27
Special Requirement: Desharis will not answer your call in a natural environment, only responding in the worked landscapes of urban areas. 

Influence: Under Desharis's influence, you cannot stand to be alone, and the more people you have around you, the better. You never voluntarily accept any task that requires you to be alone, and you argue vigorously against options that would split the party. If you have the opportunity to socialize with large groups of people (such as entering a boisterous tavern), you must take it unless doing so is overtly harmful, or you have reason to suspect the individuals are hostile to you.

Granted Abilities: 
Desharis grants abilities that reflect his desire to protect the civilized peoples of the world, plus provides a few that show his anger at the fey and other creatures of nature.

Spirits of the City: You can animate objects, as the spell, as a caster of your binder level. Once you have used this ability, you must wait 5 rounds after the effect has expired before you can do so again.
*/

#include "bnd_inc_bndfunc"

void WrapDesh(object oBinder, int nSpell)
{
	BindAbilCooldown(oBinder, nSpell, VESTIGE_DESHARIS);
}	

void main()
{
    object oBinder    = OBJECT_SELF;
    int nSpell = GetSpellId(); 
    if (GetLocalInt(oBinder, "Bind"+IntToString(nSpell))) return;
    int nBinderLevel  = GetBinderLevel(oBinder, VESTIGE_DESHARIS);
	SetLocalInt(oBinder, "Bind"+IntToString(nSpell), TRUE);
	
	DoRacialSLA(SPELL_ANIMATE_OBJECT, nBinderLevel, GetBinderDC(oBinder, VESTIGE_DESHARIS), FALSE);
	float fDur = RoundsToSeconds(nBinderLevel);
	DelayCommand(fDur, DeleteLocalInt(oBinder, "Bind"+IntToString(nSpell)));
	DelayCommand(fDur+0.25, WrapDesh(oBinder, nSpell));	
}