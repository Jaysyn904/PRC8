/* 
Inferno
(Spell Compendium, p. 123)

Transmutation [Fire]
Level: Druid 5,
Components: V, S, M,
Casting Time: 1 standard action
Range: Close (25 ft. + 5 ft./2 levels)
Target: One creature
Duration: 6 rounds; see text
Saving Throw: Fortitude negates and Re?ex partial; see text
Spell Resistance: Yes

Singling out the target, you call upon elemental forces to surround it in fire.

The target of the inferno takes 6d6 points of fire damage unless it makes a Fortitude save. In each round thereafter, the fire deals 1d6 fewer points of damage (minimum 1d6) until the spell ends or the subject manages to extinguish the flames. Thus, the fire deals 5d6 points of damage in the second round, 4d6 points in the third round, and so forth. Flammable, nonmagical items carried by the target automatically fail their saves to resist this damage.
After the first round, the subject can attempt a DC 15 Reflex save as a full-round action to extinguish the flames before taking additional damage. Rolling on the ground (the subject becomes prone) allows the target a +2 bonus on this save. Leaping into a large body of water or magically extinguishing the flames automatically ends the effect.

Material Component: A gob of beeswax.
 */


//::///////////////////////////////////////////////
//:: Inferno
//:: x0_s0_inferno.nss
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Does 2d6 fire per round
    Duration: 1 round per level
*/
//:://////////////////////////////////////////////
//:: Created By: Aidan Scanlan
//:: Created On: 01/09/01
//:://////////////////////////////////////////////
//:: Rewritten: Georg Zoeller, 2003-Oct-19
//::            - VFX update
//::            - Spell no longer stacks with itself
//::            - Spell can now be dispelled
//::            - Spell is now much less cpu expensive

//:: altered by mr_bumpkin Dec 4, 2003 for prc stuff

//::////////////////////////////////////////////////////////  
//:: PnP notes:  
//:: - Round 1: 6d6 fire, Fort negates entirely (no damage at all  
//::   on a success, not half).  
//:: - Each round after: damage drops by 1d6 (min 1d6) until  
//::   6 rounds pass or subject extinguishes.  
//:: - Subject can attempt a DC 15 Reflex save as a full-round  
//::   action to put out the flames (ends spell).  
//:: - Prone/rolling on the ground grants no extra bonus in this  
//::   version (PnP lets a full-round action of rolling = free  
//::   extinguish attempt w/ circumstance bonus; approximated  
//::   as "doing nothing for 1 round" per your request below).  
//::////////////////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_alterations"  
#include "prc_add_spell_dc"  
  
void RunImpact(object oTarget, object oCaster, int nMetaMagic, int EleDmg, int nDieCount, int nSaveDC, int nRoundsLeft);  
  
int GetIsProne(object oCreature)  
{  
    effect eCheck = GetFirstEffect(oCreature);  
    while (GetIsEffectValid(eCheck))  
    {  
        if (GetEffectType(eCheck) == EFFECT_TYPE_KNOCKDOWN) return TRUE;  
        eCheck = GetNextEffect(oCreature);  
    }  
    return FALSE;  
}  
  
void main()  
{  
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");  
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);  
  
    object oTarget = PRCGetSpellTargetObject();  
  
    if (!X2PreSpellCastCode())  
    {  
        return;  
    }  
  
    // Doesn't stack with itself or Combust  
    if (GetHasSpellEffect(GetSpellId(), oTarget) || GetHasSpellEffect(SPELL_COMBUST, oTarget))  
    {  
        FloatingTextStrRefOnCreature(100775, OBJECT_SELF, FALSE);  
        return;  
    }  
  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    int nCasterLvl = PRCGetCasterLevel(OBJECT_SELF);  
    int EleDmg     = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE);  
    int nPenetr    = nCasterLvl + SPGetPenetr();  
    int nSaveDC    = PRCGetSaveDC(oTarget, OBJECT_SELF);  
  
    // Duration: 6 rounds baseline; Extend adds extra rounds at the 1d6 floor  
    int nRoundsLeft = 6;  
    if (nMetaMagic & METAMAGIC_EXTEND)  
    {  
        nRoundsLeft = nRoundsLeft * 2; // +100% duration, per PRCGetMetaMagicDuration convention  
    }  
  
    effect eRay = EffectBeam(444, OBJECT_SELF, BODY_NODE_CHEST);  
    effect eDur = EffectVisualEffect(498);  
  
    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));  
  
    float fDelay = GetDistanceBetween(oTarget, OBJECT_SELF) / 13;  
  
    if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nPenetr))  
    {  
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 3.0f, FALSE);  
        DelayCommand(fDelay, SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oTarget, RoundsToSeconds(nRoundsLeft), FALSE));  
  
        object oSelf = OBJECT_SELF;  
        // Round 1: full Fortitude negates (no damage at all, not half)  
        DelayCommand(fDelay + 0.1f, RunImpact(oTarget, oSelf, nMetaMagic, EleDmg, 6, nSaveDC, nRoundsLeft));  
    }  
    else  
    {  
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 2.0f, FALSE);  
        effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);  
        DelayCommand(fDelay + 0.3f, SPApplyEffectToObject(DURATION_TYPE_INSTANT, eSmoke, oTarget));  
    }  
  
    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");  
}  
  
