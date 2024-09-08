﻿#Requires AutoHotkey >=v2.0

#Include %A_ScriptDir%\lib\github.ahk


CoordMode "Pixel", "Client"
CoordMode "Mouse", "Client"


;操作间隔（单位：毫秒）
sleepTime := 1500
scrRatio := 1.0


;consts
stdScreenW := 3840
stdScreenH := 2160
waitTolerance := 50
colorTolerance := 15

currentVersion := "v0.1.7"
usr := "kyokakawaii"
repo := "DoroHelper"


;utilities
IsSimilarColor(targetColor, color) 
{
    tr := Format("{:d}", "0x" . substr(targetColor, 3, 2))
    tg := Format("{:d}", "0x" . substr(targetColor, 5, 2))
    tb := Format("{:d}", "0x" . substr(targetColor, 7, 2))

    pr := Format("{:d}", "0x" . substr(color, 3, 2))
    pg := Format("{:d}", "0x" . substr(color, 5, 2))
    pb := Format("{:d}", "0x" . substr(color, 7, 2))

    ;MsgBox tr tg tb pr pg pb

    distance := sqrt((tr - pr) ** 2 + (tg - pg) ** 2 + (tb - pb) ** 2)

    if (distance < colorTolerance)
        return true

    return false
}


ClickOnCheckForUpdate(*)
{
    latestObj := Github.latest(usr, repo)
    if currentVersion != latestObj.version
    {
        userResponse := MsgBox(
            "DoroHelper存在更新版本:`n"
            "`nVersion: " latestObj.version
            "`nNotes:`n" 
            . latestObj.change_notes  
            "`n`n是否下载?",, '36')

        if (userResponse = "Yes") {
            try {
                Github.Download(latestObj.downloadURLs[1], A_ScriptDir "\DoroDownload")
            }
            catch as err {
                MsgBox "下载失败，请检查网络。"
            } 
            else {
                FileMove "DoroDownload.exe", "DoroHelper-" latestObj.version ".exe"
                MsgBox "已下载至当前目录。"
                ExitApp
            }
        }
    } 
    else {
        MsgBox "当前Doro已是最新版本。"
    }
}


;functions
UserClick(sX, sY, k)
{
    uX := Integer(sX * k)
    uY := Integer(sY * k)
    Send "{Click " uX " " uY "}"
}


UserCheckColor(sX, sY, sC, k) {
    loop sX.Length {
        uX := Integer(sX[A_Index] * k)
        uY := Integer(sY[A_Index] * k)
        uC := PixelGetColor(uX, uY)
        if (!IsSimilarColor(uC, sC[A_Index]))
            return 0
    }
    return 1
}


Login()
{
    stdTargetX := 333
    stdTargetY := 2041
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        if UserCheckColor([1973, 1969], [1368, 1432], ["0x00ADFB", "0x00ADFB"], scrRatio) {
            UserClick(2127, 1400, scrRatio)
            Sleep sleepTime
        }

        if A_Index > waitTolerance * 20 {
            MsgBox "登录失败！"
            ExitApp
        }
    }
}


BackToHall()
{
    stdTargetX := 333
    stdTargetY := 2041
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退回大厅失败！"
            ExitApp
        }
    }
}


;=============================================================
;1: 防御前哨基地奖励
OutpostDefence()
{
    Start:
    stdTargetX := 1092
    stdTargetY := 1795
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime


    ;standard checkpoint
    stdCkptX := [1500, 1847]
    stdCkptY := [1816, 1858]
    desiredColor := ["0xF8FCFD", "0xF7FCFD"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入防御前哨失败！"
            ExitApp
        }

        if A_Index > 10 {
            BackToHall()
            goto Start
        }
    }

    ;一举歼灭
    stdTargetX := 1686
    stdTargetY := 1846
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1500, 1847]
    stdCkptY := [1816, 1858]
    desiredColor := ["0xF8FCFD", "0xF7FCFD"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入一举歼灭失败！"
            ExitApp
        }

        if A_Index > 10 {
            BackToHall()
            goto Start
        }
    }

    ;如有免费次数则扫荡，否则跳过
    stdCkptX := [1933]
    stdCkptY := [1648]
    desiredColor := ["0xE9ECF0"]

    if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        stdTargetX := 2093
        stdTargetY := 1651
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        ;UserClick(stdTargetX, stdTargetY, scrRatio)
        ;Sleep sleepTime

        stdCkptX := [1933]
        stdCkptY := [1648]
        desiredColor := ["0x11ADF5"]

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            
            if UserCheckColor([2088], [1327], ["0x00A0EB"], scrRatio) {
                UserClick(2202, 1342, scrRatio)
            }

            if A_Index > 10 {
                BackToHall()
                goto Start
            }
        }

        ;如果升级，把框点掉
        stdCkptX := [2356]
        stdCkptY := [1870]
        desiredColor := ["0x0EAFF4"]
        stdTargetX := 2156
        stdTargetY := 1846

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            
            if UserCheckColor([2088], [1327], ["0x00A0EB"], scrRatio) {
                UserClick(2202, 1342, scrRatio)
            }

            if A_Index > 10 {
                BackToHall()
                goto Start
            }
        }
    }
    else {
        stdCkptX := [2356]
        stdCkptY := [1870]
        desiredColor := ["0x0EAFF4"]
        stdTargetX := 2156
        stdTargetY := 1846

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            
            if UserCheckColor([2088], [1327], ["0x00A0EB"], scrRatio) {
                UserClick(2202, 1342, scrRatio)
            }

            if A_Index > 10 {
                BackToHall()
                goto Start
            }
        }
    }


    ;获得奖励
    stdTargetX := 2156
    stdTargetY := 1846
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime
    ;UserClick(stdTargetX, stdTargetY, scrRatio)
    ;Sleep sleepTime // 2
    ;多点一下，以防升级
    ;UserClick(stdTargetX, stdTargetY, scrRatio)
    ;Sleep sleepTime // 2

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if UserCheckColor([2088], [1327], ["0x00A0EB"], scrRatio) {
            UserClick(2202, 1342, scrRatio)
        }
        if A_Index > waitTolerance {
            MsgBox "前哨基地防御异常！"
            ExitApp
        }
    }
}


;=============================================================
;2: 付费商店每日每周免费钻
CashShop()
{
    ;进入商店
    stdTargetX := 1163
    stdTargetY := 1354
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [158, 199]
    stdCkptY := [525, 439]
    desiredColor := ["0x0DC2F4", "0x3B3E41"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        if UserCheckColor([2047], [1677], ["0x00A0EB"], scrRatio) {
            UserClick(1789, 1387, scrRatio)
            Sleep sleepTime
            UserClick(1789, 1387, scrRatio)
            Sleep sleepTime
            UserClick(2144, 1656, scrRatio)
            Sleep sleepTime
            while UserCheckColor([2047], [1677], ["0x00A0EB"], scrRatio) {
                UserClick(2144, 1656, scrRatio)
                Sleep sleepTime
            }
            break
        }

        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if UserCheckColor([2088], [1327], ["0x00A0EB"], scrRatio) {
            UserClick(2202, 1342, scrRatio)
        }
        if A_Index > waitTolerance {
            MsgBox "进入付费商店失败！"
            ExitApp
        }
    }

    Sleep sleepTime
    if UserCheckColor([2047], [1677], ["0x00A0EB"], scrRatio) {
        UserClick(1789, 1387, scrRatio)
        Sleep sleepTime
        UserClick(1789, 1387, scrRatio)
        Sleep sleepTime
        UserClick(2144, 1656, scrRatio)
        Sleep sleepTime
        while UserCheckColor([2047], [1677], ["0x00A0EB"], scrRatio) {
            UserClick(2144, 1656, scrRatio)
            Sleep sleepTime
        }
    }

    delta := false

    stdCkptX := [1093]
    stdCkptY := [480]
    desiredColor := ["0xD8D9DA"]

    if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio)
        delta := true
    

    stdTargetX := 256
    if delta
        stdTargetX := 432
    stdTargetY := 486
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [194]
    if delta
        stdCkptX := [373]
    stdCkptY := [436]
    desiredColor := ["0x0FC7F5"]
    if delta
        desiredColor := ["0x0BC7F4"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入礼包页面失败！"
            ExitApp
        }
    }

    ;每日
    stdTargetX := 545
    stdTargetY := 610
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [431]
    stdCkptY := [594]
    desiredColor := ["0x0EC7F5"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入每日礼包页面失败！"
            ExitApp
        }
    }

    stdTargetX := 212
    stdTargetY := 1095
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2

    ;每周
    stdTargetX := 878
    stdTargetY := 612
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [769]
    stdCkptY := [600]
    desiredColor := ["0x0CC8F4"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入每周礼包页面失败！"
            ExitApp
        }
    }

    stdTargetX := 212
    stdTargetY := 1095
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2

    ;每月
    stdTargetX := 1211
    stdTargetY := 612
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1114]
    stdCkptY := [600]
    desiredColor := ["0x0CC8F4"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入每月礼包页面失败！"
            ExitApp
        }
    }

    stdTargetX := 212
    stdTargetY := 1095
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2

    ;回到大厅
    stdTargetX := 333
    stdTargetY := 2041
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "退出付费商店失败！"
            ExitApp
        }
    }
}


