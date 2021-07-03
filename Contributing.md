# Contributing

## Requirements

- [SKYUI SDK](https://github.com/schlangster/skyui/wiki)
- [Skyrim Special Edition Creation Kit](https://tesalliance.org/forums/index.php?/tutorials/article/161-skyrim-se-creation-kit-installation-updated-may-2020/)
	- Scripts need to be extracted to compile correctly

## Optional Requirements

- VSCode IDE
	- [Joel Day's Papyrus Extension (joelday.papyrus-lang-vscode)](https://marketplace.visualstudio.com/items?itemName=joelday.papyrus-lang-vscode)
	- Updated version of [pyro](https://github.com/fireundubh/pyro) manually installed into the papyrus extension folder

## Building

- With VSC and Papyrus (Recommended):
	1. Open the folder in vscode.
	2. Change `gamePath` in [launch.json](./.vscode/tasks.json) to your Skyrim SE game directory
	3. Change paths in [hurt.ppj](./hurt.ppj) for Skyrim SE and SKYUI SDK scripts.
	4. Build all papyrus files with vscode's build command. (Ctrl-Shift-B or Tasks: Run Task)
- With the Creation Kit:
	1. Open the CreationKit with `Hurt.esl` selected
	2. Open the script properties on the `hrtQuest` quest.
	3. Edit scripts and save to recompile

## Languages

Languages are stored in [interface/translations](./interface/translations/) and use the [SkyUI Localization format](https://github.com/schlangster/skyui/wiki/MCM-Advanced-Features#Localization)