void RunImpact(object oTarget, object oCaster, int nMetaMagic, int EleDmg, int nDieCount, int nSaveDC, int nRoundsLeft)  
{  
    // Spell expired / dispelled?  
    if (PRCGetDelayedSpellEffectsExpired(SPELL_INFERNO, oTarget, oCaster))  
    {  
        return;  
    }  
  
    if (GetIsDead(oTarget))  
    {  
        return;  
    }  
  
    if (nRoundsLeft <= 0)  
    {  
        PRCRemoveSpellEffects(SPELL_INFERNO, oCaster, oTarget);  
        return;  
    }  
  
    // "Putting out the fire" — only triggers if the subject stayed  
    // inactive (no action queued) this round. Prone + inactive grants  
    // a +2 bonus to the Reflex check.  
    int bInactive = (GetCurrentAction(oTarget) == ACTION_INVALID);  
  
    if (bInactive)  
    {  
        int nExtinguishDC = 15;  
        if (GetIsProne(oTarget)) nExtinguishDC -= 2; // +2 bonus to the save == -2 to the DC  
  
        if (PRCMySavingThrow(SAVING_THROW_REFLEX, oTarget, nExtinguishDC, SAVING_THROW_TYPE_FIRE))  
        {  
            PRCRemoveSpellEffects(SPELL_INFERNO, oCaster, oTarget);  
            FloatingTextStringOnCreature("*You have extinguished the flames*", oTarget, FALSE);  
            return;  
        }  
    }  
  
    // Round 1 only: Fortitude negates entirely  
    if (nDieCount == 6)  
    {  
        if (PRCMySavingThrow(SAVING_THROW_FORT, oTarget, nSaveDC, SAVING_THROW_TYPE_FIRE))  
        {  
            FloatingTextStringOnCreature("*Resisted the inferno*", oTarget, FALSE);  
            DelayCommand(6.0f, RunImpact(oTarget, oCaster, nMetaMagic, EleDmg, nDieCount - 1, nSaveDC, nRoundsLeft - 1));  
            return;  
        }  
    }  
  
    int nDamage = PRCMaximizeOrEmpower(6, nDieCount, nMetaMagic);  
    nDamage += SpellDamagePerDice(oCaster, nDieCount);  
    effect eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);  
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);  
    eDam = EffectLinkEffects(eVis, eDam);  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget);  
    PRCBonusDamage(oTarget);  
  
    int nNextDieCount = nDieCount - 1;  
    if (nNextDieCount < 1) nNextDieCount = 1;  
  
    DelayCommand(6.0f, RunImpact(oTarget, oCaster, nMetaMagic, EleDmg, nNextDieCount, nSaveDC, nRoundsLeft - 1));  
}



















