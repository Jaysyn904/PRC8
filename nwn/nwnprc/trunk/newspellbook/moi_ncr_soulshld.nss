/*Necrocarnum Soulshield

You gain a bonus on all saving throws equal to the number of necrocarnum soulmelds that you currently have shaped. 
This ability is usable a number of times per day equal to one-half your necrocarnate level, and lasts for one round per class level.
*/

#include "prc_inc_spells"

void main()
{
    object oMeldshaper = OBJECT_SELF;
	int nBonus;
	if (GetHasSpellEffect(MELD_NECROCARNUM_CIRCLET  , oMeldshaper)) nBonus += 1;
	if (GetHasSpellEffect(MELD_NECROCARNUM_MANTLE   , oMeldshaper)) nBonus += 1;
	if (GetHasSpellEffect(MELD_NECROCARNUM_SHROUD   , oMeldshaper)) nBonus += 1;
	if (GetHasSpellEffect(MELD_NECROCARNUM_TOUCH    , oMeldshaper)) nBonus += 1;
	if (GetHasSpellEffect(MELD_NECROCARNUM_VESTMENTS, oMeldshaper)) nBonus += 1;
	if (GetHasSpellEffect(MELD_NECROCARNUM_WEAPON   , oMeldshaper)) nBonus += 1;

    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSavingThrowIncrease(SAVING_THROW_ALL, nBonus), oMeldshaper, RoundsToSeconds(GetLevelByClass(CLASS_TYPE_NECROCARNATE, oMeldshaper)));
}
