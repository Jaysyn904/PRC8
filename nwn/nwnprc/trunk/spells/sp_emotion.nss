//::////////////////////////////////////////////////////////
//::
/*
	Emotion		(sp_emotion.nss)
	Enchantment (Compulsion) [Mind-Affecting]
	Level: 				Brd 3, Sor/Wiz 4
	Components: 		V, S
	Casting time: 		1 action
	Range: 				Medium (100 ft. + 10 ft./level)
	Targets: 			All living creatures within a 15-ft. 
						radius
	Duration: 			Concentration
	Saving Throw: 		Will negates
	Spell Resistance:	Yes
*/
//::
//::////////////////////////////////////////////////////////
//::
/*
	This spell arouses a single emotion of the character's 
	choice in the subjects. The character can choose any 
	one of the following versions:

	Despair: The enchanted creatures suffer a –2 morale 
	penalty to saving throws, attack rolls, ability checks, 
	skill checks, and weapon damage rolls. Emotion (despair) 
	dispels emotion (hope).

	Fear: The enchanted creatures flee from the character 
	whenever they are in sight of the character. Emotion 
	(fear) dispels emotion (rage).

	Friendship: The enchanted creatures react more 
	positively toward others. Their attitude shifts to the 
	next more favorable reaction (hostile to unfriendly, 
	unfriendly to indifferent, indifferent to friendly, or 
	friendly to helpful). Creatures involved in combat, 
	however, continue to fight back normally. Emotion 
	(friendship) dispels emotion (hate).

	Hate: The enchanted creatures react more negatively 
	toward others. Their attitude shifts to the next less 
	favorable reaction (helpful to friendly, friendly to 
	indifferent, indifferent to unfriendly, or unfriendly 
	to hostile). Emotion (hate) dispels emotion (friendship).

	Hope: The enchanted creatures gain a +2 morale bonus to 
	saving throws, attack rolls, ability checks, skill 
	checks, and weapon damage rolls. Emotion (hope) dispels 
	emotion (despair).

	Rage: The enchanted creatures gain a +2 morale bonus to 
	Strength and Constitution scores, a +1 morale bonus on 
	Will saves, and a –1 penalty to AC. They are compelled 
	to fight heedless of danger. Emotion (rage) does not 
	stack with barbarian rage or with itself. Emotion 
	rage) dispels emotion (fear). 
	
	Subradial spell:  
	- SPELL_EMOTION_DESPAIR - -2 morale penalty to attacks,  
	  saves, skills, damage  
	- SPELL_EMOTION_FEAR    - subjects flee from the caster  
	- SPELL_EMOTION_HOPE    - +2 morale bonus to attacks,  
	  saves, skills, damage  
	- SPELL_EMOTION_RAGE    - +2 Str/Con, +1 Will, -1 AC  

	- Friendship/Hate omitted: NWN has no NPC reaction/  
	  attitude system, and the emotion spell in PnP relies on  
	  reaction adjustment. 

*/
//::
//::////////////////////////////////////////////////////////
//::
//:: Created by: Jaysyn
//:: Date: 2026-10-09 23:38:15
//::
//:://////////////////////////////////////////////////////// 
#include "prc_inc_spells"  
#include "prc_add_spell_dc"  

