// Works on Homecoming version 27.7.6043.2. Also supports Beta version 27.7.5940 and Cryptic version 27.4.4868, but these are often outdated.
// Poorly cobbled together and maintained by Bloodom on discord, let me know if you have questions, requests for sub-objectives, or tips to improve this!

state("cityofheroes", "Homecoming")
{
    int MissionSelected: 0xBDE5C0; // Navigation Status Window. MissionSelected should be 1068641 on Return to Contact, 16777216 on no mission, and 269502050 when mission is complete but the player is still in the mission (as well as other niche cases).
    int TeamLock: 0xBE0AB2; // Team is locked/unlocked. TeamLock value (4 Byte) should be 2042527 (or higher) when unlocked, 2031616 when TF started, 0 on loadscreen (10911 if team not locked and loading INTO SG base), 2031616 in mission or in base (regardless of TF status). TeamLock value (2 Byte) should be 10911 (or higher) when unlocked, 0 when TF started, 0 on loadscreen (10911 if team not locked and loading INTO SG base), 0 in mission or in base (regardless of TF status). Best bet to find is to set 2 Byte and then keep checking for changed values starting/quitting TFs and check for 0 values, since the 5-digit value changes daily. 
    int Zone: 0x87B684; // Different values depending on the type of instance the player is in. The value is 1 when in an Overworld zone, 5 when in a Supergroup base, and varies when in a mission instance (usually 0 or 4).
    int PopUp: 0x9A0478; // TF/SF/Trial completion pop-up. This address value will be 0 upon loading into a zone with no pop-up, < 400 when a mission pop-up, teleport prompt, hide prompt, or TT prompt appears, and > 400 on TF/SF/Trial complete pop-up. If re-finding this address, the value is often 316 on quit prompt.
}

state("cityofheroes", "Beta") 
{
    int MissionSelected: 0xBD6590;
    int TeamLock: 0xBD8A76;
    int Zone: 0x872684;
    int PopUp: 0x9982F8;
}

state("cityofheroes", "Cryptic")
{
    int MissionSelected: 0xBD1820; 
    int TeamLock: 0xBD3CEE; 
    int Zone: 0x86D3F4;
    int PopUp: 0x992DB8; 
}

