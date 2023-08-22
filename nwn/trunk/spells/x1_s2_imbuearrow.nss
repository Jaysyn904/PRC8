////////////////////////////////////////////////////////////////////////////////
//                                IMBUE ARROW                                 //
////////////////////////////////////////////////////////////////////////////////
//                                                                            //
//  Script run when the Imbue Arrow feat is used.                             //
//                                                                            //
////////////////////////////////////////////////////////////////////////////////
//Edited By   : Nailog                                                        //
//Last Edited : 7-26-2004                                                     //
////////////////////////////////////////////////////////////////////////////////

#include "prc_inc_sp_tch"
#include "prc_add_spell_dc"

//*GZ: 2003-07-23. honor critical and weapon spec
// Updated: 02/14/2008 CraigW - Added support for Epic Weapon Specialization.
// nCrit -

int PRCArcaneArcherDamageDoneByBow(int bCrit = FALSE, object oUser = OBJECT_SELF)
{
    object oItem = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND);
    int nDamage;
    int bSpec = FALSE;
    int bEpicSpecialization = FALSE;

    if (GetIsObjectValid(oItem) == TRUE)
    {
        if (GetBaseItemType(oItem) == BASE_ITEM_LONGBOW )
        {
            nDamage = d8();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_LONGBOW,oUser))
            {
              bEpicSpecialization = TRUE;
            }
        }
        else
        if (GetBaseItemType(oItem) == BASE_ITEM_SHORTBOW)
        {
            nDamage = d6();
            if (GetHasFeat(FEAT_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bSpec = TRUE;
            }
            if (GetHasFeat(FEAT_EPIC_WEAPON_SPECIALIZATION_SHORTBOW,oUser))
            {
              bEpicSpecialization = TRUE;
            }
        }
        else
            return 0;
    }
    else
    {
            return 0;
    }

    // add strength bonus
    int nStrength = GetAbilityModifier(ABILITY_STRENGTH,oUser);
    nDamage += nStrength;

    if (bSpec == TRUE)
    {
        nDamage +=2;
    }
    if ( bEpicSpecialization == TRUE )
    {
        nDamage +=4;
    }
    if (bCrit == TRUE)
    {
         nDamage *=3;
    }

    return nDamage;
}

//*GZ: 2003-07-23. Properly calculated enhancement bonus
int PRCArcaneArcherCalculateBonus()
{
    int nLevel = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER, OBJECT_SELF);

    if (nLevel == 0) //not an arcane archer?
    {
        return 0;
    }
    int nBonus = ((nLevel+1)/2); // every odd level after 1 get +1
    return nBonus;
}

