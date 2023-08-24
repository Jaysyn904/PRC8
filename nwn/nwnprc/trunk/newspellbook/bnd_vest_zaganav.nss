/*
15/03/21 by Stratovarius

Zagan, Duke of Disappointment
  
On the cusp of deification, Zagan lost all he had worked for. As a vestige, he offers his summoners a snake’s sense of smell, the power to cause an enemy flee his presence, the ability to immobilize an opponent, and more effective combat abilities against snakes and their ilk.

Vestige Level: 6th
Binding DC: 25
Special Requirement: No

Influence: While influenced by Zagan, you become domineering and aggressive. Zagan requires that you slay any snake or snakelike being you meet, and deface any representations of snakes or snakelike beings other than Zagan that you find.

Granted Abilities: 
Zagan grants you a snake’s ability to detect creatures by scent, the ability to grapple and constrict as a snake, increased combat ability against snakes and their cousins, and the power to cause your foes to avoid your mere presence.

Aversion: As a standard action, you can create a compulsion effect targeting any creature within 30 feet. The target must succeed on a Will save or gain an aversion to you. An affected creature must stay at least 20 feet away from you; if already within 20 feet, the target moves away. Aversion is a mind-affecting compulsion ability. After using this ability, you must wait 5 rounds before using it again.

Improved Grapple: You gain the benefit of the Improved Grapple feat. In addition, you are considered to be of Large size for the purpose of making grapple checks.

Scent: You gain the scent special quality.

Constrict: You gain a giant constrictor’s ability to crush the life from its prey. You deal damage equal to 1d8 + 1-1/2 * your Str modifier with a successful grapple check, in addition to your normal unarmed damage.

Lizard Bane: Zagan’s grants you +2 melee attack and +2d6 damage on melee attacks against lizardfolk.
*/

#include "bnd_inc_bndfunc"
void main()
{
    object oBinder = OBJECT_SELF;
    if(!BindAbilCooldown(oBinder, GetSpellId(), VESTIGE_ZAGAN)) return;
    object oTarget = PRCGetSpellTargetObject();
    int nDC = GetBinderDC(oBinder, VESTIGE_ZAGAN);

	// Build effects
	effect eVis  = EffectVisualEffect(VFX_IMP_DAZED_S);
	effect eLink =                          EffectFrightened();
	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));
	       eLink = EffectLinkEffects(eLink, EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE));

    //Make a saving throw check
    if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
    {
        //Apply VFX Impact and fear effect
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, 30.0);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);
    }// end if - Save to negate
}
