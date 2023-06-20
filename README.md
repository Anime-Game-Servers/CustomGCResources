# CustomAnimeGameResources (WIP)

This repo will contain community written scripts, resources and patches to make more PS features usable


Usage
=====

## How to use it with GC
Copy all folders into the resources directory used for GC, then run the AnimeGameResourcePatcher to apply the patches and generate the output in Resources/Generated

Project structure
=====

## Overview
Scripts: Community written Lua scripts. These are used by different systems of the Server

Server: Custom excel files, that are not part of the client, but are requried for server operation.

Patches: Patches applying missing or custom data to resource files.

ScriptSceneData: Currently used by ps for rewind purposes, will be replaced/removed in the future.

## Scripts
Common: Scripts that can be included by other lua code, that contain shared code

Gadget: Scripts that contain custom controllers used for some gadget logic on the server

Scene:  Scripts used for general overworld logic, like spawning maps and puzzles

Quest/Share: These are used to define important points and general data used by the client and server

## Patches
Quest: Patches in the Binout format, applied to quest defintions
Activity: Patches for activityExcelFiles

Licensing
=====

This software library is licensed und the terms of the MIT license, with the exemptions noted below.

You can find a copy of the license in the [LICENSE file](LICENSE).

Exemptions:
* miHoYo and its subsidiaries are exempt from the MIT licensing and may instead license any source code authored for the AnimeGameServer projects under the Zero-Clause BSD license.
