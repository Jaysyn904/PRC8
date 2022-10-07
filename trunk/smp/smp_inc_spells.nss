/*:://////////////////////////////////////////////
//:: Spells Include
//:: SMP_INC_SPELLS
//:://////////////////////////////////////////////
    Reference numbers, may be useful:

    1 foot = 0.32 meter.
    10 feet = 3.33M.

    See SMP_INC_Constants.nss for the full list.

    This include file holds a lot of basic reusable functions, much like the
    NW_i0_spells did for the original Bioware spells. It also includes all
    relivant sub-include files.

    This is included in each spell file, and thusly only one include reference is
    needed.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//:: Created On: 2003
//::////////////////////////////////////////////*/

// All AOE functions
#include "SMP_INC_AOE"
// All Applying wrappers - EG for damage (for, say, Shield Other)
#include "SMP_INC_APPLY"
// All Array functions
#include "SMP_INC_ARRAY"
// All spell componant checks - gems, items ETC
#include "SMP_INC_COMPNENT"
// All new spell constants  (Includes polymorph and visuals includes)
// * Included at least in SMP_INC_EFFECTS
//#include "SMP_INC_CONSTANT"
// All difficulty functions (mainly not used)
#include "SMP_INC_DIFFICLT"
// All dispel magic things
#include "SMP_INC_DISPEL"
// All effect creating functions
#include "SMP_INC_EFFECTS"
// All Item Property checking, and adding
#include "SMP_INC_ITEMPROP"
// All removal things (RemoveEffect)
#include "SMP_INC_REMOVE"
// All resisting spell (ResistSpell) functions
#include "SMP_INC_RESIST"
// All spell save functions
#include "SMP_INC_SAVES"
// All touch and Range touch attack functions
#include "SMP_INC_TOUCHAKK"
// All turning functions (Which normally stops spells)
#include "SMP_INC_TURNING"
// Settings
#include "SMP_INC_SETTINGS"
// Summoning spells
#include "SMP_INC_SUMMON"

// Special: Debug include
#include "SMP_INC_DEBUG"

// Constants for SMP_GetDuration().
const int SMP_ROUNDS  = 1; // 6 Seconds
const int SMP_MINUTES = 2; // 60 Seconds
const int SMP_HOURS   = 3; // Default: 120 Seconds

// SMP_INC_SPELLS. This allows the application of a random delay to effects
// based on time parameters passed in.
// - Min default = 0.4, Max default = 1.1. Min = 0.1, Max = 10.0.
float SMP_GetRandomDelay(float fMinimumTime = 0.4, float MaximumTime = 1.1);

// SMP_INC_SPELLS. Returns true if oTarget is a humanoid
int SMP_GetIsHumanoid(object oTarget = OBJECT_SELF);

// SMP_INC_SPELLS. Totals the amount of items of sTag in oTargets inventory.
int SMP_TotalItemsOfBlueprint(object oTarget, string sBluePrint);
// SMP_INC_SPELLS. Destroys all items of sBluePrint on oTarget.
void SMP_DestroyItemsOfBluePrint(object oTarget, string sBluePrint);

// SMP_INC_SPELLS. This alerts all DM's of the spell being cast, and of name of
// the target, also reports Caster Level and DC for save.
void SMP_AlertDMsOfSpell(string sName, int nSpellSaveDC, int nCasterLevel);
// SMP_INC_SPELLS. This will check to see if there is a DM playing on the server
// at all. Some spells will force a DM to do the effects, else it'd be scripted
// and very limited (Wish, Miracle...etc).
// * TRUE if a DM is playing in the player (frist/next) list, else FALSE.
int SMP_GetIsDMPlaying();

// SMP_INC_SPELLS. Wrapper for the signal event. Smaller :-P
// * Default to a HOSTILE spell. :-)
// * It uses OBJECT_SELF as the default caster
// It uses SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell, bHarmful));
// It won't fire it at a PC, to reduce lag.
void SMP_SignalSpellCastAt(object oTarget, int nSpell, int bHarmful = TRUE, object oCaster = OBJECT_SELF);

// SMP_INC_SPELLS.
// * Returns true if oCreature does not have a mind
int SMP_SpellsIsMindless(object oCreature);
// SMP_INC_SPELLS.
// * Returns true or false depending on whether the creature is flying or not
int SMP_SpellsIsFlying(object oCreature);
// SMP_INC_SPELLS.
// * Returns true if the creature has flesh
int SMP_SpellsIsImmuneToPetrification(object oCreature);

// SMP_INC_SPELLS. Bullrush attack
// - Uses oTarget's strength, add modifiers, against nCasterModifier.
// - Reports results to caster and target
int SMP_Bullrush(object oTarget, int nCasterModifier, object oCaster = OBJECT_SELF);
// SMP_INC_SPELLS. Bullrush
// - Returns TRUE if oCreature is immune to bullrush
// - Oozes, for instance.
int SMP_ImmuneToBullrush(object oCreature);
// SMP_INC_SPELLS. Bullrush.
// * Returns the size modifier for bullrush in spells (XP1)
// +4 for every size over medium
// -4 for every size under medium. Medium = 0.
int SMP_GetSizeModifier(object oCreature);
// SMP_INC_SPELLS. Bullrush.
// * Returns TRUE if oCreature is steady.
//      - Has more then 2 legs
//      - Is steadying themselves by use of Defensive Casting or Expertise.
//      - Is steady by moving slowly around!
int SMP_GetIsSteady(object oCreature);
// SMP_INC_SPELLS. Moves the target back from their current position,
// away from oTarget, fDistance.
// NEED TO REPLACE WITH REPULSION THING
void SMP_DoMoveBackwards(object oSource, object oTarget, float fDistance);

// SMP_INC_SPELLS. Can the creature be destroyed without breaking a plot?
// - Immortal, Plot or DM returns FALSE.
int SMP_CanCreatureBeDestroyed(object oTarget);
// SMP_INC_SPELLS. Returns TRUE if oTarget is an Minotaur. Maze spell uses this.
int SMP_GetIsMinotaur(object oTarget);

// SMP_INC_SPELLS. Is oTarget in a maze area? (enables some spells really)
int SMP_IsInMazeArea(object oTarget = OBJECT_SELF);
// SMP_INC_SPELLS. Is oTarget in a Imprisonment area? (only used to check to jump back really)
int SMP_IsInPrisonArea(object oTarget = OBJECT_SELF);

// SMP_INC_SPELLS. Returns TRUE if oTarget is an Ethereal, or an Ethereal creature
int SMP_GetIsEthereal(object oTarget);
// SMP_INC_SPELLS. Returns TRUE if oTarget is an Astral creature
int SMP_GetIsAstral(object oTarget);
// SMP_INC_SPELLS. Returns TRUE if oTarget is Crystalline - earthy
int SMP_GetIsCrystalline(object oTarget);
// SMP_INC_SPELLS. This returns TRUE if they are Incorporeal, via. local variable,
// spell or effect
int SMP_GetIsIncorporeal(object oTarget);

// SMP_INC_SPELLS. Immune to polymorph - also plays approprate effect.
// * Returns TRUE if oTarget cannot be polymorphed.
int SMP_ImmuneToPolymorph(object oTarget);

// SMP_INC_SPELLS. This returns a positive, negative or zero number
// Add this to any DC's for sleep.
// * Adds 2 for lullaby.
int SMP_GetSleepSaveModifier(object oTarget);

// SMP_INC_SPELLS.
// * FALSE if they are a Non-living creature. Dead objects have no effect on result.
// * sDebug - If this is filled, it is sent to the caster, if it returns FALSE.
int SMP_GetIsAliveCreature(object oTarget, string sDebug = "");

// SMP_INC_SPELLS. Sorts out metamagic checks, using Random()
// * nDiceSides (EG: 6 for D6 dice) * nNumberOfDice (EG: 2, for 2d6)
// * nBonus - Bonus to at the end.
// * Does include Maximise and Empower checks.
// * nTouch - If 2, it is a critcal, and does double what it would normally return.
int SMP_MaximizeOrEmpower(int nDiceSides, int nNumberOfDice, int nMeta, int nBonus = 0, int nTouch = 0);

// SMP_INC_SPELLS. Works out a dice-rolled time.
// * nType - use SMP_ROUNDS (6 sec), SMP_MINUTES (60 sec), SMP_HOURS (mod dependant)
// * nDiceSides, nNumberOfDice - The dice (EG 5, 6sided dice = 6, 5)
// * nMeta - Metamagic feat EXTEND is used here
// * nBonus - Added before metamagic, such as 4d(caster level) + Bonus.
float SMP_GetRandomDuration(int nType, int nDiceSides, int nNumberOfDice, int nMeta, int nBonusTime = 0);
// SMP_INC_SPELLS. Works out a normal time. Useful wrapper.
// * nType - use SMP_ROUNDS (6 sec), SMP_MINUTES (60 sec), SMP_HOURS (mod dependant)
// * nTime - the time in hours, rounds or turns
// * nMeta - The metamagic feat EXTEND is also taken into account.
float SMP_GetDuration(int nType, int nTime, int nMeta);

// SMP_INC_SPELLS. Does a fortitude check and applys EffectPetrify :-)
// - Taken from Bioware's petrify. More generic however.
// - No ReactionType checks.
// - Will not petrify immune creatures
// * oTarget - Target
// * nCasterLevel - Either the hit dice of the creature or the caster level
// * nFortSaveDC: pass in this number from the spell script
// - It will also apply bonuses of a construct.
void SMP_SpellFortitudePetrify(object oTarget, int nCasterLevel, int nFortSaveDC);

// SMP_INC_SPELLS. Creates a new location from lLocation on a varying X and Y
// value, in increments of 1 meter.
// * nRandom - this is the number you want to randomise. It will be up to HALF
//             this in meters from lLocation, north south east or west.
location SMP_GetRandomLocation(location lLocation, int nRandom);

// SMP_INC_SPELLS. Returns bolts, arrows, bullets or -1 for the ammo item type used by oWeapon.
int SMP_GetWeaponsAmmoType(object oWeapon);
// SMP_INC_SPELLS. Gets the right slot for nBaseAmmoType or -1.
int SMP_GetAmmoSlot(int nBaseAmmoType);

// SMP_INC_SPELLS. Is the creature dazzeled?
// Spells include:
// - Flare
int SMP_GetIsDazzled(object oTarget);

// SMP_INC_SPELLS. Can the caster, oCaster, teleport to lTarget without disrupting a module?
// - Trigger, if at the location or the caster, stops it
// - The area can be made "No teleport"
// - Includes a check for SMP_GetDimensionalAnchor(oCaster);.
// TRUE if they can NOT teleport to lTarget.
int SMP_CannotTeleport(object oCaster, location lTarget);
// SMP_INC_SPELLS. Returns TRUE if oCreature is locked in this dimension by:
// - Dimensional Anchor
// - Dimensional Lock
// - Forbiddance
int SMP_GetDimensionalAnchor(object oCreature);

// SMP_INC_SPELLS.
// This is used for some spells to limit creatures by size. EG: Dimension door.
// Returns: 1 for Medium, small and tiny creatures.
//          2 for Large (Equivilant of 2 medium creatures)
//          4 for Huge creature sizes (Equivilant of 2 Large creatures)
int SMP_SizeEquvilant(object oCreature);

// SMP_INC_SPELLS. Removes all Fatigue/Exhaustion from oTarget.
void SMP_RemoveFatigue(object oTarget);
// SMP_INC_SPELLS. Applys a new Fatigue effect to oTarget, if not already got it...
// * If bExhaustion is TRUE, it applies Exhaustion instead.
//   * Exhaustion "overrides" any fatigue, and using the Bioware problem of
//     ability penalties not stacking, will mearly apply exhasution over fatigue.
// (Noting, of course, speed decreases stack. Anyone exhausted also becomes fatiged,
//  but not vice versa).
// * Stats: Fatigue: 20% move penalty. -2 Dex and STR.
//          Exhaustion: An additional -4 to Dex and STR, -20% speed. (so -6, 40%)
void SMP_ApplyFatigue(object oTarget, int bExhaustion = FALSE, int nDurationType = DURATION_TYPE_PERMANENT, float fDuration = 0.0);

// SMP_INC_SPELLS.
// Returns iHighest if it is over nHighest, or nLowest if under nLowest, or
// the integer put in (nInteger) if between them already.
int SMP_LimitInteger(int nInteger, int nHighest = 100, int nLowest = 1);

// SMP_INC_SPELLS. This is fired from AI files.
// - Removes cirtain spells if the target is attacked, harmed and so on during
//   the spells effects.
void SMP_RemoveSpellsIfAttacked(object oAttacked = OBJECT_SELF);

// SMP_INC_SPELLS. This DESTROYS oTarget.
// - Removes plot flags, all inventory, before proper destorying.
void SMP_PermamentlyRemove(object oTarget);

// SMP_INC_SPELLS. Increase or decrease a stored integer on oTarget, by
// nAmount, under sName
// * Returns Stored amount + nAmount, the new integer set.
int SMP_IncreaseStoredInteger(object oTarget, string sName, int nAmount = 1);

// SMP_INC_SPELLS. Use in DelayCommand(), to delete integer under sName
// on oTarget. Deleted only if oTarget is valid!
void SMP_DelayedDeleteInteger(object oTarget, string sName);

// SMP_INC_SPELLS. Returns TRUE if oTarget's subrace is plant, or integer SMP_PLANT is valid.
int SMP_GetIsPlant(object oTarget);
// SMP_INC_SPELLS. Returns TRUE if oTarget's subrace is water elemental,
// or thier appearance is that of a water elemental.
int SMP_GetIsWaterElemental(object oTarget);


// SMP_INC_SPELLS.
// This will make sure that oTarget is not commandable, and also that the
// commandable was not applied by some other spell which is active.
void SMP_SetCommandableOnSafe(object oTarget, int nSpellRemove);

