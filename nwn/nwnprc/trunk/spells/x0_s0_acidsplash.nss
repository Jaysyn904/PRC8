 //::///////////////////////////////////////////////
//:: Acid Splash
//:: [X0_S0_AcidSplash.nss]
//:: Copyright (c) 2002 Bioware Corp.
//:://////////////////////////////////////////////
/*
Acid Splash
Conjuration (Creation) [Acid]
Level:            Sor/Wiz 0
Components:       V, S
Casting Time:     1 standard action
Range:            Close (25 ft. + 5 ft./2 levels)
Effect:           One missile of acid
Duration:         Instantaneous
Saving Throw:     None
Spell Resistance: No

You fire a small orb of acid at the target. You
must succeed on a ranged touch attack to hit your
target. The orb deals 1d3 points of acid damage.

*/
//:://////////////////////////////////////////////
//:: Created By: Brent
//:: Created On: July 17 2002
//:://////////////////////////////////////////////
//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

#include "prc_inc_sp_tch"

void main()
{
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_CONJURATION);

    //Declare major variables
    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();
    int nMetaMagic = PRCGetMetaMagicFeat();
    int EleDmg = ChangedElementalDamage(oCaster, DAMAGE_TYPE_ACID);
    effect eVis = EffectVisualEffect(VFX_IMP_ACID_S);

    if(!GetIsReactionTypeFriendly(oTarget))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_ACID_SPLASH));

        int iAttackRoll = PRCDoRangedTouchAttack(oTarget);
        if(iAttackRoll > 0)
        {
            int nDamage = PRCMaximizeOrEmpower(3, 1, nMetaMagic);
            // Acid Sheath adds +1 damage per die to acid descriptor spells
            if (GetHasDescriptor(SPELL_ACID_SPLASH, DESCRIPTOR_ACID) && GetHasSpellEffect(SPELL_MESTILS_ACID_SHEATH, oCaster))
            	nDamage += 1;  
			nDamage += SpellDamagePerDice(OBJECT_SELF, 1);
            //Apply the VFX impact and damage effect
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget);

            // perform attack roll for ray and deal proper damage
            ApplyTouchAttackDamage(oCaster, oTarget, iAttackRoll, nDamage, EleDmg);
            PRCBonusDamage(oTarget);
        }
    }
    PRCSetSchool();
}
