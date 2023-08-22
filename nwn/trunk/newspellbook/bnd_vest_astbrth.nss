/*
13/03/21 by Stratovarius

Astaroth, Unjustly Fallen
  
A fallen angel who would never accept responsibility for his own transgressions, Astaroth grants his summoners influence over the behavior of others, knowledge of hidden things, and the ability to sicken enemies.

Vestige Level: 4th
Binding DC: 22
Special Requirement: No

Influence: Astaroth's influence renders you incapable of taking responsibility for your own actions. You cannot admit any fault, acknowledge any mistake, or make reparations or 
apologies for any wrong, no matter the consequences or the evidence against you.

Granted Abilities: 
Astaroth guided mortals, and he still grants abilities based in knowledge and education. As a fallen angel, and then a vestige, his magics have grown ever grimmer and more distasteful;
he also grants powers based on directly controlling and offending others.

Angelic Lore: Astaroth constantly whispers the secrets of reality in the back of your mind, allowing you to draw on his own nigh-infinite knowledge. This grants a bonus to Lore equal to your effective binder level.

Astaroth's Breath: Once every 5 rounds, you can exhale a 60-foot cone of foul-smelling gas. Creatures within the cone must make a Fortitude save or be 
nauseated for 1 round and sickened for an additional 1d4 rounds. Those who make the save are merely sickened for 1 round. Creatures immune to poison or disease are immune to this effect.
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oBinder = OBJECT_SELF;
    location lTarget = PRCGetSpellTargetLocation();
    float fRange = FeetToMeters(60.0);    
    int nDC = GetBinderDC(oBinder, VESTIGE_ASTAROTH);
    
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ASTAROTH)) return;

    object oTarget = MyFirstObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    while(GetIsObjectValid(oTarget))
    {
        if(oTarget != oBinder && !GetIsImmune(oTarget, IMMUNITY_TYPE_POISON) && !GetIsImmune(oTarget, IMMUNITY_TYPE_DISEASE))
        {
        	if(!PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nDC, SAVING_THROW_TYPE_POISON))
        	{
        	    ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DISEASE_S), oTarget);
        	    DelayCommand(6.0, ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSickened(), oTarget, RoundsToSeconds(d4())));
        	    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectNausea(oTarget, 6.0), oTarget, RoundsToSeconds(1));
        	}    
        	else
        		ApplyEffectToObject(DURATION_TYPE_TEMPORARY, EffectSickened(), oTarget, RoundsToSeconds(1));
        }
        oTarget = MyNextObjectInShape(SHAPE_SPELLCONE, fRange, lTarget, FALSE, OBJECT_TYPE_CREATURE);
    }   
}

