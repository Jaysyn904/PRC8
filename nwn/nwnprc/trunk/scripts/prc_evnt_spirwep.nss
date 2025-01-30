//::///////////////////////////////////////////////
//:: [Spiritual Weapon]
//:: [prc_evnt_spirwep.nss]
//:: [Jaysyn 2024-08-23 07:58:14]
//::
//:: OnHit event script for the Spiritual 
//:: Weapon spell.
//::
//::///////////////////////////////////////////////
/**@  Spiritual Weapon
(Player's Handbook v.3.5, p. 283)

Evocation [Force]
Level: Cleric 2, Knight of the Chalice 2, War 2, Mysticism 2,
Components: V, S, DF,
Casting Time: 1 standard action
Range: Medium (100 ft. + 10 ft./level)
Effect: Magic weapon of force
Duration: 1 round/level (D)
Saving Throw: None
Spell Resistance: Yes

A weapon made of pure force springs into existence and attacks
opponents at a distance, as you direct it, dealing 1d8 force 
damage per hit, +1 point per three caster levels (maximum +5 
at 15th level). The weapon takes the shape of a weapon 
favored by your deity or a weapon with some spiritual 
significance or symbolism to you (see below) and has the 
same threat range and critical multipliers as a real weapon 
of its form. It strikes the opponent you designate, starting 
with one attack in the round the spell is cast and continuing 
each round thereafter on your turn. It uses your base attack 
bonus (possibly allowing it multiple attacks per round in 
subsequent rounds) plus your Wisdom modifier as its attack 
bonus. It strikes as a spell, not as a weapon, so, for 
example, it can damage creatures that have damage 
reduction. As a force effect, it can strike incorporeal 
creatures without the normal miss chance associated with 
incorporeality. The weapon always strikes from your 
direction. It does not get a flanking bonus or help a 
combatant get one. Your feats (such as Weapon Focus) 
or combat actions (such as charge) do not affect the 
weapon. If the weapon goes beyond the spell range, if 
it goes out of your sight, or if you are not directing 
it, the weapon returns to you and hovers.

Each round after the first, you can use a move action to
 redirect the weapon to a new target. If you do not, 
 the weapon continues to attack the previous round's 
 target. On any round that the weapon switches targets, 
 it gets one attack. Subsequent rounds of attacking that 
 target allow the weapon to make multiple attacks if your 
 base attack bonus would allow it to. Even if the spiritual 
 weapon is a ranged weapon, use the spell's range, not the 
 weapon's normal range increment, and switching targets 
 still is a move action.

A spiritual weapon cannot be attacked or harmed by 
physical attacks, but dispel magic, disintegrate, a 
sphere of annihilation, or a rod of cancellation affects it. 
A spiritual weapon's AC against touch attacks is 12 (10 + 
size bonus for Tiny object).

If an attacked creature has spell resistance, you make a 
caster level check (1d20 + caster level) against that 
spell resistance the first time the spiritual weapon 
strikes it. If the weapon is successfully resisted, the 
spell is dispelled. If not, the weapon has its normal 
full effect on that creature for the duration of the spell.
*///////////////////////////////////////////////////////////
#include "prc_inc_spells"
#include "inc_spirit_weapn"