/* #include "prc_inc_spells"
#include "prc_alterations"
#include "prc_add_spell_dc"

void RunImpact(object oTarget, object oCaster, int nMetamagic,int EleDmg);

void main()
{

    DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
    SetLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR", SPELL_SCHOOL_TRANSMUTATION);



    object oTarget = PRCGetSpellTargetObject();

    //--------------------------------------------------------------------------
    // Spellcast Hook Code
    // Added 2003-06-20 by Georg
    // If you want to make changes to all spells, check x2_inc_spellhook.nss to
    // find out more
    //--------------------------------------------------------------------------
    if (!X2PreSpellCastCode())
    {
        return;
    }
    // End of Spell Cast Hook

    //--------------------------------------------------------------------------
    // This spell no longer stacks. If there is one of that type, thats ok
    //--------------------------------------------------------------------------
    if (GetHasSpellEffect(GetSpellId(),oTarget) || GetHasSpellEffect(SPELL_COMBUST,oTarget))
    {
        FloatingTextStrRefOnCreature(100775,OBJECT_SELF,FALSE);
        return;
    }

    //--------------------------------------------------------------------------
    // Calculate the duration
    //--------------------------------------------------------------------------
    int nMetaMagic = PRCGetMetaMagicFeat();
    int CasterLvl = PRCGetCasterLevel(OBJECT_SELF);
    int EleDmg = ChangedElementalDamage(OBJECT_SELF, DAMAGE_TYPE_FIRE);

    int nDuration = CasterLvl ;
    int nPenetr =  CasterLvl + SPGetPenetr();

    if ((nMetaMagic & METAMAGIC_EXTEND))
    {
       nDuration = nDuration * 2;
    }

    if (nDuration < 1)
    {
        nDuration = 1;
    }

    //--------------------------------------------------------------------------
    // Flamethrower VFX, thanks to Alex
    //--------------------------------------------------------------------------
    effect eRay      = EffectBeam(444,OBJECT_SELF,BODY_NODE_CHEST);
    effect eDur      = EffectVisualEffect(498);


    SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, GetSpellId()));

    float fDelay = GetDistanceBetween(oTarget, OBJECT_SELF)/13;

    if(!PRCDoResistSpell(OBJECT_SELF, oTarget,nPenetr))
    {
        //----------------------------------------------------------------------
        // Engulf the target in flame
        //----------------------------------------------------------------------
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 3.0f,FALSE);


        //----------------------------------------------------------------------
        // Apply the VFX that is used to track the spells duration
        //----------------------------------------------------------------------
        DelayCommand(fDelay,SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,eDur,oTarget,RoundsToSeconds(nDuration),FALSE));
        object oSelf = OBJECT_SELF; // because OBJECT_SELF is a function
        DelayCommand(fDelay+0.1f,RunImpact(oTarget, oSelf,nMetaMagic,EleDmg));
    }
    else
    {
        //----------------------------------------------------------------------
        // Indicate Failure
        //----------------------------------------------------------------------
        SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eRay, oTarget, 2.0f,FALSE);
        effect eSmoke = EffectVisualEffect(VFX_IMP_REFLEX_SAVE_THROW_USE);
        DelayCommand(fDelay+0.3f,SPApplyEffectToObject(DURATION_TYPE_INSTANT,eSmoke,oTarget));
    }

}


void RunImpact(object oTarget, object oCaster, int nMetaMagic,int EleDmg)
{
    //--------------------------------------------------------------------------
    // Check if the spell has expired (check also removes effects)
    //--------------------------------------------------------------------------
    if (PRCGetDelayedSpellEffectsExpired(446,oTarget,oCaster))
    {
        return;
    }

    if (GetIsDead(oTarget) == FALSE)
    {
        //----------------------------------------------------------------------
        // Calculate Damage
        //----------------------------------------------------------------------
        int nDamage = PRCMaximizeOrEmpower(6,2,nMetaMagic);
        nDamage += SpellDamagePerDice(oCaster, 2);
        //nDamage += ApplySpellBetrayalStrikeDamage(oTarget, OBJECT_SELF, FALSE);
        effect eDam = PRCEffectDamage(oTarget, nDamage, EleDmg);
        effect eVis = EffectVisualEffect(VFX_IMP_FLAME_S);
        eDam = EffectLinkEffects(eVis,eDam); // flare up
        SPApplyEffectToObject (DURATION_TYPE_INSTANT,eDam,oTarget);
        DelayCommand(6.0f,RunImpact(oTarget,oCaster,nMetaMagic,EleDmg));
    }

DeleteLocalInt(OBJECT_SELF, "X2_L_LAST_SPELLSCHOOL_VAR");
// Erasing the variable used to store the spell's spell school
}

 */