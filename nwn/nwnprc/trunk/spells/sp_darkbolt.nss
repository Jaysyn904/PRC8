#include "prc_inc_spells"
#include "prc_add_spell_dc"
void main()
{
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()) return;

    PRCSetSchool(SPELL_SCHOOL_NECROMANCY);
    object oTarget = PRCGetSpellTargetObject();
    int nCasterLvl = PRCGetCasterLevel();
    int nMetaMagic = PRCGetMetaMagicFeat();
        int nPenetr = nCasterLvl + SPGetPenetr();

    int nMissiles = nCasterLvl/2;
    float fDist = GetDistanceBetween(OBJECT_SELF, oTarget);
    float fDelay = fDist/(3.0 * log(fDist) + 2.0);
    float fDelay2, fTime;
    int nCnt;

        effect eBolt = EffectBeam(VFX_BEAM_EVIL, OBJECT_SELF, BODY_NODE_HAND);
    effect eMissile = EffectVisualEffect(VFX_BEAM_EVIL);
    effect eVis = EffectVisualEffect(VFX_IMP_NEGATIVE_ENERGY);
    effect eDazed=EffectDazed();

    effect eVis2 = EffectVisualEffect(VFX_IMP_DAZED_S);


    //Fire cast spell at event for the specified target
        SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, SPELL_RAY_OF_ENFEEBLEMENT));
        //Limit missiles to 7
        if (nMissiles > 7) nMissiles = 7;

        //Make SR Check
        if (!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
        {
            //Apply a single damage hit for each missile instead of as a single mass
            for (nCnt = 1; nCnt <= nMissiles; nCnt++)
            {
                //Roll damage
                int nDam = d8(2);
                //Enter Metamagic conditions
                if ((nMetaMagic & METAMAGIC_MAXIMIZE))
                {
                      nDam = 16;//Damage is at max
                }
                if ((nMetaMagic & METAMAGIC_EMPOWER))
                {
                      nDam = nDam + nDam/2; //Damage/Healing is +50%
                }
				nDam += SpellDamagePerDice(OBJECT_SELF, 2);
               fTime = fDelay;
               fDelay2 += 0.1;
               fTime += fDelay2;

               //Set damage effect
                effect eDam = PRCEffectDamage(oTarget, nDam, DAMAGE_TYPE_MAGICAL);

              SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eBolt, oTarget, 1.0,FALSE);

                if(MyPRCGetRacialType(oTarget) != RACIAL_TYPE_UNDEAD)
                {
                   DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                   PRCBonusDamage(oTarget);
                   DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,0.0,FALSE));
                   //DelayCommand(fDelay2, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eBolt, oTarget,1.0));

                }


            }
             //Make reflex save
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, PRCGetSaveDC(oTarget,OBJECT_SELF)))
                {
                   DelayCommand(fTime, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eVis, oTarget,6.0));

                   if(!GetIsImmune(oTarget,IMMUNITY_TYPE_MIND_SPELLS))
                   {
                     DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDazed, oTarget,6.0));
                    // FloatingTextStringOnCreature("no immune " , OBJECT_SELF, FALSE);
                   }
                   else
                   {
                    // FloatingTextStringOnCreature("immune " , OBJECT_SELF, FALSE);

                     AssignCommand(oTarget,ClearAllActions(TRUE));
                     AssignCommand(oTarget,ActionPlayAnimation(ANIMATION_LOOPING_PAUSE,1.0,6.0));
                     DelayCommand(0.2,SetCommandable(FALSE,oTarget));
                     DelayCommand(6.2,SetCommandable(TRUE,oTarget));
                   }
                }
        }


        PRCSetSchool();

}