startup
{
    // Commonly used static values.
    vars.MissionComplete = 269502050;
    vars.ReturnToContact = 1068641;
    vars.NoMission = 16777216;
    vars.Locked = 2030000;
    vars.Unlocked = 2040000;
    vars.CompletePopUp = 320;
    vars.Loadscreen = 0;
    vars.SGBase = 5;
    vars.Overworld = 1;

    // Adds the option to disable sub-objective splits and pause the timer during loadscreens.
    settings.Add("subobjective_splits", true, "Sub-objective Splits");
    settings.SetToolTip("subobjective_splits", "Adds split triggers on specific sub-objectives, in accordance with the Speedrun.com splits.");
    settings.Add("gametime", false, "Ensure Layout is set to Game Time or the setting below won't work.");
    settings.SetToolTip("gametime", "This can be done through: Edit Layout > Timer > Timing Method > Game Time");
    settings.Add("loadscreen", false, "Pause on Loadscreen", "gametime");
    settings.SetToolTip("loadscreen", "Will have no bearing on the time submitted to Speedrun.com, and only provides insight on Solo runs.");

    // List of integers associated with the MissionSelected value of a location on the overworld map's name in the navigation status.
    vars.maplocation = new List<int> 
    {
        /* General */ 2114843905, 336447467,
        /* The Chantry */ 1242344912, -1810884738, 1645105185, 302946588, -569460932, -1089517987, -502286754, 1141865036, -1844622067, 756014409, 1527724109, -1559290020,
        /* Cascade Archipelago */ -1962077182, -871354484, 1007585824, -552667836, 1477371944, 2064676732, 1578003233,
        /* Firebase Zulu */ -1928346032, 1997536852, -485609678, -2129837309, 17742610, 1275983616, -267401633, -1811087100, 302927123, 1393457184, -1794250493, -1861349085, 437070325,
        /* The Storm Palace */ -569475014, -66219493, 1510880042, 1729015338, -1257417970, -1559193475, -334675950
    };

    // List of integers associated with the MissionSelected value of a out-of-mission navigation status, following a mission where the team leader is likely to call in the mission before the player can load into the overworld zone.
    vars.aftercalled = new List<int>
    {
        /* Positron pt. 1 */
        /* Positron pt. 2 */
        /* Virgil Tarikoss */
        /* Synapse */
        /* Silver Mantis */
        /* Penelope Yin */
        /* Moonfire */
        /* SF Op. Renault */ 
        /* Citadel */
        /* Ernesto Hess */
        /* Katie Hannon */
        /* Manticore */
        /* Ice Mistral */
        /* Numina */
        /* Mortimer Kal */
        /* Admiral Sutter */
        /* Dr. Aeon */ 1042828100, /* Mission 2 to 3 */ 1479035226, /* Mission 3 to 4/5 */ 858712818, /* Mission 5 to 6 */
        /* Dr. Quaterfield */
        /* Sara Moore */
        /* Justin Augustine */
        /* Faathim the Kind */
        /* Imperious */
        /* Lord Recluse */ -903477954, 1948758664, /* Mission 2 to 3/4 */
        /* Ms. Liberty */ -853041477, /* Mission 2 to 3 */
        /* Lady Grey */
        /* Barracuda */ -719063020, -1205383759, /* Mission 2 to 3/4 */ -433583027, /* Ensures no split upon leaving mission 4 */
        /* Dr. Kahn */ -1775820126, -13952855, /* Mission 3 to 4/5 */
        /* Tin Mage Mk. II */ -1792523463, /* Mission 1 to 2 */
        /* Apex */ -1389951275, /* Mission 1 to 2 */
        /* Cavern of Transcendence */
        /* Tree of Thorns (1) */
        /* Terror Volta (1) */
        /* Tree of Thorns (2) */
        /* Terror Volta (2) */
        /* Descent to the Hydra */
        /* Prisoners of Eden */
        /* Market Crash */ -1356282845 /* Mission 2 to 3 */
        /* Tree of Thorns (3) */
        /* Terror Volta (3) */
    };

    // List of integers associated with the MissionSelected value of a contact's name in the navigation status.
    vars.tfcontact = new List<int>
    {
        /* Virgil Tarikoss */ 1309638721, -1037935653,
        /* Synapse */ 1410119889, -1105228143,
        /* Silver Mantis */ 1913530658, -752699972,
        /* Penelope Yin */ -116583149, -1457304575, 
        /* Moonfire */ -1341374498, -266356050,
        /* SF Op. Renault */ -1139509936, 489284439,
        /* Citadel */ 655135439, -836775518,
        /* Ernesto Hess */ 68044307, 1143065900, 
        /* Katie Hannon */ -519208176, -752884832,
        /* Manticore */ 319644651, 1646316983,
        /* Ice Mistral */ 2114819841, -2044676873,
        /* Numina */ -653578556, -2128546842,
        /* Mortimer Kal */ -133323757, 1495436434,
        /* Dr. Aeon */ -133473323, 1813975217,
        /* Dr. Quaterfield */ -351348679, 86181325,
        /* Sara Moore */ 437089780, 1713587695,
        /* Justin Augustine */ -1022373806, 102993354,
        /* Faathim the Kind */ 303006281, 1428306075,
        /* Imperious */ 772631020, -1994412423,
        /* Lord Recluse */ -183669231, 639734283,
        /* Ms. Liberty */ 1510802687, 170088647,
        /* Lady Grey */ -217212390, 623030419,
        /* Barracuda */ -166981654, 656435630, 
        /* Dr. Kahn */ -150248747, -1625288193, 
        /* Tin Mage Mk. II */ -1827746494, -987618336, 
        /* Apex */ -16098901, 824125305, 
        /* Tree of Thorns (1) */ -284330488, -1826399759,
        /* Terror Volta (1) */ 1108227614, -232533475,
        /* Tree of Thorns (2) */ -284312824, -1826382095, 
        /* Terror Volta (2) */ -1223634036, 1596314062,
        /* Descent to the Hydra */ -770705571, -1641882956,
        /* Market Crash */ -1173454803, 941839322,
        /* Tree of Thorns (3) */ -284343032, -1826412303,
        /* Terror Volta (3) */ 1209028219, -1926890802
    };

    // List of integers associated with the MissionSelected value of a auto-assigned mission.
    vars.autoassigned = new List<int>
    {
        /* Positron pt. 1 */ -1557797646,
        /* Positron pt. 2 */ 606728755, -366196208, 1529373685,
        /* Synapse */ -1456986590, -148312007, 1697018688, 1126714614, 875046629, 2032701202,
        /* Penelope Yin */ -500204358,
        /* Moonfire */ -954086547, 690467466, 1864490048,
        /* SF Op. Renault */ -1842745962, -1423628856, -534556122, -1993822432,
        /* Citadel */ -1574452042, 
        /* Ernesto Hess */ -1188651435, -1104796329, 1764164503,
        /* Manticore */ -2044431247, 975869641, 120059257, 1445430688, 1462234495,
        /* Ice Mistral */ 1193636781,
        /* Numina */ 2512922, -1205218862, 1093289739, 942200110, 657004434, 1395255192, 539539747, 1680538149, -1406485416, -399584077, -1993809850, 1059781897, -366381309, 1965964381, 1798223597, -1238707636,
        /* Mortimer Kal */ 1211125201, -64631546, 
        /* Admiral Sutter */ 136712442, -2111601413,
        /* Dr. Aeon */ 1495798634, -1658059990,
        /* Dr. Quaterfield */ -1910099413, 925206178,
        /* Justin Augustine */ -1306076579, -2144879181,
        /* Faathim the Kind */ -1205297607, 1462304526, -601124419, -1070989381, -1741791731, -1725775181, 1780729061, 1613089470, -1021004653, -1037871066, 472354437, -1255833340, -1255833340,
        /* Barracuda */ -1524487784,
        /* Tin Mage Mk. II */ -316347995,
        /* Terror Volta (1) */ 690613405,
        /* Descent to the Hydra */ -1806663539,
        /* Prisoners of Eden */ -48054279, -2075576774,
        /* Terror Volta (3) */ -1054439848, 438748461,
        /* Heather Townshend */ -1708698706
    };

    // List of integers associated with the MissionSelected value of an objective in a mission that was left early, leading to the auto-assigned mission value to reappear.
    vars.leftearly = new List<int>
    {
        /* Positron pt. 1 */
        /* Positron pt. 2 */
        /* Synapse */
        /* Penelope Yin */
        /* Moonfire */
        /* SF Op. Renault */
        /* Citadel */
        /* Ernesto Hess */
        /* Manticore */
        /* Ice Mistral */
        /* Numina */
        /* Mortimer Kal */
        /* Admiral Sutter */
        /* Dr. Aeon */ -1556956150
        /* Dr. Quaterfield */
        /* Justin Augustine */
        /* Faathim the Kind */ 
        /* Barracuda */
        /* Tin Mage Mk. II */
        /* Terror Volta (1) */
        /* Descent to the Hydra */
        /* Prisoners of Eden */
        /* Terror Volta (3) */
        /* Heather Townshend */
    };



    // List of integers associated with the MissionSelected value of a sub-objective during a mission.
    vars.subobjective = new List<int>
    {
        /* Positron pt. 1 */ -517484794, -1842574541,
        /* Positron pt. 2 */
        /* Virgil Tarikoss */
        /* Synapse */ 
        /* Silver Mantis */
        /* Penelope Yin */ -500204358,
        /* Moonfire */ 
        /* SF Op. Renault */
        /* Citadel */ 
        /* Ernesto Hess */
        /* Katie Hannon */
        /* Manticore */
        /* Ice Mistral */
        /* Numina */
        /* Mortimer Kal */ 1681642647,
        /* Admiral Sutter */ 56988065, -1283442977, 2018279193, -952035147,
        /* Dr. Aeon */ 1211306078, 925982979, -1959697871, -1641398002,
        /* Dr. Quaterfield */
        /* Sara Moore */
        /* Justin Augustine */
        /* Faathim the Kind */
        /* Imperious */
        /* Lord Recluse */
        /* Ms. Liberty */
        /* HM Lady Grey */ 373571353, -1170055000,
        /* Lady Grey */
        /* Barracuda */ -1943289237,
        /* Dr. Kahn */
        /* Tin Mage Mk. II */ 1110496666, 1009849786, 1613774055,
        /* Apex */ 1227958122, 137304902, 1865395608,
        /* Cavern of Transcendence */
        /* Tree of Thorns (1) */
        /* Terror Volta (1) */ 
        /* Tree of Thorns (2) */
        /* Terror Volta (2) */
        /* Descent to the Hydra */
        /* Prisoners of Eden */ 
        /* Market Crash */ -1825859210, -835203351,
        /* Tree of Thorns (3) */
        /* Terror Volta (3) */
    };

    // List of integers associated with the MissionSelected value of a TF/SF/Trial's overworld glowies when in the relevant zone.
    vars.clicky = new List<int>
    {
        /* Faathim */ 1579718438, -1138180784, 1512690316, -920107948, 388511491, 86752840,
        /* Justin Augustine */ -752614001, -1742396194, 1344607165, 287718408, -131667870, -1960440777, 958751927, -685423378, -1272623131
    };

    // List of integers associated with the MissionSelected value of a TF/SF/Trial's overworld glowies when not in the relevant zone.
    vars.altclicky = new List<int>
    {
        /* Faathim */ -1574812217, 2329579, -1641820387, 220414702, 1528976808, 1227226302,
        /* Justin Augustine */ -1189073654, 2116146512, 908188722, 539097134, 119728509, -1709074857, 522267182, -1121894306, -1709061034
    };
}