;=============================================================
;3: 免费商店
FreeShop(numOfBook)
{
    ;进入商店
    stdTargetX := 1193
    stdTargetY := 1487
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [118]
    stdCkptY := [908]
    desiredColor := ["0xF99217"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入普通商店失败！"
            ExitApp
        }
    }

    ;如果今天没白嫖过
    stdCkptX := [349]
    stdCkptY := [1305]
    desiredColor := ["0x127CD7"]

    if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        ;白嫖第一次
        stdTargetX := 383
        stdTargetY := 1480
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [2063]
        stdCkptY := [1821]
        desiredColor := ["0x079FE4"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime // 2
            if A_Index > waitTolerance {
                MsgBox "普通商店白嫖异常！"
                ExitApp
            }
        }

        stdTargetX := 2100
        stdTargetY := 1821
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [118]
        stdCkptY := [908]
        desiredColor := ["0xF99217"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime // 2
            if A_Index > waitTolerance {
                MsgBox "普通商店白嫖异常！"
                ExitApp
            }
        }

        ;如果还有免费次数，则白嫖第二次
        stdCkptX := [697]
        stdCkptY := [949]
        desiredColor := ["0xFB5C24"]

        if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            ;刷新
            stdTargetX := 476
            stdTargetY := 981
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [2133]
            stdCkptY := [1345]
            desiredColor := ["0x00A0EB"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index > waitTolerance {
                    MsgBox "普通商店刷新异常！"
                    ExitApp
                }
            }

            stdTargetX := 2221
            stdTargetY := 1351
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [118]
            stdCkptY := [908]
            desiredColor := ["0xF99217"]
            stdTargetX := 588
            stdTargetY := 1803

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index > waitTolerance {
                    MsgBox "普通商店刷新异常！"
                    ExitApp
                }
            }

            ;第二次白嫖
            stdTargetX := 383
            stdTargetY := 1480
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [2063]
            stdCkptY := [1821]
            desiredColor := ["0x079FE4"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index > waitTolerance {
                    MsgBox "普通商店白嫖异常！"
                    ExitApp
                }
            }

            stdTargetX := 2100
            stdTargetY := 1821
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [118]
            stdCkptY := [908]
            desiredColor := ["0xF99217"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index > waitTolerance {
                    MsgBox "普通商店白嫖异常！"
                    ExitApp
                }
            }
        }

    }


    ;废铁商店检查是否已经购买
    stdTargetX := 137
    stdTargetY := 1737
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [137]
    stdCkptY := [1650]
    desiredColor := ["0xFB931A"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "废铁商店进入异常！"
            ExitApp
        }
    }

    if sleepTime < 1500
        Sleep 500

    global isBoughtTrash

    stdCkptX := [349]
    stdCkptY := [1305]
    desiredColor := ["0x137CD5"]

    if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        isBoughtTrash := 0
    }
    else {
        isBoughtTrash := 1
    }


    ;如果需要，则购买竞技场商店前三本书
    if numOfBook >= 1 or isCheckedCompanyWeapon {
        stdTargetX := 134
        stdTargetY := 1403
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [134]
        stdCkptY := [1316]
        desiredColor := ["0xFA9318"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime // 2
            if A_Index > waitTolerance {
                MsgBox "竞技场商店进入异常！"
                ExitApp
            }
        }

        if sleepTime < 1500
            Sleep 500
    }

    if numOfBook >= 1 {
        ;购买第一本书
        ;如果今天没买过
        stdCkptX := [349]
        stdCkptY := [1305]
        desiredColor := ["0x127CD7"]

        ;如果今天没买过
        if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            stdTargetX := 384
            stdTargetY := 1486
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [2067]
            stdCkptY := [1770]
            desiredColor := ["0x07A0E4"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index > waitTolerance {
                    MsgBox "第一本书购买异常！"
                    ExitApp
                }
            }

            stdTargetX := 2067
            stdTargetY := 1770
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [134]
            stdCkptY := [1316]
            desiredColor := ["0xFA9318"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index >= 2 {
                    stdTargetX := 2067
                    stdTargetY := 1970
                }
                if A_Index > waitTolerance {
                    MsgBox "第一本书购买异常！"
                    ExitApp
                }
            }
        }
    }

    if numOfBook >= 2 {
        ;购买第二本书
        ;如果今天没买过
        stdCkptX := [673]
        stdCkptY := [1305]
        desiredColor := ["0x137CD5"]

        if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            stdTargetX := 702
            stdTargetY := 1484
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [2067]
            stdCkptY := [1770]
            desiredColor := ["0x07A0E4"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index > waitTolerance {
                    MsgBox "第二本书购买异常！"
                    ExitApp
                }
            }

            stdTargetX := 2067
            stdTargetY := 1770
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [134]
            stdCkptY := [1316]
            desiredColor := ["0xFA9318"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index >= 2 {
                    stdTargetX := 2067
                    stdTargetY := 1970
                }
                if A_Index > waitTolerance {
                    MsgBox "第二本书购买异常！"
                    ExitApp
                }
            }
        }
    }

    if numOfBook >= 3 {
        ;购买第三本书
        ;如果今天没买过
        stdCkptX := [997]
        stdCkptY := [1304]
        desiredColor := ["0x147BD4"]

        if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            stdTargetX := 1030
            stdTargetY := 1485
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [2067]
            stdCkptY := [1770]
            desiredColor := ["0x07A0E4"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index > waitTolerance {
                    MsgBox "第三本书购买异常！"
                    ExitApp
                }
            }

            stdTargetX := 2067
            stdTargetY := 1770
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [134]
            stdCkptY := [1316]
            desiredColor := ["0xFA9318"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index >= 2 {
                    stdTargetX := 2067
                    stdTargetY := 1970
                }
                if A_Index > waitTolerance {
                    MsgBox "第三本书购买异常！"
                    ExitApp
                }
            }
        }
    }

    if isCheckedCompanyWeapon {
        stdCkptX := [2011]
        stdCkptY := [1213]
        desiredColor := ["0xD65E46"]
        
        if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            stdTargetX := 2017
            stdTargetY := 1485
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [2067]
            stdCkptY := [1770]
            desiredColor := ["0x07A0E4"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index > waitTolerance {
                    MsgBox "公司武器熔炉购买异常！"
                    ExitApp
                }
            }

            stdTargetX := 2067
            stdTargetY := 1770
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [134]
            stdCkptY := [1316]
            desiredColor := ["0xFA9318"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                if A_Index >= 2 {
                    stdTargetX := 2067
                    stdTargetY := 1970
                }
                if A_Index > waitTolerance {
                    MsgBox "公司武器熔炉购买异常！"
                    ExitApp
                }
            }
        }
    }

    stdTargetX := 333
    stdTargetY := 2041
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "退出免费商店失败！"
            ExitApp
        }
    }
}


