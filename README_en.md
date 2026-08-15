<!-- markdownlint-disable MD033 MD041 -->

<div align="center">

<img alt="LOGO" src="./img/logo.png" width="256" height="256" />

# DoroHelper

A PC tool for clearing daily tasks. One-click cleaning of multiple daily chores. Supports all clients except the **Chinese Server**.

<p align="center">
  <img alt="AutoHotkeyV2" src="https://img.shields.io/badge/AutoHotkeyV2-white?logo=AutoHotkey&logoColor=black">
  <img alt="platform" src="https://img.shields.io/badge/platform-Windows-blueviolet">
  <img alt="license" src="https://img.shields.io/github/license/1204244136/DoroHelper">
  <br/>
  <img alt="commit" src="https://img.shields.io/github/commit-activity/m/1204244136/DoroHelper">
  <img alt="stars" src="https://img.shields.io/github/stars/1204244136/DoroHelper?style=social">
  <a href="https://mirrorchyan.com/?source=doro-github-release" target="_blank"><img alt="mirrorc" src="https://img.shields.io/badge/Mirror%E9%85%B1-%239af3f6?logo=countingworkspro&logoColor=4f46e5"></a>
</p>

**English Readme | [中文说明](README.md)**

</div>

## DoroHelper Has Been Fully Upgraded to MDA

Thank you all for your continued support and companionship with DoroHelper.

During the ongoing development and maintenance process, the overall architecture of the script has become quite outdated, limiting the efficiency of future feature expansion and long-term maintenance. Therefore, based on the entirely new MaaFramework, the script has been completely rewritten. The new version is named **MDA (Maa Doro Assistant)**. With this mature and powerful community tool, future bug fixes and content updates will be more efficient and stable.

Compared to the old version, the new framework brings a series of significant improvements:

- Brand new UI design with a cleaner and more aesthetically pleasing interface, natively supporting multilingual, and allowing free customization of themes, colors, and backgrounds
- Supports free adjustment of task order and provides richer detailed configuration options
- Supports running the game in the background for a more flexible experience
- Supports all resolutions, no longer limited to specific resolutions
- Supports Linux, macOS, and other operating systems, and is compatible with the aarch64 architecture

### MDA Download Links