// SMP_INC_SPELLS.
// Automatically reports sucess or failure for the ability check. The roll
// of d20 + nAbility's scrore needs to be >= nDC.
int SMP_AbilityCheck(object oCheck, int nAbility, int nDC);

// SMP_INC_SPELLS. Applys the visual effect nVis, across from oStart to the object oTarget,
// at intervals of 0.05, playing the visual in the direction.
void SMP_ApplyBeamAlongVisuals(int nVis, object oStart, object oTarget, float fIncrement = 1.0);

// SMP_INC_SPELLS. Returns TRUE if sunlight will kill/seriously damage/almost
// obliterate oTarget, IE: Vampires.
int SMP_GetHateSun(object oTarget);

// SMP_INC_SPELLS.
// This will check if they have any charges for nSpellId, or not as the case
// may be.
// * You can use bFeedback set to FALSE to surpress feedback (EG: test Call
//   Lightning Storm and then Call Lightning, surpress CLS's feedback first).
// * Sucess always has feedback!
// * TRUE if the check passes, else FALSE
int SMP_CheckChargesForSpell(int nSpellId, int bFeedback = TRUE, object oCaster = OBJECT_SELF);
// SMP_INC_SPELLS. This will apply a duration effect, and set an amount of charges
// left to use nSpellId's power for, if they concentrate for another round using
// a special item.
void SMP_AddChargesForSpell(int nSpellId, int nCharges, float fDuration, object oCaster = OBJECT_SELF);

// SMP_INC_SPELLS. This changed oArea's music to iTrack for fDuration.
// * Note: If either tracks are already nTrack, they don't change.
void SMP_PlayMusicForDuration(object oArea, int nTrack, float fDuration);
// SMP_INC_SPELLS. This changes it permantly. (used in PlayMusicForDuration).
// * Set bNightOrDay to TRUE for daytime music.
void SMP_ChangeMusicPermantly(object oArea, int nTrack, int bNightOrDay);
// SMP_INC_SPELLS. This performs an area wether check.
// * Changes oAreas wether to nNewWether for fDuration.
void SMP_ChangeAreaWether(object oArea, int nNewWether, float fDuration);

// SMP_INC_SPELLS.
// This will check the target, to see if they have broken thier concentration
// by moving, doing something else, or not being able to do anything.
// * It sets SMP_CONCENTRATION_CHECK_ + IntToString(nSpellId) to TRUE if broken.
int SMP_ConcentrationCheck(object oTarget, int nSpellId);

// SMP_INC_SPELLS.
// This does a "detect" check for PC rogues - the range is 5ft non-search-mode,
// and 10ft for search mode. The DC is 25 + nLevel.
void SMP_MagicalTrapsDetect(int nLevel);

// SMP_INC_SPELLS, This removes:
// ability damage, blinded, confused,
// dazed, dazzled, deafened, diseased, exhausted, fatigued, feebleminded,
// insanity, nauseated, sickened, stunned, and poisoned.
// * Note that SMP_SPELL_SYMBOL_OF_INSANITY, as well as SMP_SPELL_INSANTY are both the "insanity"
void SMP_HealSpellRemoval(object oTarget);

// SMP_INC_SPELLS. Checks if they are a shapechanger subtype (so can cancle polymorph)
// * They will be able to if they are a shapechanger class
// * They can be a NPC and be a sub-race Shapechanger, or RACIAL_TYPE_SHAPECHANGER.
int SMP_GetIsShapechangerSubtype(object oTarget);

// SMP_INC_SPELLS. If sStoredTo integer on oTarget is nInteger, we delete it.
void SMP_DeleteIntInTime(string sStoredTo, object oTarget, int nInteger);
// SMP_INC_SPELLS. Loops all objects of nObjectType, nearest firest, until it finds sTag's.
object SMP_GetNearestObjectByTagToLocation(int nObjectType, string sTag, location lTarget);
// SMP_INC_SPELLS. Loops all objects of sTag from oCreator's location
// until it finds the nearest created by oCreator, and which is nearest to
// OBJECT_SELF.
object SMP_GetNearestAOEOfTagToUs(string sTag, object oCreator);

// SMP_INC_SPELLS. Returns the base armor type as a number, of oItem
// -1 if invalid, or not armor, or just plain not found.
// 0 to 8 as the value of AC got from the armor - 0 for none, 8 for Full plate.
int SMP_GetArmorType(object oItem);

// SMP_INC_SPELLS. Returns TRUE if oItem is a metal-based weapon.
// * FALSE if invalid, or not a weapon, or just plain not found.
int SMP_GetIsMetalWeapon(object oItem);
// SMP_INC_SPELLS. Returns TRUE if oItem is a metal-based armor.
// * FALSE if invalid, or not armor, or just plain not found.
int SMP_GetIsMetalArmor(object oItem);
// Returns TRUE if oObject is a creature, and is made of metal
int SMP_GetIsFerrous(object oObject);
// SMP_INC_SPELLS. Returns TRUE if oItem is any shield.
// 0 if invalid, or not a shield, or just plain not found.
int SMP_GetIsShield(object oItem);

// SMP_INC_SPELLS. SPELL HOOK FOR ALL PLAYER SPELLS
// Returns TRUE if they can cast the spell, FALSE means they cannot.
// * Note: By using the "Master" column, this hook automatically checks for the
//   main, master spell for GetSpellId(). This means no input is needed, it is
//   all automatic.
int SMP_SpellHookCheck();

// SMP_INC_SPELLS. This is used for the spell "Explosive Runes".
// - When reading a scroll or book (And there is a new "Read" 'spell' too),
//   the runes will trigger and explode for 6d6 damage and some blast damage.
// Returns TRUE if they explode!
int SMP_ExplosiveRunes();
// SMP_INC_SPELLS. This does the explosion effects for oItem, if they had
// explosive runes fire this.
// It will also destroy the item, oItem, if it was not plot.
void SMP_ExplosiveRunesExplode(object oItem);

// SMP_INC_SPELLS. Checks if oTarget was summoned via. a spell.
int SMP_GetIsSummonedCreature(object oTarget);

// SMP_INC_SPELLS. Moves back oTarget from oCaster, fDistance.
// Antilife shell ETC uses this.
void SMP_PerformMoveBack(object oCaster, object oTarget, float fDistance, int bOriginalCommandable);

// SMP_INC_SPELLS. Destroys oObject utterly.
// - Turns off Plot Flag, Cursed Flag and Stolen flag.
// - Then uses a standard DestroyObject() command.
void SMP_CompletelyDestroyObject(object oObject);

// SMP_INC_SPELLS.
// Depending on if oTarget is a PC or an NPC, it will "Disintegrate them as the spell"
// and should create some dust where the items will go.
// * PC's are just damaged normally.
// * Cirtain placables are damaged past thier plot status.
// * Cirtain spells on oTarget are destroyed/removed
// * Executes "SMP_AIL_Disinteg" for NPC's.
void SMP_DisintegrateDamage(object oTarget, effect eVis, int nDam);

// SMP_INC_SPELLS. Returns the bonus to Charisma, Wisdom or Intelligence.
// * Uses GetLastSpellCastClass()
// * Will return Charisma as default.
// * Only can be used in impact scripts
// Will be used in some spells which require the "Bonus to spells" bonus.
int SMP_GetAppropriateAbilityBonus();

// SMP_INC_SPELLS. This performs a grapple check against nAC.
// To use it for "opposed" checks, mearly put the amount the oTarget got into
// nAC, such as Black Tentacles.
// Check is made as an attack roll at:
// *  Base attack bonus + Strength modifier + special size modifier
// Note:
// Special Size Modifier: The special size modifier for a grapple check is as
// follows: Colossal +16, Gargantuan +12, Huge +8, Large +4, Medium +0,
// Small –4, Tiny –8, Diminutive –12, Fine –16. Use this number in place of the
// normal size modifier you use when making an attack roll.
// * Use SMP_GrappleSizeBonus() to get a creatures nSizeMod.
// * Relays to oTarget and oSource (if any) the result of the check.
int SMP_GrappleCheck(object oTarget, int nBAB, int nStrMod, int nSizeMod, int nAC, object oSource = OBJECT_SELF);

// SMP_INC_SPELLS. Special Size Modifier: The special size modifier for a grapple check is as
// follows: Colossal +16, Gargantuan +12, Huge +8, Large +4, Medium +0,
// Small –4, Tiny –8, Diminutive –12, Fine –16.
int SMP_GrappleSizeBonus(object oCreature);

// SMP_INC_SPELLS. This will roll an attack roll, using nBAB, nStrMod, nExtra
// against nAC, that is, oTarget's AC (or should be). Relays the results
// as if it was a proper attack.
// NOTE: Returns FALSE on a miss, but else returns the total attack roll of all 3 things
// plus the d20.
int SMP_AttackCheck(object oTarget, int nBAB, int nStrMod, int nExtra, int nAC, object oSource = OBJECT_SELF);

// SMP_INC_SPELLS. Use AssignCommand() to do this on another person, it will set cutscene mode
// for a few seconds (if not already in a cutscene) and move them to lTarget's
// location, then remove the cutscene mode. It will mean no effects are removed
// and it always is sucessful.
// * lTarget is where to move to
// * nGoVis/nAppearVis, if not VFX_NONE, will be applied at the target location
//   and the person moving location as appropriate.
void SMP_ForceMovementToLocation(location lTarget, int nGoVis = VFX_NONE, int nAppearVis  = VFX_NONE);

// SMP_INC_SPELLS. Roughly gets the weight of oCreature, in tenths of pounds.
// * Based on creature size.
// * Use with GetWeight(oCreature) to get what they are carrying plus the creature weight
int SMP_GetCreatureWeight(object oCreature);

// SMP_INC_SPELLS. This will check if lTarget and lSource are on the same plane
// of exsistance.
// * Used to stop escape from Maze, Prismatic's Plane, Imprisonment.
int SMP_CheckIfSamePlane(location lSource, location lTarget);

// SMP_INC_SPELLS. SMP_GetHitDiceByXP
// HitDice is determined by player's xp, not by whether or not they have leveled
// * Solve for hd from xp = hd * (hd - 1) * 500
//   hd = 1/50 * (sqrt(5) * sqrt(xp + 125) + 25)
int SMP_GetHitDiceByXP(object oCreature);
// SMP_INC_SPELLS. This will get the targets character level, not hit dice,
// and so will be used in death stuff to calculate thier actual character level.
// * Can be used on NPC's, and will use GetHitDice(oTarget);
int SMP_GetCharacterLevel(object oTarget);
// SMP_INC_SPELLS. This will get the correct amount of experience to set a person
// to for there to be a level loss of 1, so they have the exact amount needed
// for the previous level.
// * Will return 1 if at level 1.
int SMP_GetLevelLossXP(int nHD);

// SMP_INC_SPELLs. Removes all avalible castings of nSpell on oCreature
// - oCreature: creature to modify
// - nSpell: constant SPELL_*
void SMP_DecrementAllRemainingSpellUses(object oCreature, int nSpell);

