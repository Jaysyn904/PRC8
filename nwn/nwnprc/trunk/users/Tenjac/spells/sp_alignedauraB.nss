//:://////////////////////////////////////////////
//:: Name     Aligned Aura
//:: FileName   sp_alignedaura.nss
//:://////////////////////////////////////////////
/** @file

Abjuration
Level: Blackguard 4, Cleric 4, Paladin 4,
Components: V, S, DF,
Casting Time: 1 standard action
Range: 20 ft. or 60 ft.
Area: 20-ft.-radius emanation or 60-ft.-radius burst, centered on you
Duration: 1 round/level or until discharged
Saving Throw: Fortitude partial
Spell Resistance: Yes

A rush of divine energy flows through your holy symbol, infusing your body 
with the essence of the divine ethos. When you cast this spell, choose one 
non-neutral aspect of your own alignment—chaos, evil, good, or law. 
(If you are neutral, you can select whichever alignment you wish each time 
you cast this spell). You are immediately surrounded in a 20-foot aura of 
invisible energy associated with the chosen alignment component. Anyone in 
that area who shares that alignment component gains a bonus, and anyone with 
the opposed alignment component must make a Fortitude save or take a penalty. 
The values of these modifiers and the features to which they apply are given 
on the following table. These modifiers end when the affected creature leaves 
the spell's area.

Alignment	Bonus	Penalty
Chaos	+1 on attack rolls	-1 on saving throws
Evil	+1 on damage rolls	-1 to Armor Class
Good	+1 on saving throws	-1 on attack rolls
Law	+1 to Armor Class	-1 on damage rolls
At any point before the duration expires, you can choose to unleash the spell's 
remaining power in a 60-foot burst that deals 1d4 points of damage per round of 
duration remaining (maximum 15d4) to each creature of the opposed alignment in 
the area. Each affected creature can attempt a Fortitude save for half damage. 
The burst also heals 1 point of damage per round of duration remaining 
(maximum 15 points) for each creature of the same alignment in the area. Once 
this option is invoked, the spell ends immediately.
 
*/
//:://////////////////////////////////////////////
//:: Created By: Tenjac
//:: Created On: 1/24/21
//:://////////////////////////////////////////////

#include "prc_sp_func"
#include "prc_add_spell_dc"

void main()
{
        object oCaster = GetAreaOfEffectCreator();
        object oTarget = GetExitingObject();  
        int nSpellId
        effect eToDispel = GetFirstEffect(oTarget);
        
        while(GetIsEffectValid(eToDispel))
        {
        	nSpellId = GetEffectSpellId(eToDispel);
        	if(nSpellId == SPELL_ALIGNED_AURA_CHAOS || nSpellId == SPELL_ALIGNED_AURA_LAW || nSpellId == SPELL_ALIGNED_AURA_GOOD || nSpellId == SPELL_ALIGNED_AURA_EVIL)
                {
                	RemoveEffect(oTarget, eToDispel);
                }
                eToDispel = GetNextEffect(oTarget);
                }
        }
}