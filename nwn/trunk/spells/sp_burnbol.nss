//::///////////////////////////////////////////////
//:: Burning Bolt
//:: sp_burnbol.nss
//:://////////////////////////////////////////////
/*
Caster Level(s):  Wizard / Sorcerer 1
Innate Level:     1
School:           Evocation
Descriptor(s):    Fire
Component(s):     Verbal, Somatic
Range:            Long
Target:           Single
Duration:         Instant
Save:             None
Spell Resistance: Yes

The caster creates a bolt of fire that is aimed
at the target with a ranged touch attack. After
level 1, the spell creates 1 additional missile
every two caster levels. Bolts do 1D4+1 points
of fire damage each.

*/
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////


#include "prc_inc_sp_tch"

void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_EVOCATION);

    object oCaster = OBJECT_SELF;
    object oTarget = PRCGetSpellTargetObject();

    if(spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))
    {
        // Declare major variables
        int nCasterLvl = PRCGetCasterLevel(oCaster);
        int nPenetr= nCasterLvl + SPGetPenetr();
        float fDist = GetDistanceBetween(oCaster, oTarget);
        float fDelay = fDist/(3.0 * log(fDist) + 2.0);
        effect eMissile = EffectVisualEffect(VFX_IMP_MIRV_FLAME);

        //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SPELL_BURNING_BOLT));

        //Make SR Check
        if (!PRCDoResistSpell(oCaster, oTarget, nPenetr, fDelay))
        {
            int nMetaMagic = PRCGetMetaMagicFeat();
            int nCnt;
            int nMissiles = (nCasterLvl + 1)/2;
            float fDelay2, fTime;
            effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);

            // Get the proper damage type adjusted for classes/feats.
            int nDamageType = ChangedElementalDamage(oCaster, DAMAGE_TYPE_FIRE);

            //Apply a single damage hit for each missile instead of as a single mass
            for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                fTime = fDelay;
                fDelay2 += 0.1;
                fTime += fDelay2;

                int nTouchAttack = PRCDoRangedTouchAttack(oTarget);
                if (nTouchAttack > 0)
                {
                    int nDamage = d4(1) + 1;
                    if(nMetaMagic & METAMAGIC_MAXIMIZE)
                        nDamage = 5;
                    if(nMetaMagic & METAMAGIC_EMPOWER)
                        nDamage += (nDamage/2);
					nDamage += SpellDamagePerDice(oCaster, 1);
                    // if this is the first target / first attack do sneak damage
                    if(nCnt == 1)
                    {
                        ApplyTouchAttackDamage(oCaster, oTarget, nTouchAttack, nDamage, nDamageType);
                    }
                    else
                        nDamage *= nTouchAttack;

                    // apply the damage and the damage visual effect.
                    effect eDamage = PRCEffectDamage(oTarget, nDamage, nDamageType);
                    DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget));
                    DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
                // Always apply the MIRV effect because we're trying to hit the target whether we
                // actually succeed or not.
                DelayCommand(fDelay2, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget));
            }
        }
        else
            // SR check failed, have to make animation for missiles but no damage.
            SPApplyEffectToObject(DURATION_TYPE_INSTANT, eMissile, oTarget);
    }
    PRCSetSchool();
}
