/*
17/10/20 by Stratovarius

Necrocarnum Shroud

Descriptors: Evil, necrocarnum
Classes: Incarnate, soulborn
Chakra: Soul or waist
Saving Throw: See text

Chakra Bind (Soul)

While you have necrocarnum shroud bound to your soul chakra, you can take a standard action to strike a living foe with the raw evil of necrocarnum. When you use this ability, you must make a 
successful melee touch attack against the intended victim. If successful, your touch bestows 1d4 negative levels on the target (Fortitude half). For each negative level bestowed, you gain 1 temporary point of essentia
and 5 temporary hit points. The temporary essentia lasts until the end of your next turn. The temporary hit points fade after 1 hour.
*/

#include "moi_inc_moifunc"
#include "prc_inc_sp_tch"

void main()
{
	object oMeldshaper = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject(); 
    int nEssentia = GetEssentiaInvested(oMeldshaper, MELD_NECROCARNUM_SHROUD); 
    int nClass = GetMeldShapedClass(oMeldshaper, MELD_NECROCARNUM_SHROUD);
	int nDC = GetMeldshaperDC(oMeldshaper, nClass, MELD_NECROCARNUM_SHROUD);
	int nDamage = d4();
	int nMeldshaperLvl = GetMeldshaperLevel(oMeldshaper, nClass, MELD_NECROCARNUM_SHROUD);
    
    int nAttack = PRCDoMeleeTouchAttack(oTarget);
    if (nAttack > 0)
    {
        // Only creatures, and PvP check.
        if(!GetIsReactionTypeFriendly(oTarget) && PRCGetIsAliveCreature(oTarget))
        {
            // Check Spell Resistance
            if(!PRCDoResistSpell(oMeldshaper, oTarget, nMeldshaperLvl))
            {      
            	if(PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_NEGATIVE))
            		nDamage = nDamage/2;

               	ApplyEffectToObject(DURATION_TYPE_PERMANENT, SupernaturalEffect(EffectNegativeLevel(nDamage)), oTarget);
               	ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_REDUCE_ABILITY_SCORE), oTarget);
               	ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectTemporaryHitpoints(nDamage*5), oMeldshaper, HoursToSeconds(1));
           	    SetTemporaryEssentia(oMeldshaper, nDamage);
    			DelayCommand(6.0, SetTemporaryEssentia(oMeldshaper, nDamage * -1));
            }    
        }
    }    

}