const int SPELL_EMOTION_DESPAIR = 99999;
const int SPELL_EMOTION_FEAR	= 98888;
const int SPELL_EMOTION_HOPE	= 98777;
const int SPELL_EMOTION_RAGE	= 98766;

  
void main()  
{  
    object oPC = OBJECT_SELF;  
    int nSpellID = PRCGetSpellId();  
  
    //Spellhook  
    if(!X2PreSpellCastCode()) return;  
  
    PRCSetSchool(SPELL_SCHOOL_ENCHANTMENT);  
  
    location lLoc = PRCGetSpellTargetLocation();  
    int nCasterLvl = PRCGetCasterLevel(oPC);  
    int nDC;  
    int nMetaMagic = PRCGetMetaMagicFeat();  
    float fDur = RoundsToSeconds(nCasterLvl);  
  
    if(nMetaMagic & METAMAGIC_EXTEND)  
        fDur += fDur;  
  
    int nDuration = FloatToInt(fDur);  
  
    //Build the effect links once  
    effect eDespair = EffectLinkEffects(  
        EffectAttackDecrease(2, ATTACK_BONUS_MISC),  
        EffectSavingThrowDecrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));  
    eDespair = EffectLinkEffects(eDespair,  
        EffectSkillDecrease(SKILL_ALL_SKILLS, 2));  
    eDespair = EffectLinkEffects(eDespair,  
        EffectDamageDecrease(2, DAMAGE_TYPE_UNTYPED));  
    eDespair = EffectLinkEffects(eDespair,  
        EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE));  
  
    effect eFear = EffectLinkEffects(  
        EffectFrightened(),  
        EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));  
  
    effect eHope = EffectLinkEffects(  
        EffectAttackIncrease(2, ATTACK_BONUS_MISC),  
        EffectSavingThrowIncrease(SAVING_THROW_ALL, 2, SAVING_THROW_TYPE_ALL));  
    eHope = EffectLinkEffects(eHope,  
        EffectSkillIncrease(SKILL_ALL_SKILLS, 2));  
    eHope = EffectLinkEffects(eHope,  
        EffectDamageIncrease(2, DAMAGE_TYPE_UNTYPED));  
    eHope = EffectLinkEffects(eHope,  
        EffectVisualEffect(VFX_DUR_MIND_AFFECTING_POSITIVE));  
  
    effect eRage = EffectLinkEffects(  
        EffectAbilityIncrease(ABILITY_STRENGTH, 2),  
        EffectAbilityIncrease(ABILITY_CONSTITUTION, 2));  
    eRage = EffectLinkEffects(eRage,  
        EffectSavingThrowIncrease(SAVING_THROW_WILL, 1, SAVING_THROW_TYPE_ALL));  
    eRage = EffectLinkEffects(eRage,  
        EffectACDecrease(1, AC_DODGE_BONUS));  
    eRage = EffectLinkEffects(eRage,  
        EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE));  
  
    //Harmful subradials require SR/save; beneficial ones (Hope/Rage) don't  
    int bHarmful = (nSpellID == SPELL_EMOTION_DESPAIR ||  
                    nSpellID == SPELL_EMOTION_FEAR);  
  
    object oTarget = MyFirstObjectInShape(  
        SHAPE_SPHERE, FeetToMeters(15.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);  
  
    while(GetIsObjectValid(oTarget))  
    {  
        if(PRCGetIsAliveCreature(oTarget))  
        {  
            nDC = PRCGetSaveDC(oTarget, oPC);  
            PRCSignalSpellEvent(oTarget, TRUE, nSpellID, oPC);  
  
            int bResisted = bHarmful &&  
                PRCDoResistSpell(oPC, oTarget, nCasterLvl + SPGetPenetr());  
  
            if(!bResisted &&  
               (!bHarmful ||  
                !PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC,  
                    SAVING_THROW_TYPE_MIND_SPELLS)))  
            {  
                effect eApply;  
                if(nSpellID == SPELL_EMOTION_DESPAIR) eApply = eDespair;  
                else if(nSpellID == SPELL_EMOTION_FEAR) eApply = eFear;  
                else if(nSpellID == SPELL_EMOTION_HOPE) eApply = eHope;  
                else eApply = eRage;  
  
                SPApplyEffectToObject(DURATION_TYPE_TEMPORARY,  
                    eApply, oTarget, fDur, TRUE, -1, nCasterLvl);  
  
                //Standard PRC concentration monitor - strips the effect  
                //early if the caster's concentration breaks  
                DelayCommand(3.0, CheckConcentrationOnEffect(  
                    oPC, nSpellID, oTarget, nDuration));  
            }  
        }  
        oTarget = MyNextObjectInShape(  
            SHAPE_SPHERE, FeetToMeters(15.0), lLoc, TRUE, OBJECT_TYPE_CREATURE);  
    }  
  
    PRCSetSchool();  
}