init
{
    // print(modules.First().ModuleMemorySize.ToString());

    // Sets the proper server based on which is open.
    switch (modules.First().ModuleMemorySize)
    {
        case 23289856: version = "Homecoming";
        break;
        case 1: version = "Beta";
        break;
        case 2 : version = "Cryptic";
        break;
        default: version = "Unknown!";
        break;
    }
}

start
{
    // Starts the split once the TF/SF/Trial is started.
    if((old.TeamLock > vars.Unlocked && current.TeamLock < vars.Unlocked && current.TeamLock > vars.Locked) || (current.Zone == vars.SGBase && old.MissionSelected == vars.NoMission && current.MissionSelected != vars.NoMission))
    {
        // print("Run Started");
        return true;
    }
}

split
{
    // Splitter associated with the maplocation list, as well as a general purpose splitter. Splits upon exiting a mission and getting vars.ReturnToContact or vars.NoMission value, while accounting for the situation where those values are replaced by a maplocation value.
    // Merged with splitter associated with aftercalled and tfcontact lists. Accounts for when the leader calls in a mission and the team member using LiveSplit isn't loaded out prior to the next mission being set.
    if(old.MissionSelected != vars.NoMission 
        && old.MissionSelected != vars.ReturnToContact 
        && old.MissionSelected != current.MissionSelected
        && ((!vars.maplocation.Contains(old.MissionSelected) && (vars.maplocation.Contains(current.MissionSelected) || (current.MissionSelected == vars.NoMission && current.Zone != vars.SGBase) || current.MissionSelected == vars.ReturnToContact) && old.MissionSelected != vars.MissionComplete)
        || (vars.aftercalled.Contains(current.MissionSelected) && !vars.aftercalled.Contains(old.MissionSelected) && !vars.tfcontact.Contains(old.MissionSelected))))
    {
        // print("General & Teammate Loading Split");
        return true;
    }

    // Splitter associated with tfcontact list. Accounts for when the leader is calling in a mission they were not inside of when completed and calling the contact (i.e. having the contact name appear in the nav. status) would bypass the general split condition.
    else if(old.MissionSelected == vars.MissionComplete 
        && (vars.tfcontact.Contains(current.MissionSelected) || (current.Zone != vars.SGBase && (current.MissionSelected == vars.NoMission || current.MissionSelected == vars.ReturnToContact))))
    {
        // print("Mission Complete Split");
        return true;
    }

    // A few exceptions that need their own splits.
    else if(old.MissionSelected != current.MissionSelected 
        && (((old.MissionSelected == -1608194966 || old.MissionSelected == -1524487784 || old.MissionSelected == vars.MissionComplete) && current.MissionSelected == -719063020) // Split into final mission of Barracuda, due to the final mission value being a mission with a repeated value and an auto-assigned mission.
        || (!vars.altclicky.Contains(old.MissionSelected) && vars.clicky.Contains(current.MissionSelected) || !vars.clicky.Contains(old.MissionSelected) && vars.altclicky.Contains(current.MissionSelected)))) // Splitter to ensure overworld glowies split properly and don't double split if going between zones.
    {
        // print("Exception Split");
        return true;
    }

    // Splitters associated with the autoassigned list, accounting for all of the auto-assigned mission splits (when a talk mission is followed by an auto-assigned door mission, it is handled as one split for team split consistency, unless it can be safely assumed the entire team will be out of mission prior to the talk mission).
    else if(vars.autoassigned.Contains(current.MissionSelected) 
        && old.MissionSelected != current.MissionSelected
        && current.Zone != vars.SGBase
        && !vars.leftearly.Contains(old.MissionSelected))
    {
        // print("Auto-assigned Split");
        return true;
    }

    // Relating to a fix for when a player zones into an SG base from a completed mission and the next mission does not become active on the navigation status despite having the mission, leading to additional splits.
    else if(current.Zone == vars.SGBase
        && old.MissionSelected == vars.NoMission
        && old.MissionSelected != current.MissionSelected)
    {
        // print("SGBase-fix Split");
        return true;
    }

    // Sub-objective setting and splitter, adds any sub-objectives players want in the splits on a case-by-case basis.
    if(settings["subobjective_splits"])
    {
        if(vars.subobjective.Contains(current.MissionSelected) 
            && old.MissionSelected != current.MissionSelected
            && current.MissionSelected != -2092671484) // Condition for Dr. Aeon Mission 5 ripple split. 
        {
            // print("Sub-objective Split");
            return true;
        }
    }

    // TF/SF/Trial completion pop-up splitter, in order to finish the split while still in mission.
    if(current.PopUp > vars.CompletePopUp && old.PopUp != current.PopUp)
    {
        // print("Complete PopUp Split");
        return true;
    }
}

isLoading
{
    // Setting that causes the timer to pause on loadscreens. 
    if(settings["loadscreen"])
    {
        if(current.TeamLock == vars.Loadscreen)
        {
            // print("Loadscreen Pause");
            return true;
        }

        else
        {
            // print("Loadscreen Unpause");
            return false;
        }
    }
}

reset
{
    // Resets the split upon quitting a TF/SF/Trial. 
    if((current.TeamLock > vars.Unlocked && old.TeamLock != current.TeamLock) || (current.MissionSelected == vars.NoMission && current.Zone != vars.Overworld && current.Zone != vars.SGBase))
    {
        // print("Team Unlocked");
        return true;
    }
}
