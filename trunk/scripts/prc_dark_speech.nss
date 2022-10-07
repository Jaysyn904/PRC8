//////////////////////////////////////////////////////////////////////
/* Dark Speech [Vile]
You learn a smattering of the language of truly dark power.
Prerequisites: Will save bonus +5, Int 15, Cha 15.
Benefit: You can use the Dark Speech to bring loathing and fear to others, to help cast evil spells and create evil magic
items, and to weaken physical objects.

Dread: Whenever you use Dark Speech in this manner,
you take 1d4 points of Charisma damage, and every other
creature in a 30-foot radius must attempt a Will save (DC 10
+ 1/2 your character level + your Cha modifier). The result of
a failed save by a listener depends on the listener’s character
level and alignment, as detailed in the table below.
Level (Alignment) Result
1st-4th (non-evil) Listener is shaken for 10 rounds and must flee from you until you are out of sight.
1st-4th (evil) Listener cowers in fear for 10 rounds.
5th-10th (non-evil) Listener is shaken for 10 rounds.
5th-10th (evil) Listener is charmed by you (as charm monster) for 10 rounds.
11th+ (non-evil) Listener is filled with loathing for you but is not otherwise influenced.
11th+ (evil) Listener is impressed, and you gain a +2 competence bonus on attempts to change its attitude in the future.

Power: Whenever you use Dark Speech in this manner,
you take 1d4 points of Charisma damage. By incorporating
the Dark Speech into the verbal component of a spell, you
increase its effective caster level by 1. 

Special: You gain a +4 circumstance bonus on saving
throws made when someone uses the Dark Speech against
you.

Special: If you cannot take ability damage, you cannot
select this feat.
*/
//////////////////////////////////////////////////////////////////////////////////////////////

#include "prc_inc_spells"

void main()
{
    object oPC = OBJECT_SELF;
    location lLoc = GetLocation(oPC);
    int nSpell = GetSpellId();
    object oTarget;
    int nDC = 10 + (GetHitDice(oPC) / 2) + GetAbilityModifier(ABILITY_CHARISMA, oPC);
    
    if(GetIsImmune(oPC, IMMUNITY_TYPE_ABILITY_DECREASE))
    {
        FloatingTextStringOnCreature("If you cannot take ability damage, you cannot use this feat", oPC, FALSE);
        return;
    }
    
    if(nSpell == SPELL_DARK_SPEECH_DREAD)
    {
        int nHD;
        oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);     
        
        ApplyAbilityDamage(oPC, ABILITY_CHARISMA, d4(1), DURATION_TYPE_TEMPORARY, TRUE, -1.0f);
        
        while(GetIsObjectValid(oTarget))
        {
            if(oTarget != oPC)
            {
                if(!PRCMySavingThrow(SAVING_THROW_WILL, oTarget, nDC, SAVING_THROW_TYPE_MIND_SPELLS))
                {
                    nHD = GetHitDice(oTarget);
                    
                    if(GetAlignmentGoodEvil(oTarget) == ALIGNMENT_EVIL)
                    {                           
                        if(nHD < 5) SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR))), oTarget, RoundsToSeconds(10));
                        else if (nHD > 4 && nHD < 11) SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectCharmed()), oTarget, RoundsToSeconds(10));
                        else FloatingTextStringOnCreature(GetName(oTarget) + " is impressed by your Dark Speech.", oPC, FALSE);                                        
                        
                        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_RED), oTarget);
                    }
                    else
                    {
                        if(nHD < 5)
                        {
                            effect eLink = EffectLinkEffects(EffectFrightened(), EffectVisualEffect(VFX_DUR_MIND_AFFECTING_FEAR));
                                   eLink = EffectLinkEffects(eLink, EffectShaken());
                            
                            SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(eLink), oTarget, RoundsToSeconds(10));
                            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_BLINDDEAD_DN_RED), oTarget);
                        }
                        else if (nHD > 4 && nHD < 11) SPApplyEffectToObject(DURATION_TYPE_TEMPORARY, SupernaturalEffect(EffectShaken()), oTarget, RoundsToSeconds(10));
                        else FloatingTextStringOnCreature(GetName(oTarget) + " is filled with loathing for you.", oPC, FALSE);
                    }
                }
            }
            oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(30.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
        }
    }
    else if(nSpell == SPELL_DARK_SPEECH_POWER)
    {
        if (GetHasSpellEffect(SPELL_DARK_SPEECH_POWER, oPC))
        {
            PRCRemoveSpellEffects(SPELL_DARK_SPEECH_POWER, oPC, oPC);
    		GZPRCRemoveSpellEffects(SPELL_DARK_SPEECH_POWER, oPC, FALSE);
		}
		else
			ApplyEffectToObject(DURATION_TYPE_PERMANENT, EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE), oPC);
    }
}