;=============================================================
;4: 派遣
Expedition()
{
    ;进入前哨基地
    stdTargetX := 1169
    stdTargetY := 1663
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入前哨基地失败！"
            ExitApp
        }
    }

    stdCkptX := [1907, 1963, 1838, 2034]
    stdCkptY := [1817, 1852, 1763, 1877]
    desiredColor := ["0xFFFFFF", "0xFFFFFF", "0x0B1219", "0x0B1219"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入前哨基地失败！"
            ExitApp
        }
    }

    ;派遣公告栏
    ;收菜
    stdTargetX := 2002
    stdTargetY := 2046
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [2113, 2119, 2387]
    stdCkptY := [372, 399, 384]
    desiredColor := ["0x404240", "0x404240", "0x404240"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入派遣失败！"
            ExitApp
        }
    }

    stdTargetX := 2268
    stdTargetY := 1814
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    Sleep 3000

    ;全部派遣
    stdCkptX := [1869, 1977]
    stdCkptY := [1777, 1847]
    desiredColor := ["0xCFCFCF", "0xCFCFCF"]

    ;如果今天没派遣过
    if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        stdTargetX := 1930
        stdTargetY := 1813
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [2199, 2055]
        stdCkptY := [1796, 1853]
        desiredColor := ["0x00ADFF", "0x00ADFF"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "全部派遣失败！"
                ExitApp
            }

            if UserCheckColor([1779], [1778], ["0xCFCFCF"], scrRatio)
                break
        }

        stdTargetX := 2073
        stdTargetY := 1818
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [2199, 2055]
        stdCkptY := [1796, 1853]
        desiredColor := ["0x00ADFF", "0x00ADFF"]

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "全部派遣失败！"
                ExitApp
            }
        }
    }

    ;回到大厅
    stdTargetX := 333
    stdTargetY := 2041
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退出前哨基地失败！"
            ExitApp
        }
    }
}


;=============================================================
;5: 好友点数收取
FriendPoint()
{
    stdTargetX := 3729
    stdTargetY := 524
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入好友界面失败！"
            ExitApp
        }
    }

    stdCkptX := [2104, 2197]
    stdCkptY := [1825, 1838]
    desiredColor := ["0x0CAFF4", "0xF7FDFE"]
    stdTargetX := 2276
    stdTargetY := 1837

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "赠送好友点数失败"
            ExitApp
        }
    }

    stdTargetX := 333
    stdTargetY := 2041
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退出好友界面失败！"
            ExitApp
        }
    }
}


;=============================================================
;6: 模拟室5C
SimulationRoom()
{
    stdTargetX := 2689
    stdTargetY := 1463
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    stdCkptX := [1641]
    stdCkptY := [324]
    desiredColor := ["0x01D4F6"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    ;进入模拟室
    stdTargetX := 1547
    stdTargetY := 1138
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1829, 2024]
    stdCkptY := [1122, 1094]
    desiredColor := ["0xF8FCFD", "0xF8FCFD"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入模拟室失败！"
            ExitApp
        }
    }

    ;开始模拟
    stdTargetX := 1917
    stdTargetY := 1274
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1687, 1759]
    stdCkptY := [1823, 628]
    desiredColor := ["0x05AFF4", "0x1D1D1C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入选关失败！"
            ExitApp
        }
    }

    ;选择5C
    stdTargetX := 2127
    stdTargetY := 1074
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2

    stdTargetX := 2263
    stdTargetY := 1307
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2

    ;点击开始模拟
    ;开始模拟
    stdTargetX := 1891
    stdTargetY := 1818
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1687, 1759]
    stdCkptY := [1823, 628]
    desiredColor := ["0x05AFF4", "0x1D1D1C"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "开始模拟失败！"
            ExitApp
        }
    }

    ;1C-5C
    loop 5 {
        ;选择最右边的关卡
        stdTargetX := 2255
        stdTargetY := 1478
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [1912]
        stdCkptY := [1943]
        desiredColor := ["0xF8FCFD"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "选择关卡失败！"
                ExitApp
            }
        }

        stdCkptX := [2062]
        stdCkptY := [1850]
        desiredColor := ["0xF96F36"]

        ;如果是战斗关卡
        if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            ;点击快速战斗
            stdTargetX := 2233
            stdTargetY := 1854
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [2062]
            stdCkptY := [1850]
            desiredColor := ["0xF96F36"]

            while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime
                if A_Index > waitTolerance {
                    MsgBox "快速战斗失败！"
                    ExitApp
                }
            }

            stdCkptX := [2112]
            stdCkptY := [1808]
            desiredColor := ["0x05A0E3"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) && !UserCheckColor(stdCkptX, [1808 + 79], desiredColor, scrRatio) {
                Sleep sleepTime
                if A_Index > waitTolerance {
                    MsgBox "快速战斗失败！"
                    ExitApp
                }
            }

            Sleep 1500 ;kkk
            if sleepTime <= 1000
                Sleep 750

            ;点击不选择
            deltaY := 0
            stdCkptX := [1599]
            stdCkptY := [1811 + 79]
            desiredColor := ["0xDEE1E1"]
            if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio)
                deltaY := 79

            ;if deltaY == 79
            ;    MsgBox "79"

            stdTargetX := 1631
            stdTargetY := 1811 + deltaY
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [2112]
            stdCkptY := [1808 + deltaY]
            desiredColor := ["0x05A0E3"]

            while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime
                if A_Index > waitTolerance {
                    MsgBox "不选择buff失败！"
                    ExitApp
                }
            }

            ;点击确认
            stdTargetX := 2146
            stdTargetY := 1349
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [2081]
            stdCkptY := [1320]
            desiredColor := ["0x00A0EB"]

            while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime
                if A_Index > waitTolerance {
                    MsgBox "不选择buff失败！"
                    ExitApp
                }
            }
        }
        else {
            Sleep 1500 ;kkk
            if sleepTime <= 1000
                Sleep 750

            stdCkptX := [1636, 2053]
            stdCkptY := [1991, 1991]
            desiredColor := ["0xE0E2E2", "0x13A1E4"]
    
            ;如果是可以不选择的buff关卡
            if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                ;点击不选择
                stdTargetX := 1743
                stdTargetY := 2019
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime

                stdCkptX := [2053]
                stdCkptY := [1991]
                desiredColor := ["0x13A1E4"]

                while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime
                    if A_Index > waitTolerance {
                        MsgBox "不选择buff失败！"
                        ExitApp
                    }
                }

                ;点击确认
                stdTargetX := 2180
                stdTargetY := 1346
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime

                stdCkptX := [2080]
                stdCkptY := [1319]
                desiredColor := ["0x00A0EB"]

                while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime
                    if A_Index > waitTolerance {
                        MsgBox "不选择buff失败！"
                        ExitApp
                    }
                }

                ;点击确认
                stdTargetX := 1932
                stdTargetY := 1293
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime

                stdCkptX := [1836]
                stdCkptY := [1260]
                desiredColor := ["0x069FE3"]

                while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime
                    if A_Index > waitTolerance {
                        MsgBox "不选择buff失败！"
                        ExitApp
                    }
                }
            }
            else {
                ;是必须选择的关卡
                ;选择buff
                stdTargetX := 1885
                stdTargetY := 1862
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime // 2
                stdTargetX := 1904
                stdTargetY := 1900
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime

                if sleepTime <= 1000
                    Sleep 1000

                ;点击确认
                stdCkptX := [1858]
                stdCkptY := [1572]
                desiredColor := ["0x069FE3"]

                if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                    stdTargetX := 1923
                    stdTargetY := 1589
                    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                        UserClick(stdTargetX, stdTargetY, scrRatio)
                        Sleep sleepTime
                        if A_Index > waitTolerance {
                            MsgBox "确认失败！"
                            ExitApp
                        }
                    }
                }
                else {
                    stdTargetX := 1908
                    stdTargetY := 2016
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime // 2
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime // 2
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime // 2
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime

                    ;不替换buff
                    ;点击不选择和确定
                    tX := 2104
                    tY := 1656
                    desiredColor := ["0x089FE4"]

                    flag := true

                    while !UserCheckColor([tX], [tY], desiredColor, scrRatio) {
                        tY := tY + 65
                        if tY > 2160 {
                            flag := false
                            break
                        }
                    }

                    if !flag {
                        /*
                        stdTargetX := 1908
                        stdTargetY := 2016
                        UserClick(stdTargetX, stdTargetY, scrRatio)
                        Sleep sleepTime // 2
                        UserClick(stdTargetX, stdTargetY, scrRatio)
                        Sleep sleepTime // 2
                        UserClick(stdTargetX, stdTargetY, scrRatio)
                        Sleep sleepTime // 2
                        UserClick(stdTargetX, stdTargetY, scrRatio)
                        Sleep sleepTime
                        */
                        continue
                    }

                    ;MsgBox "点不选择"
                    stdTargetX := 2185
                    stdTargetY := tY - 200
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime // 2
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime // 2

                    ;MsgBox "点击确定"
                    stdTargetX := 2185
                    stdTargetY := tY
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime

                    stdCkptX := [2104]
                    stdCkptY := [tY]
                    desiredColor := ["0x089FE4"]

                    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                        UserClick(stdTargetX, stdTargetY, scrRatio)
                        Sleep sleepTime
                        if A_Index > waitTolerance {
                            MsgBox "模拟室结束异常！"
                            ExitApp
                        }
                    }

                    stdTargetX := 1908
                    stdTargetY := 2016
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime // 2
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime // 2
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime // 2
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime
                }
            }
        }
    }

    ;6C
    ;选择右边一个关卡
    stdTargetX := 2084
    stdTargetY := 1508
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1921]
    stdCkptY := [1921]
    desiredColor := ["0x000000"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "选择关卡失败！"
            ExitApp
        }
    }

    Sleep 1500 ;kkk
    if sleepTime <= 1000
        Sleep 750

    stdCkptX := [1648]
    stdCkptY := [1995]
    desiredColor := ["0xE1E2E2"]

    ;如果是属性提升
    if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        stdTargetX := 1711
        stdTargetY := 2020
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "不选择失败！"
                ExitApp
            }
        }

        stdTargetX := 2304
        stdTargetY := 1338
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
    }
    else {
        ;如果是疗养室
        stdTargetX := 1908
        stdTargetY := 1767
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2

        stdTargetX := 1892
        stdTargetY := 2014
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
    }

    ;7C
    stdTargetX := 1916
    stdTargetY := 1471
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [837, 951]
    stdCkptY := [1407, 1762]
    desiredColor := ["0xF8FCFE", "0xF8FCFE"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "选择关卡失败！"
            ExitApp
        }
    }

    ;点击进入战斗
    stdTargetX := 2225
    stdTargetY := 2004
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2

    stdCkptX := [1420, 2337]
    stdCkptY := [1243, 1440]
    desiredColor := ["0xFFFFFF", "0xFE0203"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        ;UserClick(stdTargetX, stdTargetY - 300, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance * 3 {
            MsgBox "模拟室boss战异常！"
            ExitApp
        }
    }

    stdTargetX := 1898
    stdTargetY := 1996
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [2115]
    stdCkptY := [1305]
    stdCkptX2 := [2115]
    stdCkptY2 := [1556]
    desiredColor := ["0xEFF3F5"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) && !UserCheckColor(stdCkptX2, stdCkptY2, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "模拟室结束异常！"
            ExitApp
        }
    }

    if colorTolerance != 15 {
        Sleep 5000
    }

    ;点击模拟结束
    stdTargetX := 1923
    stdTargetY := 1276
    if UserCheckColor(stdCkptX2, stdCkptY2, desiredColor, scrRatio) {
        stdTargetX := 1923
        stdTargetY := 1552
    }
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    /*
    stdTargetX := 1902
    stdTargetY := 1461
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    */

    ;点击不选择和确定
    tX := 2104
    tY := 1656
    desiredColor := ["0x089FE4"]

    while !UserCheckColor([tX], [tY], desiredColor, scrRatio) {
        tY := tY + 65
        if tY > 2160 {
            MsgBox "模拟室结束异常！"
            ExitApp
        }
    }

    ;MsgBox "点不选择"
    stdTargetX := 2185
    stdTargetY := tY - 200
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2

    ;MsgBox "点击确定"
    stdTargetX := 2185
    stdTargetY := tY
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [2104]
    stdCkptY := [tY]
    desiredColor := ["0x089FE4"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "模拟室结束异常！"
            ExitApp
        }
    }

    stdTargetX := 2191
    stdTargetY := 1349
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    ;退回大厅
    stdTargetX := 333
    stdTargetY := 2041
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退回大厅失败！"
            ExitApp
        }
    }
}


