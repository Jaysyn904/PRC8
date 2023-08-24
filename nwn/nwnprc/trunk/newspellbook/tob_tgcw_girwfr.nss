//////////////////////////////////////////////////
// Girallon Windmill Flesh Rip
// tob_tgcw_girwfr.nss
// Tenjac 10/10/07
//////////////////////////////////////////////////
/** @file Girallon Windmill Flesh Rip
Tiger Claw (Boost)
Level: Swordsage 8, warblade 8
Prerequisite: Three Tiger Claw maneuvers
Inititation Action: 1 swift action
Range: Melee attack
Target: One or more creatures
Duration: 1 round

Windmilling your arms in a furious blur, you strike your perplexed enemy from two
directions at once, rending his flesh with each strike.

Each of your attacks is precisely timed to maximize the carnage it inflicts. You must be wielding
two or more weapons to initiate this maneuver. As you hack into your opponent, you use your weapons
together to murderous effect. With a cruel twist of your blade, you widen the wounds you cause with
each successive strike.

You must initiate this maneuver before making any attacks in the current round. If you strike an
opponent multiple times during your turn, you also deal rend damage. This damage is based on the
number of times you strike your opponent during your turn (see the table below). Determine the 
rend damage dealt immediately after you make your last attack for your turn.

If you attack multiple opponents during your turn, you gain this extra damage against each of them.
A creature takes rend damage based on the number of attakcs that hit it, not the number of successful
attacks you make. For example, if you hit a fire giant three times and an evil cleric twice during
your turn, the fire giant takes rend damage for three attacks and the cleric takes rend damage for
two attacks.

Successful Attacks          Rend Damage

2                            8d6
3                           10d6 
4                           12d6
5                           14d6
6                           16d6
7                           18d6
8+                          20d6 
*/

void RendDamage(object oInitiator, int nDamType);

#include "tob_inc_move"
#include "tob_movehook"
//#include "prc_alterations"

void main()
{
        if (!PreManeuverCastCode())
        {
                // If code within the PreManeuverCastCode (i.e. UMD) reports FALSE, do not run this spell
                return;                                
        }        
        // End of Spell Cast Hook
        
        object oInitiator    = OBJECT_SELF;
        object oTarget       = PRCGetSpellTargetObject();
        struct maneuver move = EvaluateManeuver(oInitiator, oTarget);
        
        
        if(move.bCanManeuver)
        {
                object oWeap1 = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND, oInitiator);
                object oWeap2 = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oInitiator);
                
                //If using 2 weapons
                if(IPGetIsMeleeWeapon(oWeap1) && IPGetIsMeleeWeapon(oWeap2))
                {
                        //Add spellhook
                        itemproperty ipHook = ItemPropertyOnHitCastSpell(IP_CONST_ONHIT_CASTSPELL_ONHIT_UNIQUEPOWER, 1);
                        
                        IPSafeAddItemProperty(oWeap1, ipHook, RoundsToSeconds(1));
                        IPSafeAddItemProperty(oWeap2, ipHook, RoundsToSeconds(1));
                        
                        AddEventScript(oWeap1, EVENT_ITEM_ONHIT, "tob_event_girwfr", TRUE, FALSE);
                        AddEventScript(oWeap2, EVENT_ITEM_ONHIT, "tob_event_girwfr", TRUE, FALSE);
                                                                       
                        DelayCommand(RoundsToSeconds(1), RendDamage(oInitiator, GetWeaponDamageType(oWeap1)));
                        
                        DelayCommand(RoundsToSeconds(1), RemoveEventScript(oWeap1, EVENT_ITEM_ONHIT, "tob_event_girwfr", TRUE, TRUE));
                        DelayCommand(RoundsToSeconds(1), RemoveEventScript(oWeap2, EVENT_ITEM_ONHIT, "tob_event_girwfr", TRUE, TRUE));
                }
        }
}

void RendDamage(object oInitiator, int nDamType)
{
        location lLoc = GetLocation(oInitiator);
        object oTarget = MyFirstObjectInShape(SHAPE_SPHERE, FeetToMeters(100.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
        
        while(GetIsObjectValid(oTarget))
        {
               int nHits = GetLocalInt(oTarget, "TOB_GIR_WINDMILL_FR");
                       
               if(nHits > 1)
               {
                       int nDam;
                       
                       if(nHits == 2)      nDam = d6(8);
                       else if(nHits == 3) nDam = d6(10);
                       else if(nHits == 4) nDam = d6(12);
                       else if(nHits == 5) nDam = d6(14);
                       else if(nHits == 6) nDam = d6(16);
                       else if(nHits == 7) nDam = d6(18);
                       else nDam = d6(20);                      
                       
                       SPApplyEffectToObject(DURATION_TYPE_INSTANT, EffectDamage(nDam, nDamType), oTarget);                                      
               }
               
               DeleteLocalInt(oTarget, "TOB_GIR_WINDMILL_FR");
               oTarget = MyNextObjectInShape(SHAPE_SPHERE, FeetToMeters(100.0), lLoc, FALSE, OBJECT_TYPE_CREATURE);
       }
}               