/*:://////////////////////////////////////////////
//:: Functions
//:://////////////////////////////////////////////
    Functions start.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/

// SMP_INC_SPELLS.
// * FALSE if they are a Non-living creature. Dead objects have no effect on result.
// * sDebug - If this is filled, it is sent to the caster, if it returns FALSE.
int SMP_GetIsAliveCreature(object oTarget, string sDebug = "")
{
    // invalid (IE dead etc) races and so on.
    int nRace = GetRacialType(oTarget);
    // Needs to be a creature
    if(GetObjectType(oTarget) != OBJECT_TYPE_CREATURE ||
    // Needs to be a valid race (not a dead or un-alive one!)
        nRace == RACIAL_TYPE_CONSTRUCT ||
        nRace == RACIAL_TYPE_UNDEAD)
    {
        if(sDebug != "")
        {
            SendMessageToPC(OBJECT_SELF, sDebug);
        }
        return FALSE;
    }
    return TRUE;
}


// SMP_INC_SPELLS. Returns true if oTarget is a humanoid
int SMP_GetIsHumanoid(object oTarget)
{
    int nRacial = GetRacialType(oTarget);

    switch(nRacial)
    {
        case RACIAL_TYPE_DWARF:
        case RACIAL_TYPE_HALFELF:
        case RACIAL_TYPE_HALFORC:
        case RACIAL_TYPE_ELF:
        case RACIAL_TYPE_GNOME:
        case RACIAL_TYPE_HUMANOID_GOBLINOID:
        case RACIAL_TYPE_HALFLING:
        case RACIAL_TYPE_HUMAN:
        case RACIAL_TYPE_HUMANOID_MONSTROUS:
        case RACIAL_TYPE_HUMANOID_ORC:
        case RACIAL_TYPE_HUMANOID_REPTILIAN:
        {
            return TRUE;
        }
        break;
    }
   return FALSE;
}

// SMP_INC_SPELLS. This allows the application of a random delay to effects
// based on time parameters passed in.
// - Min default = 0.4, Max default = 1.1. Min = 0.1, Max = 10.0.
float SMP_GetRandomDelay(float fMinimumTime = 0.4, float MaximumTime = 1.1)
{
    float fRandom = MaximumTime - fMinimumTime;
    int nRandom;
    if(fRandom < 0.0)
    {
        return 0.0;
    }
    else
    {
        nRandom = FloatToInt(fRandom  * 10.0);
        nRandom = Random(nRandom) + 1;
        fRandom = IntToFloat(nRandom);
        fRandom /= 10.0;
        return fRandom + fMinimumTime;
    }
}

// SMP_INC_SPELLS. Totals the amount of items of sTag in oTargets inventory.
int SMP_TotalItemsOfBlueprint(object oTarget, string sBluePrint)
{
    object oItem = GetFirstItemInInventory(oTarget);
    int nCount = 0;
    while(GetIsObjectValid(oItem))
    {
        if(GetResRef(oItem) == sBluePrint)
        {
            nCount += GetNumStackedItems(oItem);
        }
        oItem = GetNextItemInInventory(oTarget);
    }
    return nCount;
}

// SMP_INC_SPELLS. Destroys all items of sBluePrint on oTarget.
void SMP_DestroyItemsOfBluePrint(object oTarget, string sBluePrint)
{
    object oItem = GetFirstItemInInventory(oTarget);
    while(GetIsObjectValid(oItem))
    {
        if(GetResRef(oItem) == sBluePrint)
        {
            DestroyObject(oItem);
        }
        oItem = GetNextItemInInventory(oTarget);
    }
}
// SMP_INC_SPELLS. This alerts all DM's of the spell being cast, and of name of
// the target, also reports Caster Level and DC for save.
void SMP_AlertDMsOfSpell(string sName, int nSpellSaveDC, int nCasterLevel)
{
    string sMessage;
    string sTarget = "None";
    object oTarget = GetSpellTargetObject();
    object oArea = GetArea(OBJECT_SELF);
    if(GetIsObjectValid(oTarget))
    {
        sTarget = GetName(oTarget);
    }
    sMessage = "[SPELL CAST: "+sName+"] [Caster: "+GetName(OBJECT_SELF)+"] [Caster Level: "+IntToString(nCasterLevel)+"] [Target: "+sTarget+"] [Area :"+GetName(oArea)+"] [SaveDC: "+IntToString(nSpellSaveDC)+"]";
    SendMessageToAllDMs(sMessage);
}
// SMP_INC_SPELLS. This will check to see if there is a DM playing on the server
// at all. Some spells will force a DM to do the effects, else it'd be scripted
// and very limited (Wish, Miracle...etc).
// * TRUE if a DM is playing in the player (frist/next) list, else FALSE.
int SMP_GetIsDMPlaying()
{
    // Loop PC list
    object oPC = GetFirstPC();
    while(GetIsObjectValid(oPC))
    {
        // Check if DM, or DM possessed (IE: Might be possessing something somehow)
        if(GetIsDM(oPC) || GetIsDMPossessed(oPC))
        {
            return TRUE;
        }
        // Get next PC
        oPC = GetNextPC();
    }
    // No DM
    return FALSE;
}

// SMP_INC_SPELLS. Wrapper for the signal event. Smaller :-P
// * Default to a HOSTILE spell. :-)
// * It uses OBJECT_SELF as the default caster
// It uses SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell, bHarmful));
// It won't fire it at a PC, to reduce lag.
void SMP_SignalSpellCastAt(object oTarget, int nSpell, int bHarmful = TRUE, object oCaster = OBJECT_SELF)
{
    if(GetIsPC(oTarget)) return;
    SignalEvent(oTarget, EventSpellCastAt(oCaster, nSpell, bHarmful));
}

// SMP_INC_SPELLS.
// * Returns true if oCreature does not have a mind
int SMP_SpellsIsMindless(object oCreature)
{
    int nRacialType = GetRacialType(oCreature);
    switch(nRacialType)
    {
        case RACIAL_TYPE_ELEMENTAL:
        case RACIAL_TYPE_UNDEAD:
        case RACIAL_TYPE_VERMIN:
        case RACIAL_TYPE_CONSTRUCT:
        return TRUE;
    }
    return FALSE;
}

// SMP_INC_SPELLS.
// * Returns true or false depending on whether the creature is flying or not
int SMP_SpellsIsFlying(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bFlying = FALSE;
    switch(nAppearance)
    {
        case APPEARANCE_TYPE_ALLIP:
        case APPEARANCE_TYPE_BAT:
        case APPEARANCE_TYPE_BAT_HORROR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_FAERIE_DRAGON:
        case APPEARANCE_TYPE_FALCON:
        case APPEARANCE_TYPE_FAIRY:
        case APPEARANCE_TYPE_HELMED_HORROR:
        case APPEARANCE_TYPE_IMP:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case APPEARANCE_TYPE_MEPHIT_AIR:
        case APPEARANCE_TYPE_MEPHIT_DUST:
        case APPEARANCE_TYPE_MEPHIT_EARTH:
        case APPEARANCE_TYPE_MEPHIT_FIRE:
        case APPEARANCE_TYPE_MEPHIT_ICE:
        case APPEARANCE_TYPE_MEPHIT_MAGMA:
        case APPEARANCE_TYPE_MEPHIT_OOZE:
        case APPEARANCE_TYPE_MEPHIT_SALT:
        case APPEARANCE_TYPE_MEPHIT_STEAM:
        case APPEARANCE_TYPE_MEPHIT_WATER:
        case APPEARANCE_TYPE_QUASIT:
        case APPEARANCE_TYPE_RAVEN:
        case APPEARANCE_TYPE_SHADOW:
        case APPEARANCE_TYPE_SHADOW_FIEND:
        case APPEARANCE_TYPE_SPECTRE:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_WRAITH:
        case APPEARANCE_TYPE_WYRMLING_BLACK:
        case APPEARANCE_TYPE_WYRMLING_BLUE:
        case APPEARANCE_TYPE_WYRMLING_BRASS:
        case APPEARANCE_TYPE_WYRMLING_BRONZE:
        case APPEARANCE_TYPE_WYRMLING_COPPER:
        case APPEARANCE_TYPE_WYRMLING_GOLD:
        case APPEARANCE_TYPE_WYRMLING_GREEN:
        case APPEARANCE_TYPE_WYRMLING_RED:
        case APPEARANCE_TYPE_WYRMLING_SILVER:
        case APPEARANCE_TYPE_WYRMLING_WHITE:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        // hordes
        case 401: //beholder
        case 402: //beholder
        case 403: //beholder
        case 419: // harpy
        case 430: // Demi Lich
        case 472: // Hive mother
        {
            bFlying = TRUE;
        }
        break;
    }
    if(!bFlying)
    {
        // Checking effect appear disappear - like flying dragons
        bFlying = SMP_GetHasEffect(EFFECT_TYPE_DISAPPEARAPPEAR, oCreature);
    }
    return bFlying;
}

// SMP_INC_SPELLS.
// * Returns true if the creature has flesh
int SMP_SpellsIsImmuneToPetrification(object oCreature)
{
    int nAppearance = GetAppearanceType(oCreature);
    int bImmune = FALSE;
    switch (nAppearance)
    {
        case APPEARANCE_TYPE_BASILISK:
        case APPEARANCE_TYPE_COCKATRICE:
        case APPEARANCE_TYPE_MEDUSA:
        case APPEARANCE_TYPE_ALLIP:
        case APPEARANCE_TYPE_ELEMENTAL_AIR:
        case APPEARANCE_TYPE_ELEMENTAL_AIR_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_FIRE:
        case APPEARANCE_TYPE_ELEMENTAL_FIRE_ELDER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        case APPEARANCE_TYPE_GOLEM_STONE:
        case APPEARANCE_TYPE_GOLEM_IRON:
        case APPEARANCE_TYPE_GOLEM_CLAY:
        case APPEARANCE_TYPE_GOLEM_BONE:
        case APPEARANCE_TYPE_GORGON:
        case APPEARANCE_TYPE_HEURODIS_LICH:
        case APPEARANCE_TYPE_LANTERN_ARCHON:
        case APPEARANCE_TYPE_SHADOW:
        case APPEARANCE_TYPE_SHADOW_FIEND:
        case APPEARANCE_TYPE_SHIELD_GUARDIAN:
        case APPEARANCE_TYPE_SKELETAL_DEVOURER:
        case APPEARANCE_TYPE_SKELETON_CHIEFTAIN:
        case APPEARANCE_TYPE_SKELETON_COMMON:
        case APPEARANCE_TYPE_SKELETON_MAGE:
        case APPEARANCE_TYPE_SKELETON_PRIEST:
        case APPEARANCE_TYPE_SKELETON_WARRIOR:
        case APPEARANCE_TYPE_SKELETON_WARRIOR_1:
        case APPEARANCE_TYPE_SPECTRE:
        case APPEARANCE_TYPE_WILL_O_WISP:
        case APPEARANCE_TYPE_WRAITH:
        case APPEARANCE_TYPE_BAT_HORROR:
        // Hordes
        case APPEARANCE_TYPE_DRACOLICH: // Dracolich:
        case APPEARANCE_TYPE_MINDFLAYER_ALHOON: // Alhoon
        case APPEARANCE_TYPE_DRAGON_SHADOW: // shadow dragon
        case APPEARANCE_TYPE_GOLEM_MITHRAL: // mithral golem
        case APPEARANCE_TYPE_GOLEM_ADAMANTIUM: // admantium golem
        case APPEARANCE_TYPE_DEMI_LICH: // Demi Lich
        case APPEARANCE_TYPE_ANIMATED_CHEST: // animated chest
        case APPEARANCE_TYPE_GOLEM_DEMONFLESH: // golems
        case APPEARANCE_TYPE_DWARF_GOLEM: // golems
        {
            bImmune = TRUE;
        }
    }

    // No death for things that cannot be destroyed.
    if(!bImmune)
    {
        bImmune = SMP_CanCreatureBeDestroyed(oCreature);
    }
    // Item Property Immunity to Petrification (But no IMMUNITY_TYPE_PETRIFICATION)
    // does exsist. This is ResistSpell() == 2
    if(!bImmune && ResistSpell(OBJECT_SELF, oCreature) == 2)
    {
        bImmune == TRUE;
    }
    return bImmune;
}

/*:://////////////////////////////////////////////
//:: Name Bullrush Attack
//:: Function Name SMP_Bullrush
//:://////////////////////////////////////////////
    Performs a D&D bullrush attack against oTarget.

    - Used to push back a person in forceful hand.
//:://////////////////////////////////////////////
//:: Created By: Jasperre
//::////////////////////////////////////////////*/
// SMP_INC_SPELLS. Bullrush attack
// - Uses oTarget's strength, add modifiers, against nCasterModifier.
// - Reports results to caster and target
int SMP_Bullrush(object oTarget, int nCasterModifier, object oCaster = OBJECT_SELF)
{
    // Check if oTarget is immune to bullrush
    if(SMP_ImmuneToBullrush(oTarget))
    {
        return FALSE;
    }

    // Get the modifier for the target
    int nTargetModifier = GetAbilityModifier(ABILITY_STRENGTH, oTarget);

    // Add 2 if they are steady
    if(SMP_GetIsSteady(oTarget))
    {
        nTargetModifier += 2;
    }

    // Add size modifier
    nTargetModifier += SMP_GetSizeModifier(oTarget);

    // We now make the rolls
    int nCasterRoll = d20();
    int nTargetRoll = d20();

    string sMessage = "Bullrush Attack! Charger Roll: " + IntToString(nCasterRoll) + ", Modifier: " + IntToString(nCasterModifier) + ". Defender Roll: " + IntToString(nTargetRoll) + ", Modifier: " + IntToString(nTargetModifier) + ". RESULT: ";

    // Check results and relay
    if(nCasterRoll + nCasterModifier > nTargetRoll + nTargetModifier)
    {
        // Charger beats the defender
        sMessage += "Charger Wins!";
        FloatingTextStringOnCreature(sMessage, oTarget, FALSE);
        FloatingTextStringOnCreature(sMessage, oCaster, FALSE);
        // Return TRUE.
        return TRUE;
    }
    else
    {
        // Defender beats the charger
        sMessage += "Defender Wins!";
        FloatingTextStringOnCreature(sMessage, oTarget, FALSE);
        FloatingTextStringOnCreature(sMessage, oCaster, FALSE);
        // Return FALSE
        return FALSE;
    }
    // Default to false if error somehow.
    return FALSE;
}
// SMP_INC_SPELLS. Bullrush
// - Returns TRUE if oCreature is immune to bullrush
// - Oozes, for instance.
int SMP_ImmuneToBullrush(object oCreature)
{
    // Return immune if local variable set
    if(GetLocalInt(oCreature, "SMP_SPELL_IMMUNE_TO_BULLRUSH")) return TRUE;

    int nAppearance = GetAppearanceType(oCreature);
    // Is it some odd creature, which is immune to being held or pushed back?
    // - EG: Oozes.
    switch(nAppearance)
    {
        case APPEARANCE_TYPE_ARCH_TARGET:
        case APPEARANCE_TYPE_COMBAT_DUMMY:
        {
            return TRUE;
        }
        break;
    }
    return FALSE;
}
// SMP_INC_SPELLS. Bullrush.
// * Returns the size modifier for bullrush in spells (XP1)
// +4 for every size over medium
// -4 for every size under medium. Medium = 0.
int SMP_GetSizeModifier(object oCreature)
{
    int nSize = GetCreatureSize(oCreature);
    int nModifier = 0;
    switch(nSize)
    {
        case CREATURE_SIZE_TINY: nModifier = -8;  break;
        case CREATURE_SIZE_SMALL: nModifier = -4; break;
        case CREATURE_SIZE_MEDIUM: nModifier = 0; break;
        case CREATURE_SIZE_LARGE: nModifier = 4;  break;
        case CREATURE_SIZE_HUGE: nModifier = 8;   break;
    }
    return nModifier;
}
// SMP_INC_SPELLS. Bullrush.
// * Returns TRUE if oCreature is steady.
//      - Has more then 2 legs
//      - Is steadying themselves by use of Defensive Casting or Expertise.
//      - Is steady by moving slowly around!
int SMP_GetIsSteady(object oCreature)
{
    // They are steady if moving slowly.
    int iSpeed = GetMovementRate(oCreature);
    // 0 = PC Movement Speed or invalid oCreature
    // 1 = Immobile
    // 2 = Very Slow
    // 3 = Slow
    // 4 = Normal
    // 5 = Fast
    // 6 = Very Fast
    // 7 = Creature Default (defined in appearance.2da)
    // 8 = DM Speed
    if(iSpeed == 1 || iSpeed == 2 || iSpeed == 3)
    {
        return TRUE;
    }

    int nAppearance = GetAppearanceType(oCreature);
    // Has it got more then two legs, or is otherwise steady? (such as a tree
    // is steady, or ooze would be steady :-) ).
    switch(nAppearance)
    {
        case APPEARANCE_TYPE_ARANEA:        // 6-8 legs
        case APPEARANCE_TYPE_BADGER:        // 4
        case APPEARANCE_TYPE_BADGER_DIRE:   // 4
        case APPEARANCE_TYPE_BASILISK:      // 4
        case APPEARANCE_TYPE_BEAR_BLACK:    // 4
        case APPEARANCE_TYPE_BEAR_BROWN:    // 4
        case APPEARANCE_TYPE_BEAR_DIRE:     // 4
        case APPEARANCE_TYPE_BEAR_KODIAK:   // 4
        case APPEARANCE_TYPE_BEAR_POLAR:    // 4
        case APPEARANCE_TYPE_BEETLE_FIRE:   // 6
        case APPEARANCE_TYPE_BEETLE_SLICER: // 6
        case APPEARANCE_TYPE_BEETLE_STAG:   // 6
        case APPEARANCE_TYPE_BEETLE_STINK:  // 6
        case APPEARANCE_TYPE_BOAR:          // 4
        case APPEARANCE_TYPE_BOAR_DIRE:     // 4
        case APPEARANCE_TYPE_CAT_CAT_DIRE:  // 4
        case APPEARANCE_TYPE_CAT_COUGAR:    // 4
        case APPEARANCE_TYPE_CAT_CRAG_CAT:  // 4
        case APPEARANCE_TYPE_CAT_JAGUAR:    // 4
        case APPEARANCE_TYPE_CAT_KRENSHAR:  // 4
        case APPEARANCE_TYPE_CAT_LEOPARD:   // 4
        case APPEARANCE_TYPE_CAT_LION:      // 4
        case APPEARANCE_TYPE_CAT_MPANTHER:  // 4
        case APPEARANCE_TYPE_CAT_PANTHER:   // 4
        case APPEARANCE_TYPE_COW:           // 4
        case APPEARANCE_TYPE_DEER:          // 4
        case APPEARANCE_TYPE_DEER_STAG:     // 4
        case APPEARANCE_TYPE_DOG:           // 4
        case APPEARANCE_TYPE_DOG_BLINKDOG:  // 4
        case APPEARANCE_TYPE_DOG_DIRE_WOLF: // 4
        case APPEARANCE_TYPE_DOG_FENHOUND:  // 4
        case APPEARANCE_TYPE_DOG_HELL_HOUND:// 4
        case APPEARANCE_TYPE_DOG_SHADOW_MASTIF:// 4
        case APPEARANCE_TYPE_DOG_WINTER_WOLF:// 4
        case APPEARANCE_TYPE_DOG_WOLF:      // 4
        case APPEARANCE_TYPE_DOG_WORG:      // 4
        // Note - We count large dragons as always being steady
        case APPEARANCE_TYPE_DRAGON_BLACK:
        case APPEARANCE_TYPE_DRAGON_BLUE:
        case APPEARANCE_TYPE_DRAGON_BRASS:
        case APPEARANCE_TYPE_DRAGON_BRONZE:
        case APPEARANCE_TYPE_DRAGON_COPPER:
        case APPEARANCE_TYPE_DRAGON_GOLD:
        case APPEARANCE_TYPE_DRAGON_GREEN:
        case APPEARANCE_TYPE_DRAGON_RED:
        case APPEARANCE_TYPE_DRAGON_SILVER:
        case APPEARANCE_TYPE_DRAGON_WHITE:
        case APPEARANCE_TYPE_FORMIAN_MYRMARCH:// 4
        case APPEARANCE_TYPE_FORMIAN_QUEEN: // 4
        case APPEARANCE_TYPE_FORMIAN_WARRIOR:// 4
        case APPEARANCE_TYPE_FORMIAN_WORKER:// 4
        case APPEARANCE_TYPE_GORGON:        // 4
        case APPEARANCE_TYPE_GYNOSPHINX:    // 4
        case APPEARANCE_TYPE_INTELLECT_DEVOURER:// 4
        case APPEARANCE_TYPE_MANTICORE:     // 4
        case APPEARANCE_TYPE_OX:            // 4
        case APPEARANCE_TYPE_RAT:           // 4
        case APPEARANCE_TYPE_RAT_DIRE:      // 4
        case APPEARANCE_TYPE_SPHINX:        // 4
        case APPEARANCE_TYPE_SPIDER_DIRE:   // 6-8
        case APPEARANCE_TYPE_SPIDER_GIANT:  // 6-8
        case APPEARANCE_TYPE_SPIDER_PHASE:  // 6-8
        case APPEARANCE_TYPE_SPIDER_SWORD:  // 6-8
        case APPEARANCE_TYPE_SPIDER_WRAITH: // 6-8
        case APPEARANCE_TYPE_STINGER:       // 4
        case APPEARANCE_TYPE_STINGER_CHIEFTAIN:// 4
        case APPEARANCE_TYPE_STINGER_MAGE:  // 4
        case APPEARANCE_TYPE_STINGER_WARRIOR:// 4
        case APPEARANCE_TYPE_WAR_DEVOURER:  // 4
        {
            return TRUE;
        }
        break;
    }
    return FALSE;
}
// SMP_INC_SPELLS. Moves the target back from their current position,
// away from oTarget, fDistance.
void SMP_DoMoveBackwards(object oSource, object oTarget, float fDistance)
{
    // Get new location fDistance behind them.
    location lMoveTo = SMP_GetLocationBehind(oSource, oTarget, fDistance);

    // Move them back to that location using the special function
    AssignCommand(oTarget, SMP_ForceMovementToLocation(lMoveTo));
}