;=============================================================
;7: 新人竞技场打第三位，顺带收50%以上的菜
RookieArena(times)
{
    ;进入方舟
    stdTargetX := 2689
    stdTargetY := 1463
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    stdCkptX := [1641]
    stdCkptY := [324]
    desiredColor := ["0x01D4F6"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    ;收pjjc菜
    if sleepTime < 1500
        Sleep 1000

    stdTargetX := 2278
    stdTargetY := 1092
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2

    stdTargetX := 2129
    stdTargetY := 1920
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime // 2

    ;进入竞技场
    stdTargetX := 2208
    stdTargetY := 1359
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1683]
    stdCkptY := [606]
    desiredColor := ["0xF7FCFE"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入竞技场失败！"
            ExitApp
        }
    }

    ;进入新人竞技场
    stdTargetX := 1647
    stdTargetY := 1164
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [784]
    stdCkptY := [1201]
    desiredColor := ["0xF8FCFE"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        if A_Index > 5 {
            ;退回大厅
            stdTargetX := 333
            stdTargetY := 2041
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [64]
            stdCkptY := [470]
            desiredColor := ["0xFAA72C"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime
                if A_Index > waitTolerance {
                    MsgBox "退回大厅失败！"
                    ExitApp
                }
            }

            return
        }
        
        if A_Index > waitTolerance {
            MsgBox "进入新人竞技场失败！"
            ExitApp
        }
    }

    loop times {
        ;点击进入战斗
        stdTargetX := 2371
        stdTargetY := 1847
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [2700]
        stdCkptY := [1691]
        desiredColor := ["0xF7FCFE"]

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "选择对手失败！"
                ExitApp
            }
        }

        ;点击进入战斗
        stdTargetX := 2123
        stdTargetY := 1784
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [2784]
        stdCkptY := [1471]
        desiredColor := ["0xF8FCFD"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "新人竞技场作战失败！"
                ExitApp
            }
        }
    }

    ;退回大厅
    stdTargetX := 333
    stdTargetY := 2041
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退回大厅失败！"
            ExitApp
        }
    }
}


;=============================================================
;8: 对前n位nikke进行好感度咨询(可以通过收藏把想要咨询的nikke排到前面)
LoveTalking(times)
{
    ;进入妮姬列表
    stdTargetX := 1497
    stdTargetY := 2004
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入妮姬列表失败！"
            ExitApp
        }
    }

    stdCkptX := [1466, 1814]
    stdCkptY := [428, 433]
    desiredColor := ["0x3B3C3E", "0x3B3C3E"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入妮姬列表失败！"
            ExitApp
        }
    }

    ;进入咨询页面
    stdTargetX := 3308
    stdTargetY := 257
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1650]
    stdCkptY := [521]
    desiredColor := ["0x14B0F5"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        ;如果没次数了，直接退出
        if UserCheckColor(stdCkptX, stdCkptY, ["0xE0E0E2"], scrRatio) {
            stdTargetX := 333
            stdTargetY := 2041
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [64]
            stdCkptY := [470]
            desiredColor := ["0xFAA72C"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime
                if A_Index > waitTolerance {
                    MsgBox "退回大厅失败！"
                    ExitApp
                }
            }
            return
        }
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入咨询页面失败！"
            ExitApp
        }
    }

    ;点进第一个妮姬
    stdTargetX := 736
    stdTargetY := 749
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1504]
    stdCkptY := [1747]
    desiredColor := ["0xF99F22"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入妮姬咨询页面失败！"
            ExitApp
        }
    }

    loop times {
        stdCkptX := [1994]
        stdCkptY := [1634]
        desiredColor := ["0xFA6E34"]

        ;如果能够快速咨询
        if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            ;点击快速咨询
            stdTargetX := 2175
            stdTargetY := 1634
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [1994]
            stdCkptY := [1634]
            desiredColor := ["0xFA6E34"]

            while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime
                if A_Index > waitTolerance {
                    MsgBox "进入妮姬咨询页面失败！"
                    ExitApp
                }
            }

            ;点击确定
            stdTargetX := 2168
            stdTargetY := 1346
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime

            stdCkptX := [1504]
            stdCkptY := [1747]
            desiredColor := ["0xF99F22"]

            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime
                if A_Index > waitTolerance {
                    MsgBox "快速咨询失败！"
                    ExitApp
                }
            }
        }
        else {
            ;如果不能快速咨询
            stdCkptX := [1982]
            stdCkptY := [1819]
            desiredColor := ["0x4A4A4C"]
            if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                stdTargetX := 2168
                stdTargetY := 1777
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime

                stdCkptX := [1504]
                stdCkptY := [1747]
                desiredColor := ["0xF99F22"]

                while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime
                    if A_Index > waitTolerance {
                        MsgBox "咨询失败！"
                        ExitApp
                    }
                }

                ;点击确认
                stdTargetX := 2192
                stdTargetY := 1349
                UserClick(stdTargetX, stdTargetY, scrRatio)
                Sleep sleepTime

                stdCkptX := [2109]
                stdCkptY := [1342]
                desiredColor := ["0x00A0EB"]

                while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep sleepTime
                    if A_Index > waitTolerance {
                        MsgBox "咨询失败！"
                        ExitApp
                    }
                }

                stdCkptX := [1504]
                stdCkptY := [1747]
                desiredColor := ["0xF99F22"]
                stdTargetX := 1903
                stdTargetY := 1483

                while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                    if Mod(A_Index, 2) == 0
                        UserClick(stdTargetX, stdTargetY, scrRatio)
                    else
                        UserClick(stdTargetX, 1625, scrRatio)
                    Sleep sleepTime // 2
                    if A_Index > waitTolerance * 2 {
                        MsgBox "咨询失败！"
                        ExitApp
                    }
                }
            }
        }

        if A_Index >= times
            break

        ;翻页
        stdTargetX := 3778
        stdTargetY := 940
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [1982]
        stdCkptY := [1819]
        desiredColor := ["0x4A4A4C"]

        numOfTalked := A_Index

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index + numOfTalked >= times
                break 2
            if A_Index > waitTolerance {
                MsgBox "咨询失败！"
                ExitApp
            }
        }
    }

    ;退回大厅
    stdTargetX := 333
    stdTargetY := 2041
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退回大厅失败！"
            ExitApp
        }
    }
}


