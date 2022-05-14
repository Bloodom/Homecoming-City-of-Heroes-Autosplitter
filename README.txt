Autosplitter confirmed working on Homecoming: version 27.3.4798, Beta version 27.3.4709, Cryptic version 27.4.4834 (check HC Speedrunning discord for current status of autosplitter)
Cobbled together and maintained by Bloodom#8540 on discord, let me know if you have questions, requests for sub-objectives, or tips to improve this!

**Note that you can edit the split names and layout, but changing the amount of splits in a particular run will interfere with the autosplitter.**

INSTRUCTIONS FOR AUTOSPLITTER

Getting Started:

1. Install LiveSplit: https://livesplit.org/downloads/
2. Download the "City of Heroes - Livesplit" .zip (from https://www.speedrun.com/city_of_heroes/resources or HC Speedrunning discord) and extract into your desired location.
3. Open any split file in the "Splits and Layout" folder (any LSS file in the "Solo," "Duo," or "Any%" folders), followed by opening the LSL file titled "City of Heroes Layout" in the main "Splits and Layout" folder.
4. Right click on the split and press "Save Layout."

Activating the Autosplitter:

5. Right click on the split and press "Edit Splits," ensure that the setting under "Attempts" states "Deactivate;" if not, click "Activate."
6. Right click on the split and press "Save Splits."
7. Open your "Solo," "Duo," or "Any%" split file of choice and enjoy!

Additional Settings can be found through Edit Splits > Settings (next to Activate/Deactivate):

1. Sub-Objectives Splits - Uncheck this box if you'd rather have only mission splits and no mid-mission objective-based splits (note you will need to modify your splits to reflect this change). Additionally, consider unchecking this settings if you plan to not be inside of certain missions during sub-objectives for a 	specific run.
2. Pause on Loadscreen - If you'd like the timer to pause on loadscreens, check both relevant boxes after confirming your layout is set to Game Time (if using the Layout from the .zip, this will already be true). This setting will display the split times normally, but the final time will not include loadscreen time; this is purely for your own curiosity since runs submitted to speedrun.com require the actual in-game time. 

Known Issues: 

1. Missions can fail to split if waypointing to somewhere on the overworld map at the time of mission call-in, since a majority of splits are triggered by the navigation status becoming Return to Contact or blank (waypoints have priority over anything that isn't an active mission in the Navigation Status window); a workaround has been implemented for doing this in the Shadow Shard——but other zones may need to be looked at if its a common issue. 
2. If you aren't the leader, the autosplitter can fail to split if the leader assigns a mission before you fully load out of a mission (effectively making the mission into an auto-assigned mission from your perspective); many of the common places this occurs have been accounted for, but many still exist. 
3. Missions that involve clicking an object in an overworld zone have separate MissionSelected values for when you're in that zone and not (this can lead to double splitting); this has been accounted for in Faathim and Justin Augustine, but there may be more instances I haven't thought of.
4. If you play with a UI Scale higher than 147%, final splits will not trigger (assuming Window Scale of 100%, lower is fine but higher is more likely to cause issues). The final split time can be added after the run in Edit Splits if changing this setting is non-negotiable.
5. Exiting an autoassigned mission before its completed may cause a double split to occur.