|Channel|Link|
|--|--|
|GitHub|[https://github.com/1204244136/MDA/releases/latest](https://github.com/1204244136/MDA/releases/latest)|
|Baidu Netdisk|[https://pan.baidu.com/s/1X4_vJ3ei9fiayRWHpI0f9A?pwd=bed7](https://pan.baidu.com/s/1X4_vJ3ei9fiayRWHpI0f9A?pwd=bed7) (Extraction code: bed7)|
|Quark Netdisk|[https://pan.quark.cn/s/9a30ca1aabe7](https://pan.quark.cn/s/9a30ca1aabe7) (Extraction code: Cprn)|

The old version will no longer be maintained but can still be used normally. If the new version does not suit your usage habits, you are welcome to continue using the old version.

## Project Evolution History

```mermaid
flowchart LR
    %% Style definitions
    classDef route1 fill:#ffe599,stroke:#333,stroke-width:2px;
    classDef route2 fill:#d9d2e9,stroke:#333,stroke-width:2px;
    classDef route2_new fill:#c9daf8,stroke:#333,stroke-width:2px;
    classDef kyoka fill:#f9f,stroke:#333,stroke-width:2px;
    classDef zhiyi fill:#bbf,stroke:#333,stroke-width:2px;
    classDef dead fill:#f4cccc,stroke:#cc0000,stroke-width:1px;
    classDef active fill:#d9ead3,stroke:#274e13,stroke-width:1px;
    classDef track fill:#fafafa,stroke:#999,stroke-width:1px,stroke-dasharray:4,font-weight:bold;

    %% ==================== Track Labels ====================
    TL1[Track 1<br>NIKKE-scripts Route]:::track
    TL2[Track 2<br>NKAS Legacy Line]:::track
    TL3[Track 3<br>DoroHelper / MDA Evolution Line]:::track

    %% ==================== Track 1: NIKKE-scripts Route (Emulator Flow) ====================
    TL1 --> Z1[Project Birth v0.1<br>2023-02-05<br>@Zebartin]:::route1
    Z1 --> Z2(Continuous iteration to v1.2.22<br>2025-06-19):::route1
    Z2 -->|❌ Official crackdown on emulators| Z_End([Project discontinued / End of the line]):::route1
    Z_End --> DeadStatus1([❌ No longer maintained]):::dead

    %% ==================== Track 2: NKAS Legacy Line (Independent Daily & Revival Flow) ====================
    TL2 --> T1[Independent daily script born v0.0.7<br>2023-04-30<br>@takagisanmie]:::route2
    T1 -->|Online update / Non-GitHub main repo| T2(Author ran out of energy<br>Regretfully stopped updating):::route2
    T2 -->|🔥 Ember reignited| M_Active([🟢 NKAS Spiritual Successor<br>megumiss/NIKKEAutoScript<br>Forked by others / Actively maintained to this day]):::route2_new
    T2 --- DeadStatus2([❌ Original author stopped updating]):::dead

    %% ==================== Track 3: DoroHelper / MDA Evolution Line (PC Modernization Flow) ====================
    TL3 --> D1[DoroHelper Born<br>2024-07-16<br>@kyokakawaii]:::kyoka
    D1 --> D2(Doro v0.1.16.1<br>2025-01-16):::kyoka
    D2 -->|Project handover| D3(Doro v0.1.22<br>2025-04-20<br>@Zhiyiyi takes over):::zhiyi
    D3 --> D4[Doro v1.15.8 Final Version<br>2026-05-11]:::zhiyi
    D4 -->|Original version curtain call| D_End([DoroHelper Archived]):::dead
    D4 -->|Complete rewrite| MDA([🟢 MDA Project<br>1204244136/MDA<br>New flagship / Actively maintained]):::zhiyi

    %% Track 3 Classic branch
    D2 -.->|Meets some users' needs| C1(Classic Born<br>Retains old core):::kyoka
    C1 --> C2(Classic v0.1.16.5<br>2025-08-10):::kyoka
    C2 --> C_Active([🟢 DoroHelper_classic<br>Maintained by kyokakawaii to this day]):::kyoka

    %% Active status unified style
    class M_Active,C_Active,MDA active;
```

## Version Notes

The features described below are for the latest version. For corresponding features in older versions, please check the README in the [legacy-v0.1.22](https://github.com/1204244136/DoroHelper/tree/legacy-v0.1.22) branch.
Older versions are no longer maintained!

**⚠️ For everyone's convenience, please do not publicly release modified versions of this software related to the Chinese server. Thank you for your cooperation!**

## Disclaimer

This project is for personal learning and research use only and is strictly prohibited for commercial use. Any content related to this project on websites or social platforms other than Github and the QQ group below **is not published by me**. I am not responsible for any consequences such as copyright infringement or violation of network security regulations.

Using any script program carries the risk of account suspension, please proceed with caution.

There may be instances where operations are incompatible. It is best to supervise the first use. If Doro goes out of control, press the **Ctrl + 1** key combination to terminate the process or **Ctrl + 2** to pause the process.

## Usage

### Run the ahk file from the repository (Recommended)

1. Download the entire project folder locally and unzip it (green "Code" button in the upper right corner - Download ZIP)
1. Download and install [AutoHotkey V2.0](https://www.autohotkey.com/download/ahk-v2.exe) (do not change the default installation path)
1. Run `DoroHelper.ahk` as administrator

### Run the executable file from the release

1. Download the release file on the right
1. Run `DoroHelper.exe` as administrator

## Feature Overview

Doro just wants you to suffer less from the damn loading screens, flashbangs, and repetitive labor. One-click cleaning of multiple daily chores (executed sequentially and all optional), including:

- **Cash Shop**
  - Claim Free Jewels
  - Claim Free Packs

- **Normal Shop**
  - Claim 2 daily free items
  - Purchase Core Dust boxes with Credit Points
  - Purchase Profile Border/Icon Packs

- **Arena Shop**
  - Purchase specified Skill Books
  - Purchase Code Manual Box
  - Purchase Profile Border/Icon Packs
  - Purchase Company Weapon Mold

- **Simulation Room**
  - Normal Simulation Room (requires Quick Sim unlock)
  - Overclock Simulation Room

- **Arena**
  - Claim Arena rewards
  - Rookie Arena
  - Special Arena
  - Champion Arena

- **Infinite Tower**
  - Climb Manufacturer Tower
  - Climb General Tower

- **Interception**
  - Normal Interception
  - Special Interception

- **Regular Reward Claims**
  - Outpost Dispatch
    - Perform Dispatch missions
  - Affinity Consult
    - View Episodes
  - Claim Friendship Points
  - Claim Mail
  - Claim Missions
  - Claim Pass rewards
  - Coordinated Operation
  - Solo Raid Daily

- **Limited-Time Reward Claims**
  - Daily free recruit during events

- **Nifty Tools**
  - Story Mode (Automates viewing the story, automatically selects options)
  - Debug Mode (Directly run a specified function)
  - Instant Burst Mode (Activates Burst instantly, faster than auto, frees up your hands)
  - Campaign Mode (Automatically plays Main Story stages)

## Steps

Open the NIKKE Launcher. Click Start. Wait for the central SHIFT UP logo to appear on the NIKKE main program, then switch out and click the "**DORO!**" button. If you see the mouse start rapidly clicking in the bottom left corner, the launch was successful. Then you can comfortably brew a cup of coffee or scroll through your phone, waiting for Doro to finish the job.

Alternatively, you can switch out and click the "**DORO!**" button while the game is at the Lobby screen (the page with the standing character).

## Feedback and Improvement

Join the [DoroHelper Feedback QQ Group](https://qm.qq.com/q/f0Q1yr7vzi)

Join the [Discord](https://discord.gg/f4rAWJVNJj)

## Support and Encouragement

Zhuyi Yiyi: After the former author [Lao H](https://github.com/kyokakawaii) stopped updating, I have been doing the majority of the maintenance and new feature additions for DoroHelper. This has cost me a significant amount of time and energy, and I hope those who are able can offer some support.

### Domestic (China)

<table>
  <tr>
<img alt="Alipay QR Code" src="./img/alipay.png" width="200" height="200" />
<img alt="WeChat Pay QR Code" src="./img/weixin.png" width="200" height="200" />
  </tr>
</table>

### Global

<table>
  <tr>
<img alt="Global QR Code" src="./img/global.png" width="200" height="200" />
  </tr>
</table>

Currently available platforms：

Hanpass|PandaRemit|WireBarley|GmoneyTrans|Debunk|PayForex|koala transfer|Sendly|GME

## Star History

[![Star History Chart](https://star-history.dera.page/svg?repos=1204244136/DoroHelper&type=Timeline)](https://star-history.dera.page/#1204244136/DoroHelper&Timeline)

## Credits

[Github.ahk-API-for-AHKv2](https://github.com/samfisherirl/Github.ahk-API-for-AHKv2)

[FindText-for-AHKv2](https://www.autohotkey.com/boards/viewtopic.php?f=83&t=116471)

## Acknowledgements

Code reference:

[M9A](https://github.com/MAA1999/M9A)