;=============================================================
;9: 爬塔一次(做每日任务)
TribeTower()
{
    stdTargetX := 2689
    stdTargetY := 1463
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    stdCkptX := [1641]
    stdCkptY := [324]
    desiredColor := ["0x01D4F6"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    ;进入无限之塔
    stdTargetX := 2278
    stdTargetY := 776
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [2405]
    stdCkptY := [1014]
    desiredColor := ["0xF8FBFE"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入无限之塔失败！"
            ExitApp
        }
    }

    stdTargetX := 1953
    stdTargetY := 934
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [2129, 2305]
    stdCkptY := [1935, 1935]
    desiredColor := ["0x2E77C2", "0x2E77C2"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "选择作战失败！"
            ExitApp
        }
    }

    stdTargetX := 2242
    stdTargetY := 2001
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [2129, 2305]
    stdCkptY := [1935, 1935]
    desiredColor := ["0x2E77C2", "0x2E77C2"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入作战失败！"
            ExitApp
        }
    }

    ;按esc
    stdCkptX := [2065]
    stdCkptY := [1954]
    desiredColor := ["0x238CFD"]
    stdTargetX := 3780
    stdTargetY := 75

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "按esc失败！"
            ExitApp
        }
    }

    ;按放弃战斗
    stdCkptX := [2065]
    stdCkptY := [1954]
    desiredColor := ["0x238CFD"]
    stdTargetX := 1678
    stdTargetY := 1986

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "放弃战斗失败！"
            ExitApp
        }
    }

    ;退回大厅
    stdTargetX := 301
    stdTargetY := 2030
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退回大厅失败！"
            ExitApp
        }
    }
}


;=============================================================
MissionCompleted()
{
    stdCkptX := [3451, 3756]
    stdCkptY := [2077, 2075]
    desiredColor := ["0x00A1FF", "0x00A1FF"]

    if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio)
        return true
    else
        return false
}

MissionFailed()
{
    stdCkptX := [2306, 1920, 1590, 1560]
    stdCkptY := [702, 1485, 1489, 1473]
    desiredColor := ["0xB71013", "0xE9E9E7", "0x161515", "0xE9E9E7"]

    if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio)
        return true
    else
        return false
}

MissionEnded()
{
    stdCkptX := [3494, 3721, 3526, 3457, 3339, 3407]
    stdCkptY := [2086, 2093, 2033, 2043, 2040, 2043]
    desiredColor := ["0x6F6F6F", "0x6F6F6F", "0x030303", "0x434343", "0xE6E6E6", "0x000000"]

    if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio)
        return true
    else
        return false
}

failedTower := Array()

CompanyTowerInfo()
{
    info := ""
    loop failedTower.Length {
        info := info failedTower[A_Index] " "
    }
    if info != "" {
        info := "`n" info "已经爬不动惹dororo..."
    }
    return info
}

;10: 企业塔
CompanyTower()
{
    stdTargetX := 2689
    stdTargetY := 1463
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    stdCkptX := [1641]
    stdCkptY := [324]
    desiredColor := ["0x01D4F6"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    ;进入无限之塔
    stdTargetX := 2278
    stdTargetY := 776
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [2405]
    stdCkptY := [1014]
    desiredColor := ["0xF8FBFE"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入无限之塔失败！"
            ExitApp
        }
    }

    Sleep 1500

    ;尝试进入每座企业塔
    targX := [1501, 1779, 2061, 2332]
    targY := [1497, 1497, 1497, 1497]
    ckptX := [1383, 1665, 1935, 2222]
    ckptY := [1925, 1925, 1925, 1925]

    loop targX.Length {
        i := A_Index

        stdTargetX := targX[i]
        stdTargetY := targY[i]
        stdCkptX := [ckptX[i]]
        stdCkptY := [ckptY[i]]
        desiredColor := ["0x00AAF4"]

        ;如果未开放，则检查下一个企业
        if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio)
            continue

        ;点击进入企业塔
        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "进入企业塔失败！"
                ExitApp
            }
        }

        ;直到成功进入企业塔
        stdCkptX := [3738]
        stdCkptY := [447]
        desiredColor := ["0xF8FCFE"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "进入企业塔失败！"
                ExitApp
            }
        }

        ;进入关卡页面
        stdTargetX := 1918
        stdTargetY := 919

        stdCkptX := [992]
        stdCkptY := [2011]
        desiredColor := ["0x000000"]

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "进入企业塔关卡页面失败！"
                ExitApp
            }
        }

        ;如果战斗次数已经用完
        Sleep 1000
        stdCkptX := [2038]
        stdCkptY := [2057]
        desiredColor := ["0x4D4E50"]
        if UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            stdCkptX := [3738]
            stdCkptY := [447]
            desiredColor := ["0xF8FCFE"]
            while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                Send "{Escape}"
                Sleep sleepTime
            }
            
            stdCkptX := [2405]
            stdCkptY := [1014]
            desiredColor := ["0xF8FBFE"]
            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio)
                Sleep sleepTime

            Sleep 1500
            continue
        }

        ;点击进入战斗
        stdTargetX := 2249
        stdTargetY := 1997
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        ;等待战斗结束
        WaitForBattleEnd:
        while !(MissionCompleted() || MissionFailed() || MissionEnded()) {
            Sleep sleepTime
            if A_Index > waitTolerance * 20 {
                MsgBox "企业塔自动战斗失败！"
                ExitApp
            }
        }

        ;如果战斗失败或次数用完
        if MissionFailed() || MissionEnded() {
            if MissionFailed() {
                towerName := ""
                global failedTower
                switch i {
                    case 1:
                        towerName := "极乐净土塔"
                    case 2:
                        towerName := "米西利斯塔"
                    case 3:
                        towerName := "泰特拉塔"
                    case 4:
                        towerName := "朝圣者塔"
                    default:
                        towerName := ""
                }
                failedTower.Push towerName
            }

            Send "{Escape}"
            Sleep sleepTime

            while MissionFailed() || MissionEnded() {
                Send "{Escape}"
                Sleep sleepTime
            }

            stdCkptX := [3738]
            stdCkptY := [447]
            desiredColor := ["0xF8FCFE"]
            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(3666, 1390, scrRatio)
                Sleep sleepTime
                if UserCheckColor([2088], [1327], ["0x00A0EB"], scrRatio) {
                    UserClick(2202, 1342, scrRatio)
                    Sleep sleepTime
                }
            }

            Sleep 1500
            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                UserClick(3666, 1390, scrRatio)
                Sleep sleepTime
                if UserCheckColor([2088], [1327], ["0x00A0EB"], scrRatio) {
                    UserClick(2202, 1342, scrRatio)
                    Sleep sleepTime
                }
            }

            while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
                Send "{Escape}"
                Sleep sleepTime
            }

            stdCkptX := [2405]
            stdCkptY := [1014]
            desiredColor := ["0xF8FBFE"]
            while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio)
                Sleep sleepTime

            Sleep 1500
            continue
        }

        ;如果战斗胜利
        while MissionCompleted() {
            Send "t"
            Sleep sleepTime
        }

        goto WaitForBattleEnd
    }

    ;退回大厅
    stdTargetX := 301
    stdTargetY := 2030
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退回大厅失败！"
            ExitApp
        }
    }
}


