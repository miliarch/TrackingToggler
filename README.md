# Tracking Toggler

A World of Warcraft addon that automatically toggles between profession tracking modes to make farming a bit easier.

## Usage

Use the `/track` command to enable or disable automated tracking.

## Behavior

While enabled, either the `Find Minerals` or `Find Herbs` spell will be cast every 5 seconds, depending on which is currently active on the player. Because casting these spells causes the global cooldown to fire, and this would be disruptive to normal gameplay, tracking mode is **not** toggled in the following busy conditions:
* When the player is in combat, unless the player is mounted
* When the player is casting or channeling a spell
* When the player is resting
* When the player has a living target

If the player is detected as busy during a polling interval, a delay will be applied to the next polling timer interval to give the player some buffer space on the tail end of whatever made them busy.

## The Story

I wanted to run the mining and herbalism professions on an alt. I found using a castsequence macro to toggle between tracking modes annoying. I needed a solution that didn't require my constant attention.

I did some research about creating WoW addons. Eventually I came across an unmaintained addon that claimed to do the job named [Tracking Switcher](https://www.curseforge.com/wow/addons/tracking-switcher), authored by [epenance](https://www.curseforge.com/members/epenance/projects). I had decided to create an addon, not find one to use, so I didn't install it. Instead, I studied the code as an example, and continued my research.

Studying the code helped me better understand the lua scripting language (first timer here) and provided some great examples of how to work with data returned by the [WoW addon API](https://wowpedia.fandom.com/wiki/World_of_Warcraft_API). While this project doesn't copy the code [epenance](https://www.curseforge.com/members/epenance/projects) authored, it is modeled after that example, and may not have existed otherwise. I am thankful for the efforts of this author, as I have learned something new. Credit where it is due.

Unlike the addon it is modeled after, Tracking Toggler requires no third-party libraries, and provides no in-game user configuration. It is designed to perform a very specific task out of the box - toggle between profession tracking modes at a frequency and in situations that do not cause the player annoyance.

**If the way this addon behaves causes you annoyance, please open an issue to report it. I might be able to fix it.**
