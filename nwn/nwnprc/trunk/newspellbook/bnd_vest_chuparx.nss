/*
13/03/21 by Stratovarius

Chupoclops, Harbinger of Forever
  
A great monster believed to be a harbinger of the apocalypse, Chupoclops became a vestige when slain by mortals. Chupoclops grants its summoner a bite attack and
unnatural senses, plus the ability to pounce on foes, to exist ethereally, and to make enemies despair.

Vestige Level: 6th
Binding DC: 25
Special Requirement: Chupoclops hates Amon for some unknown reason and will not answer your call if you are already bound to him.

Influence: While under the influence of Chupoclops, you can’t help but be pessimistic. At best, you are quietly resigned to your own failure, and at 
worst, you spread your doubts to others, trying to convince them of the hopelessness of their goals. In addition, Chupoclops requires that you voluntarily fail all saving throws against fear effects.

Granted Abilities: 
Chupoclops gives you the power to linger on the Ethereal Plane, sense the living and undead, demoralize foes, and bite enemies.

Aura of Despair: Every creature within 10 feet of you takes a –2 penalty on attack rolls, checks, saves, and weapon damage rolls. Aura of despair is a mind-affecting fear ability.

OnExit
*/

#include "bnd_inc_bndfunc"

void main()
{
    object oCreator = GetAreaOfEffectCreator();
    object oTarget  = GetExitingObject();

    // Loop over effects, removing the ones from this power
    effect eAOE;
    if(GetHasSpellEffect(VESTIGE_CHUPOCLOPS_AURA_DESPAIR, oTarget))
    {
        eAOE = GetFirstEffect(oTarget);
        while(GetIsEffectValid(eAOE))
        {
            if(GetEffectCreator(eAOE) == oCreator                            &&
               GetEffectSpellId(eAOE) == VESTIGE_CHUPOCLOPS_AURA_DESPAIR     &&
               oTarget != oCreator
               )
            {
                RemoveEffect(oTarget, eAOE);
            }
            // Get next effect on the target
            eAOE = GetNextEffect(oTarget);
        }// end while - Effect loop
    }// end if - Target has been affected at all
}