;=============================================================
;11: 进入异拦
EnterInterception()
{
    stdTargetX := 2689
    stdTargetY := 1463
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime // 2
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    stdCkptX := [1641]
    stdCkptY := [324]
    desiredColor := ["0x01D4F6"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入方舟失败！"
            ExitApp
        }
    }

    ;进入拦截战
    stdTargetX := 1781
    stdTargetY := 1719
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1641]
    stdCkptY := [324]
    desiredColor := ["0x01D4F6"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入拦截战失败！"
            ExitApp
        }
    }

    ;不勾选自动拦截就直接退出
    if !isCheckedInterception
        return

    stdCkptX := [1917]
    stdCkptY := [910]
    desiredColor := ["0x037EF9"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入拦截战失败！"
            ExitApp
        }
    }

    ;选择BOSS
    switch InterceptionBoss {
        case 1:
            stdTargetX := 1556
            stdTargetY := 886
            stdCkptX := [1907]
            stdCkptY := [898]
            desiredColor := ["0xFA910E"]

        case 2:
            stdTargetX := 2279
            stdTargetY := 1296
            stdCkptX := [1923]
            stdCkptY := [908]
            desiredColor := ["0xFB01F1"]

        case 3:
            stdCkptX := [1917]
            stdCkptY := [910]
            desiredColor := ["0x037EF9"]

        case 4:
            stdTargetX := 2281
            stdTargetY := 899
            stdCkptX := [1916]
            stdCkptY := [907]
            desiredColor := ["0x00F556"]

        case 5:
            stdTargetX := 1551
            stdTargetY := 1299
            stdCkptX := [1919]
            stdCkptY := [890]
            desiredColor := ["0xFD000F"]
            
        default:
            MsgBox "BOSS选择错误！"
            ExitApp
    }

    if InterceptionBoss != 3 {
        while UserCheckColor([1917], [910], ["0x037EF9"], scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "选择BOSS失败！"
                ExitApp
            }
        }
    }

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "选择BOSS失败！"
            ExitApp
        }
    }

    ;点击挑战按钮
    if UserCheckColor([1735], [1730], ["0x28282A"], scrRatio) {
        stdTargetX := 301
        stdTargetY := 2030
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        stdCkptX := [64]
        stdCkptY := [470]
        desiredColor := ["0xFAA72C"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "退回大厅失败！"
                ExitApp
            }
        }
        return
    }

    stdTargetX := 1924
    stdTargetY := 1779

    /*
    stdCkptX := [1735]
    stdCkptY := [1730]
    desiredColor := [""]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "点击挑战失败！"
            ExitApp
        }
    }
    */

    stdCkptX := [1390]
    stdCkptY := [1799]
    desiredColor := ["0x01AEF3"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "点击挑战失败！"
            ExitApp
        }
    }
    
    ;选择编队
    switch InterceptionBoss {
        case 1:
            stdTargetX := 1882
            stdTargetY := 1460
            stdCkptX := [1843]
            stdCkptY := [1428]

        case 2:
            stdTargetX := 2020
            stdTargetY := 1460
            stdCkptX := [1981]
            stdCkptY := [1428]

        case 3:
            stdTargetX := 2151
            stdTargetY := 1460
            stdCkptX := [2113]
            stdCkptY := [1428]

        case 4:
            stdTargetX := 2282
            stdTargetY := 1460
            stdCkptX := [2248]
            stdCkptY := [1428]

        case 5:
            stdTargetX := 2421
            stdTargetY := 1460
            stdCkptX := [2380]
            stdCkptY := [1428]
            
        default:
            MsgBox "BOSS选择错误！"
            ExitApp
    }

    desiredColor := ["0x02ADF5"]
    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep 1500
        if A_Index > waitTolerance {
            MsgBox "选择编队失败！"
            ExitApp
        }
    }

    ;如果不能快速战斗，就进入战斗
    stdCkptX := [1964]
    stdCkptY := [1800]
    desiredColor := ["0xF96B2F"]

    if !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        stdTargetX := 2219
        stdTargetY := 1992
        stdCkptX := [1962]
        stdCkptY := [1932]
        desiredColor := ["0xD52013"]

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "进入战斗失败！"
                ExitApp
            }
        }

        ;退出结算页面
        stdTargetX := 904
        stdTargetY := 1805
        stdCkptX := [1893, 1913, 1933]
        stdCkptY := [1951, 1948, 1956]
        desiredColor := ["0xFFFFFF", "0xFFFFFF", "0xFFFFFF"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            Sleep sleepTime
            if A_Index > waitTolerance * 20 {
                MsgBox "自动战斗失败！"
                ExitApp
            }
        }

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "退出结算页面失败！"
                ExitApp
            }
        }
    }

    ;检查是否退出
    stdCkptX := [1390]
    stdCkptY := [1799]
    desiredColor := ["0x01AEF3"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退出结算页面失败！"
            ExitApp
        }
    }

    ;快速战斗
    stdTargetX := 2229
    stdTargetY := 1842
    stdCkptX := [1964]
    stdCkptY := [1800]
    desiredColor := ["0xF96B2F"]

    while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "快速战斗失败！"
                ExitApp
            }
        }

        ;退出结算页面
        stdTargetX := 904
        stdTargetY := 1805
        stdCkptX := [1893, 1913, 1933]
        stdCkptY := [1951, 1948, 1956]
        desiredColor := ["0xFFFFFF", "0xFFFFFF", "0xFFFFFF"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "快速战斗结算失败！"
                ExitApp
            }
        }

        while UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            UserClick(stdTargetX, stdTargetY, scrRatio)
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "退出结算页面失败！"
                ExitApp
            }
        }

        ;检查是否退出
        stdCkptX := [1390]
        stdCkptY := [1799]
        desiredColor := ["0x01AEF3"]

        while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
            Sleep sleepTime
            if A_Index > waitTolerance {
                MsgBox "退出结算页面失败！"
                ExitApp
            }
        }

        Sleep 1000

        stdTargetX := 2229
        stdTargetY := 1842
        stdCkptX := [1964]
        stdCkptY := [1800]
        desiredColor := ["0xF96B2F"]
    }

    ;退回大厅
    stdTargetX := 301
    stdTargetY := 2030
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [64]
    stdCkptY := [470]
    desiredColor := ["0xFAA72C"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "退回大厅失败！"
            ExitApp
        }
    }

    ;进入特殊拦截战
    /*
    stdTargetX := 2059
    stdTargetY := 1689
    UserClick(stdTargetX, stdTargetY, scrRatio)
    Sleep sleepTime

    stdCkptX := [1425]
    stdCkptY := [1852]
    desiredColor := ["0x02AEF5"]

    while !UserCheckColor(stdCkptX, stdCkptY, desiredColor, scrRatio) {
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep sleepTime
        if A_Index > waitTolerance {
            MsgBox "进入特殊拦截战失败！"
            ExitApp
        }
    }
    */
}




ClickOnOutpostDefence(*) 
{
    global isCheckedOutposeDefence
    isCheckedOutposeDefence := 1 - isCheckedOutposeDefence
}

ClickOnCashShop(*)
{
    global isCheckedCashShop
    isCheckedCashShop := 1 - isCheckedCashShop
}

ClickOnFreeShop(*)
{
    global isCheckedFreeShop
    isCheckedFreeShop := 1 - isCheckedFreeShop
}

ClickOnExpedition(*)
{
    global isCheckedExpedtion
    isCheckedExpedtion := 1 - isCheckedExpedtion
}

ClickOnFriendPoint(*)
{
    global isCheckedFriendPoint
    isCheckedFriendPoint := 1 - isCheckedFriendPoint
}

