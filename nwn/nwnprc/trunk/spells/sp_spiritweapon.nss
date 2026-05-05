//::///////////////////////////////////////////////
//:: [Spiritual Weapon]
//:: [sp_spiritweapon.nss]
//:: [Jaysyn 2024-08-23 07:58:14]
//::
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
#include "x2_inc_spellhook"
#include "inc_spirit_weapn"

void main()
{
//:: Check the Spellhook
    if (!X2PreSpellCastCode()) return;

//:: Set the Spell School
    PRCSetSchool(GetSpellSchool(PRCGetSpellId()));
	
	int nRunEvent		= GetRunningEvent();

	if (nRunEvent == EVENT_NPC_ONSPELLCASTAT)
	{
		// Get the caster of the spell
		object oCaster = GetLastSpellCaster();
		int nCasterLevel = PRCGetCasterLevel(oCaster);

		if(DEBUG) DoDebug("sp_spiritweapon: EVENT_NPC_ONSPELLCASTAT triggered.");

		// Get the spell ID
		int nSpellId = GetLastSpell();
		if(DEBUG) DoDebug("sp_spiritweapon: Dispel spell ID: " + IntToString(nSpellId));

		// Check if the spell ID is a dispel spell
		if (nSpellId == SPELL_DISPEL_MAGIC || nSpellId == SPELL_LESSER_DISPEL || nSpellId == SPELL_GREATER_DISPELLING || nSpellId == SPELL_MORDENKAINENS_DISJUNCTION
			|| nSpellId == SPELL_SLASHING_DISPEL || nSpellId == SPELL_DISPELLING_TOUCH || nSpellId == SPELL_PIXIE_DISPEL || nSpellId == SPELL_GREAT_WALL_OF_DISPEL)
		{
			// Get the target of the spell
			object oTarget = OBJECT_SELF;
			if(DEBUG) DoDebug("sp_spiritweapon: Spell targeted at: " + GetName(oTarget));

			// Check if the target is OBJECT_SELF
			if (oTarget == OBJECT_SELF)
			{
				// Retrieve the original caster of the Spiritual Weapon spell from oSummon
				object oSummon = OBJECT_SELF;
				object oOriginalCaster = GetLocalObject(oSummon, "MY_CASTER");

				// Ensure oOriginalCaster is valid
				if (GetIsObjectValid(oOriginalCaster))
				{
					if(DEBUG) DoDebug("sp_spiritweapon: Original caster found. Caster level: " + IntToString(GetCasterLevel(oOriginalCaster)));

					// Determine the DC for the dispel check
					int nDispelDC = 11 + GetCasterLevel(oOriginalCaster);
					if(DEBUG) DoDebug("sp_spiritweapon: Dispel DC: " + IntToString(nDispelDC));

					// Determine the maximum cap for the dispel check
					int nDispelCap = 0;
					if (nSpellId == SPELL_LESSER_DISPEL)
						nDispelCap = 5;
					else if (nSpellId == SPELL_DISPEL_MAGIC || nSpellId == SPELL_SLASHING_DISPEL || nSpellId == SPELL_DISPELLING_TOUCH || nSpellId == SPELL_PIXIE_DISPEL || nSpellId == INVOKE_VORACIOUS_DISPELLING)
						nDispelCap = 10;
					else if (nSpellId == SPELL_GREATER_DISPELLING || nSpellId == SPELL_GREAT_WALL_OF_DISPEL)
						nDispelCap = 15;
					else if (nSpellId == SPELL_MORDENKAINENS_DISJUNCTION)
						nDispelCap = 0; // No cap for Disjunction

					// Roll for the dispel check
					int nDispelRoll = d20();
					int nCappedCasterLevel = nCasterLevel;

					if (nDispelCap > 0 && nCasterLevel > nDispelCap)
						nCappedCasterLevel = nDispelCap;

					nDispelRoll += nCappedCasterLevel;

					if(DEBUG) DoDebug("sp_spiritweapon: Dispel roll: " + IntToString(nDispelRoll) + " (Caster Level: " + IntToString(nCappedCasterLevel) + ", Cap: " + IntToString(nDispelCap) + ")");

					// Compare the dispel result to the DC
					if (nDispelRoll >= nDispelDC)
					{
						if(DEBUG) DoDebug("sp_spiritweapon: Dispel check succeeded.");

						// Dispel succeeded, destroy oSummon and the item in its right hand
						object oWeapon = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oSummon);

						if(DEBUG) DoDebug("sp_spiritweapon: Dispel Magic succeeded. Destroying Spiritual Weapon and its right hand item.");

						// Set flags and destroy objects with delays
						SetPlotFlag(oWeapon, FALSE);
						SetPlotFlag(oSummon, FALSE);
						SetImmortal(oSummon, FALSE);

						ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect(VFX_FNF_DISPEL), oSummon);

						// Destroy the weapon and summon with delays
						if (GetIsObjectValid(oWeapon))
						{
							DelayCommand(0.5f, DestroyObject(oWeapon));
							if(DEBUG) DoDebug("sp_spiritweapon: Spiritual Weapon destruction scheduled.");
						}
						else
						{
							if(DEBUG) DoDebug("sp_spiritweapon: No weapon found in right hand.");
						}

						DelayCommand(1.0f, DestroyObject(oSummon));
						if(DEBUG) DoDebug("sp_spiritweapon: Spiritual Weapon Summon destruction scheduled.");
					}
					else
					{
						RegisterSummonEvents(oSummon);
						if(DEBUG) DoDebug("sp_spiritweapon: Dispel check failed.");
					}
				}
				else
				{
					if(DEBUG) DoDebug("sp_spiritweapon: Original caster not found.");
				}
			}
		}
		return;
	}

//:: Declare major variables
    object oCaster 		= OBJECT_SELF;
    location lTarget 	= PRCGetSpellTargetLocation();
    int nClass 			= PRCGetLastSpellCastClass();
    int nDuration 		= PRCGetCasterLevel(oCaster);
    int nSwitch 		= GetPRCSwitch(PRC_SUMMON_ROUND_PER_LEVEL);
	int nMetaMagic 		= PRCGetMetaMagicFeat();	
	
	effect eSummon 		= EffectSummonCreature("prc_spirit_weapn");
    effect eVis 		= EffectVisualEffect(1200); //:: VFX_FNF_STRIKE_HOLY_SILENT

    if(nDuration < 1)
        nDuration = 1;
    
//:: Make metamagic check for extend
    if(nMetaMagic & METAMAGIC_EXTEND)
        nDuration *= 2;   //Duration is +100%
	
    float fDuration = nSwitch ? RoundsToSeconds(nDuration * nSwitch):
                                 TurnsToSeconds(nDuration);

//:: Apply the VFX impact and summon effect
    MultisummonPreSummon();
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eSummon, lTarget, fDuration);
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY, eVis, lTarget);

    DelayCommand(1.0, CreateSpiritualWeapon(oCaster, fDuration, nClass));

//:: Unset the Spell school
    PRCSetSchool();
}