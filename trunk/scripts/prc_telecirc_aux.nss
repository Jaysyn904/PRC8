//:://////////////////////////////////////////////
//:: Teleportation Circle Auxiliary
//:: prc_telecirc_aux
//:://////////////////////////////////////////////
/** @file
    Teleportation Circle auxiliary script, run on
    the area of effect object created by the
    spell / power or on the PC when they make
    their selection about the target of the circle.

    Creates the trapped trigger and, if this
    is supposed to be a visible circle, starts
    VFX heartbeat.
    Also, starts monitor heartbeats on itself
    and the trigger.

    @author Ornedan
    @date   Created  - 2005.10.25
    @date   Modified - 2006.06.04
 */
//:://////////////////////////////////////////////
//:://////////////////////////////////////////////

#include "spinc_telecircle"

void TrapMonitorHB(object oAoE)
{
    if(DEBUG) DoDebug("prc_telecirc_aux: Running TrapMonitorHB on " + GetTag(OBJECT_SELF));
    if(!GetIsObjectValid(oAoE))
    {
        if(DEBUG) DoDebug("prc_telecirc_aux: AoE no longer exists");
        DestroyObject(OBJECT_SELF);
    }
    else
        DelayCommand(6.0f, TrapMonitorHB(oAoE));
}

void AoEMonitorHB()
{
    if(DEBUG) DoDebug("prc_telecirc_aux: Running AoEMonitorHB on " + GetTag(OBJECT_SELF));
    // Loop over all traps and see if they still exist
    int i;
    for(i = 0; i < TC_NUM_TRAPS; i++)
    {
        if(!GetIsObjectValid(GetLocalObject(OBJECT_SELF, "Trap_" + IntToString(i))))
        {
            if(DEBUG) DoDebug("prc_telecirc_aux: Trap " + IntToString(i) + " no longer exists");
            DestroyObject(OBJECT_SELF);
            return;
        }
    }

    // Got this far, all traps are OK
    DelayCommand(6.0f, AoEMonitorHB());
}

void VFXHB(location lCenter)
{
    // Do a smoke puff pentagram. Cliche - but meh :P
    DrawPentacle(DURATION_TYPE_INSTANT, VFX_FNF_SMOKE_PUFF, lCenter,
                 FeetToMeters(5.0f), // Radius
                 0.0f, // VFX Duration
                 40,   // # of nodes - orig 50
                 2.0f, // Number of revolutions
                 6.0f, // Time for drawing
                 0.0f, "z" // Angle offset and axis
                 );
    DrawCircle(DURATION_TYPE_INSTANT, VFX_FNF_SMOKE_PUFF, lCenter, FeetToMeters(5.0f),
               0.0f, 24 /*36*/, 1.0f, 6.0f, 0.0f, "z"
               );

    DelayCommand(6.0f, VFXHB(lCenter));
}

void main()
{
    // Check whether we are running for the PC who selected the location the circle points at or for the area of effect object
    if(GetTag(OBJECT_SELF) != Get2DACache("vfx_persistent", "LABEL", AOE_PER_TELEPORTATIONCIRCLE))
    {
        object oPC = OBJECT_SELF;
        // Finish the casting
        TeleportationCircleAux(oPC);
    }
    // Or for the circle AoE to initialise it
    else
    {
        object oAoE       = OBJECT_SELF;
        object oArea      = GetArea(oAoE);
        object oTrap;
        int bVisible      = GetLocalInt(oAoE, "IsVisible");
        int i;
        vector vPosition  = GetPosition(oAoE);
        float fSideLength = FeetToMeters(2.5f) * sqrt(2.0f);

        // Spawn a series of traps at lTarget, rotated by a certain offset relative to each other
        for(i = 0; i < TC_NUM_TRAPS; i++)
        {
            oTrap = CreateTrapAtLocation(TRAP_BASE_TYPE_TELECIRCLE,
                                         Location(oArea, vPosition, (90.0f / TC_NUM_TRAPS) * i),
                                         fSideLength,                             // Length of the square's sides
                                         "PRC_TELECIRCLE_TRAP_" + IntToString(i), // Tag of the trap
                                         STANDARD_FACTION_HOSTILE,                // Faction of the trap - this may or may not cause problems
                                         "prc_telecirc_dis",                      // OnDisarm script
                                         ""                                       // OnTrigger script - nothing
                                         );
            if(!GetIsObjectValid(oTrap))
            {
                string sErr = "prc_telecirc_aux: ERROR: Failed to create trap " + IntToString(i) + "!";
                if(DEBUG)             DoDebug(sErr);
                else WriteTimestampedLogEntry(sErr);

                // Abort the the circle creation
                DestroyObject(oAoE);
                return;
            }

            // Set the trap to reset itself after being triggered
            SetTrapOneShot(oTrap, FALSE);

            // Set the trap to not be recoverable
            SetTrapRecoverable(oTrap, FALSE);

            // Set the detection DC - 0 if visible, 34 if hidden
            SetTrapDetectDC(oTrap, bVisible ? 0 : 34);

            // Store references to each other
            SetLocalObject(oAoE, "Trap_" + IntToString(i), oTrap);
            SetLocalObject(oTrap, "AreaOfEffectObject", oAoE);

            // Start the trap's monitor HB
            AssignCommand(oTrap, TrapMonitorHB(oAoE));
        }

        // Start the AoE's monitor HB
        AssignCommand(oAoE, AoEMonitorHB());

        // Do VFX
        if(bVisible)
            AssignCommand(oAoE, VFXHB(GetLocation(oAoE)));

        // Mark the initalisation being done
        SetLocalInt(oAoE, "PRC_TeleCircle_AoE_Inited", TRUE);
    }
}