ClickOnSimulationRoom(*)
{
    global isCheckedSimulationRoom
    isCheckedSimulationRoom := 1 - isCheckedSimulationRoom
}

ClickOnRookieArena(*)
{
    global isCheckedRookieArena
    isCheckedRookieArena := 1 - isCheckedRookieArena
}

ClickOnLoveTalking(*)
{
    global isCheckedLoveTalking
    isCheckedLoveTalking := 1 - isCheckedLoveTalking
}

ClickOnTribeTower(*)
{
    global isCheckedTribeTower
    isCheckedTribeTower := 1 - isCheckedTribeTower
}

ClickOnCompanyWeapon(*)
{
    global isCheckedCompanyWeapon
    isCheckedCompanyWeapon := 1 - isCheckedCompanyWeapon
}

ClickOnInterception(*)
{
    global isCheckedInterception
    isCheckedInterception := 1 - isCheckedInterception
}

ClickOnCompanyTower(*)
{
    global isCheckedCompanyTower
    isCheckedCompanyTower := 1 - isCheckedCompanyTower
}

ChangeOnNumOfBook(GUICtrl, *)
{
    global numOfBook
    numOfBook := GUICtrl.Value - 1
}

ChangeOnNumOfBattle(GUICtrl, *)
{
    global numOfBattle
    numOfBattle := GUICtrl.Value + 1
}

ChangeOnNumOfLoveTalking(GUICtrl, *)
{
    global numOfLoveTalking
    numOfLoveTalking := GUICtrl.Value
}

ChangeOnInterceptionBoss(GUICtrl, *)
{
    global InterceptionBoss
    InterceptionBoss := GUICtrl.Value
}

ChangeOnSleepTime(GUICtrl, *)
{
    global sleepTime
    switch GUICtrl.Value {
        case 1: sleepTime := 750
        case 2: sleepTime := 1000
        case 3: sleepTime := 1250
        case 4: sleepTime := 1500
        case 5: sleepTime := 1750
        case 6: sleepTime := 2000
        default: sleepTime := 1500
    }
}

ChangeOnColorTolerance(GUICtrl, *)
{
    global colorTolerance
    switch GUICtrl.Value {
        case 1: colorTolerance := 15
        case 2: colorTolerance := 35
        default: colorTolerance := 15
    }
}

ClickOnHelp(*)
{
    msgbox "
    (
    #############################################
    使用说明

    对大多数老玩家来说Doro设置保持默认就好。
    万一Doro失控，请按Ctrl + 1组合键结束进程。
    万一Doro失控，请按Ctrl + 1组合键结束进程。
    万一Doro失控，请按Ctrl + 1组合键结束进程。

    ############################################# 
    要求：

    - 【设定-画质-全屏幕模式 + 16:9的显示器比例】   或    【16:9的窗口模式（窗口别拉太小，否则像素识别可能出现误差）】
    - 设定-画质-开启光晕效果
    - 设定-画质-开启颜色分级
    - 游戏语言设置为简体中文
    - 以**管理员身份**运行DoroHelper

    ############################################# 
    步骤：

    -打开NIKKE启动器。点击启动。等右下角腾讯ACE反作弊系统扫完，NIKKE主程序中央SHIFT UP logo出现之后，再切出来点击“DORO!”按钮。如果你看到鼠标开始在左下角连点，那就代表启动成功了。（不行的话手动点击一下NIKKE，让它成为活跃窗口。）然后就可以悠闲地去泡一杯咖啡，或者刷一会儿手机，等待Doro完成工作了。
    -也可以在游戏处在大厅界面时（有看板娘的页面）切出来点击“DORO!”按钮启动程序。
    -游戏需要更新的时候请更新完再使用Doro。

    ############################################# 
    其他:
    -如果出现死循环，提高点击间隔可以解决80%的问题。
    -还是不行就上github搜索DoroHelper，看是否发布了新版本。
    -如果你的电脑配置较好的话，或许可以尝试降低点击间隔。
    
    )"

}

ClickOnDoro(*)
{
    WriteSettings()

    if !A_IsAdmin {
        MsgBox "请以管理员身份运行Doro"
        ExitApp
    }

    title := "勝利女神：妮姬"
    try {
        WinGetClientPos ,, &userScreenW, &userScreenH, "勝利女神：妮姬"
    } catch as err {
        title := "ahk_exe nikke.exe"
    }

    WinGetClientPos ,, &userScreenW, &userScreenH, title
    global scrRatio
    scrRatio := userScreenW / stdScreenW

    nikkeID := WinWait(title)
    WinActivate nikkeID

    Login()

    if isCheckedOutposeDefence
        OutpostDefence()

    if isCheckedCashShop
        CashShop()

    if isCheckedFreeShop
        FreeShop(numOfBook)

    if isCheckedExpedtion
        Expedition()

    if isCheckedFriendPoint
        FriendPoint()

    if isCheckedSimulationRoom
        SimulationRoom()

    if isCheckedRookieArena
        RookieArena(numOfBattle)

    if isCheckedLoveTalking
        LoveTalking(numOfLoveTalking)

    if isCheckedTribeTower && !isCheckedCompanyTower
        TribeTower()

    if isCheckedCompanyTower
        CompanyTower()

    if isCheckedOutposeDefence
        OutpostDefence()

    EnterInterception()

    if isBoughtTrash == 0 
        MsgBox "协同作战商店似乎已经刷新了，快去看看吧"

    MsgBox "Doro完成任务！" CompanyTowerInfo()

    ExitApp
}


SleepTimeToLabel(sleepTime)
{
    return String(sleepTime / 250 - 2)
}


ColorToleranceToLabel(colorTolerance)
{
    switch colorTolerance {
        case 15: return "1"
        case 35: return "2"
        default:
            return "1"
    }
}


IsCheckedToString(foo)
{
    if foo
        return "Checked"
    else
        return ""
}


NumOfBookToLabel(n)
{
    return String(n + 1)
}


NumOfBattleToLabel(n)
{
    return String(n - 1)
}

NumOfLoveTalkingToLabel(n)
{
    return String(n)
}

InterceptionBossToLabel(n)
{
    return String(n)
}


WriteSettings()
{
    IniWrite(sleepTime, "settings.ini", "section1", "sleepTime")
    IniWrite(colorTolerance, "settings.ini", "section1", "colorTolerance")
    IniWrite(isCheckedOutposeDefence, "settings.ini", "section1", "isCheckedOutposeDefence")
    IniWrite(isCheckedCashShop, "settings.ini", "section1", "isCheckedCashShop")
    IniWrite(isCheckedFreeShop, "settings.ini", "section1", "isCheckedFreeShop")
    IniWrite(isCheckedExpedtion, "settings.ini", "section1", "isCheckedExpedtion")
    IniWrite(isCheckedFriendPoint, "settings.ini", "section1", "isCheckedFriendPoint")
    IniWrite(isCheckedSimulationRoom, "settings.ini", "section1", "isCheckedSimulationRoom")
    IniWrite(isCheckedRookieArena, "settings.ini", "section1", "isCheckedRookieArena")
    IniWrite(isCheckedLoveTalking, "settings.ini", "section1", "isCheckedLoveTalking")
    IniWrite(isCheckedTribeTower, "settings.ini", "section1", "isCheckedTribeTower")
    IniWrite(isCheckedCompanyWeapon, "settings.ini", "section1", "isCheckedCompanyWeapon")
    IniWrite(numOfBook, "settings.ini", "section1", "numOfBook")
    IniWrite(numOfBattle, "settings.ini", "section1", "numOfBattle")
    IniWrite(numOfLoveTalking, "settings.ini", "section1", "numOfLoveTalking")
    IniWrite(isCheckedInterception, "settings.ini", "section1", "isCheckedInterception")
    IniWrite(InterceptionBoss, "settings.ini", "section1", "InterceptionBoss")
    IniWrite(isCheckedCompanyTower, "settings.ini", "section1", "isCheckedCompanyTower")
}


