//::////////////////////////////////////////////////////////
//::
/*
	Cast in Stone (sp_caststone.nss)
	Transmutation
	Level: 				Druid 9,
	Components: 		V, S,
	Casting Time: 		1 standard action
	Range: 				Personal
	Target: 			You
	Duration: 			1 round/level (D)
	Saving Throw: 		None and Fortitude negates; see text
	Spell Resistance:	No
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	Your eyes become like gray stone orbs traced with golden
	veins. The change catches the foes fighting you by 
	surprise, and they turn to stone.

	Any creature within 30 feet that meets your gaze is 
	permanently turned into a mindless, inert statue (as 
	flesh to stone), unless it succeeds on a Fortitude 
	save. You can free the victim of your own cast in stone 
	at any time by speaking a command word you establish 
	during the casting.

	Each creature within range of the gaze must attempt a 
	saving throw against the gaze effect each round at the 
	beginning of its turn. A creature can avert its eyes, 
	which grants a 50% chance to avoid the gaze but in turn 
	grants you concealment relative to it. A creature can 
	close its eyes or turn away entirely; doing so prevents 
	the gaze from affecting it but grants you total 
	concealment from that creature.

	In addition, you can actively attempt to use the gaze 
	as a standard action each round. To do so, you choose 
	a target within range, and that target must attempt a 
	saving throw. A target that is averting or shutting its 
	eyes gains the above benefits.

	PnP notes:  
	- Gaze aura: each creature within 30 ft makes a Fort  
	  save each round or be petrified (as flesh to stone).  
	- Averting eyes: 50% avoid but caster gets concealment;  
	  closing eyes: immune but caster gets total conceal.  
	-> Modeled as a per-round 50% "exposed" roll, plus a  
	  modest EffectConcealment on the caster.  
	- Blind creatures are immune to gaze attacks.  
	- "Free victims with a command word" -> dismissed by  
	  casting Stone to Flesh / break enchantment / dispel  
	  on the victim (petrify is tagged with nSpellID).
*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-09 23:05:28
//::
//::////////////////////////////////////////////////////////  
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  
#include "prc_sp_func"  
  
void GazeCheck(object oCaster, object oTarget, int nSpellID)  
{  
    // invalid, dead, petrified, or blind targets skip  
    if (!GetIsObjectValid(oTarget)  
        || GetIsDead(oTarget)  
        || oTarget == oCaster  
        || PRCGetHasEffect(EFFECT_TYPE_BLINDNESS, oTarget)  
        || !PRCGetIsAliveCreature(oTarget))  
    {  
        return;  
    }  
  
    // friendly check — gaze affects enemies (PnP hits everyone  
    // meeting the gaze; allies assumed to look away)  
    if (GetIsReactionTypeFriendly(oTarget, oCaster)) return;  
  
    // Averting eyes: 50% chance the gaze misses this round  
    if (d100() <= 50) return;  
  
    // Fort save or petrify — PRCDoPetrification handles save,  
    // immunities, difficulty scaling, and the VFX link  
    int nSaveDC = PRCGetSaveDC(oTarget, oCaster, nSpellID);  
    PRCDoPetrification(PRCGetCasterLevel(oCaster), oCaster,  
                       oTarget, nSpellID, nSaveDC);  
}  
  
void GazeBeat(object oCaster, int nSpellID)  
{  
    // Spell expired or dispelled?  
    if (!GetIsObjectValid(oCaster)  
        || GetIsDead(oCaster)  
        || !GetHasSpellEffect(nSpellID, oCaster))  
    {  
        DeleteLocalInt(oCaster, "PRC_CASTSTONE");  
        return;  
    }  
  
    // Round tick: every creature in 30 ft sphere around caster  
    object oTarget =  
        GetFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0),  
                              GetLocation(oCaster), TRUE,  
                              OBJECT_TYPE_CREATURE);  
    while (GetIsObjectValid(oTarget))  
    {  
        if (spellsIsTarget(oTarget, SPELL_TARGET_STANDARDHOSTILE, oCaster))  
        {  
            GazeCheck(oCaster, oTarget, nSpellID);  
        }  
        oTarget =  
            GetNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0),  
                                 GetLocation(oCaster), TRUE,  
                                 OBJECT_TYPE_CREATURE);  
    }  
  
    DelayCommand(6.0f, GazeBeat(oCaster, nSpellID));  
}  
  
void main()  
{  
    if (!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_TRANSMUTATION);  
  
    object oCaster     = OBJECT_SELF;  
    int nSpellID       = PRCGetSpellId();  
    int nCasterLvl     = PRCGetCasterLevel(oCaster);  
    int nMetaMagic     = PRCGetMetaMagicFeat();  
    float fDur         = RoundsToSeconds(nCasterLvl);  
    if (CheckMetaMagic(nMetaMagic, METAMAGIC_EXTEND)) fDur += fDur;  
  
    // Remove any previous casting before reapplying  
    PRCRemoveEffectsFromSpell(oCaster, nSpellID);  
  
    // Stone-eyes VFX + concealment granted by averted/closed eyes.  
    // EffectConcealment is global rather than per-attacker —  
    // compromise approximation of the avert/close-eyes clause.  
    effect eLink = EffectVisualEffect(VFX_DUR_PROT_STONESKIN);  
    eLink = EffectLinkEffects(eLink, EffectConcealment(20));  
  
    SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oCaster,  
                          fDur, TRUE, nSpellID, nCasterLvl);  
    SPApplyEffectToObject(DURATION_TYPE_INSTANT,  
                          EffectVisualEffect(VFX_IMP_DUST_EXPLOSION),  
                          oCaster);  
  
    // First gaze pulse happens immediately on casting, then  
    // heartbeat each round for the duration  
    GazeBeat(oCaster, nSpellID);  
  
    PRCSetSchool();  
}