void main()
{
    //modified by primogenitor
    //removed conversation etc, now in main spellhook instead
    //this feat will be applied as a bonus feat on the hide
    //when the switch PRC_USE_NEW_IMBUE_ARROW is off
    /*//Reroute feat to conversation, only for PCs.
    if (GetIsPC(OBJECT_SELF))
    {

        string sScript =  PRCGetUserSpecificSpellScript();
        if (sScript != "aa_spellhook")
        {
            SetLocalString(OBJECT_SELF,"temp_spell_at_inst",sScript);
            PRCSetUserSpecificSpellScript("aa_spellhook");
        }
        //If in combat, can't converse.
        if (GetIsInCombat())
        {
            FloatingTextStringOnCreature("* cast spell on arrow to Imbue *", OBJECT_SELF);
        }
        else
        {
            ActionStartConversation(OBJECT_SELF, "aa_imbuearrow", TRUE, FALSE);
        }
    }
    else
    {*/

    ////////////////////////////////////////////////////////////////////////////
    // DEFAULT IMBUE ARROW SCRIPT                                             //
    ////////////////////////////////////////////////////////////////////////////
    //                                                                        //
    //   Allow NPCs to continue using old imbue arrow, since writing AI to    //
    // handle new imbue would be a large task.                                //
    //                                                                        //
    ////////////////////////////////////////////////////////////////////////////

    //Declare major variables
    object oCaster = OBJECT_SELF;
    int nCasterLvl = GetLevelByClass(CLASS_TYPE_ARCANE_ARCHER,oCaster); // * get a bonus of +10 to make this useful for arcane archer
    int nDamage;
    float fDelay;
    effect eExplode = EffectVisualEffect(VFX_FNF_FIREBALL);
    effect eVis = EffectVisualEffect(VFX_IMP_FLAME_M);
    effect eDam;
    //Get the spell target location as opposed to the spell target.
    location lTarget = PRCGetSpellTargetLocation();
    //Limit Caster level for the purposes of damage
    if (nCasterLvl > 10)
    {
        nCasterLvl = 10 + ((nCasterLvl-10)/2);      // add some epic progression of 1d6 per 2 levels after 10
    }
    else // * preserve minimum damage of 10d6
    {
         nCasterLvl = 10;
    }
    object oTarget = PRCGetSpellTargetObject();
    // * GZ: Add arrow damage if targeted on creature...
    if (GetIsObjectValid(oTarget ))
    {
        if (spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF))
        {
          int nTouch = PRCDoRangedTouchAttack(oTarget);;
          if (nTouch > 0)
          {

            nDamage = PRCArcaneArcherDamageDoneByBow(nTouch ==2);

            int  nBonus = PRCArcaneArcherCalculateBonus() ;
            effect ePhysical = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_PIERCING,IPGetDamagePowerConstantFromNumber(nBonus));
            effect eMagic = PRCEffectDamage(oTarget, nBonus, DAMAGE_TYPE_MAGICAL);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, ePhysical, oTarget);
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eMagic, oTarget);
          }
        }
    }

    //Apply the fireball explosion at the location captured above.
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eExplode, lTarget);
    //Declare the spell shape, size and the location.  Capture the first target object in the shape.
    oTarget = MyFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    //Cycle through the targets within the spell shape until an invalid object is captured.
    while (GetIsObjectValid(oTarget))
    {
        if(spellsIsTarget(oTarget, SPELL_TARGET_SELECTIVEHOSTILE, OBJECT_SELF) == TRUE)
        {

            //Fire cast spell at event for the specified target
            SignalEvent(oTarget, EventSpellCastAt(OBJECT_SELF, PRCGetSpellId(), TRUE));
            //Get the distance between the explosion and the target to calculate delay
            fDelay = GetDistanceBetweenLocations(lTarget, GetLocation(oTarget))/20;
            if (!PRCDoResistSpell(OBJECT_SELF, oTarget, nCasterLvl + SPGetPenetr(), fDelay))
            {
                //Roll damage for each target
                nDamage = d6(nCasterLvl);
                //Resolve metamagic
                //Adjust the damage based on the Reflex Save, Evasion and Improved Evasion.
                nDamage = GetReflexAdjustedDamage(nDamage, oTarget, PRCGetSaveDC(oTarget, OBJECT_SELF), SAVING_THROW_TYPE_FIRE);
                //Set the damage effect
                eDam = PRCEffectDamage(oTarget, nDamage, DAMAGE_TYPE_FIRE);
                if(nDamage > 0)
                {
                    // Apply effects to the currently selected target.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eDam, oTarget));
                    //This visual effect is applied to the target object not the location as above.  This visual effect
                    //represents the flame that erupts on the target not on the ground.
                    DelayCommand(fDelay, ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oTarget));
                }
             }
        }
       //Select the next target within the spell shape.
       oTarget = MyNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_HUGE, lTarget, TRUE, OBJECT_TYPE_CREATURE | OBJECT_TYPE_DOOR | OBJECT_TYPE_PLACEABLE);
    }

    ////////////////////////////////////////////////////////////////////////////
    // END DEFAULT                                                            //
    ////////////////////////////////////////////////////////////////////////////

    //}
}