// SMP_INC_SPELLS. Can the creature be destroyed without breaking a plot?
// - Immortal, Plot or DM returns FALSE.
int SMP_CanCreatureBeDestroyed(object oTarget)
{
    if (GetPlotFlag(oTarget) == FALSE &&
        GetImmortal(oTarget) == FALSE &&
        GetIsDM(oTarget) == FALSE &&
        GetIsDead(oTarget) == FALSE)
    {
        return TRUE;
    }
    return FALSE;
}
// SMP_INC_SPELLS. Is oTarget in a maze area? (enables some spells really)
int SMP_IsInMazeArea(object oTarget = OBJECT_SELF)
{
    // Maze waypoint
    object oWP = GetWaypointByTag(SMP_S_MAZE_TARGET);
    if(GetIsObjectValid(oWP) && GetArea(oWP) == GetArea(oTarget))
    {
        // Return TRUE if same area
        return TRUE;
    }
    // Return FALSE
    return FALSE;
}
// SMP_INC_SPELLS. Is oTarget in a Imprisonment area? (only used to check to jump back really)
int SMP_IsInPrisonArea(object oTarget = OBJECT_SELF)
{
    // Imprisonment waypoint
    object oWP = GetWaypointByTag(SMP_S_IMPRISONMENT_TARGET);
    if(GetIsObjectValid(oWP) && GetArea(oWP) == GetArea(oTarget))
    {
        // Return TRUE if same area
        return TRUE;
    }
    // Return FALSE
    return FALSE;
}

// SMP_INC_SPELLS. Returns TRUE if oTarget is an Minotaur. Maze spell uses this.
int SMP_GetIsMinotaur(object oTarget)
{
    int nAppearance = GetAppearanceType(oTarget);
    int bReturn = FALSE;
    switch (nAppearance)
    {
        case APPEARANCE_TYPE_MINOGON:
        case APPEARANCE_TYPE_MINOTAUR:
        case APPEARANCE_TYPE_MINOTAUR_CHIEFTAIN:
        case APPEARANCE_TYPE_MINOTAUR_SHAMAN:
        {
            bReturn = TRUE;
        }
        break;
    }
    // Minotaur subrace
    if(FindSubString("MINOTAUR", GetStringUpperCase(GetSubRace(oTarget))) > FALSE)
    {
        bReturn = TRUE;
    }
    return bReturn;
}
// SMP_INC_SPELLS. Returns TRUE if oTarget is an Astral creature
int SMP_GetIsAstral(object oTarget)
{
    if(GetLocalInt(oTarget, "SPELL_IS_ASTRAL"))
    {
        return TRUE;
    }
    return FALSE;
}
// SMP_INC_SPELLS. Returns TRUE if oTarget is an Ethereal, or an Ethereal creature
int SMP_GetIsEthereal(object oTarget)
{
    if(SMP_GetHasEffect(EFFECT_TYPE_ETHEREAL, oTarget) ||
       GetLocalInt(oTarget, "SPELL_IS_ETHEREAL"))
    {
        return TRUE;
    }
    return FALSE;
}

// SMP_INC_SPELLS. This returns TRUE if they are Incorporeal, via. local variable,
// spell or effect
int SMP_GetIsIncorporeal(object oTarget)
{
    // Incorporal flag
    if(GetLocalInt(oTarget, "INCORPOREAL")) return TRUE;

    // Check Etherealness
    if(SMP_GetIsEthereal(oTarget)) return TRUE;

    // Check appearance type
    switch(GetAppearanceType(oTarget))
    {
        case APPEARANCE_TYPE_INVISIBLE_STALKER:
        case APPEARANCE_TYPE_SHADOW:
        case APPEARANCE_TYPE_SHADOW_FIEND:
        case APPEARANCE_TYPE_WRAITH:
        {
            return TRUE;
        }
        break;
    }

    // Spells
    if(GetHasSpellEffect(SMP_SPELL_GASEOUS_FORM, oTarget))
    {
        return TRUE;
    }
    return FALSE;
}

// Immune to polymorph - also plays approprate effect.
// * Returns TRUE if oTarget cannot be polymorphed.
int SMP_ImmuneToPolymorph(object oTarget)
{
    if(SMP_GetIsIncorporeal(oTarget))
    {
        effect eMantle = EffectVisualEffect(VFX_IMP_SPELL_MANTLE_USE);
        ApplyEffectToObject(DURATION_TYPE_INSTANT, eMantle, oTarget);
        return TRUE;
    }
    return FALSE;
}

// SMP_INC_SPELLS. Returns TRUE if oTarget is Crystalline - earthy
int SMP_GetIsCrystalline(object oTarget)
{
    if(GetLocalInt(oTarget, SMP_CRYSTALLINE))
    {
        return TRUE;
    }
    // Check appearance
    switch(GetAppearanceType(oTarget))
    {
        case APPEARANCE_TYPE_ELEMENTAL_EARTH:
        case APPEARANCE_TYPE_ELEMENTAL_EARTH_ELDER:
        {
            return TRUE;
        }
        break;
    }
    return FALSE;
}

// SMP_INC_SPELLS. Sorts out metamagic checks, using Random()
// * nDiceSides (EG: 6 for D6 dice) * nNumberOfDice (EG: 2, for 2d6)
// * nBonus - Bonus to at the end.
// * Does include Maximise and Empower checks.
// * nTouch - If 2, it is a critcal, and does double what it would normally return.
int SMP_MaximizeOrEmpower(int nDiceSides, int nNumberOfDice, int nMeta, int nBonus = 0, int nTouch = 0)
{
    int nDiceReturn, nCnt;
    //Resolve metamagic
    if(nMeta == METAMAGIC_MAXIMIZE)
    {
        nDiceReturn = nDiceSides * nNumberOfDice;
    }
    else
    {
        // Else, can be empowered or normal. Roll dice
        for(nCnt = 1; nCnt <= nNumberOfDice; nCnt++)
        {
            nDiceReturn += Random(nDiceSides) + 1;
        }
        // Resolve metamagic empower
        if(nMeta == METAMAGIC_EMPOWER)
        {
            nDiceReturn = nDiceReturn + (nDiceReturn/2);
        }
    }
    // Add bonus.
    nDiceReturn += nBonus;
    // Make sure we multiply if touch attack based.
    if(nTouch == 2)
    {
        nDiceReturn * 2;
    }
    return nDiceReturn;
}

// SMP_INC_SPELLS. Works out a dice-rolled time.
// * nType - use SMP_ROUNDS (6 sec), SMP_MINUTES (60 sec), SMP_HOURS (mod dependant)
// * nDiceSides, nNumberOfDice - The dice (EG 5, 6sided dice = 6, 5)
// * nMeta - Metamagic feat EXTEND is used here
// * nBonus - Added before metamagic, such as 4d(caster level) + Bonus.
float SMP_GetRandomDuration(int nType, int nDiceSides, int nNumberOfDice, int nMeta, int nBonusTime = 0)
{
    int nDiceRolls, nCnt;
    // Roll dice
    for(nCnt = 1; nCnt <= nNumberOfDice; nCnt++)
    {
        nDiceRolls = nDiceRolls + Random(nDiceSides - 1) + 1;
    }
    // Resolve metamagic
    int nTotal = nDiceRolls + nBonusTime;
    if(nMeta == METAMAGIC_EXTEND)
    {
        nTotal *= 2;// x2 duration
    }
    // Returns the right time
    float fTime;
    if(nType == SMP_ROUNDS)
    {
        fTime = RoundsToSeconds(nTotal);
    }
    else if(nType == SMP_MINUTES)
    {
        fTime = TurnsToSeconds(nTotal);
    }
    else if(nType == SMP_HOURS)
    {
        fTime = HoursToSeconds(nTotal);
    }
    return fTime;
}

// SMP_INC_SPELLS. Works out a normal time. Useful wrapper.
// * nType - use SMP_ROUNDS (6 sec), SMP_MINUTES (60 sec), SMP_HOURS (mod dependant)
// * nTime - the time in hours, rounds or turns
// * nMeta - The metamagic feat EXTEND is also taken into account..
float SMP_GetDuration(int nType, int nTime, int nMeta)
{
    // Error checking
    if(nTime < 1) nTime = 1;
    // Resolve metamagic
    if(nMeta == METAMAGIC_EXTEND)
    {
        nTime *= 2;// x2 duration
    }
    // Returns the right time
    float fTime;
    if(nType == SMP_ROUNDS)
    {
        fTime = RoundsToSeconds(nTime);
    }
    else if(nType == SMP_MINUTES)
    {
        fTime = TurnsToSeconds(nTime);
    }
    else if(nType == SMP_HOURS)
    {
        fTime = HoursToSeconds(nTime);
    }
    return fTime;
}