void main()
{
    object oWeapon 	= PRCGetSpellCastItem();     				// The weapon itself
    object oSummon 	= GetItemPossessor(oWeapon); 				// The wielder of the weapon
    object oTarget 	= PRCGetSpellTargetObject(); 				// The creature being attacked
    object oCaster 	= GetLocalObject(oSummon, "MY_CASTER"); 	// Retrieve the stored caster
	
	int nRunEvent	= GetRunningEvent();
	
	if (nRunEvent == EVENT_ONUNAQUIREITEM || nRunEvent == EVENT_ITEM_ONPLAYERUNEQUIPITEM)
    {
		oSummon = GetPCItemLastUnequippedBy();
		oWeapon = GetPCItemLastUnequipped();
		
		if(GetIsPC(oSummon) == TRUE)
		{
			return;
		}
		
		if(DEBUG) DoDebug("prc_evnt_spirwep: Item OnUnEquip / OnUnAcquire Event running.");
		HandleSpiritualWeaponUnequipEvent();
		return;	  
    } 
	
	if(DEBUG) DoDebug("prc_evnt_spirwep: Script started. Weapon hit detected.");
	
	if(DEBUG) DoDebug("prc_evnt_spirwep: Caster found: " + GetName(oCaster));

    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();

    if(DEBUG) DoDebug("prc_evnt_spirwep: Caster Level: " + IntToString(nCasterLevel));
    if(DEBUG) DoDebug("prc_evnt_spirwep: Spell Penetration: " + IntToString(SPGetPenetr()));
    if(DEBUG) DoDebug("prc_evnt_spirwep: Total Penetration: " + IntToString(nPenetr));

    string sRunKey = ObjectToString(oWeapon)+"SR_CHECKED_" + ObjectToString(oTarget);
    if (!GetLocalInt(oWeapon, sRunKey))
    {
        if(DEBUG) DoDebug("prc_evnt_spirwep: SR check has not been performed yet. Proceeding with the check.");
        SetLocalInt(oWeapon, sRunKey, TRUE);

        if(PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
			if(DEBUG) DoDebug("prc_evnt_spirwep: Target's spell resistance check succeeded. Destroying Spiritual Weapon.");

            SetPlotFlag(oWeapon, FALSE);
            SetPlotFlag(oSummon, FALSE);
            SetImmortal(oSummon, FALSE);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), oSummon);
            if(DEBUG) DoDebug("prc_evnt_spirwep: VFX applied to wielder.");

            DelayCommand(0.5f, DestroyObject(oWeapon));
            if(DEBUG) DoDebug("prc_evnt_spirwep: Spiritual Weapon destruction scheduled.");

            DelayCommand(1.0f, DestroyObject(oSummon));
            if(DEBUG) DoDebug("prc_evnt_spirwep: Spiritual Weapon Summon destruction scheduled.");

            return;
        }
        else
        {
			if(DEBUG) DoDebug("prc_evnt_spirwep: Spell resistance check passed. Spiritual Weapon remains intact.");
        }
    }
    else
    {
        if(DEBUG) DoDebug("prc_evnt_spirwep: SR check already performed for this target. Skipping SR check.");
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////

	


/* void main()
{
    object oWeapon = PRCGetSpellCastItem();     // The weapon itself
    object oSummon = GetItemPossessor(oWeapon); // The wielder of the weapon
    object oTarget = PRCGetSpellTargetObject(); // The creature being attacked
    object oCaster = GetLocalObject(oSummon, "MY_CASTER"); // Retrieve the stored caster
    object oPC = GetFirstPC(); // First player character for debug messages
	
	if(DEBUG) DoDebug("prc_evnt_spirwep: Script started. Weapon hit detected.");
	
	if (GetUserDefinedItemEventNumber() == X2_ITEM_EVENT_UNEQUIP)
    {
		oSummon = GetPCItemLastUnequippedBy();
		oWeapon = GetPCItemLastUnequipped();
		SendMessageToPC(GetFirstPC(), "prc_evnt_spirwep: Item OnUnEquip Event running.");
		HandleSpiritualWeaponUnequipEvent();
		return;	  
    }    
	
	else if (GetUserDefinedItemEventNumber() != X2_ITEM_EVENT_ONHITCAST)
    {
        if(DEBUG) DoDebug("prc_evnt_spirwep: onHit Event not detected.");
		return;
    }	


    if (oCaster == OBJECT_INVALID)
    {
        if(DEBUG) DoDebug("prc_evnt_spirwep: Error: Caster not found on summon. Exiting script.");
        return;
    }

    if(DEBUG) DoDebug("prc_evnt_spirwep: Caster found: " + GetName(oCaster));

    int nCasterLevel = PRCGetCasterLevel(oCaster);
    int nPenetr = nCasterLevel + SPGetPenetr();

    if(DEBUG) DoDebug("prc_evnt_spirwep: Caster Level: " + IntToString(nCasterLevel));
    if(DEBUG) DoDebug("prc_evnt_spirwep: Spell Penetration: " + IntToString(SPGetPenetr()));
    if(DEBUG) DoDebug("prc_evnt_spirwep: Total Penetration: " + IntToString(nPenetr));

    string sRunKey = ObjectToString(oWeapon)+"SR_CHECKED_" + ObjectToString(oTarget);
    if (!GetLocalInt(oWeapon, sRunKey))
    {
        if(DEBUG) DoDebug("prc_evnt_spirwep: SR check has not been performed yet. Proceeding with the check.");
        SetLocalInt(oWeapon, sRunKey, TRUE);

        if(PRCDoResistSpell(oCaster, oTarget, nPenetr))
        {
			if(DEBUG) DoDebug("prc_evnt_spirwep: Target's spell resistance check succeeded. Destroying Spiritual Weapon.");

            SetPlotFlag(oWeapon, FALSE);
            SetPlotFlag(oSummon, FALSE);
            SetImmortal(oSummon, FALSE);

            ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), oSummon);
            if(DEBUG) DoDebug("prc_evnt_spirwep: VFX applied to wielder.");

            DelayCommand(0.5f, DestroyObject(oWeapon));
            if(DEBUG) DoDebug("prc_evnt_spirwep: Spiritual Weapon destruction scheduled.");

            DelayCommand(1.0f, DestroyObject(oSummon));
            if(DEBUG) DoDebug("prc_evnt_spirwep: Spiritual Weapon Summon destruction scheduled.");

            return;
        }
        else
        {
			if(DEBUG) DoDebug("prc_evnt_spirwep: Spell resistance check passed. Spiritual Weapon remains intact.");
        }
    }
    else
    {
        if(DEBUG) DoDebug("prc_evnt_spirwep: SR check already performed for this target. Skipping SR check.");
    }

    int nDamBonus	= PRCMin(5, nCasterLevel / 3);
    effect eDamage = EffectDamage(nDamBonus, DAMAGE_TYPE_DIVINE);
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eDamage, oTarget);
    if(DEBUG) DoDebug("prc_evnt_spirwep: "+IntToString(nDamBonus)+" magical damage applied to the target.");
} */