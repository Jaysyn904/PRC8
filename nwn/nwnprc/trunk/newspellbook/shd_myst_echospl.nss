/*
16/02/19 by Stratovarius

Echo Spell 

Initiate, Black Magic 
Level/School: 5th/Universal 
Range: Close (25 ft. + 5 ft./2 levels) 
Effect: Repeat a previously cast spell or mystery 
Duration: See text 
Saving Throw: See text Spell 
Resistance: See text
Even as you recoil from your enemy’s spell, you reach into the Plane of Shadow and draw forth the spiritual reflection of that spell. 
With a grin, you manifest it in the physical world and hurl it back at him.

You can “echo” a mystery or spell cast by anyone other than yourself, causing it to remanifest under your control. Both the caster 
and the effect must have been within echo spell’s range, and the entire casting must have occurred in the previous round. You choose 
the mystery or spell’s target, and make any other choices involved in casting it. You cast the mystery or spell using your mystery 
user level (use your Cha modifier to determine the mystery or spell’s DC; its duration, saves, and the like are as normal for that 
spell). You cannot echo a mystery or spell of a higher level than the highest-level mystery you can cast, and you can never echo a 
mystery or a spell of higher than 4th level.
*/

#include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow = OBJECT_SELF;
    int nMyst = PRCGetSpellId();

    if(DEBUG) DoDebug("shd_myst_echospl: nMyst " + IntToString(nMyst));

    // Disallow if this spell is from an item
    if (PRCGetSpellCastItem(oShadow) != OBJECT_INVALID)
    {
        FloatingTextStringOnCreature("You cannot Echo spells cast from items.", oShadow);
		if(DEBUG) DoDebug("shd_myst_echospl: Disallowed - item cast");
        return;
    }
    // Disallow if this spell is cast by the shadowcaster itself
    if (GetLastSpellCaster() == oShadow)
    {
        FloatingTextStringOnCreature("You cannot Echo your own spells.", oShadow);
		if(DEBUG) DoDebug("shd_myst_echospl: Disallowed - item cast or cast by oShadow");
        return;
    }	

    if (GetLocalInt(oShadow, "EchoedSpell"))
    {
        int nSpellId = GetLocalInt(oShadow, "EchoedSpell");
        int nDC = 10 + StringToInt(Get2DACache("spells", "Innate", nSpellId)) + GetAbilityModifier(ABILITY_CHARISMA, oShadow);

        if(DEBUG) DoDebug("shd_myst_echospl: Echo SpellId " + IntToString(nSpellId) + " at DC " + IntToString(nDC));

        AssignCommand(oShadow, ActionCastSpell(nSpellId, GetShadowcasterLevel(oShadow), 0, nDC));
    }
    else
    {
        if(DEBUG) DoDebug("shd_myst_echospl: MYST_ECHO_SPELL");
        if (!ShadPreMystCastCode()) return;

        object oTarget = PRCGetSpellTargetObject();
        struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

        if (myst.bCanMyst)
        {
            if(DEBUG) DoDebug("shd_myst_echospl: MYST_ECHO_SPELL bCanMyst");
            SetLocalInt(oTarget, "EchoSpell", TRUE);
            SetLocalObject(oTarget, "EchoSpell", oShadow);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DIMENSIONANCHOR), oTarget);
        }
    }
}



/* #include "shd_inc_shdfunc"
#include "shd_mysthook"

void main()
{
    object oShadow = OBJECT_SELF;
    int nMyst = PRCGetSpellId();
    
    if(DEBUG) DoDebug("shd_myst_echospl: nMyst "+IntToString(nMyst));
    
    if (GetLocalInt(oShadow, "EchoedSpell"))    
    {
        int nSpellId = GetLocalInt(oShadow, "EchoedSpell");
        int nDC = 10 + StringToInt(Get2DACache("spells", "Innate", nSpellId)) + GetAbilityModifier(ABILITY_CHARISMA, oShadow);
        
        if(DEBUG) DoDebug("shd_myst_echospl: Echo SpellId "+IntToString(nSpellId)+" at DC "+IntToString(nDC));
        
        AssignCommand(oShadow, ActionCastSpell(nSpellId, GetShadowcasterLevel(oShadow), 0, nDC));
    }     
    else
    {
        if(DEBUG) DoDebug("shd_myst_echospl: MYST_ECHO_SPELL");
        if(!ShadPreMystCastCode()) return;

        object oTarget      = PRCGetSpellTargetObject();
        struct mystery myst = EvaluateMystery(oShadow, oTarget, METASHADOW_NONE);

        if(myst.bCanMyst)
        {
            if(DEBUG) DoDebug("shd_myst_echospl: MYST_ECHO_SPELL bCanMyst");
            SetLocalInt(oTarget, "EchoSpell", TRUE);
            SetLocalObject(oTarget, "EchoSpell", oShadow);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_IMP_DIMENSIONANCHOR), oTarget);
        }
    }
} */