// SMP_INC_SPELLS. Does a fortitude check and applys EffectPetrify :-)
// - Taken from Bioware's petrify. More generic however.
// - No ReactionType checks.
// - Will not petrify immune creatures
// * oTarget - Target
// * nCasterLevel - Either the hit dice of the creature or the caster level
// * nFortSaveDC: pass in this number from the spell script
// - It will also apply bonuses of a construct.
void SMP_SpellFortitudePetrify(object oTarget, int nCasterLevel, int nFortSaveDC)
{
    // * Exit if creature is immune to petrification
    if(SMP_SpellsIsImmuneToPetrification(oTarget)) return;

    float fDifficulty = 0.0;
    int bShowPopup = FALSE;

    // Declare effects
    // * Proper, statue, link. Construct immunities linked.
    effect eLink = SMP_CreateProperPetrifyEffectLink();

    // Do a fortitude save check
    if(!SMP_SavingThrow(SAVING_THROW_FORT, oTarget, nFortSaveDC))
    {
        // * The duration is permanent against NPCs but only temporary against PCs
        //   unless the PC's are playing core rules or higher.
        if(GetIsPC(oTarget))
        {
            // * Under hardcore rules or higher, this is an instant death
            if(GetGameDifficulty() >= GAME_DIFFICULTY_CORE_RULES)
            {
                ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
                // Death panel
                DelayCommand(2.75, PopUpDeathGUIPanel(oTarget, FALSE , TRUE, 40579));
            }
            else
            {
                // Apply for nCasterLevel rounds.
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, oTarget, RoundsToSeconds(nCasterLevel));
            }
        }
        else
        // * NPCs get full effect. No death panel.
        {
            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eLink, oTarget);
        }
        // April 2003: Clearing actions to kick them out of conversation when petrified
        AssignCommand(oTarget, ClearAllActions());
    }
}


// SMP_INC_SPELLS. Creates a new location from lLocation on a varying X and Y value, in increments
// of 1 meter.
// * nRandom - this is the number you want to randomise. It will be up to HALF
//             this in meters from lLocation, north south east or west.
location SMP_GetRandomLocation(location lLocation, int nRandom)
{
    vector vOld = GetPositionFromLocation(lLocation);
    float fFacing = IntToFloat(Random(360));
    float fNewX = vOld.x + IntToFloat(Random(nRandom) - (nRandom/2));
    float fNewY = vOld.y + IntToFloat(Random(nRandom) - (nRandom/2));
    float fNewZ = vOld.z;
    vector vNew = Vector(fNewX, fNewY, fNewZ);
    location lReturn = Location(GetAreaFromLocation(lLocation), vNew, fFacing);
    // Return the finnished one
    return lReturn;
}

// SMP_INC_SPELLS. Returns bolts, arrows, bullets or -1 for the ammo item type used by oWeapon.
int SMP_GetWeaponsAmmoType(object oWeapon)
{
    int nItemType = GetBaseItemType(oWeapon);

    if(nItemType == BASE_ITEM_LONGBOW || nItemType == BASE_ITEM_SHORTBOW)
    {
        return BASE_ITEM_ARROW;
    }
    else if(nItemType == BASE_ITEM_HEAVYCROSSBOW || nItemType == BASE_ITEM_LIGHTCROSSBOW)
    {
        return BASE_ITEM_BOLT;
    }
    else if(nItemType == BASE_ITEM_SLING)
    {
        return BASE_ITEM_BULLET;
    }
    return -1;
}
// SMP_INC_SPELLS. Gets the right slot for iBaseAmmoType or -1.
int SMP_GetAmmoSlot(int nBaseAmmoType)
{
    if(nBaseAmmoType == BASE_ITEM_ARROW)
    {
        return INVENTORY_SLOT_ARROWS;
    }
    else if(nBaseAmmoType == BASE_ITEM_BOLT)
    {
        return INVENTORY_SLOT_BOLTS;
    }
    else if(nBaseAmmoType == BASE_ITEM_BULLET)
    {
        return INVENTORY_SLOT_BULLETS;
    }
    return -1;
}

// SMP_INC_SPELLS. Is the creature dazzeled?
// Spells include:
// - Flare
int SMP_GetIsDazzled(object oTarget)
{
    effect eCheck = GetFirstEffect(oTarget);
    int nSpell;
    while(GetIsEffectValid(eCheck))
    {
        nSpell = GetEffectSpellId(eCheck);
        // Check spells
        switch(nSpell)
        {
            case SMP_SPELL_FLARE:
            {
                return TRUE;
            }
            break;
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}

// SMP_INC_SPELLS. Can the caster, oCaster, teleport to lTarget without disrupting a module?
// - Trigger, if at the location or the caster, stops it
// - The area can be made "No teleport"
int SMP_CannotTeleport(object oCaster, location lTarget)
{
    // Check for Dimensional Anchor
    if(SMP_GetDimensionalAnchor(oCaster))
    {
        SendMessageToPC(oCaster, "Your Dimensional Anchor stops extraplanar travel!");
        return TRUE;
    }

    // Check for waypoint
    object oWP = GetWaypointByTag("SMP_SPELL_NO_TELEPORT_WP");
    if(GetIsObjectValid(oWP))
    {
        // Return TRUE - cannot teleport
        SendMessageToPC(oCaster, "Your movement spell is disrupted!");
        return TRUE;
    }

    // Get nearest teleport trigger.
    object oTeleportTrigger = GetNearestObjectByTag("SMP_SPELL_NO_TELEPORT", oCaster);

    // Make sure oCaster is not in the trigger
    if(GetIsObjectValid(oTeleportTrigger) &&
       GetObjectType(oTeleportTrigger) == OBJECT_TYPE_TRIGGER)
    {
        // Loop objects in the trigger
        object oInTrig = GetFirstInPersistentObject(oTeleportTrigger, OBJECT_TYPE_CREATURE);
        while(GetIsObjectValid(oInTrig))
        {
            // Cannot teleport if in the trigger
            if(oInTrig == oCaster)
            {
                SendMessageToPC(oCaster, "Your movement spell is disrupted!");
                return TRUE;
            }
            oInTrig = GetNextInPersistentObject(oTeleportTrigger, OBJECT_TYPE_CREATURE);
        }
        // If we didn't find the caster was in the known trigger, check the
        // location

        // Make sure, that the location is valid, and not in a trigger
        // - We create a placeable object, invisible object, of a new tag mind
        //   you, for this.
        string sCaster = ObjectToString(oCaster);
        object oNewPlaceable = CreateObject(OBJECT_TYPE_PLACEABLE, "invis", lTarget, FALSE, sCaster);

        // We check the nearest trigger to the target location
        oTeleportTrigger = GetNearestObjectByTag("SMP_SPELL_NO_TELEPORT", oNewPlaceable);
        if(GetIsObjectValid(oTeleportTrigger))
        {
            if(GetObjectType(oTeleportTrigger) == OBJECT_TYPE_TRIGGER)
            {
                // Loop the objects in the teleport trigger
                oInTrig = GetFirstInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                while(GetIsObjectValid(oInTrig))
                {
                    // Cannot teleport if in the trigger
                    if(oInTrig == oNewPlaceable)
                    {
                        DestroyObject(oNewPlaceable);
                        SendMessageToPC(oCaster, "Your movement spell is disrupted!");
                        return TRUE;
                    }
                    oInTrig = GetNextInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                }
            }
        }

        // We check for any Forbiddance in the target location.
        oTeleportTrigger = GetNearestObjectByTag(SMP_AOE_TAG_PER_FORBIDDANCE, oNewPlaceable);
        if(GetIsObjectValid(oTeleportTrigger))
        {
            if(GetObjectType(oTeleportTrigger) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                // Loop the objects in the teleport trigger
                oInTrig = GetFirstInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                while(GetIsObjectValid(oInTrig))
                {
                    // Cannot teleport if in the trigger
                    if(oInTrig == oNewPlaceable)
                    {
                        DestroyObject(oNewPlaceable);
                        SendMessageToPC(oCaster, "Your movement spell is disrupted by Dimensional Lock!");
                        return TRUE;
                    }
                    oInTrig = GetNextInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                }
            }
        }

        // FINALLY, we check for any Dimensional Anchors in the target location.
        oTeleportTrigger = GetNearestObjectByTag(SMP_AOE_TAG_PER_DIMENSIONAL_LOCK, oNewPlaceable);
        if(GetIsObjectValid(oTeleportTrigger))
        {
            if(GetObjectType(oTeleportTrigger) == OBJECT_TYPE_AREA_OF_EFFECT)
            {
                // Loop the objects in the teleport trigger
                oInTrig = GetFirstInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                while(GetIsObjectValid(oInTrig))
                {
                    // Cannot teleport if in the trigger
                    if(oInTrig == oNewPlaceable)
                    {
                        DestroyObject(oNewPlaceable);
                        SendMessageToPC(oCaster, "Your movement spell is disrupted by Dimensional Lock!");
                        return TRUE;
                    }
                    oInTrig = GetNextInPersistentObject(oTeleportTrigger, OBJECT_TYPE_PLACEABLE);
                }
            }
        }

    }
    // We can teleport or whatever.
    return FALSE;
}

// SMP_INC_SPELLS. Returns TRUE if oCreature is locked in this dimension by:
// - Dimensional Anchor
// - Dimensional Lock
int SMP_GetDimensionalAnchor(object oCreature)
{
    if(GetHasSpellEffect(SMP_SPELL_DIMENSIONAL_ANCHOR, oCreature) ||
       GetHasSpellEffect(SMP_SPELL_DIMENSIONAL_LOCK, oCreature) ||
       GetHasSpellEffect(SMP_SPELL_FORBIDDANCE, oCreature))
    {
        return TRUE;
    }
    return FALSE;
}

// This is used for some spells to limit creatures by size. EG: Dimension door.
// This returns:
// - 1 for Medium, small and tiny creatures.
// - 2 for Large (Equivilant of 2 medium creatures)
// - 4 for Huge creature sizes (Equivilant of 2 Large creatures)
int SMP_SizeEquvilant(object oCreature)
{
    int nReturn = 1;
    int nSize = GetCreatureSize(oCreature);
    // Check size of creature
    switch(nSize)
    {
        case CREATURE_SIZE_TINY:   nReturn = 1; break;
        case CREATURE_SIZE_SMALL:  nReturn = 1; break;
        case CREATURE_SIZE_MEDIUM: nReturn = 1; break;
        case CREATURE_SIZE_LARGE:  nReturn = 2; break;
        case CREATURE_SIZE_HUGE:   nReturn = 4; break;
    }
    return nReturn;
}

// SMP_INC_SPELLS. Removes all Fatigue/Exhaustion from oTarget.
void SMP_RemoveFatigue(object oTarget)
{
    // Check for spells of X type...
    // - Ability Fatigue is just fatigue :-)
    object oFatigue = GetObjectByTag("SMP_PLC_FATIGUE");
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        // Check creator of the effect is fatigue
        if(GetEffectCreator(eCheck) == oFatigue)
        {
            RemoveEffect(oTarget, eCheck);
        }
        eCheck = GetNextEffect(oTarget);
    }
}
// SMP_INC_SPELLS. Applys a new Fatigue effect to oTarget, if not already got it...
// * If bExhaustion is TRUE, it applies Exhaustion instead.
//   * Exhaustion "overrides" any fatigue, and using the Bioware problem of
//     ability penalties not stacking, will mearly apply exhasution over fatigue.
// (Noting, of course, speed decreases stack. Anyone exhausted also becomes fatiged,
//  but not vice versa).
// * Stats: Fatigue: 20% move penalty. -2 Dex and STR.
//          Exhaustion: An additional -4 to Dex and STR, -20% speed. (so -6, 40%)
void SMP_ApplyFatigue(object oTarget, int bExhaustion = FALSE, int nDurationType = DURATION_TYPE_PERMANENT, float fDuration = 0.0)
{
    // Get the fatigue creator
    object oCreator = GetObjectByTag("SMP_PLC_FATIGUE");
    // Set the object to affect, the duration type and the duration, and if
    // fatigue.
    SetLocalObject(oCreator, "FATIGUE_TARGET", oTarget);
    SetLocalInt(oCreator, "FATIGUE_DURATION_TYPE", nDurationType);
    SetLocalFloat(oCreator, "FATIGUE_DURATION", fDuration);
    SetLocalInt(oCreator, "FATIGUE_EXHAUSTION", bExhaustion);
    // Make them apply effects in the script.
    // * Fatigue is defined by who created the fatigue.
    ExecuteScript("SMP_ail_fatigue", oCreator);
}

// SMP_INC_SPELLS.
// Returns iHighest if it is over nHighest, or nLowest if under nLowest, or
// the integer put in (nInteger) if between them already.
int SMP_LimitInteger(int nInteger, int nHighest = 100, int nLowest = 1)
{
    if(nInteger > nHighest)
    {
        return nHighest;
    }
    else if(nInteger < nLowest)
    {
        return nLowest;
    }
    return nInteger;
}

// SMP_INC_SPELLS. This is fired from AI files.
// - Removes cirtain spells if the target is attacked, harmed and so on during
//   the spells effects.
void SMP_RemoveSpellsIfAttacked(object oAttacked = OBJECT_SELF)
{
    // - Removes Halt Undead effects
    SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_HALT_UNDEAD, oAttacked);

    // - Others...
}