LoadSettings()
{
    global sleepTime
    global colorTolerance
    global isCheckedOutposeDefence
    global isCheckedCashShop
    global isCheckedFreeShop
    global isCheckedExpedtion
    global isCheckedFriendPoint
    global isCheckedSimulationRoom
    global isCheckedRookieArena
    global isCheckedLoveTalking
    global isCheckedTribeTower
    global isCheckedCompanyWeapon
    global numOfBook
    global numOfBattle
    global numOfLoveTalking
    global isCheckedInterception
    global InterceptionBoss
    global isCheckedCompanyTower

    sleepTime := IniRead("settings.ini", "section1", "sleepTime")
    colorTolerance := IniRead("settings.ini", "section1", "colorTolerance")
    isCheckedOutposeDefence := IniRead("settings.ini", "section1", "isCheckedOutposeDefence")
    isCheckedCashShop := IniRead("settings.ini", "section1", "isCheckedCashShop")
    isCheckedFreeShop := IniRead("settings.ini", "section1", "isCheckedFreeShop")
    isCheckedExpedtion := IniRead("settings.ini", "section1", "isCheckedExpedtion")
    isCheckedFriendPoint := IniRead("settings.ini", "section1", "isCheckedFriendPoint")
    isCheckedSimulationRoom := IniRead("settings.ini", "section1", "isCheckedSimulationRoom")
    isCheckedRookieArena := IniRead("settings.ini", "section1", "isCheckedRookieArena")
    isCheckedLoveTalking := IniRead("settings.ini", "section1", "isCheckedLoveTalking")
    isCheckedTribeTower := IniRead("settings.ini", "section1", "isCheckedTribeTower")
    isCheckedCompanyWeapon := IniRead("settings.ini", "section1", "isCheckedCompanyWeapon")
    numOfBook := IniRead("settings.ini", "section1", "numOfBook")
    numOfBattle := IniRead("settings.ini", "section1", "numOfBattle")
    numOfLoveTalking := IniRead("settings.ini", "section1", "numOfLoveTalking")

    try {
        isCheckedInterception := IniRead("settings.ini", "section1", "isCheckedInterception")
    }
    catch as err {
        IniWrite(isCheckedInterception, "settings.ini", "section1", "isCheckedInterception")
    }
    
    try {
        InterceptionBoss := IniRead("settings.ini", "section1", "InterceptionBoss")
    }
    catch as err {
        IniWrite(InterceptionBoss, "settings.ini", "section1", "InterceptionBoss")
    }

    try {
        isCheckedCompanyTower := IniRead("settings.ini", "section1", "isCheckedCompanyTower")
    }
    catch as err {
        IniWrite(isCheckedCompanyTower, "settings.ini", "section1", "isCheckedCompanyTower")
    }
}


isCheckedOutposeDefence := 1
isCheckedCashShop := 1
isCheckedFreeShop := 1
isCheckedExpedtion := 1
isCheckedFriendPoint := 1
isCheckedSimulationRoom := 1
isCheckedRookieArena := 1
isCheckedLoveTalking := 1
isCheckedTribeTower := 1
isCheckedCompanyWeapon := 1
isCheckedInterception := 0
isCheckedCompanyTower := 0
InterceptionBoss := 1
numOfBook := 3
numOfBattle := 5
numOfLoveTalking := 10
isBoughtTrash := 1

/*
^1::{
    MsgBox isCheckedOutposeDefence " " isCheckedCashShop " " isCheckedFreeShop " " isCheckedExpedtion " " isCheckedFriendPoint " " isCheckedSimulationRoom " " isCheckedRookieArena " " isCheckedLoveTalking " " isCheckedTribeTower
}
^2::{
    MsgBox colorTolerance
}
*/


;读取设置
SetWorkingDir A_ScriptDir
try {
    LoadSettings()
}
catch as err {
    WriteSettings()
}

/*
if not FileExist("settings.ini") {
    ;MsgBox "write"
    WriteSettings()
} else {
    ;MsgBox "load"
    LoadSettings()
}
*/


;创建gui
doroGui := Gui(, "Doro小帮手" currentVersion)
doroGui.Add("Button", "Default w80", "帮助").OnEvent("Click", ClickOnHelp)
doroGui.Add("Button", "Default w80", "检查更新").OnEvent("Click", ClickOnCheckForUpdate)
doroGui.Add("Text",, "点击间隔(单位毫秒)，谨慎更改")
doroGui.Add("DropDownList", "Choose" SleepTimeToLabel(sleepTime), [750, 1000, 1250, 1500, 1750, 2000]).OnEvent("Change", ChangeOnSleepTime)
doroGui.Add("Text",, "色差容忍度，能跑就别改")
doroGui.Add("DropDownList", "Choose" ColorToleranceToLabel(colorTolerance), ["严格", "宽松"]).OnEvent("Change", ChangeOnColorTolerance)
doroGui.Add("GroupBox", "w300 h435 YP+40", "想让Doro帮你做什么呢？")
doroGui.Add("Checkbox", IsCheckedToString(isCheckedOutposeDefence) " XP+10 YP+20", "领取前哨基地防御奖励").OnEvent("Click", ClickOnOutpostDefence)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedCashShop), "领取付费商店免费钻(进不了商店的别选)").OnEvent("Click", ClickOnCashShop)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedFreeShop), "普通商店 每日白嫖2次，并购买n本属性书").OnEvent("Click", ClickOnFreeShop)
doroGui.Add("Text",, "购买几本属性书？")
doroGui.Add("DropDownList", "Choose" NumOfBookToLabel(numOfBook), [0, 1, 2, 3]).OnEvent("Change", ChangeOnNumOfBook)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedCompanyWeapon), "普通商店购买公司武器熔炉").OnEvent("Click", ClickOnCompanyWeapon)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedExpedtion), "派遣远征").OnEvent("Click", ClickOnExpedition)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedFriendPoint), "好友点数收取").OnEvent("Click", ClickOnFriendPoint)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedSimulationRoom), "模拟室5C(普通关卡需要快速战斗)").OnEvent("Click", ClickOnSimulationRoom)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedRookieArena), "新人竞技场n次(请点开快速战斗)").OnEvent("Click", ClickOnRookieArena)
doroGui.Add("Text",, "新人竞技场打几次？")
doroGui.Add("DropDownList", "Choose" NumOfBattleToLabel(numOfBattle), [2, 3, 4, 5]).OnEvent("Change", ChangeOnNumOfBattle)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedLoveTalking), "咨询n位妮姬(可以通过收藏改变妮姬排序)").OnEvent("Click", ClickOnLoveTalking)
doroGui.Add("Text",, "咨询几位妮姬？")
doroGui.Add("DropDownList", "Choose" NumOfLoveTalkingToLabel(numOfLoveTalking), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]).OnEvent("Change", ChangeOnNumOfLoveTalking)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedTribeTower), "爬塔1次(蹭每日任务)").OnEvent("Click", ClickOnTribeTower)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedCompanyTower), "爬企业塔(勾选此条则上条无效)").OnEvent("Click", ClickOnCompanyTower)
doroGui.Add("Checkbox", IsCheckedToString(isCheckedInterception), "使用对应编队进行异常拦截自动战斗`n（不勾选则在异拦界面停止）").OnEvent("Click", ClickOnInterception)
doroGui.Add("Text",, "自动打哪个异拦boss？(勾选上条才生效)")
doroGui.Add("DropDownList", "Choose" InterceptionBossToLabel(InterceptionBoss), ["克拉肯(石)，编队1", "过激派(头)，编队2", "镜像容器(手)，编队3", "茵迪维利亚(衣)，编队4", "死神(脚)，编队5"]).OnEvent("Change", ChangeOnInterceptionBoss)
doroGui.Add("Button", "Default w80 XP+100 YP+40", "DORO!").OnEvent("Click", ClickOnDoro)
doroGui.Show()

^1::{
    ExitApp
}






/*
;登陆到主界面
Login()

;前哨基地防御奖励
OutpostDefence()

;付费商店领免费钻
CashShop()

;普通商店白嫖
FreeShop()

;派遣
Expedition()

;好友点数收取
FriendPoint()

;模拟室5C(不拿buff)
SimulationRoom()

RookieArenaTimes := 0

;新人竞技场n次打第三位，顺带收50%以上的菜
RookieArena(RookieArenaTimes)

LoveTalkingTimes := 10

;对前n位nikke进行好感度咨询(可以通过收藏把想要咨询的nikke排到前面)
;LoveTalking(LoveTalkingTimes)

;爬塔一次(蹭每日任务)
TribeTower()

;再次收前哨基地防御奖励(蹭每日任务)
OutpostDefence()

;进入特拦界面
EnterInterception()
*/