// SMP_INC_SPELLS. This DESTROYS oTarget.
// - Removes plot flags, all inventory, before proper destorying.
void SMP_PermamentlyRemove(object oTarget)
{
    // Error check
    if(GetIsPC(oTarget)) return;
    // We can destroy them
    SetPlotFlag(oTarget, FALSE);
    SetImmortal(oTarget, FALSE);
    // If a creature, make sure their corpse is off
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        AssignCommand(oTarget, ClearAllActions());
        AssignCommand(oTarget, SetIsDestroyable(TRUE, FALSE, FALSE));
        SetLootable(oTarget, FALSE);
    }
    // Destory inventory
    if(GetHasInventory(oTarget))
    {
        object oItem = GetFirstItemInInventory(oTarget);
        while(GetIsObjectValid(oItem))
        {
            SetPlotFlag(oItem, FALSE);
            DestroyObject(oItem);
            oItem = GetNextItemInInventory(oTarget);
        }
    }
    // Destroy target
    DestroyObject(oTarget);
}

// SMP_INC_SPELLS. Increase or decrease a stored integer on oTarget, by
// nAmount, under sName
// * Returns Stored amount + nAmount, the new integer set.
int SMP_IncreaseStoredInteger(object oTarget, string sName, int nAmount = 1)
{
    // Get old
    int nOriginal = GetLocalInt(oTarget, sName);
    // Add new
    int nNew = nOriginal + nAmount;
    // Set new
    SetLocalInt(oTarget, sName, nNew);
    // Return the new value
    return nNew;
}
// SMP_INC_SPELLS. Use in DelayCommand(), to delete integer under sName
// on oTarget. Deleted only if oTarget is valid!
void SMP_DelayedDeleteInteger(object oTarget, string sName)
{
    if(GetIsObjectValid(oTarget))
    {
        DeleteLocalInt(oTarget, sName);
    }
}

// SMP_INC_SPELLS. Returns TRUE if oTarget's subrace is plant, or integer SMP_PLANT is valid.
int SMP_GetIsPlant(object oTarget)
{
    if(FindSubString(GetStringUpperCase(GetSubRace(oTarget)), "PLANT") >= 0)
    {
        return TRUE;
    }
    else if(GetLocalInt(oTarget, SMP_PLANT))
    {
        return TRUE;
    }
    return FALSE;
}

// SMP_INC_SPELLS. Returns TRUE if oTarget's subrace is water elemental,
// or thier appearance is that of a water elemental.
int SMP_GetIsWaterElemental(object oTarget)
{
    string sSubrace = GetStringUpperCase(GetSubRace(oTarget));
    if(FindSubString(sSubrace, "WATER") >= 0 &&
       FindSubString(sSubrace, "ELEMENTAL") >= 0)
    {
        return TRUE;
    }
    // Check appearance type
    switch(GetAppearanceType(oTarget))
    {
        case APPEARANCE_TYPE_ELEMENTAL_WATER:
        case APPEARANCE_TYPE_ELEMENTAL_WATER_ELDER:
        {
            return TRUE;
        }
        break;
    }

    return FALSE;
}

// SMP_INC_SPELLS.
// This will make sure that oTarget is not commandable, and also that the
// commandable was not applied by some other spell which is active.
void SMP_SetCommandableOnSafe(object oTarget, int iSpellRemove)
{
    if(GetIsObjectValid(oTarget) && !GetCommandable(oTarget))
    {
        // Check spells which use SetCommandable
        if((!GetHasSpellEffect(SMP_SPELL_BESTOW_CURSE, oTarget) || iSpellRemove == SMP_SPELL_BESTOW_CURSE) &&
           (!GetHasSpellEffect(SMP_SPELL_IMPRISONMENT, oTarget) || iSpellRemove == SMP_SPELL_IMPRISONMENT))
        {
            SetCommandable(TRUE, oTarget);
        }
    }
}

// SMP_INC_SPELLS.
// Automatically reports sucess or failure for the ability check. The roll
// of d20 + nAbility's scrore needs to be >= nDC.
int SMP_AbilityCheck(object oCheck, int nAbility, int nDC)
{
    int nAbilityScore = GetAbilityScore(oCheck, nAbility);

    if(nAbilityScore + d20() >= nDC)
    {
        SendMessageToPC(oCheck, "Ability Check: Pass");
        return TRUE;
    }
    else
    {
        SendMessageToPC(oCheck, "Ability Check: Fail");
    }
    return FALSE;
}

// SMP_INC_SPELLS. Applys the visual effect nVis, across from oStart to the object oTarget,
// at intervals of 0.05, playing the visual in the direction.
void SMP_ApplyBeamAlongVisuals(int nVis, object oStart, object oTarget, float fIncrement = 1.0)
{
    effect eVis = EffectVisualEffect(nVis);
    float fDelay;
    object oArea = GetArea(oStart);
    vector vTarget = GetPosition(oStart);
    vector vCaster = GetPosition(oTarget);
    vector vEffectStep = vTarget - vCaster; /* Get the vector from caster to target */
    int iFXCount = FloatToInt(VectorMagnitude(vEffectStep)/fIncrement); /* Determine the number of effects needed */
    vEffectStep = (VectorNormalize(vEffectStep) * fIncrement); /* generate the normalized vector (assuming a length of 1m) */
    vector vEffect = vCaster + vEffectStep; /* first Effect location (fIncrement from caster) */
    while(iFXCount > 0)
    {
        fDelay += 0.05;
        DelayCommand(fDelay, ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, Location(oArea, vEffect, 0.0)));
        vEffect += vEffectStep; /* Move effect location 1m */
        iFXCount--; /* decrement the effect counter */
    }
}

// SMP_INC_SPELLS. Returns TRUE if sunlight will kill/seriously damage/almost
// obliterate oTarget, IE: Vampires.
int SMP_GetHateSun(object oTarget)
{
    switch(GetAppearanceType(oTarget))
    {
        case APPEARANCE_TYPE_VAMPIRE_MALE:
        case APPEARANCE_TYPE_VAMPIRE_FEMALE:
        {
            return TRUE;
        }
        break;
    }
    // Check subrace
    string sSubrace = GetStringUpperCase(GetSubRace(oTarget));
    // Check subraces
    if(FindSubString(sSubrace, "VAMPIRE") >= 0)
    {
        return TRUE;
    }
    return FALSE;
}

// SMP_INC_SPELLS. This will apply a duration effect, and set an amount of charges
// left to use nSpellId's power for, if they concentrate for another round using
// a special item.
void SMP_AddChargesForSpell(int nSpellId, int nCharges, float fDuration, object oCaster = OBJECT_SELF)
{
    // Variable name
    string sVariableName = "SMP_SPELL_CHARGES" + IntToString(nSpellId);
    // New spell from a scroll or normal spell, ETC.
    // Set charges and apply new effect
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    // Remove previous effects and apply this one
    SMP_PRCRemoveSpellEffects(nSpellId, oCaster, oCaster);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oCaster, fDuration);

    // New charges
    SetLocalInt(oCaster, sVariableName, nCharges);

    // Message
    SendMessageToPC(oCaster, "You can release the spell " + IntToString(nCharges) + " more times.");
}


// SMP_INC_SPELLS.
// This will check if they have any charges for nSpellId, or not as the case
// may be.
// * You can use bFeedback set to FALSE to surpress feedback (EG: test Call
//   Lightning Storm and then Call Lightning, surpress CLS's feedback first).
// * Sucess always has feedback!
// * TRUE if the check passes, else FALSE
int SMP_CheckChargesForSpell(int nSpellId, int bFeedback = TRUE, object oCaster = OBJECT_SELF)
{
    // Check caster item
    string sVariableName = "SMP_SPELL_CHARGES" + IntToString(nSpellId);

    // Check charges used by this item - do we have the effects at all?
    if(SMP_GetHasSpellEffectFromCaster(nSpellId, oCaster, oCaster))
    {
        // Got the spell's effects, so thats good.
        int nChargesNow = GetLocalInt(oCaster, sVariableName);

        // Check charges
        if(nChargesNow <= 0)
        {
            // No charges left
            if(bFeedback) SendMessageToPC(oCaster, "You have no more charges of this spell to release.");
            DeleteLocalInt(oCaster, sVariableName);
            SMP_PRCRemoveSpellEffects(nSpellId, oCaster, oCaster);
            return FALSE;
        }
        else
        {
            // Decrease charges by 1
            nChargesNow--;
            SetLocalInt(oCaster, sVariableName, nChargesNow);
            SendMessageToPC(oCaster, "You can release the spell " + IntToString(nChargesNow) + " more times.");
            return TRUE;
        }
    }
    // Not got the spell's effects, bad, can't cast more
    DeleteLocalInt(oCaster, sVariableName);
    if(bFeedback) SendMessageToPC(oCaster, "You have not cast this spell in time, or not cast it at all, and cannot use another stored charge");
    return FALSE;
}
// SMP_INC_SPELLS. This changes it permantly. (used in PlayMusicForDuration).
// * Set bNightOrDay to TRUE for daytime music.
void SMP_ChangeMusicPermantly(object oArea, int nTrack, int bNightOrDay)
{
    MusicBackgroundStop(oArea);
    if(bNightOrDay)
    {
        MusicBackgroundChangeDay(oArea, nTrack);
    }
    else
    {
        MusicBackgroundChangeNight(oArea, nTrack);
    }
    MusicBackgroundPlay(oArea);
}
// SMP_INC_SPELLS. This changed oArea's music to iTrack for fDuration.
// * Note: If either tracks are already nTrack, they don't change.
void SMP_PlayMusicForDuration(object oArea, int nTrack, float fDuration)
{
    int nMusicNight = MusicBackgroundGetNightTrack(oArea);
    int nMusicDay = MusicBackgroundGetDayTrack(oArea);
    // Change it.
    MusicBackgroundStop(oArea);
    if(nMusicNight != nTrack)
    {
        MusicBackgroundChangeNight(oArea, nTrack);
        DelayCommand(fDuration, SMP_ChangeMusicPermantly(oArea, nMusicNight, FALSE));
    }
    if(nMusicDay != nTrack)
    {
        MusicBackgroundChangeDay(oArea, nTrack);
        DelayCommand(fDuration, SMP_ChangeMusicPermantly(oArea, nMusicDay, TRUE));
    }
    MusicBackgroundPlay(oArea);
}
// SMP_INC_SPELLS. This performs an area wether check.
// * Changes oAreas wether to nNewWether for fDuration.
void SMP_ChangeAreaWether(object oArea, int nNewWether, float fDuration)
{
    // Return on error.
    if(fDuration < 0.0 || nNewWether > 2 || nNewWether < -1 || !GetIsObjectValid(oArea)) return;

    SetWeather(GetArea(OBJECT_SELF), nNewWether);

    DelayCommand(fDuration, SetWeather(GetArea(OBJECT_SELF), WEATHER_USE_AREA_SETTINGS));
}

// SMP_INC_SPELLS.
// This will check the target, to see if they have broken thier concentration
// by moving, doing something else, or not being able to do anything.
// * It sets SMP_CONCENTRATION_CHECK_ + IntToString(nSpellId) to TRUE if broken.
int SMP_ConcentrationCheck(object oTarget, int nSpellId)
{
    switch(GetCurrentAction(oTarget))
    {
        // Basically, the INVALID ones are put here.
        case ACTION_DISABLETRAP:
        case ACTION_TAUNT:
        case ACTION_PICKPOCKET:
        case ACTION_ATTACKOBJECT:
        case ACTION_COUNTERSPELL:
        case ACTION_FLAGTRAP:
        case ACTION_CASTSPELL:
        case ACTION_ITEMCASTSPELL:
        {
            // Not OK
            SetLocalInt(oTarget, "SMP_CONCENTRATION_CHECK_" + IntToString(nSpellId), TRUE);
        }
        break;
        default:
        {
            // All OK
        }
        break;
    }
    // Check if they can cast a spell!
    effect eCheck = GetFirstEffect(oTarget);
    while(GetIsEffectValid(eCheck))
    {
        switch(GetEffectType(eCheck))
        {
            case EFFECT_TYPE_CUTSCENE_PARALYZE:
            case EFFECT_TYPE_CUTSCENEIMMOBILIZE:
            case EFFECT_TYPE_DAZED:
            case EFFECT_TYPE_FRIGHTENED:
            case EFFECT_TYPE_PARALYZE:
            case EFFECT_TYPE_PETRIFY:
            case EFFECT_TYPE_POLYMORPH:
            case EFFECT_TYPE_SLEEP:
            case EFFECT_TYPE_STUNNED:
            case EFFECT_TYPE_TURNED:
            {
                SetLocalInt(oTarget, "SMP_CONCENTRATION_CHECK_" + IntToString(nSpellId), TRUE);
                return TRUE;
            }
            break;
        }
        eCheck = GetNextEffect(oTarget);
    }
    return FALSE;
}

// SMP_INC_SPELLS.
// This does a "detect" check for PC rogues - the range is 5ft non-search-mode,
// and 10ft for search mode. The DC is 25 + nLevel.
void SMP_MagicalTrapsDetect(int nLevel)
{


}


// SMP_INC_SPELLS, This removes:
// ability damage, blinded, confused,
// dazed, dazzled, deafened, diseased, exhausted, fatigued, feebleminded,
// insanity, nauseated, sickened, stunned, and poisoned.
void SMP_HealSpellRemoval(object oTarget)
{
    // ability damage, blinded, confused,
    // dazed, dazzled, deafened, diseased, exhausted, fatigued, feebleminded,
    // insanity, nauseated, sickened, stunned, and poisoned.
    effect eCheck = GetFirstEffect(oTarget);
    // Loop effects
    while(GetIsEffectValid(eCheck))
    {
        // Remove cirtain spells
        switch(GetEffectSpellId(eCheck))
        {
            // - Feeblemind
            case SMP_SPELL_FEEBLEMIND:
            // - All insanity
            case SMP_SPELL_INSANITY:
            case SMP_SPELL_SYMBOL_OF_INSANITY:
            // - Dazzeled
            case SMP_SPELL_FLARE:
            {
                // Remove this effect (and its linked effects)
                RemoveEffect(oTarget, eCheck);
            }
            break;
            // Other effects
            default:
            {
                // Remove cirtain effects
                switch(GetEffectType(eCheck))
                {
                    case EFFECT_TYPE_DAZED:
                    case EFFECT_TYPE_DEAF:
                    case EFFECT_TYPE_DISEASE:
                    case EFFECT_TYPE_STUNNED:
                    case EFFECT_TYPE_POISON:
                    {
                        RemoveEffect(oTarget, eCheck);
                    }
                    break;
                }
            }
            break;
        }
        // Get next effect
        eCheck = GetNextEffect(oTarget);
    }
    // Remove fatige
    SMP_RemoveFatigue(oTarget);
}

// SMP_INC_SPELLS. Checks if they are a shapechanger subtype (so can cancle polymorph)
// * They will be able to if they are a shapechanger class
// * They can be a NPC and be a sub-race Shapechanger, or RACIAL_TYPE_SHAPECHANGER.
int SMP_GetIsShapechangerSubtype(object oTarget)
{
    // Shapechanger class is inherant.
    if(GetLevelByClass(CLASS_TYPE_SHAPECHANGER, oTarget) >= 1 ||
    // Racial type: Shapechanger
       GetRacialType(oTarget) == RACIAL_TYPE_SHAPECHANGER ||
    // NPC with the shapechanger subrace
     (!GetIsPC(oTarget) &&
       FindSubString(GetStringUpperCase(GetSubRace(oTarget)), "SHAPECHANGER")))
    {
        return TRUE;
    }
    return FALSE;
}

// If sStoredTo integer on oTarget is nInteger, we delete it.
void SMP_DeleteIntInTime(string sStoredTo, object oTarget, int nInteger)
{
    // Check if the integer is equal
    if(GetLocalInt(oTarget, sStoredTo) == nInteger)
    {
        DeleteLocalInt(oTarget, sStoredTo);
    }
}

// Loops all objects of nObjectType, nearest firest, until it finds sTag's.
object SMP_GetNearestObjectByTagToLocation(int nObjectType, string sTag, location lTarget)
{
    int nCnt = 1;
    object oObject = GetNearestObjectToLocation(nObjectType, lTarget, nCnt);
    while(GetIsObjectValid(oObject))
    {
        // Check tag
        if(GetTag(oObject) == sTag)
        {
            return oObject;
        }
        // Next one
        nCnt++;
        oObject = GetNearestObjectToLocation(nObjectType, lTarget, nCnt);
    }
    return OBJECT_INVALID;
}
// SMP_INC_SPELLS. Loops all objects of sTag from oCreator's location
// until it finds the nearest created by oCreator, and which is nearest to
// OBJECT_SELF.
object SMP_GetNearestAOEOfTagToUs(string sTag, object oCreator)
{
    // Area check
    if(GetArea(oCreator) != GetArea(OBJECT_SELF)) return OBJECT_INVALID;

    // Loop the AOE's
    int nCnt = 1;
    object oReturn = OBJECT_INVALID;
    float fLowestdistance = 1000.0;
    object oAOE = GetNearestObjectByTag(sTag, oCreator, nCnt);
    while(GetIsObjectValid(oAOE))
    {
        // Check AOE creator
        if(GetObjectType(oAOE) == OBJECT_TYPE_AREA_OF_EFFECT &&
           GetAreaOfEffectCreator(oAOE) == oCreator)
        {
            // Check distance
            if(GetDistanceBetween(oAOE, OBJECT_SELF) <= fLowestdistance)
            {
                oReturn = oAOE;
            }
        }
        // Next one
        nCnt++;
        oAOE = GetNearestObjectByTag(sTag, oCreator, nCnt);
    }
    return oReturn;
}

// SMP_INC_SPELLS. Returns the base armor type as a number, of oItem
// -1 if invalid, or not armor, or just plain not found.
// 0 to 8 as the value of AC got from the armor - 0 for none, 8 for Full plate.
int SMP_GetArmorType(object oItem)
{
    // Make sure the item is valid and is an armor.
    if (!GetIsObjectValid(oItem))
        return -1;
    if (GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
        return -1;

    // Get the identified flag for safe keeping.
    int bIdentified = GetIdentified(oItem);
    SetIdentified(oItem,FALSE);

    int nType = -1;
    switch (GetGoldPieceValue(oItem))
    {
        case    1: nType = 0; break; // None
        case    5: nType = 1; break; // Padded
        case   10: nType = 2; break; // Leather
        case   15: nType = 3; break; // Studded Leather / Hide
        case  100: nType = 4; break; // Chain Shirt / Scale Mail
        case  150: nType = 5; break; // Chainmail / Breastplate
        case  200: nType = 6; break; // Splint Mail / Banded Mail
        case  600: nType = 7; break; // Half-Plate
        case 1500: nType = 8; break; // Full Plate
    }
    // Restore the identified flag, and return armor type.
    SetIdentified(oItem,bIdentified);
    return nType;
}

// SMP_INC_SPELLS. Returns TRUE if oItem is a metal-based weapon.
// * FALSE if invalid, or not a weapon, or just plain not found.
int SMP_GetIsMetalWeapon(object oItem)
{
    // Make sure the item is valid
    if(!GetIsObjectValid(oItem)) return FALSE;

    // Check the item type of oItem.
    switch(GetBaseItemType(oItem))
    {
        // List all, but uncomment non-metal, or mainly non-metal ones.
        case BASE_ITEM_BASTARDSWORD:
        case BASE_ITEM_BATTLEAXE:
        //case BASE_ITEM_CLUB:
        case BASE_ITEM_DAGGER:
        //case BASE_ITEM_DART:
        case BASE_ITEM_DIREMACE:
        case BASE_ITEM_DOUBLEAXE:
        case BASE_ITEM_DWARVENWARAXE:
        case BASE_ITEM_GREATAXE:
        case BASE_ITEM_GREATSWORD:
        case BASE_ITEM_HALBERD:
        case BASE_ITEM_HANDAXE:
        //case BASE_ITEM_HEAVYCROSSBOW:
        case BASE_ITEM_HEAVYFLAIL:
        case BASE_ITEM_KAMA:
        case BASE_ITEM_KATANA:
        case BASE_ITEM_KUKRI:
        //case BASE_ITEM_LIGHTCROSSBOW:
        case BASE_ITEM_LIGHTFLAIL:
        case BASE_ITEM_LIGHTHAMMER:
        case BASE_ITEM_LIGHTMACE:
        //case BASE_ITEM_LONGBOW:
        case BASE_ITEM_LONGSWORD:
        case BASE_ITEM_MAGICSTAFF:
        case BASE_ITEM_MORNINGSTAR:
        //case BASE_ITEM_QUARTERSTAFF:
        case BASE_ITEM_RAPIER:
        case BASE_ITEM_SCIMITAR:
        case BASE_ITEM_SCYTHE:
        //case BASE_ITEM_SHORTBOW:
        //case BASE_ITEM_SHORTSPEAR:
        case BASE_ITEM_SHORTSWORD:
        //case BASE_ITEM_SHURIKEN:
        case BASE_ITEM_SICKLE:
        //case BASE_ITEM_SLING:
        case BASE_ITEM_TWOBLADEDSWORD:
        case BASE_ITEM_WARHAMMER:
        //case BASE_ITEM_WHIP:
        {
            return TRUE;
        }
        break;
    }
    return FALSE;
}
// SMP_INC_SPELLS. Returns TRUE if oItem is a metal-based armor.
// * FALSE if invalid, or not armor, or just plain not found.
int SMP_GetIsMetalArmor(object oItem)
{
    // Make sure the item is valid
    if(!GetIsObjectValid(oItem)) return FALSE;

    // Check the item type of oItem.
    if(GetBaseItemType(oItem) == BASE_ITEM_ARMOR)
    {
        // 4 is chain, anything bigger is of course more.
        if(SMP_GetArmorType(oItem) >= 4)
        {
            return TRUE;
        }
    }
    return FALSE;
}

// Returns TRUE if oObject is a creature, and is made of metal
int SMP_GetIsFerrous(object oObject)
{
    // Make sure the object is valid
    if(!GetIsObjectValid(oObject)) return FALSE;
    // Make sure it is a creature
    if(GetObjectType(oObject) != OBJECT_TYPE_CREATURE) return FALSE;

    // Check appearance
    switch(GetAppearanceType(oObject))
    {
        // Metal creatures (some golems mainly)
        case APPEARANCE_TYPE_BAT_HORROR:
        case APPEARANCE_TYPE_GOLEM_IRON:
        case APPEARANCE_TYPE_MINOGON:
        case APPEARANCE_TYPE_HELMED_HORROR:
        {
            return TRUE;
        }
    }
    // Not metal
    return FALSE;
}

// SMP_INC_SPELLS. Returns TRUE if oItem is any shield.
// 0 if invalid, or not a shield, or just plain not found.
int SMP_GetIsShield(object oItem)
{
    int bReturn = FALSE;
    switch(GetBaseItemType(oItem))
    {
        case BASE_ITEM_LARGESHIELD:
        case BASE_ITEM_SMALLSHIELD:
        case BASE_ITEM_TOWERSHIELD:
        {
            bReturn = TRUE;
        }
        break;
    }
    return bReturn;
}

// SPELL HOOK FOR ALL PLAYER SPELLS
// Returns TRUE if they can cast the spell, FALSE means they cannot.
// * nSpellID - The spell ID of the spell.
//              If it is the default, SPELL_INVALID, it will use GetSpellId();
int SMP_SpellHookCheck()
{
    // Debug
    SMP_Debug("hook Check fired, object self: " + GetName(OBJECT_SELF));

    // Execute the spell hook file directly on the caster
    ExecuteScript("smp_spellhook", OBJECT_SELF);

    // Get return value
    int bReturn = GetLocalInt(OBJECT_SELF, "SMP_SPELLHOOK_RETURN");

    // Debug
    SMP_Debug("HOOK RESULT 2: " + IntToString(bReturn));

    return bReturn;
}

// This is used for the spell "Explosive Runes".
// - When reading a scroll or book (And there is a new "Read" 'spell' too),
//   the runes will trigger and explode for 6d6 damage and some blast damage.
// Returns TRUE if they explode!
int SMP_ExplosiveRunes()
{
    // Get item
    object oItem = GetSpellCastItem();
    int nType = GetBaseItemType(oItem);

    // Check if valid, and if a book or a scroll
    if(GetIsObjectValid(oItem))
    {
        if(nType == BASE_ITEM_BLANK_SCROLL ||
           nType == BASE_ITEM_ENCHANTED_SCROLL ||
           nType == BASE_ITEM_SPELLSCROLL ||   // Invalid but hey, who cares?
           nType == BASE_ITEM_BOOK)
        {
            // Check for explosive runes integer
            if(GetLocalInt(oItem, SMP_EXPLOSIVE_RUNES_SET))
            {
                // Use the function
                SMP_ExplosiveRunesExplode(oItem);

                // Explosive runes! ouch!
                return TRUE;
            }
        }
    }
    return FALSE;
}


// This does the explosion effects for oItem, if they had explosive runes fire this.
// It will also destroy the item, oItem, if it was not plot.
void SMP_ExplosiveRunesExplode(object oItem)
{
    // Get caster and DC
    object oCaster = GetLocalObject(oItem, SMP_EXPLOSIVE_RUNES_OBJECT);
    int nSpellSaveDC = GetLocalInt(oItem, SMP_EXPLOSIVE_RUNES_DC);

    // Declare effects
    effect eVis = EffectVisualEffect(VFX_IMP_MAGBLUE);
    int nDam;
    float fDelay;

    // We do damage to all those in the AOE. The caster gets no save.
    // 10 feet range. Location: Caster
    location lTarget = GetLocation(OBJECT_SELF);
    object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_10, lTarget, TRUE);
    while(GetIsObjectValid(oTarget))
    {
        // No check of reaction type. PvP doesn't apply as it
        // could be read in a no PvP area.
        // Signal spell cast at
        SignalEvent(oTarget, EventSpellCastAt(oCaster, SMP_SPELL_EXPLOSIVE_RUNES));

        // Get delay
        fDelay = GetDistanceToObject(oTarget)/20;

        // Check spell resistance
        if(!SMP_SpellResistanceCheck(oCaster, oTarget, fDelay))
        {
            // Roll damage
            nDam = d6(6);

            // Reflex Saving throw for half damage
            if(oTarget != OBJECT_SELF)
            {
                nDam = SMP_GetAdjustedDamage(SAVING_THROW_REFLEX, nDam, oTarget, nSpellSaveDC, SAVING_THROW_TYPE_SPELL, oCaster, fDelay);
            }
            // Apply damage and visual
            if(nDam > 0)
            {
                // Do force magical damage
                DelayCommand(fDelay, SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam));
            }
        }
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_FEET_10, lTarget, TRUE);
    }
    // Note we also destroy the object it was written on, unless
    // it is plot, because it also takes damage!
    if(!GetPlotFlag(oItem))
    {
        DestroyObject(oItem);
    }
}

// Checks if oTarget was summoned via. a spell.
int SMP_GetIsSummonedCreature(object oTarget)
{
    // Check associate type
    if(GetAssociateType(oTarget) == ASSOCIATE_TYPE_SUMMONED)
    {
        return TRUE;
    }
    // Master assoicated one - a henchman. No henchman check though.
    if(GetLocalInt(oTarget, "SMP_SUMMON_SPELL") > 0)
    {
        return TRUE;
    }
    // Not a summon
    return FALSE;
}

// Moves back oTarget from oCaster, fDistance.
// Antilife shell ETC uses this.
void SMP_PerformMoveBack(object oCaster, object oTarget, float fDistance, int bOriginalCommandable)
{
    // Get new location, fDistance, behind them.
    location lMoveTo = SMP_GetLocationBehind(oCaster, oTarget, fDistance);

    // Move the target back to that point
    SetCommandable(TRUE, oTarget);
    // Assign commands
    AssignCommand(oTarget, JumpToLocation(lMoveTo));
    // Set to original commandability.
    SetCommandable(bOriginalCommandable);
}

// SMP_INC_SPELLS. Destroys oObject utterly.
// - Turns off Plot Flag, Cursed Flag and Stolen flag.
// - Then uses a standard DestroyObject() command.
void SMP_CompletelyDestroyObject(object oObject)
{
    // Turn off all the flags.
    SetItemCursedFlag(oObject, FALSE);
    SetPlotFlag(oObject, FALSE);
    SetItemCursedFlag(oObject, FALSE);

    // Destroy it
    DestroyObject(oObject);
}

// SMP_INC_SPELLS.
// Depending on if oTarget is a PC or an NPC, it will "Disintegrate them as the spell"
// and should create some dust where the items will go.
// * PC's are just damaged normally.
// * Cirtain placables are damaged past thier plot status.
// * Cirtain spells on oTarget are destroyed/removed
// * Executes "SMP_AIL_Disinteg" for NPC's.
void SMP_DisintegrateDamage(object oTarget, effect eVis, int nDam)
{
    // Object type
    if(GetObjectType(oTarget) == OBJECT_TYPE_CREATURE)
    {
        // Remove any Interposing Hands
        // * Note: All of the *Hand* spells can do this, so we remove all
        //   Attack Penalties (which is what interposing hand applies).
        SMP_RemoveInterposingHands(oTarget);

        // If we do not remove any spheres, we will be OK
        if(!SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_RESILIENT_SPHERE, oTarget) &&
           !SMP_RemoveSpellEffectsFromTarget(SMP_SPELL_TELEKINETIC_SPHERE, oTarget))
        {
            // PC version - just damage
            if(GetIsPC(oTarget))
            {
                // Apply damage
                SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam);
            }
            else
            {
                // NPC version

                // Get HP
                int nHP = GetCurrentHitPoints(oTarget);

                // - Will it kill them?
                int bPreviousLootable = GetLootable(oTarget);
                if(GetLootable(oTarget) && nDam >= nHP)
                {
                    // Turn off lootable
                    SetLootable(oTarget, FALSE);
                }
                // Apply damage and VFX
                SMP_ApplyDamageVFXToObject(oTarget, eVis, nDam);
                // If an NPC, and dead now, we fire the script.
                if(nDam >= nHP)
                {
                    ExecuteScript("SMP_AIL_DISINTEG", oTarget);
                }
                else
                {
                    // Else, re-do the lootable flag from before
                    // * EG: Shield other worked, for instance
                    SetLootable(oTarget, bPreviousLootable);
                }
            }
        }
    }
    else
    {
        // Cirtain placables are damaged.
    }
}

// SMP_INC_SPELLS. Returns the bonus to Charisma, Wisdom or Intelligence.
// * Uses GetLastSpellCastClass()
// * Will return Charisma as default.
// * Only can be used in impact scripts
// Will be used in some spells which require the "Bonus to spells" bonus.
int SMP_GetAppropriateAbilityBonus()
{
    int nClass = GetLastSpellCastClass();

    switch(nClass)
    {
        case CLASS_TYPE_BARD:
        case CLASS_TYPE_SORCERER:
        case CLASS_TYPE_INVALID:
        {
            // Return Charisma bonus
            return GetAbilityModifier(ABILITY_CHARISMA);
        }
        break;
        case CLASS_TYPE_WIZARD:
        {
            // Return Intelligence bonus
            return GetAbilityModifier(ABILITY_INTELLIGENCE);
        }
        break;
        case CLASS_TYPE_CLERIC:
        case CLASS_TYPE_PALADIN:
        case CLASS_TYPE_RANGER:
        {
            // Return Wisdom bonus
            return GetAbilityModifier(ABILITY_WISDOM);
        }
        break;
    }
    // Return default of Charisma
    return GetAbilityModifier(ABILITY_CHARISMA);
}

// SMP_INC_SPELLS. This performs a grapple check against nAC.
// To use it for "opposed" checks, mearly put the amount the oTarget got into
// nAC, such as Black Tentacles.
// Check is made as an attack roll at:
// *  Base attack bonus + Strength modifier + special size modifier
// Note:
// Special Size Modifier: The special size modifier for a grapple check is as
// follows: Colossal +16, Gargantuan +12, Huge +8, Large +4, Medium +0,
// Small –4, Tiny –8, Diminutive –12, Fine –16. Use this number in place of the
// normal size modifier you use when making an attack roll.
// * Use SMP_GrappleSizeBonus() to get a creatures nSizeMod.
// * Relays to oTarget and oSource (if any) the result of the check.
int SMP_GrappleCheck(object oTarget, int nBAB, int nStrMod, int nSizeMod, int nAC, object oSource = OBJECT_SELF)
{
    // Get the source's roll.
    int nBase = nBAB + nStrMod + nSizeMod;
    int nRoll = d20();

    // Result:
    int bResult;

    // Start relay string
    string sRelay = "Grapple check against " + GetName(oTarget) + ". Roll: " + IntToString(nRoll) + " + " + IntToString(nBase) + " VS " + IntToString(nAC) + ": ";

    // Check the result
    if(nBase + nRoll >= nAC)
    {
        // Sucess!
        bResult = TRUE;

        // We relay sucess
        sRelay += "Grapple Sucessful.";
    }
    else
    {
        // Failure!
        bResult = FALSE;


        // We relay failure
        sRelay += "Grapple Failed.";
    }
    // Send messages
    if(GetIsObjectValid(oSource))
    {
        SendMessageToPC(oSource, sRelay);
    }
    if(oSource != oTarget)
    {
        SendMessageToPC(oTarget, sRelay);
    }
    return bResult;
}

// Special Size Modifier: The special size modifier for a grapple check is as
// follows: Colossal +16, Gargantuan +12, Huge +8, Large +4, Medium +0,
// Small –4, Tiny –8, Diminutive –12, Fine –16.
int SMP_GrappleSizeBonus(object oCreature)
{
    // Default to 0
    if(GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return FALSE;

    // Check creature size
    switch(GetCreatureSize(oCreature))
    {
        // Modifiers are 4 differences each stage away from "Normal" medium size
        case CREATURE_SIZE_HUGE: return 8; break;
        case CREATURE_SIZE_LARGE: return 4; break;
        case CREATURE_SIZE_MEDIUM: return 0; break;
        case CREATURE_SIZE_SMALL: return -4; break;
        case CREATURE_SIZE_TINY: return -8; break;
    }
    // Default to 0
    return FALSE;
}

// SMP_INC_SPELLS. This will roll an attack roll, using nBAB, nStrMod, nExtra
// against nAC, that is, oTarget's AC (or should be). Relays the results
// as if it was a proper attack.
// NOTE: Returns FALSE on a miss, but else returns the total attack roll of all 3 things
// plus the d20.
int SMP_AttackCheck(object oTarget, int nBAB, int nStrMod, int nExtra, int nAC, object oSource = OBJECT_SELF)
{
    // Get the source's roll.
    int nBase = nBAB + nStrMod + nExtra;
    int nRoll = d20();

    // Result:
    int bResult;

    // Start relay string
    string sRelay = "Attack roll against " + GetName(oTarget) + ". Roll: " + IntToString(nRoll) + " + " + IntToString(nBase) + " VS " + IntToString(nAC) + ": ";

    // Check the result
    if(nBase + nRoll >= nAC)
    {
        // Sucess!
        // * Return the total attack roll (for disipline checks etc)
        bResult = nBase + nRoll;

        // We relay sucess
        sRelay += "Attack Hit.";
    }
    else
    {
        // Failure!
        bResult = FALSE;

        // We relay failure
        sRelay += "Attack Missed.";
    }
    // Send messages
    if(GetIsObjectValid(oSource))
    {
        SendMessageToPC(oSource, sRelay);
    }
    if(oSource != oTarget)
    {
        SendMessageToPC(oTarget, sRelay);
    }
    return bResult;
}

// Use AssignCommand() to do this on another person, it will set cutscene mode
// for a few seconds (if not already in a cutscene) and move them to lTarget's
// location, then remove the cutscene mode. It will mean no effects are removed
// and it always is sucessful.
// * lTarget is where to move to
// * nGoVis/nAppearVis, if not VFX_NONE, will be applied at the target location
//   and the person moving location as appropriate.
void SMP_ForceMovementToLocation(location lTarget, int nGoVis = VFX_NONE, int nAppearVis  = VFX_NONE)
{
    // Special start; we set cutscene mode. Use OBJECT_SELF as the person
    object oSelf = OBJECT_SELF;

    // Will not move them if they are already plot somehow.
    // * catches exsisting cutscenes
    if(GetPlotFlag(oSelf)) return;

    // Clear all actions
    ClearAllActions();

    // Set it ON
    SetCutsceneMode(oSelf, TRUE);

    // Apply visuals
    if(nGoVis != VFX_NONE)
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nGoVis), GetLocation(oSelf));
    }
    if(nAppearVis != VFX_NONE)
    {
        ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(nAppearVis), lTarget);
    }

    // Move them
    int bResetFalse = FALSE;
    if(!GetCommandable(oSelf))
    {
        // Needs to be set commandable
        SetCommandable(TRUE, oSelf);
        bResetFalse = TRUE;
    }
    JumpToLocation(lTarget);
    // Set the cutscene mode OFF as an action
    ActionDoCommand(SetCutsceneMode(oSelf, FALSE));

    // Reset the state of commandable if need be.
    if(bResetFalse == FALSE)
    {
        // Reset commandable state.
        SetCommandable(FALSE, oSelf);
    }
}

// Roughly gets the weight of oCreature, in tenths of pounds.
// * Based on creature size.
// * Use with GetWeight(oCreature) to get what they are carrying plus the creature weight
int SMP_GetCreatureWeight(object oCreature)
{
    // Default to 0
    if(GetObjectType(oCreature) != OBJECT_TYPE_CREATURE) return FALSE;

    // Check creature size
    switch(GetCreatureSize(oCreature))
    {
        // All * 10, so in tenths of pounds
        case CREATURE_SIZE_HUGE: return 10000; break;
        case CREATURE_SIZE_LARGE: return 3500; break;
        case CREATURE_SIZE_MEDIUM: return 2000; break;
        case CREATURE_SIZE_SMALL: return 600; break;
        case CREATURE_SIZE_TINY: return 150; break;
    }
    // Default to 0
    return FALSE;
}

// SMP_INC_SPELLS. This will check if lTarget and lSource are on the same plane
// of exsistance.
// * Used to stop escape from Maze, Prismatic's Plane, Imprisonment.
int SMP_CheckIfSamePlane(location lSource, location lTarget)
{
    // Check if lSource is a "non material plane"
    object oSourceArea = GetAreaFromLocation(lSource);
    object oTargetArea = GetAreaFromLocation(lTarget);

    // Check if both valid first
    if(!GetIsObjectValid(oSourceArea) || !GetIsObjectValid(oTargetArea)) return FALSE;

    // Check the source area?
    string sTag = GetTag(oSourceArea);
    if(sTag == "SMP_MAZE" || sTag == "SMP_IMPRISONMENT" || sTag == "SMP_PRISPLANE")
    {
        // Cannot work.
        return FALSE;
    }
    // Check target area
    sTag = GetTag(oTargetArea);
    if(sTag == "SMP_MAZE" || sTag == "SMP_IMPRISONMENT" || sTag == "SMP_PRISPLANE")
    {
        // Cannot work.
        return FALSE;
    }
    // TRUE, they ARE on the same plane
    // * Default return value
    return TRUE;
}
// SMP_INC_SPELLS. SMP_GetHitDiceByXP
// HitDice is determined by player's xp, not by whether or not they have leveled
// * Solve for hd from xp = hd * (hd - 1) * 500
//   hd = 1/50 * (sqrt(5) * sqrt(xp + 125) + 25)
int SMP_GetHitDiceByXP(object oCreature)
{
   float fXP = IntToFloat(GetXP(oCreature));
   int nHD = FloatToInt(0.02f * (sqrt(5.0f) * sqrt(fXP + 125.0f) + 25.0f));
   // Limit it to 40 levels (they can go well over level 40 with masses of XP, but
   // it cannot add anything to total HD)
   if (GetIsPC(oCreature) && nHD > 40)
      nHD = 40;
   return nHD;
}
// SMP_INC_SPELLS. This will get the targets character level, not hit dice,
// and so will be used in death stuff to calculate thier actual character level.
// * Can be used on NPC's, and will use GetHitDice(oTarget);
// * THanks to th1ef, who did the "GetHitDiceByXP" function used in this
int SMP_GetCharacterLevel(object oTarget)
{
    // If NPC (or DM, gah!) we return the HD of the target
    if(!GetIsPC(oTarget) || GetIsDM(oTarget))
    {
        return GetHitDice(oTarget);
    }
    // Else, must be a PC
    return SMP_GetHitDiceByXP(oTarget);
}
// SMP_INC_SPELLS. This will get the correct amount of experience to set a person
// to for there to be a level loss of 1, so they have the exact amount needed
// for the previous level.
// * Will return 1 if at level 1.
int SMP_GetLevelLossXP(int nHD)
{
    // Take 1 HD off nHD to get the next level down.
    nHD--;

    // we calculate, based on the new nHD value, the XP needed for that level.
    int nReturn = ((nHD * (nHD - 1)) / 2) * 1000;

    // Cannot be 0. Can be 1.
    if(nReturn < 1) nReturn = 1;

    // Return it
    return nReturn;
}

// SMP_INC_SPELLs. Removes all avalible castings of nSpell on oCreature
// - oCreature: creature to modify
// - nSpell: constant SPELL_*
void SMP_DecrementAllRemainingSpellUses(object oCreature, int nSpell)
{
    int i, nUses = GetHasSpell(nSpell, oCreature);
    if(nUses > 0)
    {
        for(i = 1; i <= nUses; i++)
        {
            DecrementRemainingSpellUses(oCreature, nSpell);
        }
    }
}

// End of file Debug lines. Uncomment below "/*" with "//" and compile.
/*
void main()
{
    return;
}
//*/
