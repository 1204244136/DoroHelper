#Requires AutoHotkey >=v2.0
#Include <github>
#Include <FindText>
#Include <GuiCtrlTips>
CoordMode "Pixel", "Client"
CoordMode "Mouse", "Client"
;region 设置常量
try TraySetIcon "doro.ico"
currentVersion := "v1.0.0-beta.17"
usr := "1204244136"
repo := "DoroHelper"
;endregion 设置常量
;region 设置变量
;tag 简单开关
global g_settings := Map(
    ;商店
    "Shop", 1,                 ;商店总开关
    "CashShop", 1,             ;付费商店
    "NormalShop", 1,           ;普通商店
    "NormalShopDust", 1,       ;普通商店：芯尘盒
    "NormalShopPackage", 0,    ;普通商店：简介个性化礼包
    "ArenaShop", 1,            ;竞技场商店
    "BookFire", 1,             ;竞技场商店：燃烧手册
    "BookWater", 1,            ;竞技场商店：水冷手册
    "BookWind", 1,             ;竞技场商店：风压手册
    "BookElec", 1,             ;竞技场商店：电击手册
    "BookIron", 1,             ;竞技场商店：铁甲手册
    "BookBox", 1,              ;竞技场商店：手册宝箱
    "ArenaShopPackage", 1,     ;竞技场商店：简介个性化礼包
    "ArenaShopFurnace", 1,     ;竞技场商店：公司武器熔炉
    "ScrapShop", 1,            ;废铁商店
    "ScrapShopGem", 1,         ;废铁商店：珠宝
    "ScrapShopVoucher", 0,     ;废铁商店：好感券
    "ScrapShopResources", 1,   ;废铁商店：养成资源
    ;模拟室
    "SimulationRoom", 1,       ;模拟室
    "SimulationOverClock", 1,  ;模拟室超频
    ;竞技场
    "Arena", 1,                ;竞技场收菜
    "RookieArena", 1,          ;新人竞技场
    "SpecialArena", 1,         ;特殊竞技场
    "ChampionArena", 1,        ;冠军竞技场
    ;无限之塔
    "Tower", 1,                ;无限之塔总开关
    "CompanyTower", 1,         ;企业塔
    "UniversalTower", 0,       ;通用塔
    ;异常拦截
    "Interception", 1,         ;拦截战
    "InterceptionShot", 0,    ;拦截截图
    ;常规奖励
    "Award", 1,                ;奖励领取总开关
    "OutpostDefence", 1,       ;前哨基地收菜
    "Expedition", 1,           ;派遣
    "LoveTalking", 1,          ;咨询
    "Appreciation", 1,         ;花絮鉴赏
    "FriendPoint", 1,          ;好友点数
    "Mail", 1,                 ;邮箱
    "RankingReward", 1,        ;排名奖励
    "Mission", 1,              ;任务
    "Pass", 1,                 ;通行证
    ;限时奖励
    "FreeRecruit", 1,          ;活动期间每日免费招募
    "RoadToVillain", 1,        ;德雷克·反派之路
    "Cooperate", 1,            ;协同作战
    "SoloRaid", 1,             ;个人突击
    "Session", 1,              ;小活动
    "Festival", 1,             ;大活动
    ;妙妙工具
    "StoryModeAutoStar", 1,    ;剧情模式自动收藏
    "StoryModeAutoChoose", 1,  ;剧情模式自动选择
    ;其他
    "AutoCheckUpdate", 0,      ;自动检查更新
    "isPreRelease", 1,         ;启用预发布通道
    "MirrorUpdate", 0,         ;使用Mirror酱检查和更新
    "AdjustSize", 0,           ;启用画面缩放
    "SelfClosing", 0,          ;完成后自动关闭程序
    "OpenBlablalink", 1,       ;完成后打开Blablalink
)
;tag 其他非简单开关
global g_numeric_settings := Map(
    "SleepTime", 1000,            ;默认等待时间
    "InterceptionBoss", 1,        ;拦截战BOSS选择
    "Tolerance", 1,               ;宽容度
    "MirrorCDK", "",              ;Mirror酱的CDK
    "Version", currentVersion,    ;版本号
    "Username", "12042"            ;用户名
)
;tag 其他全局变量
Victory := 0
PicTolerance := g_numeric_settings["Tolerance"]
;endregion 设置变量
;region 读取设置
SetWorkingDir A_ScriptDir
try {
    LoadSettings()
    if CompareVersionsSemVer(currentVersion, g_numeric_settings["Version"]) {
        MsgBox("版本已更新，所有设置将重置")
        g_numeric_settings["Version"] := currentVersion
        WriteSettings()
    }
}
catch {
    WriteSettings()
}
;endregion 读取设置
;region 识图素材
; FindText().PicLib("对应的内容")
;tag 通用
FindText().PicLib("|<红点>FA3F1F-0.70$12.3sDwTyTzzzzzzzzzTyTyDw1kU", 1)
FindText().PicLib("|<圈中的感叹号>*150$22.zU7zs07y7wDszwTDzsszDlbwzYzzy3zzwDzzkznz3zDwDwzkznz3zDsbwzaDnwQTzXszwTkz3zU0TzU7y", 1)
FindText().PicLib("|<白色的圆圈加勾>*200$34.zz03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDszzz1z3zzsDwTzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXlzzzwD3zzzVy7zzw7wDzzUzsDzw7zkDz0zzU007zz001zzzU0TzzzkTzy", 1)
FindText().PicLib("|<确认的白色勾>*225$28.zzzzjzzzsTzzz0zzzs3zzz0Tzzs3zzz0Tzzs3tzz0T3zs3w7z0TkDs3zUT0Tz0s3zy10Tzw03zzs0Tzzk3zzzUTzzz3zzs", 1)
FindText().PicLib("|<灰色空心方框>*220$28.DzzzVzzzzbzzzyzzzzzk003z000Dw000zk003z000Dw000zk003z000Dw000zk003z000Dw000zk003z000Dw000zk003z000Dw000zk003z000DzzzzxzzzzbzzzwU", 1)
FindText().PicLib("|<白色的叉叉>*220$28.zzzzszzzz1zzzsXzzz77zzsyDzz7wTzszszz7zlzszzXz7zz7szzyD7zzwMzzzs7zzzkzzzz3zzzs7zzz6DzzswTzz7szzszlzz7znzszz7z7zyDszzwT7zzsszzzlDzzzVzzzzc", 1)
FindText().PicLib("|<方舟的眼睛>*90$54.0007w0000003zzs00000Tzzy00001zzzzs0003zzzzw000Dzyzzy000TzsATzU00zzUA7zs00zy0A3zw03zw0A0zy07zw0A0Tz0Dzs0Q0DzUTzs3z0DzkTzk7zk7zszzkDzk7zszzkDzs3zwzzkTzw3zyzzzzzw3zyzzzzzzzzzTzkDzzzzzTzkDzw3zzDzkDzs3zzDzs7zs3zy7zs3zk7zw3zs0z07zw1zw0Q0Dzs0zy0A0Dzk0Tz0A0Tzk0DzUA0zzU07zsA3zz003zyADzy000zzzzzs000Dzzzzk0003zzzz00000Tzzs00000Dzz000U", 1)
FindText().PicLib("|<勾>*225$28.zzzzjzzzsTzzz0zzzs3zzz0Tzzs3zzz0Tzzs3tzz0T3zs3w7z0TkDs3zUT0Tz0s3zy10Tzw03zzs0Tzzk3zzzUTzzz3zzs", 1)
FindText().PicLib("|<ESC>*150$37.zzzzzzzzzzzzw0Q0w0y0A0A0D0C6677bz7X7XnzXzXls3kDlzw1w0szy0z0ATz7zz6DzbzjX7XlzXlXls0k0k0w0Q0Q0S0D0T0TzzzzzzzzzzzzU", 1)
FindText().PicLib("|<白底蓝色右箭头>*200$33.zzUDzzzU0Dzzk00Tzs000zy0003zU000Ds0000y00007k0000Q0k601UD1s081wTU107ly000T7s001wTU007ly000TXs003wT000z7k00Dlw003wT000z7k00Dnw041sT01U71k0C00403k0000T00007w0001zk000Tz0007zw001zzs00zzzs0zzU", 1)
FindText().PicLib("|<MAX>*120$27.zzzzzzzzzvvnzyCAAnllVaSAAA7kVVky4AC7kVVky48DDk19ty096Dk10ky0867k10kyF1YXm8AaSF1UnzTSjTzzzzzzzzw", 1)
;tag 商店
FindText().PicLib("|<礼物的图标>*120$34.z0zw3zs1zU7z33w8TwS7VszlwADXz7s1wTw0001zs000Dzk001zzzzzzzzzzzzk03s01007U0000S00001s00007U0000S00001s00007U0000S00001s00007U03zzzzzzzzzzzs07U0zU0S01y01s07s07U0TU0S01y01s07s07U0TU0S01y01s07s07U0TU0S01y01s0DU", 1)
FindText().PicLib("|<简介>*190$37.C3U0707zzU7U7zzk7s7zzsDz3zRkTzszzwzVzDzyTUTbzzDU7bzzUQD3jxkC7Vryw73kvzS3VsRzj3kwCzrVsS7TvlwD3jzlw7Vk3sw3ks1sA1kU", 1)
FindText().PicLib("|<FREE>*200$35.0MDUQ00U70s0z7CTntySQzbnwws70UM1kC1Dk7bwyTXDDtwzDC0k1zSQ3U8", 1)
FindText().PicLib("|<芯尘盒>*200$62.3Us01k00C00wC00Q007k3zzy3bi07z0zzzVxzk7zwDzzsSSy7zzvzzyDbjnzzz3rw7lswzzzUvy1sSD7zzk0w0A71UTzk0DU01k07zw6xsk0Q01zz1zSw0Dw0TzkTnbVzzsDzyDw1szzy3zznz3S7zzUzzwzkzk1s0DzzCzzw0S03ivlbzgTzzvzzy1zs7zzyzzzkDw1zzzDzzu", 1)
FindText().PicLib("|<信用点的图标>*200$29.000s0003s000Ds001vs007bs00Tzs01zrk0Dzbk0zzzk3zzzUTzzzVzzzv7zzzyTzzzlzzzz7jzzw7Dzzk6jzy09zzs0/zzU0Dzy00Dzk00Dj000Tw000TU000S00008004", 1)
FindText().PicLib("|<竞技场商店的图标>*120$42.zzs0DzzzzU03zzzz001zzzy1y1zzzw7z0zzzsTTUzzzswDUzzzkwDUlzylwDUwTsVsDVz7lXsD1zXXXsS3zl7Xk07zs7300Tzs7301zzs73U0Tzs73kETzs33ksDzlVXks7zVlXkw7wrxVUw3szzVUy1kzzk0z01zzk1X03zzs1zU7zzy3zsDzU", 1)
FindText().PicLib("|<水冷代码的图标>15DEF6-0.75$17.0840kM3VkD7kzDVyT7yQTw0zs3zk7zUTz0zy0zs1zk1y00k0E", 1)
FindText().PicLib("|<铁甲代码的图标>FA902D-0.85$20.3kA3yDlzzzTzzzyTzzjzzvzzyzxzzyDzz0Dz0Dy03zU0zs0Tw07z01zk0Ds01s08", 1)
FindText().PicLib("|<风压代码的图标>58F42B-0.85$21.07U01y00DnU7zz7zzsztbS08zzzy7zzVwDkTzs0DzU00A00lU06A00vU03s00A0U", 1)
FindText().PicLib("|<燃烧代码的图标>FD238B-0.79$15.0D03s0z0Ds7zUzwDznzyTzvzzzDzkzy7zkTS3vsSD3VwM7a0Q030080U", 1)
FindText().PicLib("|<电击代码的图标>FB31F5-0.82$12.040A0Q0w1s1s3s7k7kDkDzTzzyzyDw3s3k7U7U70C0A080M0E0U", 1)
FindText().PicLib("|<熔炉>*100$40.60k0k20M3U30A1XzsA0k6Q3Uk7UTkC3PzzlUUzi7r776wkTMsCP31tUC1gC761w0kzwsCs33VnXlsAA3DTjVsk0wTw7n03NVUPQ0Na63Zk3UQMA6041zUkM00760002", 1)
FindText().PicLib("|<代码手册宝箱的图标>*150$71.00000Ts000000000Dky000000000k07000000003k0S00000000SPDzU000000DUQC3s000003s1sy0z00001y0xUHUDk000T0C000M1y03rk3W00060DzCw0k01E11U7XU0Q003k0CA000r00000003A05m00000000t0QU0000000007s01M000S00SCA00000000E6s3U0000003U7U0s000000M0DE0QU0000r03zw07s000Dk0zzy01y0Y1y0DzvzU0S007U3zzbjs0D00s0TznU", 1)
FindText().PicLib("|<废铁商店的图标>*200$40.zw000zzzk001zzy0007zzk000Dzz3zzkzzsTzzVzzVzzy3zwDzzwDzUz7zsTy7w7zVzkzkDz3z3zUDwDsTz0TsTVzz1zUwDzz7z3UzwTzy67zkTzsEzz0Tzk3zy0zz27zw1zsMDzw7zVkzzwTwDVzlzzky7z1zy7wDw1zsTkzs3z3zVzk7sDy7zkTVzwDzlwDzsTzzkzzVzzy7zz3zzkzzw0003zzs000TzzU001zzz000DzU", 1)
FindText().PicLib("|<黄色的礼物图标>*200$22.3sT0Dny1XwM67VUQSCDzDzzwzzznzzzDzzwzzznzzzDzTwzw0000000Dwzkznz3zDwDwzkznz3zDw7wzm", 1)
;tag 方舟
FindText().PicLib("|<左上角的方舟文本>*100$37.zlzzkzzszzsTs00T00M007U0C003k27sDzsVXyDzwMlz01yAEzU0s007k0S003kyD003sz7sXXsTXsElwDlwQ8wDkwDsQC0wDsCDUT7wDjkzzyDU", 1)
;tag 招募
FindText().PicLib("|<SKIP的箭头>*220$19.DtzXwTkS7s70w1UC001000000000830Q3US7kz7szjxzs", 1)
FindText().PicLib("|<确认>*220$52.zzzzzzzbzzyDzyzyTs0sTzlztzU307zXzbzXwMTz7yTyDXlzyTtztyD7zzzbzbk03zzyTyS00DzztzlsQQw3z7z0NvnkDwTw1b7DwzlzVa00znz7yCM03zDwDktbDDwzkzXaQwzny3zCMlnzDs7ytU0DwzaTva00znQMza1nnz1nny0DjDwCD7s0ywzVlyDj3vnyCDwSyTUDvszszvzlzzbzq", 1)
;tag 战斗
FindText().PicLib("|<进入战斗的进>*200$31.nzkwDkzsS7wDwD3z3y7Vzkz1UTss001zw000zy000TzwD3zzy7Vzzz3ky0zVsT0TkwDUC000S7000DXU007ls003sz3sTwTVwDyDVy7z7kz3zXkTVzlsTkzkSTsTk7zzzU0Dzzks0000z0006Ts003", 1)
FindText().PicLib("|<进行战斗的进>*200$25.zzzzzzzzyTnnz7tlzVwszsw8DyM01zw01zzVXzztlz1wszUwADsM01yA00z7XXzXnlzllszskwTwQyDw6zjw0TySQ00DDk07zzzzzzzzk", 1)
FindText().PicLib("|<AUTO的图标>7D8484-0.81$24.07k00zy41zzg7wDwDU3wD01yS03yQ03yw00Cs000s00As00Cs00DM00C000Cs00Cz00Szk0QTU0wTU3sTsDkTzzU8zz00Ds0U", 1)
FindText().PicLib("|<射击的图标>*100$34.zzsTzzzzVzzzzy7zzzzsTzzzzVzzzza6TzzsMMTzz1VUzzsC71zz1sS3zwDVyDzVy7sTyDzzlzzzzzzzzzzzzzzzzzw03zk000Dz0000zw03zzzzzzzzzzzyDzzkzszVz7zVy7sTz3sT3zy7VsTzw663zzsMMTzzlVXzzzq6zzzzsTzzzzVzzzzy7zzzzsTzy", 1)
FindText().PicLib("|<快速战斗的图标>*200$33.zzzzzzzzzzzk7UDzz0S0zzw1s3zzk7UDzz0S0zzw1s3zzk7UDzz0S0zzw1s3zzk7UDzz0S0zzw1s3zz0S0zzk7UDzw1s3zz0S0zzk7UDzw1s3zz0S0zzk7UDzw1s3zz0S0zzk7UDzzzzzzzzzzzzw", 1)
;无限塔胜利或失败会出现该图标
FindText().PicLib("|<TAB的图标>*200$34.zzzzzzzzzzzw1zzzzk7zzzz0Tzzzw1zzzzk7zzzz0Tzzzw1zzzzk7k7zz0T0Tzw1w1zzk7k7zz0T0Tzw1w1s3k7k7UD0T0S0w1w1s3k7k7UD0T0S0w1w1s3k7k7UD0T0S0w1w1s3k7k7UD0T0S0w1w1s3zzzzzzzzzzzzzzzzzzzzzzz00000w00003k0000DzzzzzzzzzzzU", 1)
;特殊竞技场快速战斗会出现该图标
FindText().PicLib("|<重播的图标>*200$41.zzs0Dzzzz003zzzk001zzz0001zzw1zw0xzUDzy0ny1zzz07w7zzz0DkTzzzUD1zzzz0S7zzzw0sTzzzk1UzyzzU33zwTzza7zsTzzwTzkTzzkzzUTzzVzz0Dzz3zy0Dzy7zw0DzwDzs0DzsTzk0TzkzzU1zzVzz0Dzz3zy0zzV7zw3zz67zsDzwADzlzzsQDzbzzVsTzTzz3sTzzzwDkTzzzkTkTzzz1zkTzzw7zkTzzkTzkDzy1zzk7zk7zzk000Tzzs003zzzw00Tzzzz07zzk", 1)
;拦截扫荡会出现该图标
FindText().PicLib("|<点击>*100$39.zlzzwTzyDzzXzzk0zwTzy07U03zlzw00TyDzzXzk01zwTy00D001lzlk006DyD001kzVzwTy00DXXXs03wQQTzzzXXXlAFwQQSMX7U03X6Mw00MslXU03zzzzzyQ", 1)
;判断胜利状态
FindText().PicLib("|<下一关卡的图标>*220$36.zzzxzzzzzwzzzzzwTzzzzwDzzzzw7zzzzw3zzzzw1zzzzw0zzzzk0Tzzw00Dzzk007zz0003zw0001zs0000zk0001zU0003z00007y0000Dy0000Tw0000zs0Dw1zs1zw3zkDzw7zkTzwDzlzzwTzXzzwzzbzzxzzjzzzzzTzzzzzU", 1)
FindText().PicLib("|<编队的图标>*200$32.z3zwDzUDw0zk3zUDw1kQ1y0k30TUA0M7w6061z1U1UzsM0MDz706DzUk3VzkC1k7s1kw0w1s3UC0M0Q1UA030M300M61U060UM01U0600A01U0300k00k0A00A3z003zzk00zzw00Dy", 1)
;红圈
FindText().PicLib("|<红圈的上边缘>FEFE7B-323232$27.0Djk1zxzyzzjzzzxzzzzjzzw00z0000A", 1)
FindText().PicLib("|<红圈的下边缘>*220$27.7zzz0020000E00020000E07020DU", 1)
;tag 模拟室
FindText().PicLib("|<模拟室>*100$62.zzzzzzzzzzzzzzzzzzzzzvxnyzzzzjzwQ0D6DXzUzz601lUsk00DlU0sM6A003k40Q01X000w007000k00D000k00D007w80D683s03z203lW0y00zU00s0wTU0Ds00A0D7k01w00303ly0Az000kM0DU3DkM06603k01w401lU0Q00TVU0wE07U0DwM0C481U00z4311a4E00DlVskzX4003yTzzzzzzzzzzzzzzzzzzzzzzzzzzzzzU", 1)
FindText().PicLib("|<开始模拟的开始>*150$46.zzzzzzzzzzzzzzzzzzzwTlzk007lz7z000D7szw000wTXDzXkz0AATyD3w0llzswDk2DXzXkzW00DyD3y800Q000tU1lk003aTzz000AFk1zkwDk603z7kzUM0DwT3zVXszVwDy2DXwDkzk8yDUz3y0U0w7wDky03kzkz7s0DbzXyzXszzzzzzzzzzzzzzzy", 1)
FindText().PicLib("|<快速模拟的图标>*200$42.zzk07zzzz000zzzw000Dzzk0007zzU0001zz00000zy00000Tw00000Ds00000Ds000007k0U1003k1k3U03U3s7k01U3y7s0103z7w0100zXy0000Tlz0000DsTU0007wDs0003y7w0001z3y0001z3w0003wDs0007wTk000TkzU000zVz0001z3y0003y7w01U3w7s01U3s7k03k0k3U03k000007s000007w00000Dw00000Ty00000zz00000zzU0003zzs0007zzw000Dzzz001zzzzs07zzU", 1)
FindText().PicLib("|<跳过增益效果选择的图标>*170$26.E0U0C0C03s3k0z0z0DwDs3zXzUzyzwDzzznzzzyzzzzzzzzvzzzwzzzyDzTy3z3z0zUz0DUDU3k3U0E0k08", 1)
FindText().PicLib("|<模拟结束的图标>*170$38.03zzzz01zzzzs0zzzzy0Dk00Dk3s001w0w000D0D0003k00000w00000D000003k0U000w0s000D0S0003kDU000w7zzU0D3zzw03nzzz00xzzzk0Dzzzw03zzzz00zzzzk0DDzzw03lzzz00wDzzU0D0y0003k7U000w0s000D020003k00000w00000D000003k3k000w0w000T0DU00Dk3zzzzw0Tzzzy03zzzz00Tzzz2", 1)
;tag 竞技场
FindText().PicLib("|<SPECIAL>*120$40.zzzzzzzzzzzzzyCCARnjkEEUaAz99CGMnwYYt9VDnmHba4zD9CSMHy449tVDwEFba4ztDCSMHzYwtdVDmHnYYoz1DC2H3y4w49A3zzzzzzzzzzzzzs", 1)
FindText().PicLib("|<竞技场>*200$61.zzzzzzzzzzzzzzzzzzzzzzTznyTzzzz007tzDys0zU03wzbzS0TyTDyQ0DjsTzDbw007XwTs00C3wzUsTw007nyTkE0Tzzzty7yw0Dk07ws0TT07s03wA8TjaHwztw7DDrrNyDky7bDvnAzU0zntbw3iTwlztw7s3bDyRzwz3wDrjwSSyS0yznbkT0QQ67zn3sTUSDDXzvXzzzzzzzzzzzzzzzzzzzzy", 1)
FindText().PicLib("|<左上角的竞技场>*150$59.zzzzzzzzzzzzzzzzzzzzzXztyDwzzz007nwTtU3y00Db07n07zbXw0077sTy73s00Q7XzU00kT7s47z003tyDk00TU0TnU3tk0z00z107nk1yDtw2CDbY3wTXsCQTCN7s07swFw0WDs0Ttw7k3ATslrnsDUwNzVXbbUD7lns70AA07z67kz0sMwTyQTzzzzzzzzvzzzzzzzzzzzzzzzzzzzzs", 1)
FindText().PicLib("|<新人>*100$38.zzzzzzzzzzzzzwznzlzy7UTwTy0E7z7zU0Tzlzwl7zwTzAFzz7zU00zUzk00DsDzlk3y3zU4Fz0Ts04Tk7y0F7sMzU4FyC7s0AT3kyE371y3UMlUzkyCAQTyDbz7zzzzzzzzzzzzzzzs", 1)
FindText().PicLib("|<免费>*200$40.zzzzzzzzzzzzzzlzzwFzy0Dw00Ts0zz4Fz7bz007kQTw00z003k00y6CD003wssz7aTnXXUQHz00D00Dw00y00zz0zszXzsXzX6Dz6Cy8szkstw67w7k60w7tz0sTyTzzzzzzzzzzzzzU", 1)
FindText().PicLib("|<ON>*200$36.zzzzzzzzzzzzz0Tjzby07bzXwD7VzXszXUzXszlUTXtzlU7Xlzlb3XtzlbVXtzlbk3sznbw3wTXby3w07bz3y0DbznzUzbzzzzzzzzzzzzzzU", 1)
FindText().PicLib("|<OFF>*120$54.zzzzzzzzzzzzzzzzzzzkTw01s03z07k01U03y03k01U03w01U03007sDUVzz3zzsTkU0D00TsTkU0D00TkTk00D00DkTkU0D00TsTkVzz3zzsTUVzz3zzw71Vzz3zzw01Vzz3zzy03Vzz3zzz07Vzz3zzzkTnzzbzzzzzzzzzzzzzzzzzzzzU", 1)
FindText().PicLib("|<特殊>*100$38.zzzzzzzzzzzzztyTzzDyQ0k4Xw70400z0k1Vk1k7Xw80Q0060070U0U2DmM0MVVzbyAM03sU0000k00E70w307VUD1lXss3yQMyA0TbaD483ty3368yTVtzXzbszzszzzzzzzzzzzzzs", 1)
;tag 无限之塔
FindText().PicLib("|<无限之塔的无限>*150$41.zzzzzzzzzzzzzzU03k00z003U01y00DAXnzwzyN07ztzwW0DzVzsAAT000kMsy001aE1zs3zAU3zsDyM4rzUTwk87z0zs4MDwNxkMkzlnlblVy3X3DU1sT0CT1Xlz0Qy7bzzzxzzzzzzzzzzzzzzzzs", 1)
FindText().PicLib("|<每日通关>*100$62.zzzzzzzzzzzzzzzzzzzzzwzzzzzzzjby07U0tU3ltzU0s0CC1yQTk0CDXlUy01s07XwzU3U0S01szDs0zVzs4S0300Dszs03U0s0300Q00MzD00k03k0CDnk0DsDw07Xww23w3z00s0D0Uw4Ds0C03U043UzwDU0tU13wTzbzzzzzzzzzzzzzzzzzzzzzzzzzzzzs", 1)
FindText().PicLib("|<STAGE>*100$43.zzzzzzzzzzzzzzw30sw3Uy1UQS1kD7syD7szbwS3bwznyD1nyDtz7Utz7wTXkQzXy1ltCMkTUswXAMDyQQFaATzCC8n6Tzb70Nn7zXXUAFXy1ll60kD0sll0MDzzzzzzzzzzzzzzk", 1)
FindText().PicLib("|<无限之塔·向右的箭头>*100$12.3z1zVzVzkzkzkTsTsTsDwDwDw7y7y7z3z3z1zVzVzUzkzkzkzkzVzVzVz3z3y3y7y7w7wDwDsDsTsTkzkzUzVzVz1z3zU", 1)
FindText().PicLib("|<塔内的无限之塔>*200$67.0000000000000000000000000000000140zzbzy0M0lr0Tznzz0C0Pzs0w1jXXzwAzs0A0yzlzzDjs060TTs0D7ns3zzjiQ071ny1zzqzy070zzk1w3Dy070Tzk0y1bjU70C000z0znk707zw0vXTNkD07zy0tngDsT03X71szq7zTzw1zUsDn3nATw0zk0000000000000000000000E", 1)
;tag 拦截战
FindText().PicLib("|<拦截战>*140$63.zzzzzzzzzzznzzzDDzzxzySSTUsbwz5znlXs14TbsbyDAz0MnwL4z0U1s24TUMzs006001w30zVU1k00DXU3yTzz0szww0znzzs36TXkby7zz00XU74z0k3k1Uw0Q7kA0C0A7X3Uz3k3s1UwQQDyTzz0ADXXVznzzs1VQQQTyTzz0M9U30TX00s00A003sM07003X0MT7zztzwyyzbzzzzzzzzzzzzzzzzzzzzzU", 1)
FindText().PicLib("|<红字的异常>BF0200-0.81$44.0000000000000000000Fl03zzUSQw0zzs7bD0Dzy7zzw3k7Vzzz0zzsS03kDzy7Tzw3U0trzz0zzy1kQ0DzzUTz00zzU7zk0C3U07U03Us1zzkDzzsTzy3zzy7zzUzzzVlts3kC0QSS1w3U77zUS0s1lrk60C00QU000000000000000U", 1)
FindText().PicLib("|<克拉肯的克>*200$43.zzz0zzzzzzUTzzzzzkDzzzzzs7zzy00000070000003U000001k000000s000000Tzzs7zzzzzw3zzzzzy1zzzzzz0zzzzU0000Dzk00007zs00003zw00001zy00000zz0zzzUTzUzzzkDzkTzzs7zsDzzw3zw00001zy00000zz00000TzU0000Dzk00007zs00003zzs3s3zzzw1y3zzzy0z1zzzz0zUzzzz0TkTzzzUDsDwDzUDw7y1zU7y3z0z07z0zUw03zUTUE03zk00803zs00607zw007U7zz003kDzzk03wzzzzzzs", 1)
FindText().PicLib("|<镜像容器的镜>*200$44.zTzzy7zzUzzy1zzsDz0003w1zk000z00Q000DU070003k01y1s1w00TUz1y007sDkT0Tzy3s7kDzzUS1w3zw0001Vzz0000M00k000700A0001s03zzzzy00zzzzzk0DU007z0zk001zkDw000Tw3z0zs7z0zkTz1zUDw7zkS0070007U01k001s00Q3zUS0071zw7k01kTz1zkDw000Tw3z0007z0zk001zkDzUM7zw37s71zz01y3kTzk0TUw7zs07kD1zy01s3kQz01w1w73k1y0T0Uw0y0Dk0DUzU7w07szw7zU1zTzXzy3s", 1)
FindText().PicLib("|<茵迪维利亚的茵>*200$47.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzkDz0zzzzUTy1zzzz0zw1zzk000000zU000001z0000003y0000007w000000Dzz0zw3zzzy1zs7zzzzzzzzzzzzzzzzzzU00000Tz000000zy000001zw000003zs000007zkTzzzsDzUzw7zkTz1zsDzUzy3zkTz1zw7000C3zsC000Q7zkQ000sDzUs001kTz1k003Uzy3zU7z1zw7z07y3zsDw03w7zkTs03sDzUz003kTz1s0k3Uzy303k31zw70DkC3zsD0zkQ7zkT7zlsDzUyzzrkTz000000zy000001zw000003zs000007zk00000DzU00000Tz1zzzzUzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzz", 1)
FindText().PicLib("|<过激派的过>*200$43.zzzzzkDzzzzzs7z7zzzw3z1zzzy1z0Tzzz0zU7zzzUTs3zzzUDy0zzzk7zUC00007kD00003wTU0001zTk0000zzs0000Tzzzzk7zzzzzw3zzzzzy1zzzwTz0z03s7zUTU1w1zkDk0z0Ts7s0TUDw3w0Ds3y1zs7y0z0zw3zUTUTz1zkTkDzUzwzs7zkTzzw3zsDzzw1zw7zzy0zy3zy00zz1zz00Tz0zzU0DzUTzs0DzU7zw0Tz01zzzzz007zzzz000Dzz00000000070000047s000077z00003bzw0001vzzzzzzk", 1)
FindText().PicLib("|<死神的死>*200$42.U00000100000000000000000000000000000000001zUDz0zzzUTz0zzzUTz0zzz0Tz0zzz0Tz0zzz00D0zzy0030zDy0030y7w0030w3s0030s3s3s3001k7s7003UDs700D0Ts700T0TsD01z0nkD07zVVkD0DznU0T0zzz00T0zzzU0T0zzzk0z0zzzs0z0zzzs1z0zzzs3z0zzzk3z0zXzU7z0zUz0Dz0zUy0Tz0z0s0Tz0C0k0zzU0101zzU01U7zzU01kDzzk03szzzy0TU", 1)
FindText().PicLib("|<异常拦截·向右的箭头>*20$33.s00zzz003zzw00Dzzk00zzz003zzw00Dzzk00zs3003z0400Dw0E00zk1U03z0600Dw0E00zk1U03z0600Dw0M00zk3007w0M00z0600Dk1U03w0M00z0400Dk1003w0E00z0400Dw1003zzk00zzw00DzzU03zzk00zzy00DzzU03zzs00zzw", 1)
FindText().PicLib("|<01>*100$18.zzzzzzwC7k43k03k23lX3lX3lX3lX3lX3lX3lX3lX3lX3lX3lX3lX3lX3lX3lX3lX3k33k33s77zzzzzzU", 1)
FindText().PicLib("|<02>*100$22.zzzzzzzz3wTs30T001w003kU4D60EwMH3lVwD67kwMT3lVUD641wM0DlU7z60TwM1zlU7z60TwM1zkU7z001w0U7w60TzzzzzzzU", 1)
FindText().PicLib("|<03>*100$22.zzzzzzzzVwDs30T040w003kk6D30MwA1XklyD37swATXklkD371wAQ7klyD37swATXkl6D30MwA1XkU6D040y0E3w3UTzzzzzzzU", 1)
FindText().PicLib("|<04>*100$22.zzzzzzzz3yDs3kT0D1w0M7lVUT661wMM7lV0T64FwMF7lUAT60lwM37lU8T600wM03lU0D67lwMT7kVwT07lw0z7s7wTzzzzzzzU", 1)
FindText().PicLib("|<05>*100$22.zzzzzzzz3k7s20T001w007lU7z60TwM1zlU7z603wM07lU0D66EwMT3lVwD67kwMT3lVAD60EwM13kU4D000w0k7w7UzzzzzzzzU", 1)
FindText().PicLib("|<拦截战·进入战斗的进>*200$27.nzXlwDwSDkzXlz3wSDw800Dr001zs00DzwQDzzXlzzwSDUTXls3sA7UM007X000wQ00DXsSDwT7lzXkyDwQDlzXVyDsSTly0zzzU0zz0Q000bs007zs01U", 1)
FindText().PicLib("|<拦截战·快速战斗的图标>*200$34.zzzzzzzzzzzy0w1zzw1s3zzs3k7zzk7UDzzUD0Tzz0S0zzy0w1zzw1s3zzs3k7zzk7UDzzUD0Tzz0S0zzs3s3zz0T0Tzs3s3zz0T0Tzs3s3zz0T0Tzs3s3zz0T0Tzs3s3zz0T0Tzs3s3zz0T0Tzzzzzzzzzzzzy", 1)
;tag 前哨基地
FindText().PicLib("|<前哨基地的图标>*100$23.S032C0A8C0kUD3287A887kVA7X6A3gQ63kk63nA61wQ21wQ30wQ30xy30zS1UQC1UES1U3D1kAD0kkr0n37Uw63UEM3U1UDV", 1)
FindText().PicLib("|<溢出资源的图标>*100$21.zsTzwtzyTnyDzbbzz8zzs1zw03yA077U03w01zU0Dw01zU0Dw01zY0Dls1szkATzUDzz7zU", 1)
FindText().PicLib("|<歼灭>*150$47.zzyDU006020C0004000A0000000M000M0U7w001s3sTzw7zk3kzwsTT03VzskwC0D3zVUsQ800D31UkE00Q633U000sQ470001Uk0S0DVzXU1y0T3zy0DzUy7zw0Tz3wDzkETw7sTz0kDkTkzs3k61zVy0DU07z3w0zk4Ty7s7zkRzwDszzwk", 1)
FindText().PicLib("|<获得奖励的图标>*200$38.zzzzzzzzzzzzzzzsTzzzzy7zzzzzVzzzzzsTzzzzy7zzzzzVzzzzzsTzzzzy7zzzzzVzzzzzsTzzzzy7zzzzzVzzzzs00Tzzy007zzzk03zzzw01zzzzU0Tzzzw0Dzzzz07zzlzs1zkwTz0zwD7zkTz3lzy7zkwTznzwD7zxzz3lzzzzkwTzzzwD7zzzz3lzzzzkwTzzzwD3zzzz3k00000w00000TU0000Dy00007zzzzzzzzzzzzzU", 1)
FindText().PicLib("|<派遣公告栏的图标>*200$58.zzzzszzzzzzzzy0zzzzzzzzk0zzzzzzzw00zzzzzzz001zzzzzzk1k1zzzzzy0Tk1zzzzzU3zk1zzzzs0zDk3zzzy0DkDU3zzzk3wQTU3zzw0T7wTU3zz07kzwT07zk1yDzwT07y0TXzzsz07U3sTzzsz040z7zzzsz00Dlzzzzky03wTzzzzly0D7zznzzls0szzy7zzlU3jzzkDzza0Czzy0TzyM0vzzs3zztU3jzzkTzza0CzzzXzzyM0vyzzTzztU3jvzzzyza0CzbzzzvyM0vyDzzzDtU3jszzzsza0CzVzzzXyM0vy7zDwDtU3jsDkTkza0CzUy0y3yM0vy1k1sDtU3js6010za0CzU0003yM0vy0000DtU3js0000za0CzU0003yM0vy0000DtU3jy0001za0Czy000TyM0tzw007ztU3Xzw01zyC0DXzw0TzVs0T3zw3zwT00T7zszz7s00z7zzzly080z7zzwDU3s0z7zzXw0zs0yDzsz07zs1yDyDk1zzk1yDVw0Tzzk1yAT07zzzk1w7s0zzzzk3xy0DzzzzU3zU3zzzzzU3w0zzzzzzU307zzzzzzU01zzzzzzz00Tzzzzzzz07zzzzzzzz0zzzzzzzzzDzzzzU", 1)
FindText().PicLib("|<派遣公告栏的派遣>*100$68.000000001w01U00DU000T00S00zw1kDzzsDkTzzUy3zzy3zTzzkDkyT7UDbzz01yDzzs1tzs00Dnzzy04T0001sTzzU07k3s0A07k001wTz00DzzzW0TDzs03zzzts7nzw000000T1wzs000000DwTDS0TsTzz1z7nrU7y7zzk7Vwws1zVs0w0ESDDMTsTzz007Xnz0S7zzk01swzs7Vzzw08SDDw1sS00077Xlw0S7zzs1tswS07Vzzy0ySD7U1sTzzUD7Xlw0S7U1s7nswD07Vzzy1swD3s1wTzzUyD3yz1zU000D7lzbszz000LlwTxyTzzzzxwS7wD3lzzzyCDVw1UsDzzzVVkA0M60Tzzs04000000Dy0U", 1)
FindText().PicLib("|<全部派遣的图标>*200$35.00Ty0007zz000zzzU03zzzU0DzzzU0zzzzU3zzzzUDzzzzUTzzzzVzbwzz3y7kzz7w7UzyTw3Uzwzw3Uztzw3Uzzzy3Uzzzy3Uzzzs71zzzUQ7yzy1kTxzsD1znzUw7zXy3kTz7wDVzwDwzbzsDzzzzkTzzzz0Tzzzw0Tzzzk0Tzzz00Tzzw00Dzzk007zy0003zU08", 1)
;tag 咨询
FindText().PicLib("|<妮姬的图标>*150$32.zztzzzzk3zzzk0Dzzs01zzw00Dzy001zzU00Tzk003zw000zz000DzU003zs000zz000Dzk003zw000zzU00Tzs00Dzz003zzs01zzz00zzzw0zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzw00001000000000000000000000M0000600003k0000w0000TU0007s0003z0000zk000Dy0007zU003zs000zz000Dzs007zy001zzU00zzw00Dzz003zzs01zzy00Tzzk0Dzzw03zzzU1zzzs0Tzzz0Dzzzk3zzzw1zzzzUTzzzwDzzzz3zzU", 1)
FindText().PicLib("|<咨询的图标>*150$31.z7zwTzXzyDzlzz7zszzXyAM0lU6A0Mk360AM1X06A0zU3y0Tk1z0000000000000000000003zzzzVzzzzkzzjzsTzXzwDzUzy7z07z3zU7zVzs3zkzw3zsTy1zwDzizy7zzzz3zzzzVzzzzkzzzzs00000U0000E", 1)
FindText().PicLib("|<》》》>*200$36.D0S0w0TUz1y0zlz3y0zlzXz0TsznzUTszlzUDwTtzkDyTwzs7zDyTs3z7yDw3zbzDw1zXz7y1znzbz1zXz7y3zbzDy3z7yDw7zDyTsDyTwzsDwTtzkTszlzUTsznzUzlzXz0zlzXy0TUz1y0D0S0w0U", 1)
FindText().PicLib("|<20/>*200$23.T002z3sBiDkMCtkkxnXVnb67bCASCQtsQtbwtnDwzCDlwM000k003000600048", 1)
FindText().PicLib("|<MAX>*190$49.0000000000000000301001s7Vk1k60S7Uw1s7U7bkT1w3k3nkDvy3w0zk7zz1y0Dk3bnVzU3k1llktk1s0s0sww1y0Q0QQC1zUC0CS7Vts707C1kwS3U3j0wwD1k1r0Cw3k0000000000000000U", 1)
FindText().PicLib("|<收藏的图标>FE4431-0.90$32.zzzzzzzzzzzzzbzzzzkzzzzwDzzzy1zzzzUTzzzk3zzzw0Tzzw03zzk003z00003k0000w0000TU0007w0003zU001zw000zzU00Tzw007zz003zzk00zzs007zy001zzU00Tzs007zy1y1zzVzsTztzzbzzzzzzzzzzzs", 1)
FindText().PicLib("|<快速咨询的图标>*200$32.zzzzzzzzzzz0S0zzs3k7zz0S0zzs3k7zz0S0zzs3k7zz0S0zzs3k7zz0S0zzs3k7zz0S0zzk7UDzs3k7zw1s3zy0w1zz0S0zzUD0Tzk7UDzs3k7zw1s3zy0w1zz0S0zzzzzzzzzzzzy", 1)
FindText().PicLib("|<咨询的咨>*200$30.zzXzznz3zzkz3zzkD001wC000zC001zwC3VzsS7VzsS7Xzsy3Xznw3zy3w1zU3s0z0DUMT1y0s7bs3y0zs7z1zwzztzwzzzw0007w0007w0007wDzw7wDzy7wDzy7wDzy7wDzw7w0007w0007w0007wDzw7U", 1)
FindText().PicLib("|<咨询·向右的图标>*200$28.03zzy0Dzzw0Tzzk0zzzU3zzz07zzw0Dzzs0zzzk1zzz03zzy0Dzzw0Tzzk0zzzU3zzz07zzw0Dzzs0zzzk1zzz03zzy0Dzzw0Tzzk0zzzU3zzz07zzw0Dzzs0zzzk1zzz03zzy0Dzzs0zzz07zzs0TzzU3zzw0DzzU1zzy0Dzzk0zzy07zzs0zzz03zzw0TzzU3zzw0DzzU1zzy0Dzzk0zzz07zzs0zzz03zzw0TzzU3zzw0Dzzk1zzy0Dzzk0zzz07zzs0zzz03zzy", 1)
FindText().PicLib("|<0/>*220$21.Dz1vzwDTzXnkQSQ3nrUSww3rbUSwQ3bXzxsTzj1zts1sC4", 1)
;tag 奖励
FindText().PicLib("|<任务>*150$44.00000000000000010207000wTk3s00Dzs1zzU7Ds0zzs3kC0TVw0s3U7ww0S0s07z0DUC0Dzw1w7sDwzkTzzVk0M1rzs0Q00Q3U0DV060s1zzs1UC03xy0M3U0Q3U60s0C0k1XzsD0Q0MzyDVz063g1UT0000000000000002", 1)
FindText().PicLib("|<奖励>*150$43.000000000000000A4000006707zA0n7z3za0TzzVzn04z1kk1U0ttkTzz1wDsDzzVy7sDyTkrzk7Q6M1rk3jXA0n01rta01U0vwn3zzwRyNVzzyCqQkzzz7PAM0TU3xyA0zw1wzC7yDszzj3w3wzzj0U04003000000000000000U", 1)
FindText().PicLib("|<灰色的全部>#529-0.90$40.08000001k01UT07U0D3z1z07zjwDz0TyvVsy0tniT0y3bCvw3yCQzDzzlzzwDzyDzzk1s0TzvU30003a0z03zCMTzUTytVzy1zvi0S073js1s0QCz7zzVzvUzzz7zi1zzsQSk8", 1)
FindText().PicLib("|<浅红点>*150$19.zzzzzzzsDzk3zlwTlzDtzntztwzySTzDDzbbzbtznwTlz7Vzk1zy3zzzzzzzk", 1)
;tag 活动
FindText().PicLib("|<作战出击的击>*200$37.zzw7zzzzy3zzzzz1zzy3zUzzz000DzzU000Dzk00001s00000zz0000Tzz000DzzkDw7zzsDzz0Tw7zzU001zzk0001zs000004000001zk0000zzs000Tzy1z0C3z1zzz0zUzzzUTkTkTkDsDs7s7w7w3w3y3y1y1z1z0z0zUzUTU1UDkDk003s7s00003w00001zk0000zzzU00Tzzzy0Dzzzzs7zzzzzrk", 1)
FindText().PicLib("|<活动地区>*150$74.zzzzzzzzjzzztz0zzXzDlz00640S0MznYTU01n0TkCDwt7sTlzz7zz0SCECDyzzlzzU20U1XD7i01U00k80MlVkU0M1WC81CA0yDlz3tXm0HXkTzwTtyMwl4sw7zy7wPaDCFCC0zg0D6NXUY3X27l03l0Ms95sVkslws06A6Py9ySATC03b7btXzz703bklzswM00Fk0zyETy06003wSDzyDzk7k01U", 1)
FindText().PicLib("|<签到>*200$35.nszzzt0U706k00T0NV4tyAnDVzwFqT1zs1AsMzk2N0kDxyk02Dtxbwzy0vDvzs0qNnbyDgtbTyTtzwzs7nzky0D000Q7wDzzzztk", 1)
FindText().PicLib("|<全部领取的全部>*140$40.0S00s7k3s03kzkTk1zvz3zk7zywTDUTyvbkTUtniz0zXbDnzzyTzzDzznzzw7zsDzys1s000vUDk0znb7zs7ziQTzUTyvk7U1lvy0S077jtzzwTyuDzzlzvUzzz7zi2", 1)
FindText().PicLib("|<STORYⅠ>*200$71.kC03s7w0syTt0C0D03s0tszkTzXyD7nllnzUzz7sz77nnbz0zyDlyDDbaTyETwTXwSSDUzwkDsz7sw0T1ztsDlyDlk1y7znwTXwTXV7yDzbwz7syDb7wTz/lyDswTD7szy03wTs1ySDlzwUDszs7wyDXzt", 1)
FindText().PicLib("|<剧情活动>*150$75.zzswzDyzszzlw0D7Y03VU3U6DU10w00w81w0lwS8700DvUTzyDU10k00zzXzz040861Uzy01zs0X70UU0Mk0A0l4084407201U68U00Uk0yzXzDn4087a07zwTtiMX70wlszM0S8n4087a07l03l4MU18wk0y8yQ0307D7a07X7nU0t0lswk0sswQC6A0A7aS7703zk1s1lwnkxs0TzATzyTiSTzjrzzzU", 1)
FindText().PicLib("|<时间>*150$40.zztzzzzzzblU003yTW000DtzA00M01zzy1U07Dzs680Qk1U8zbn0603STASM08twltUMlbn061X6TA0M6C9wltU8zbn7a03yTA0M0Dtwk1UTzbnzy9zUTDzkzy1wzz7zzznzws", 1)
FindText().PicLib("|<活动关卡>*150$74.rz7zyDyTXzszss0w1XzXszyDy40y0MzwwTzU3vUTzyDy63zs0zz7zy0C00DyDzw07zU3U03zXz601U68zszs00Ek0M1WDyDy003TlzbtX003U00zwTtiMk00Tszyk0wFaA007y7z40DAFXz1zzUDl7nk0MzUDzs0slws0CTk1zyA4QSC7X7kQ3zXv703zk1kDUTszvk0zyMwDyDzDzyzzzzzzzzzrzU", 1)
FindText().PicLib("|<REPEAT>*150$57.zzzzzzzzzzzzzzzzzzzk70k70yS0S0k60M7Xs3naDnXDwTnyQlyQNzVyTnaDnXDwDnyQlyQNzdyTnaDnXDtDnyEkCQMDByTmC7k3DtbnyHly0tzAyTmCDnzDtbnyNlyTty0yTnCDnzDk7nyMlyTtySSTna0nz0nnnyQs6Ts6SSTzzzzzzzzzzzzzzzzzzzU", 1)
FindText().PicLib("|<挑战>*200$41.zzzzzzzzzzzzzzntDyT7zbmTwy9z647synw08DkQzk0ETXkDskVzD0Tll7yS0zXmDsyBy34D0C3sAMC0Q7skkQwsTtVattsznXDnnXzb6PX74zAQn081wNsCA37tzsTzzDzzzzzzzzzzzzzw", 1)
FindText().PicLib("|<挑战关卡>*150$75.lt7yTbzDlzwTyD8znwbsyDzXzlt5yTYzbXzw0Q087kArsMDzU3U11y1bw00TwTwA8Dnk3U03zXzll3yS0TwTw00CD8znkzzXzU00kt3k3UM00Q00048C0Q7001zXzV10lXUs00DyDy88aSQDz1zzkDlV7nnlzk7zy0SCMiCQ/w0Tzn1lX4k10S3UTyTQ8s60030y1znzXDUlkMMTwTyTyzzzzzzzzzzrzU", 1)
FindText().PicLib("|<红色的关卡的循环图标>B40000-0.70$61.00000000000000000000000000000000000000000000000000000000000000000000000000001U000000000w000000000TU0000003zzsDzs0001zzz7zw0000zzzvzy0000Tzztzz0000DzzkzzU0007kTU07k0003sD003s0001w7001w0000y2000y0000T0000T0000DU000DU0007k0007k0003s0063s0001w00D1w0000y00TUy0000T00TkT0000DzkzzzU0007ztzzzk0003zwzzzs0001zy7zzw0000000zU000000007k000000001s000000000A00000000000000000000000000000000000000000000000000004", 1)
FindText().PicLib("|<黄色的关卡的循环图标>F5A317-0.60$49.0000000000000000000000000000000000000000000000000000A00000007U0000003w00000Dzz1zy00DzzszzU07zzyTzk03zzyDzs01zzw7zw00y3w00y00T1s00T00DUk00DU07k0007k03s0003s01w0001w00y0000y00T000kT00DU01sDU07k03w7k03s03y3s01zy7zzw00zzDzzy00TzXzzz00DzkTzz000007w0000000y0000000700000000U000000000000000001", 1)
FindText().PicLib("|<协同作战的协同>*200$39.zzzzzzzzzzzzztyzzzzzDrz003twTs00TC0TDznkU3tU6S30TA0nkwntzyTAa7DzntYktU6TBa7AMnsAkNbaTDC3AwnttntU6TCCTA1ntXntryTAkTDz3tj7tzszzzzzzzzzzzzzw", 1)
FindText().PicLib("|<任务的图标>*142$28.zzbzzzw7zzz27zzkyDzwDQDz3twDsTbwC7yDwNzkzw7y1zkTs3z1z07w7k0DkS00D1U00A4000EQ0071w01w7s0TkTk3z1zUTwbz1zmDwDyADszVwTbsTsTS7zsTVzzsQTzzs3zzzszzU", 1)
;tag 协同作战
FindText().PicLib("|<开始匹配的开始>*200$54.zzzzzXzXzzzk0zXzVzU000TXzXzU000TXz3zk000T3z7DzXyDw0S77zXyDw0CD3zXyDw0ADXzXyDy08T1zXyDz6000zXyDy4000U000CAM000000CAPzt0000CATzzU000S4Q03z3yDy0M01z3yDz0s01z3yDzUsTVy7yDzkMTVy7yDzU8TVwDyDzU8TVsDyDz28TVkTyDy7M01UzyDw7s01lzyDyDs01vzyDzzwznU", 1)
FindText().PicLib("|<普通>*200$67.0C0600000000T07s001zzy0Dk3s0D0zzzU3s3w0DkTzzlzzzzw7w7zzkzzzzy1z0SDkTzzzz0TkTzk7zzzzU7sDzk1sySD01k1zs0yTD7U0ETzzsTDbbk00Dzzw7bnnk007zzy3nvts003tyTTzzzzs01wzDjzzzzwzszzzrzzzzyTwTzzvzzzzzDyDzzw000007z7nsy3zzzw0DXzzz1zzzy07lzzzUzzzz03szzzkTzzzU1wTzzsDU07k0yDXlw7zzzs0T7lzy3zzzw0DXsxz1zzzy07lwSz0zzzz07wwDD0T00DU7zk000DzzzkDzzzzy7zzzs7tzzzz3zzzw1sDzzz1zzzy0M1zzzUy00z0000Q04", 1)
FindText().PicLib("|<准备>*200$52.zzzzzyTzzzlXzzkzzlyC7zy00z7swTzk00yDXlzy007sQ00DUDkzlU00w0S7z67VzlU0zwkT7zz07zy1wTzw0Dzk007s000T000A07U0yE01s3zk7z7lzUTznyQT7zk00DslsTz000z3003wS7XwQ00TlsSDVlwTz000y77lzw003swT7zlsSD3k00z7VswT001w003tw00Dk00Dzlzzz000y", 1)
;tag 剧情模式
FindText().PicLib("|<SKIP的图标>*200$20.7szky7w7Uz0M3k20Q00100000040030M3kC1wDVz7sznyTy", 1)
FindText().PicLib("|<1>*200$10.zzzz3kD0zXyDszXyDszXyDszXyDzzzU", 1)
FindText().PicLib("|<2>*150$14.zzzzzU7k0w0D7XzszkDk3s3w7z7zlzw0D03k0zzzzzU", 1)
FindText().PicLib("|<AUTO>*200$66.z3zXyD00S03y1zXyD00Q01y1zXyD00Q01y1zXyDyDwDkwEzXyDyDwTkwMzXyDyDwTkwMzXyDyDwTksMTXyDyDwTkswTXyDyDwTkswTXyDyDwTkkwTXyDyDwTkk0DXyDyDwTkk0DXyDyDwTkU0DXyDyDwTkVy7XyDyDwTkXz7VwDyDwDkXz7U0DyDw013z3k0DyDy017z3s0zyDz03U", 1)
FindText().PicLib("|<灰色的星星>5B5D5F-0.90$26.00E000C0007U001w000z000Ds007y001zk0DzzszzzzzzzzxzzzyDzzz0zzzU7zzk0zzs0Dzw03zzU0zzs0Dzy07zzU1zjs0TUy07U7k1U0Q8", 1)
FindText().PicLib("|<记录播放的播放>*200$53.sTzlztz3zks01zVy7zVk03z3wDz3U0Dz7sTy7W4D00kzk328y0100U601w02010000w7w03VU01wDkMD3U03sTUky7k0Tk01VwC00TU037s08ED000DU0sky480Q0003w8S0w3U07sEw3s700DlVs7wC4ATX3sDsQ00y67kTks01wAD0TVk03sMM0T3V37VkU08700C001UES00SA67Vkw00ysQzb", 1)
;endregion 识图素材
;region 运行前提示
if g_numeric_settings["Username"] != A_Username
    ClickOnHelp
if g_numeric_settings["Username"] != A_Username {
    N := Random(1, 2)
    if N = 1 {
        verify := "你是否想继续程序"
    }
    if N = 2 {
        verify := "你是否想关闭程序"
    }
    Result := msgbox(
        (
            "你是" A_Username
            "`n反馈任何问题前，请先尝试复现，如能复现再进行反馈，反馈时必须有录屏和全部日志。"
            "`n如果什么资料都没有就唐突反馈的话将会被斩首示众，使用本软件视为你已阅读并同意此条目。"
            "`n==========================="
            "`n人机检测：" verify
            "`n可以在配置文件settings.ini中将Username改成自己的永久关闭提示"
            "`n==========================="
            "`n鼠标悬浮在控件上会有对应的提示，请勾选或点击前仔细阅读！"
            "`n==========================="
            "`n1080p已做适配，但以下功能由于周期问题暂时无法正常使用："
            "`n废铁商店、模拟室超频、冠军竞技场、反派之路、花絮鉴赏会、普通协同作战、单人突击、每日免费招募"
            "`n想适配的话务必在功能开放当天提醒我！"
        ), , "YesNo")
    if (Result = "Yes" and N = 2) or (Result = "No" and N = 1) {
        msgbox("人机检测失败，你有认真看公告吗？")
        ExitApp
    }
}
;endregion 运行前提示
;region 创建gui
doroGui := Gui("+Resize", "DoroHelper - " currentVersion)
doroGui.Tips := GuiCtrlTips(doroGui) ; 为 doroGui 实例化 GuiCtrlTips
doroGui.Tips.SetBkColor(0xFFFFFF)
doroGui.Tips.SetTxColor(0x000000)
doroGui.Tips.SetMargins(3, 3, 3, 3)
doroGui.MarginY := Round(doroGui.MarginY * 0.9)
doroGui.SetFont("cred s11 Bold")
TextKeyInfo := doroGui.Add("Text", "R1 +0x0100", "关闭：ctrl + 1 终止：+ 2 调整窗口：+ 3")
doroGui.Tips.SetTip(TextKeyInfo, "DoroHelper 快捷键提示：`r`nCtrl+1: 立即关闭程序`r`nCtrl+2: 暂停当前正在执行的任务`r`nCtrl+3: 初始化程序并尝试调整游戏窗口至推荐状态")
LinkProject := doroGui.Add("Link", " R1 xs", '<a href="https://github.com/kyokakawaii/DoroHelper">项目地址</a>')
doroGui.Tips.SetTip(LinkProject, "点击访问 DoroHelper 在 Github 上的官方项目页面，可以获取最新版本、查看源码或反馈问题")
doroGui.SetFont()
BtnSponsor := doroGui.Add("Button", "R1 x+8", "赞助")
doroGui.Tips.SetTip(BtnSponsor, "如果你觉得 DoroHelper 对你有帮助，可以考虑点击这里支持开发者，激励项目持续更新与维护")
BtnSponsor.OnEvent("Click", MsgSponsor)
BtnHelp := doroGui.Add("Button", "R1 x+8", "帮助")
doroGui.Tips.SetTip(BtnHelp, "点击查看 DoroHelper 的详细使用说明、注意事项以及常见问题解答")
BtnHelp.OnEvent("Click", ClickOnHelp)
BtnUpdate := doroGui.Add("Button", "R1 x+8", "检查更新")
doroGui.Tips.SetTip(BtnUpdate, "手动检查 DoroHelper 是否有新版本发布。建议定期检查以获取最新功能和修复")
BtnUpdate.OnEvent("Click", ClickOnCheckForUpdate)
BtnClear := doroGui.Add("Button", "R1 x+8", "清空日志")
doroGui.Tips.SetTip(BtnClear, "点击清除下方日志标签页中当前显示的所有运行记录")
BtnClear.OnEvent("Click", (*) => LogBox.Value := "")
Tab := doroGui.Add("Tab3", "xm") ;由于autohotkey有bug只能这样写
Tab.Add(["设置", "任务", "商店", "战斗", "奖励", "日志"])
Tab.UseTab("设置")
cbAutoCheckUpdate := AddCheckboxSetting(doroGui, "AutoCheckUpdate", "自动检查更新", "Section R1.2")
doroGui.Tips.SetTip(cbAutoCheckUpdate, "勾选后，DoroHelper 启动时会自动连接到 Github 检查是否有新版本")
AddCheckboxSetting(doroGui, "isPreRelease", "测试版渠道", "x+5  R1.2")
MirrorChyan := AddCheckboxSetting(doroGui, "MirrorUpdate", "改用Mirror酱", "R1.2 xs+15")
doroGui.Tips.SetTip(MirrorChyan, "Mirror酱是一个第三方应用分发平台，让你能在普通网络环境下更新应用`r`n网址：https://mirrorchyan.com/zh/（付费使用）")
MirrorEditControl := doroGui.Add("Edit", "x+5 yp w145  h20")
doroGui.Tips.SetTip(MirrorEditControl, "输入你的Mirror酱CDK")
MirrorEditControl.Value := g_numeric_settings["MirrorCDK"]
MirrorEditControl.OnEvent("Change", (Ctrl, Info) => g_numeric_settings["MirrorCDK"] := Ctrl.Value)
cbAdjustSize := AddCheckboxSetting(doroGui, "AdjustSize", "启用窗口调整", "xs R1.2")
doroGui.Tips.SetTip(cbAdjustSize, "勾选后，DoroHelper运行前会尝试将窗口调整至合适的尺寸，并在运行结束后还原")
cbOpenBlablalink := AddCheckboxSetting(doroGui, "OpenBlablalink", "任务完成后自动打开Blablalink", "R1.2")
doroGui.Tips.SetTip(cbOpenBlablalink, "勾选后，当 DoroHelper 完成所有已选任务后，会自动在你的默认浏览器中打开 Blablalink 网站")
cbSelfClosing := AddCheckboxSetting(doroGui, "SelfClosing", "任务完成后自动关闭程序", "R1.2")
doroGui.Tips.SetTip(cbSelfClosing, "勾选后，当 DoroHelper 完成所有已选任务后，程序将自动退出`r`n注意：测试版本中此功能可能会被禁用")
TextToleranceLabel := doroGui.Add("Text", "Section +0x0100", "识图宽容度")
doroGui.Tips.SetTip(TextToleranceLabel, "调整图像识别的相似度阈值`r`n数值越高，匹配越宽松，更容易识别到目标但也可能发生误判`r`n数值越低，匹配越严格，准确性更高但可能错过一些稍有差异的目标`r`n请根据你的游戏分辨率和缩放情况适当调整")
SliderTolerance := doroGui.Add("Slider", "w200 Range100-200 TickInterval1 ToolTip vToleranceSlider", g_numeric_settings["Tolerance"] * 100)
doroGui.Tips.SetTip(SliderTolerance, "拖动滑块来调整识图的宽容度`r`n范围从 1.00 (最严格) 到 2.00 (最宽松)`r`n具体数值会显示在右侧的文本框中")
SliderTolerance.OnEvent("Change", (CtrlObj, Info) => ChangeSlider("Tolerance", CtrlObj))
toleranceDisplayEditControl := doroGui.Add("Edit", "x+10 yp w50 ReadOnly h20 vToleranceDisplay", Format("{:.1f}", g_numeric_settings["Tolerance"]))
doroGui.Tips.SetTip(toleranceDisplayEditControl, "当前识图宽容度的精确数值，由左侧滑块控制")
BtnSaveSettings := doroGui.Add("Button", "xs R1 +0x4000", "保存当前设置")
doroGui.Tips.SetTip(BtnSaveSettings, "点击此按钮会将当前所有标签页中的设置（包括开关选项和数值调整）保存到配置文件 (settings.ini) 中，以便 DoroHelper 下次启动时自动加载")
BtnSaveSettings.OnEvent("Click", SaveSettings)
TextMiaoMiaoTitle := doroGui.Add("Text", " R1 +0x0100", "===妙妙工具===")
doroGui.Tips.SetTip(TextMiaoMiaoTitle, "这里提供一些与日常任务流程无关的额外小功能")
TextStoryModeLabel := doroGui.Add("Text", "R1.2 Section +0x0100", "剧情模式")
doroGui.Tips.SetTip(TextStoryModeLabel, "尝试自动点击对话选项`r`n自动进行下一段剧情，自动启动auto")
AddCheckboxSetting(doroGui, "StoryModeAutoStar", "自动收藏", "x+5  R1.2")
AddCheckboxSetting(doroGui, "StoryModeAutoChoose", "自动抉择", "x+5 R1.2")
BtnStoryMode := doroGui.Add("Button", " x+5 yp-5", "←启动").OnEvent("Click", StoryMode)
TextTestModeLabel := doroGui.Add("Text", "xs R1.2 Section +0x0100", "调试模式")
doroGui.Tips.SetTip(TextTestModeLabel, "直接执行对应任务")
TestModeEditControl := doroGui.Add("Edit", "x+10 yp-5 w145  h20")
doroGui.Tips.SetTip(TestModeEditControl, "输入要执行的任务的函数名")
BtnTestMode := doroGui.Add("Button", "x+5", "←启动").OnEvent("Click", TestMode)
Tab.UseTab("任务")
TextTaskInfo := doroGui.Add("Text", " R1.2 +0x0100", "只有下方的内容被勾选后才会执行，右侧是详细设置")
cbShop := AddCheckboxSetting(doroGui, "Shop", "商店购买", "R1.2")
doroGui.Tips.SetTip(cbShop, "总开关：控制是否执行所有与商店购买相关的任务`r`n具体的购买项目请在「商店」标签页中详细设置")
cbSimulationRoom := AddCheckboxSetting(doroGui, "SimulationRoom", "模拟室", "R1.2")
doroGui.Tips.SetTip(cbSimulationRoom, "总开关：控制是否执行模拟室相关的任务，包括普通模拟室的快速战斗和模拟室超频`r`n详细设置请前往「战斗」标签页")
cbArena := AddCheckboxSetting(doroGui, "Arena", "竞技场", "R1.2 Section")
doroGui.Tips.SetTip(cbArena, "总开关：控制是否执行竞技场相关的任务，如领取奖励、挑战不同类型的竞技场`r`n详细设置请前往「战斗」标签页")
cbTower := AddCheckboxSetting(doroGui, "Tower", "无限之塔", "R1.2 xs")
doroGui.Tips.SetTip(cbTower, "总开关：控制是否执行无限之塔相关的任务，包括企业塔和通用塔的挑战`r`n详细设置请前往「战斗」标签页")
cbInterception := AddCheckboxSetting(doroGui, "Interception", "异常拦截", "R1.2 xs")
doroGui.Tips.SetTip(cbInterception, "总开关：控制是否执行异常拦截战任务`r`nBOSS选择、是否截图等详细设置请前往「战斗」标签页")
cbAward := AddCheckboxSetting(doroGui, "Award", "奖励收取", "R1.2 xs")
doroGui.Tips.SetTip(cbAward, "总开关：控制是否执行各类日常奖励的收取任务`r`n具体的奖励项目请在「奖励」标签页中选择")
Tab.UseTab("商店")
TextCashShopTitle := doroGui.Add("Text", "R1.2 Section +0x0100", "===付费商店===")
doroGui.Tips.SetTip(TextCashShopTitle, "设置与游戏内付费商店相关购买选项")
cbCashShop := AddCheckboxSetting(doroGui, "CashShop", "领取免费珠宝", "R1.2 xs")
doroGui.Tips.SetTip(cbCashShop, "自动领取付费商店中每日、每周、每月可获得的免费珠宝`r`n重要：如果你的游戏账号因网络原因无法正常进入付费商店，请不要勾选此项，否则可能导致程序卡住")
TextNormalShopTitle := doroGui.Add("Text", "R1.2 xs Section +0x0100", "===普通商店===")
doroGui.Tips.SetTip(TextNormalShopTitle, "设置与游戏内普通商店（使用信用点购买）相关选项")
cbNormalShop := AddCheckboxSetting(doroGui, "NormalShop", "每日白嫖2次", "R1.2 ")
doroGui.Tips.SetTip(cbNormalShop, "自动领取普通商店中每日提供的免费商品，然后利用免费刷新再领一次")
cbNormalShopDust := AddCheckboxSetting(doroGui, "NormalShopDust", "用信用点买芯尘盒", "R1.2 ")
doroGui.Tips.SetTip(cbNormalShopDust, "勾选后，在普通商店中如果出现可用信用点购买的芯尘盒，则自动购买")
cbNormalShopPackage := AddCheckboxSetting(doroGui, "NormalShopPackage", "购买简介个性化礼包", "R1.2 ")
doroGui.Tips.SetTip(cbNormalShopPackage, "勾选后，在普通商店中如果出现可用游戏内货币购买的简介个性化礼包，则自动购买")
TextArenaShopTitle := doroGui.Add("Text", " R1 xs +0x0100", "===竞技场商店===")
doroGui.Tips.SetTip(TextArenaShopTitle, "设置与游戏内竞技场商店（使用竞技场代币购买）相关选项")
cbBookFire := AddCheckboxSetting(doroGui, "BookFire", "燃烧", "R1.2")
doroGui.Tips.SetTip(cbBookFire, "在竞技场商店中自动购买所有的燃烧代码手册")
cbBookWater := AddCheckboxSetting(doroGui, "BookWater", "水冷", "R1.2 X+0.5")
doroGui.Tips.SetTip(cbBookWater, "在竞技场商店中自动购买所有的水冷代码手册")
cbBookWind := AddCheckboxSetting(doroGui, "BookWind", "风压", "R1.2 X+0.5")
doroGui.Tips.SetTip(cbBookWind, "在竞技场商店中自动购买所有的风压代码手册")
cbBookElec := AddCheckboxSetting(doroGui, "BookElec", "电击", "R1.2 X+0.5")
doroGui.Tips.SetTip(cbBookElec, "在竞技场商店中自动购买所有的电击代码手册")
cbBookIron := AddCheckboxSetting(doroGui, "BookIron", "铁甲", "R1.2 X+0.5")
doroGui.Tips.SetTip(cbBookIron, "在竞技场商店中自动购买所有的铁甲代码手册")
cbBookBox := AddCheckboxSetting(doroGui, "BookBox", "购买代码手册宝箱", "xs R1.2")
doroGui.Tips.SetTip(cbBookBox, "在竞技场商店中自动购买代码手册宝箱，可随机开出各种属性的代码手册")
cbArenaShopPackage := AddCheckboxSetting(doroGui, "ArenaShopPackage", "购买简介个性化礼包", "R1.2")
doroGui.Tips.SetTip(cbArenaShopPackage, "在竞技场商店自动购买简介个性化礼包")
cbArenaShopFurnace := AddCheckboxSetting(doroGui, "ArenaShopFurnace", "购买公司武器熔炉", "R1.2")
doroGui.Tips.SetTip(cbArenaShopFurnace, "在竞技场商店中自动购买公司武器熔炉，用于装备转化")
TextScrapShopTitle := doroGui.Add("Text", "R1.2 xs Section +0x0100", "===废铁商店===")
doroGui.Tips.SetTip(TextScrapShopTitle, "设置与游戏内废铁商店（使用废铁购买）相关选项")
cbScrapShopGem := AddCheckboxSetting(doroGui, "ScrapShopGem", "购买珠宝", "R1.2")
doroGui.Tips.SetTip(cbScrapShopGem, "在废铁商店中自动购买珠宝")
cbScrapShopVoucher := AddCheckboxSetting(doroGui, "ScrapShopVoucher", "购买全部好感券", "R1.2")
doroGui.Tips.SetTip(cbScrapShopVoucher, "在废铁商店中自动购买所有好感券，用于提升妮姬好感度")
cbScrapShopResources := AddCheckboxSetting(doroGui, "ScrapShopResources", "购买全部养成资源", "R1.2")
doroGui.Tips.SetTip(cbScrapShopResources, "在废铁商店中自动购买所有可用的养成资源")
Tab.UseTab("战斗")
TextArenaTitleBattle := doroGui.Add("Text", "R1.2 Section +0x0100", "===竞技场===")
doroGui.Tips.SetTip(TextArenaTitleBattle, "设置与各类竞技场挑战相关的选项")
cbRookieArena := AddCheckboxSetting(doroGui, "RookieArena", "新人竞技场", "R1.2")
doroGui.Tips.SetTip(cbRookieArena, "使用五次每日免费挑战次数挑战第三位")
cbSpecialArena := AddCheckboxSetting(doroGui, "SpecialArena", "特殊竞技场", "R1.2")
doroGui.Tips.SetTip(cbSpecialArena, "使用两次每日免费挑战次数挑战第三位")
cbChampionArena := AddCheckboxSetting(doroGui, "ChampionArena", "冠军竞技场", "R1.2")
doroGui.Tips.SetTip(cbChampionArena, "在活动期间进行跟风竞猜")
TextInterceptionTeamTitle := doroGui.Add("Text", "R1.2 xs Section +0x0100", "===异常拦截编队===")
doroGui.Tips.SetTip(TextInterceptionTeamTitle, "设置在执行异常拦截任务时，针对不同BOSS使用的队伍")
DropDownListBoss := doroGui.Add("DropDownList", "Choose" String(g_numeric_settings["InterceptionBoss"]), ["克拉肯(石)，编队1", "镜像容器(手)，编队2", "茵迪维利亚(衣)，编队3", "过激派(头)，编队4", "死神(脚)，编队5"])
doroGui.Tips.SetTip(DropDownListBoss, "在此选择异常拦截任务中优先挑战的BOSS`r`n请确保游戏内对应编号的队伍已经配置好针对该BOSS的阵容`r`n例如，选择克拉肯(石)，编队1，则程序会使用你的编队1去挑战克拉肯`r`n会使用3号位的狙击或发射器角色打红圈")
DropDownListBoss.OnEvent("Change", (CtrlObj, Info) => ChangeNum("InterceptionBoss", CtrlObj))
cbInterceptionShot := AddCheckboxSetting(doroGui, "InterceptionShot", "结果截图", "x+5 yp+3 R1.2")
doroGui.Tips.SetTip(cbInterceptionShot, "勾选后，在每次异常拦截战斗结束后，自动截取结算画面的图片，并保存在程序目录下的「截图」文件夹中")
TextSimRoomTitleBattle := doroGui.Add("Text", "R1.2 xs Section +0x0100", "===模拟室===")
doroGui.Tips.SetTip(TextSimRoomTitleBattle, "设置与模拟室挑战相关的选项")
TextNormalSimRoomLabel := doroGui.Add("Text", "R1.2 xs Section +0x0100", "普通模拟室")
doroGui.Tips.SetTip(TextNormalSimRoomLabel, "普通模拟室的日常扫荡。此功能需要你在游戏内已经解锁了快速模拟功能才能正常使用，需要预勾选5C`r`n此选项的勾选在「任务」标签里")
cbSimulationOverClock := AddCheckboxSetting(doroGui, "SimulationOverClock", "模拟室超频", "R1.2")
doroGui.Tips.SetTip(cbSimulationOverClock, "勾选后，自动进行模拟室超频挑战`r`n程序会默认尝试使用你上次进行超频挑战时选择的增益标签组合`r`n挑战难度必须是25")
TextTowerTitleBattle := doroGui.Add("Text", "R1.2 xs Section +0x0100", "===无限之塔===")
doroGui.Tips.SetTip(TextTowerTitleBattle, "设置与无限之塔挑战相关的选项")
cbCompanyTower := AddCheckboxSetting(doroGui, "CompanyTower", "爬企业塔", "R1.2")
doroGui.Tips.SetTip(cbCompanyTower, "勾选后，自动挑战当前可进入的所有企业塔，直到无法通关或每日次数用尽`r`n只要有一个是0/3就会判定为打过了从而跳过该任务")
cbUniversalTower := AddCheckboxSetting(doroGui, "UniversalTower", "爬通用塔", "R1.2")
doroGui.Tips.SetTip(cbUniversalTower, "勾选后，自动挑战通用无限之塔，直到无法通关")
Tab.UseTab("奖励")
TextNormalAwardTitle := doroGui.Add("Text", "R1.2 Section +0x0100", "===常规奖励===")
doroGui.Tips.SetTip(TextNormalAwardTitle, "设置各类日常可领取的常规奖励项目")
cbOutpostDefence := AddCheckboxSetting(doroGui, "OutpostDefence", "领取前哨基地防御奖励+1次免费歼灭", "R1.2  Y+M  Section")
doroGui.Tips.SetTip(cbOutpostDefence, "自动领取前哨基地的离线挂机收益，并执行一次每日免费的快速歼灭以获取额外资源")
cbExpedition := AddCheckboxSetting(doroGui, "Expedition", "领取并重新派遣委托", "R1.2 xs+15")
doroGui.Tips.SetTip(cbExpedition, "自动领取已完成的派遣委托奖励，并根据当前可用妮姬重新派遣新的委托任务")
cbLoveTalking := AddCheckboxSetting(doroGui, "LoveTalking", "咨询妮姬", "R1.2 xs Section")
doroGui.Tips.SetTip(cbLoveTalking, "自动进行每日的妮姬咨询，以提升好感度`r`n你可以通过在游戏内将妮姬设置为收藏状态来调整咨询的优先顺序`r`n会循环直到次数耗尽")
cbAppreciation := AddCheckboxSetting(doroGui, "Appreciation", "花絮鉴赏", "R1.2 xs+15")
doroGui.Tips.SetTip(cbAppreciation, "自动观看并领取花絮鉴赏中当前可领取的奖励")
cbFriendPoint := AddCheckboxSetting(doroGui, "FriendPoint", "好友点数收取", "R1.2 xs")
doroGui.Tips.SetTip(cbFriendPoint, "收取并回赠好友点数")
cbMail := AddCheckboxSetting(doroGui, "Mail", "邮箱收取", "R1.2")
doroGui.Tips.SetTip(cbMail, "收取邮箱中所有奖励")
cbRankingReward := AddCheckboxSetting(doroGui, "RankingReward", "方舟排名奖励", "R1.2")
doroGui.Tips.SetTip(cbRankingReward, "自动领取方舟内各类排名活动（如无限之塔排名、竞技场排名等）的结算奖励")
cbMission := AddCheckboxSetting(doroGui, "Mission", "任务收取", "R1.2")
doroGui.Tips.SetTip(cbMission, "收取每日任务、每周任务、主线任务以及成就等已完成任务的奖励")
cbSession := AddCheckboxSetting(doroGui, "Session", "小活动", "R1.2")
doroGui.Tips.SetTip(cbSession, "对最新的挑战关卡进行战斗或快速战斗`r`n然后对主要活动的第11关消耗所有次数进行快速战斗")
cbFestival := AddCheckboxSetting(doroGui, "Festival", "大活动", "R1.2")
doroGui.Tips.SetTip(cbFestival, "进行签到`r`n对最新的挑战关卡进行战斗或快速战斗`r`n然后对主要活动的第11关消耗所有次数进行快速战斗")
cbPass := AddCheckboxSetting(doroGui, "Pass", "通行证收取", "R1.2")
doroGui.Tips.SetTip(cbPass, "收取当前通行证中所有可领取的等级奖励")
TextLimitedAwardTitle := doroGui.Add("Text", "R1.2 Section +0x0100", "===限时奖励===")
doroGui.Tips.SetTip(TextLimitedAwardTitle, "设置在特定活动期间可领取的限时奖励或可参与的限时活动")
cbFreeRecruit := AddCheckboxSetting(doroGui, "FreeRecruit", "活动期间每日免费招募", "R1.2")
doroGui.Tips.SetTip(cbFreeRecruit, "勾选后，如果在特定活动期间有每日免费招募机会，则自动进行募")
cbCooperate := AddCheckboxSetting(doroGui, "Cooperate", "协同作战", "R1.2")
doroGui.Tips.SetTip(cbCooperate, "参与每日三次的普通难度协同作战`r`n也可参与大活动的协同作战")
cbSoloRaid := AddCheckboxSetting(doroGui, "SoloRaid", "单人突击日常", "R1.2")
doroGui.Tips.SetTip(cbSoloRaid, "参与单人突击，自动对最新的关卡进行战斗或快速战斗")
cbRoadToVillain := AddCheckboxSetting(doroGui, "RoadToVillain", "德雷克·反派之路", "R1.2")
doroGui.Tips.SetTip(cbRoadToVillain, "针对德雷克·反派之路的特殊限时活动，自动领取相关的任务奖励和进度奖励")
Tab.UseTab("日志")
LogBox := doroGui.Add("Edit", "r20 w270 ReadOnly")
LogBox.Value := "日志开始...`r`n" ;初始内容
Tab.UseTab()
BtnDoro := doroGui.Add("Button", "Default w80 xm+100", "DORO!")
doroGui.Tips.SetTip(BtnDoro, "点击启动 DoroHelper 主程序！`r`nDoro 将会按照你在各个标签页中的设置，开始自动执行所有已勾选的任务`r`n在点击前，请确保游戏客户端已在前台运行并处于大厅界面")
BtnDoro.OnEvent("Click", ClickOnDoro)
if g_settings["AutoCheckUpdate"]
    CheckForUpdate(false)
doroGui.Show()
;endregion 创建gui
;region 点击运行
ClickOnDoro(*) {
    Initialization
    Login() ;登陆到主界面
    if g_settings["Shop"] {
        if g_settings["CashShop"]
            CashShop()
        if g_settings["NormalShop"]
            NormalShop()
        if g_settings["ArenaShop"]
            ArenaShop()
        if g_settings["ScrapShop"]
            ScrapShop()
        BackToHall
    }
    if g_settings["SimulationRoom"] {
        SimulationRoom()
        if g_settings["SimulationOverClock"] ;模拟室超频
            SimulationOverClock()
        BackToHall
    }
    if g_settings["Arena"] {
        Arena()
        if g_settings["RookieArena"] ;新人竞技场
            RookieArena()
        if g_settings["SpecialArena"] ;特殊竞技场
            SpecialArena()
        if g_settings["ChampionArena"] ;冠军竞技场
            ChampionArena()
        BackToHall
    }
    if g_settings["Tower"] {
        if g_settings["CompanyTower"]
            CompanyTower()
        if g_settings["UniversalTower"]
            UniversalTower()
        BackToHall
    }
    if g_settings["Interception"]
        Interception()
    if g_settings["Award"] {
        if g_settings["OutpostDefence"] ;使用键名检查 Map
            OutpostDefence()
        if g_settings["LoveTalking"]
            LoveTalking()
        if g_settings["FriendPoint"]
            FriendPoint()
        if g_settings["Mail"]
            Mail()
        if g_settings["RankingReward"] ;方舟排名奖励
            RankingReward()
        if g_settings["Mission"]
            Mission()
        if g_settings["Session"]
            Session()
        if g_settings["Festival"]
            Festival()
        if g_settings["Pass"]
            Pass()
        if g_settings["FreeRecruit"]
            FreeRecruit()
        if g_settings["Cooperate"]
            Cooperate()
        if g_settings["SoloRaid"]
            SoloRaid()
        if g_settings["RoadToVillain"]
            RoadToVillain()
        BackToHall
    }
    if g_settings["AdjustSize"] {
        AdjustSize(OriginalW, OriginalH)
    }
    CalculateAndShowSpan()
    Result := MsgBox("Doro完成任务！" outputText "`n可以支持一下Doro吗", , "YesNo")
    if Result = "Yes"
        MsgSponsor
    if g_settings["OpenBlablalink"]
        Run("https://www.blablalink.com/")
    if g_settings["SelfClosing"] {
        if InStr(currentVersion, "beta") {
            MsgBox ("测试版本禁用自动关闭！")
            Pause
        }
        ExitApp
    }
}
;endregion 点击运行
;region 初始化
Initialization() {
    ;检测管理员身份
    if !A_IsAdmin {
        MsgBox "请以管理员身份运行Doro"
        ExitApp
    }
    global stdScreenW := 3840
    global stdScreenH := 2160
    global BattleActive := 1
    global nikkeID := ""
    global NikkeX := 0
    global NikkeY := 0
    global NikkeW := 0
    global NikkeH := 0
    global NikkeXP := 0
    global NikkeYP := 0
    global NikkeWP := 0
    global NikkeHP := 0
    global scrRatio := 1
    global currentScale := 1
    global WinRatio := 1
    global TrueRatio := 1
    LogBox.Value := ""
    WriteSettings()
    ;设置窗口标题匹配模式为完全匹配
    SetTitleMatchMode 3
    targetExe := "nikke.exe"
    if WinExist("ahk_exe " . targetExe) {
        winID := WinExist("ahk_exe " . targetExe) ;获取窗口ID
        actualWinTitle := WinGetTitle(winID)      ;获取实际窗口标题
        AddLog("找到了进程为 '" . targetExe . "' 的窗口！`n实际窗口标题是: " . actualWinTitle)
        if actualWinTitle = "胜利女神：新的希望" {
            MsgBox ("不支持国服，自动关闭！")
            ExitApp
        }
        ;激活该窗口
        WinActivate(winID)
    }
    else {
        ;没有找到该进程的窗口
        MsgBox("没有找到进程为 '" . targetExe . "' 的窗口，初始化失败！")
        Pause
    }
    nikkeID := winID
    WinGetClientPos &NikkeX, &NikkeY, &NikkeW, &NikkeH, nikkeID
    WinGetPos &NikkeXP, &NikkeYP, &NikkeWP, &NikkeHP, nikkeID
    currentScale := A_ScreenDPI / 96 ;确定dpi缩放比例，主要影响识图
    scrRatio := NikkeH / stdScreenH ;确定nikke尺寸之于额定尺寸的比例（4K），主要影响点击
    WinRatio := Round(NikkeW / 2331, 3) ;确定nikke尺寸之于额定nikke尺寸的比例（我是在nikke工作区宽度2331像素的情况下截图的），主要影响识图
    ; TrueRatio := Round(currentScale * WinRatio, 3)
    TrueRatio := Round(1 * WinRatio, 3)
    GameRatio := Round(NikkeW / NikkeH, 3)
    AddLog("`n当前的doro版本是" currentVersion "`n屏幕宽度是" A_ScreenWidth "`n屏幕高度是" A_ScreenHeight "`nnikkeX坐标是" NikkeX "`nnikkeY坐标是" NikkeY "`nnikke宽度是" NikkeW "`nnikke高度是" NikkeH "`n游戏画面比例是" GameRatio "`ndpi缩放比例是" currentScale "`n额定缩放比例是" WinRatio "`n图片缩放系数是" TrueRatio "`n识图宽容度是" PicTolerance)
    AddLog("如有问题请加入反馈qq群584275905，反馈请附带日志或录屏")
    if g_settings["AdjustSize"] {
        global OriginalW := NikkeW
        global OriginalH := NikkeH
        ; 尝试归类为2160p (4K) 及其变种
        if (A_ScreenWidth >= 3840 and A_ScreenHeight >= 2160) {
            if (A_ScreenWidth = 3840 and A_ScreenHeight = 2160) {
                AddLog("标准4K分辨率 (2160p)")
            } else if (A_ScreenWidth = 5120 and A_ScreenHeight = 2160) {
                AddLog("4K 加宽 (21:9 超宽屏)")
            } else if (A_ScreenWidth = 3840 and A_ScreenHeight = 2400) {
                AddLog("4K 增高 (16:10 宽屏)")
            } else {
                AddLog("4K 及其它变种分辨率")
            }
            AdjustSize(2331, 1311)
        }
        ; 尝试归类为1440p (2K) 及其变种
        else if (A_ScreenWidth >= 2560 and A_ScreenHeight >= 1440) {
            if (A_ScreenWidth = 2560 and A_ScreenHeight = 1440) {
                AddLog("标准2K分辨率 (1440p)")
            } else if (A_ScreenWidth = 3440 and A_ScreenHeight = 1440) {
                AddLog("2K 加宽 (21:9 超宽屏)")
            } else if (A_ScreenWidth = 5120 and A_ScreenHeight = 1440) {
                AddLog("2K 超宽 (32:9 超级带鱼屏)")
            } else if (A_ScreenWidth = 2560 and A_ScreenHeight = 1600) {
                AddLog("2K 增高 (16:10 宽屏)")
            } else {
                AddLog("2K 及其它变种分辨率")
            }
            AdjustSize(2331, 1311)
        }
        ; 尝试归类为1080p 及其变种
        else if (A_ScreenWidth >= 1920 and A_ScreenHeight >= 1080) {
            if (A_ScreenWidth = 1920 and A_ScreenHeight = 1080) {
                AddLog("标准1080p分辨率")
            } else if (A_ScreenWidth = 2560 and A_ScreenHeight = 1080) {
                AddLog("1080p 加宽 (21:9 超宽屏)")
            } else if (A_ScreenWidth = 3840 and A_ScreenHeight = 1080) {
                AddLog("1080p 超宽 (32:9 超级带鱼屏)")
            } else if (A_ScreenWidth = 1920 and A_ScreenHeight = 1200) {
                AddLog("1080p 增高 (16:10 宽屏)")
            } else {
                AddLog("1080p 及其它变种分辨率")
            }
        }
        else {
            AddLog("不足1080p分辨率")
        }
    }
}
;endregion 初始化
;region 软件更新
;tag 统一检查更新
CheckForUpdate(isManualCheck) {
    ; 全局变量声明 - 确保这些在函数外部有定义
    global currentVersion, usr, repo, latestObj, g_settings, g_numeric_settings
    latestObj := Map( ; 初始化 latestObj Map
        "version", "",
        "change_notes", "无更新说明。",
        "download_url", "",
        "source", "",
        "display_name", ""
    )
    local foundNewVersion := false
    local sourceName := ""
    local channelInfo := g_settings["isPreRelease"] ? "预发布" : "稳定"
    ; ==================== Mirror酱 更新检查 ====================
    if g_settings["MirrorUpdate"] {
        latestObj.source := "mirror"
        latestObj.display_name := "Mirror酱"
        sourceName := "Mirror酱"
        AddLog(sourceName . " 更新检查：开始 (" . channelInfo . " 渠道)...")
        if Trim(g_numeric_settings["MirrorCDK"]) = "" {
            if (isManualCheck) {
                MsgBox("Mirror酱 CDK 为空，无法检查更新。", sourceName . "检查更新错误", "IconX")
            }
            AddLog(sourceName . " 更新检查：CDK为空")
            return
        }
        local apiUrl := "https://mirrorchyan.com/api/resources/DoroHelper/latest?"
        apiUrl .= "cdk=" . g_numeric_settings["MirrorCDK"]
        if g_settings["isPreRelease"] {
            apiUrl .= "&channel=beta"
        }
        local HttpRequest := ""
        local ResponseStatus := 0
        local ResponseBody := "" ; 用于存储原始字节流
        try {
            HttpRequest := ComObject("WinHttp.WinHttpRequest.5.1")
            HttpRequest.Open("GET", apiUrl, false)
            HttpRequest.SetRequestHeader("User-Agent", "DoroHelper-AHK-Script/" . currentVersion)
            HttpRequest.Send()
            ResponseStatus := HttpRequest.Status
            if (ResponseStatus = 200) { ; 仅当成功时获取 ResponseBody
                ResponseBody := HttpRequest.ResponseBody
            }
        } catch as e {
            if (isManualCheck) {
                MsgBox(sourceName . " API 请求失败: " . e.Message, sourceName . "检查更新错误", "IconX")
            }
            AddLog(sourceName . " API 请求失败: " . e.Message)
            return
        }
        local ResponseTextForJson := "" ; 用于 JSON 解析的文本
        if (ResponseStatus = 200) {
            if (IsObject(ResponseBody) && (ComObjType(ResponseBody) & 0x2000)) { ; 检查是否为 SafeArray (VT_ARRAY)
                try {
                    local dataPtr := 0
                    local lBound := 0
                    local uBound := 0
                    DllCall("OleAut32\SafeArrayGetLBound", "Ptr", ComObjValue(ResponseBody), "UInt", 1, "Int64*", &lBound)
                    DllCall("OleAut32\SafeArrayGetUBound", "Ptr", ComObjValue(ResponseBody), "UInt", 1, "Int64*", &uBound)
                    local actualSize := uBound - lBound + 1
                    if (actualSize > 0) {
                        DllCall("OleAut32\SafeArrayAccessData", "Ptr", ComObjValue(ResponseBody), "Ptr*", &dataPtr)
                        ResponseTextForJson := StrGet(dataPtr, actualSize, "UTF-8")
                        DllCall("OleAut32\SafeArrayUnaccessData", "Ptr", ComObjValue(ResponseBody))
                        AddLog(sourceName . " DEBUG: ResponseBody (SafeArray) converted to UTF-8 string using StrGet.")
                    } else {
                        AddLog(sourceName . " 警告: SafeArray 大小为0或无效")
                        ResponseTextForJson := "" ; 确保 ResponseTextForJson 有定义
                    }
                } catch as e_sa {
                    AddLog(sourceName . " 错误: 处理 ResponseBody (SafeArray) 失败: " . e_sa.Message ". 类型: " . ComObjType(ResponseBody, "Name"))
                    ResponseTextForJson := HttpRequest.ResponseText ; 回退
                    AddLog(sourceName . " 警告: SafeArray 处理失败，回退到 HttpRequest.ResponseText，可能存在编码问题")
                }
            } else if (IsObject(ResponseBody)) {
                AddLog(sourceName . " 警告: ResponseBody 是对象但不是 SafeArray (类型: " . ComObjType(ResponseBody, "Name") . ")，尝试 ADODB.Stream")
                try {
                    local Stream := ComObject("ADODB.Stream")
                    Stream.Type := 1 ; adTypeBinary
                    Stream.Open()
                    Stream.Write(ResponseBody)
                    Stream.Position := 0
                    Stream.Type := 2 ; adTypeText
                    Stream.Charset := "utf-8"
                    ResponseTextForJson := Stream.ReadText()
                    Stream.Close()
                    AddLog(sourceName . " DEBUG: ResponseBody (non-SafeArray COM Object) converted to UTF-8 string using ADODB.Stream.")
                } catch as e_adodb {
                    AddLog(sourceName . " 错误: ADODB.Stream 处理 ResponseBody (non-SafeArray COM Object) 失败: " . e_adodb.Message)
                    ResponseTextForJson := HttpRequest.ResponseText ; 最终回退
                    AddLog(sourceName . " 警告: ADODB.Stream 失败，回退到 HttpRequest.ResponseText，可能存在编码问题")
                }
            } else {
                AddLog(sourceName . " 警告: ResponseBody 不是 COM 对象，或请求未成功。将直接使用 HttpRequest.ResponseText")
                ResponseTextForJson := HttpRequest.ResponseText
            }
            AddLog(sourceName . " API Response Status 200. Decoded ResponseTextForJson (first 500 chars): " . SubStr(ResponseTextForJson, 1, 500))
            try {
                local JsonData := Json.Load(&ResponseTextForJson)
                if (!IsObject(JsonData)) {
                    if (isManualCheck) MsgBox(sourceName . " API 响应格式错误。", sourceName . "检查更新错误", "IconX")
                        AddLog(sourceName . " API 响应未能解析为JSON. ResponseText (first 200): " . SubStr(ResponseTextForJson, 1, 200))
                    return
                }
                local jsonDataCode := JsonData.Get("code", -1)
                local potentialData := JsonData.Get("data", unset)
                if (jsonDataCode != 0) {
                    local errorMsg := sourceName . " API 返回错误。 Code: " . jsonDataCode . "."
                    if (JsonData.Has("msg") && Trim(JsonData.msg) != "") {
                        errorMsg .= " 消息: " . JsonData.msg
                    } else {
                        errorMsg .= " (API未提供详细错误消息)"
                    }
                    if (isManualCheck) {
                        MsgBox(errorMsg, sourceName . "检查更新错误", "IconX")
                    }
                    AddLog(errorMsg)
                    return
                }
                if (!IsSet(potentialData) || !IsObject(potentialData)) {
                    local errorMsg := sourceName . " API 响应成功 (code 0)，但 'data' 字段缺失或非对象类型。"
                    if (JsonData.Has("msg") && Trim(JsonData.msg) != "") {
                        errorMsg .= " API 消息: " . JsonData.msg
                    }
                    if (isManualCheck) {
                        MsgBox(errorMsg, sourceName . "检查更新错误", "IconX")
                    }
                    AddLog(errorMsg . " Type of 'data' retrieved: " . Type(potentialData))
                    return
                }
                local mirrorData := potentialData
                latestObj.version := mirrorData.Get("version_name", "")
                latestObj.change_notes := mirrorData.Get("release_note", "无更新说明")
                latestObj.download_url := mirrorData.Get("url", "")
                if latestObj.version = "" {
                    if (isManualCheck) {
                        MsgBox(sourceName . " API 响应中版本信息为空。", sourceName . "检查更新错误", "IconX")
                    }
                    AddLog(sourceName . " 更新检查：API响应中版本信息为空")
                    return
                }
                AddLog(sourceName . " 更新检查：获取到版本 " . latestObj.version)
                if (CompareVersionsSemVer(latestObj.version, currentVersion) > 0) {
                    foundNewVersion := true
                    AddLog(sourceName . " 版本比较：发现新版本")
                } else {
                    AddLog(sourceName . " 版本比较：当前已是最新或更新")
                }
            } catch as e {
                local errorDetails := "错误类型: " . Type(e) . ", 消息: " . e.Message
                if e.HasProp("What") errorDetails .= "`n触发对象/操作: " . e.What
                    if e.HasProp("File") errorDetails .= "`n文件: " . e.File
                        if e.HasProp("Line") errorDetails .= "`n行号: " . e.Line
                            if (isManualCheck) MsgBox("处理 " . sourceName . " JSON 数据时发生内部错误: `n" . errorDetails, sourceName . "检查更新错误", "IconX")
                                AddLog(sourceName . " 更新检查：处理JSON时发生内部错误: " . errorDetails)
                AddLog(sourceName . " 相关的 ResponseTextForJson (前1000字符): " . SubStr(ResponseTextForJson, 1, 1000))
                return
            }
        } else { ; ResponseStatus != 200
            local errorResponseText := HttpRequest.ResponseText ; 尝试获取错误响应文本
            local responseTextPreview := SubStr(errorResponseText, 1, 300)
            if (isManualCheck) {
                MsgBox(sourceName . " API 请求失败！`n状态码: " . ResponseStatus . "`n响应预览:`n" . responseTextPreview, sourceName . " API 错误", "IconX")
            }
            AddLog(sourceName . " API 请求失败！状态码: " . ResponseStatus . ", 响应预览: " . responseTextPreview)
            return
        }
        ; ==================== Github 更新检查 (如果 MirrorUpdate 未启用) ====================
    } else {
        latestObj.source := "github"
        latestObj.display_name := "Github"
        sourceName := "Github"
        AddLog(sourceName . " 更新检查：开始 (" . channelInfo . " 渠道)...")
        try {
            local allReleases := Github.historicReleases(usr, repo) ; 获取所有版本
            if !(allReleases is Array) || !allReleases.Length { ; AHK v2: is Array
                if (isManualCheck) {
                    MsgBox("无法获取 Github 版本列表，请检查网络或仓库信息。", sourceName . "检查更新错误", "IconX")
                }
                AddLog(sourceName . " 更新检查：无法获取版本列表")
                return
            }
            local targetRelease := ""
            if g_settings["isPreRelease"] {
                targetRelease := allReleases[1]
                if !(IsObject(targetRelease) && (targetRelease.HasProp("version") || targetRelease.HasProp("tag_name"))) {
                    local errMsg := sourceName . " 更新检查：获取到的最新预发布 Release 对象无效或缺少版本信息。"
                    if (isManualCheck) MsgBox(errMsg, sourceName . "检查更新错误", "IconX")
                        AddLog(errMsg)
                    return
                }
                AddLog(sourceName . " 更新检查：预发布版优先，已选定 Release")
            } else {
                AddLog(sourceName . " 更新检查：稳定版优先，正在查找...")
                for release_item in allReleases {
                    if !(IsObject(release_item) && (release_item.HasProp("version") || release_item.HasProp("tag_name"))) {
                        AddLog(sourceName . " DEBUG: 跳过一个无效的或缺少版本信息的 Release 对象")
                        continue
                    }
                    local current_release_version := release_item.HasProp("version") ? release_item.version : release_item.tag_name
                    if !(InStr(current_release_version, "beta") || InStr(current_release_version, "alpha") || InStr(current_release_version, "rc")) {
                        targetRelease := release_item
                        AddLog(sourceName . " 更新检查：找到稳定版 " . current_release_version)
                        break
                    }
                }
                if !IsObject(targetRelease) {
                    AddLog(sourceName . " 更新检查：未找到稳定版，将使用最新版本进行比较")
                    targetRelease := allReleases[1]
                    if !(IsObject(targetRelease) && (targetRelease.HasProp("version") || targetRelease.HasProp("tag_name"))) {
                        local errMsg := sourceName . " 更新检查：回退到的最新 Release 对象也无效或缺少版本信息。"
                        if (isManualCheck) MsgBox(errMsg, sourceName . "检查更新错误", "IconX")
                            AddLog(errMsg)
                        return
                    }
                }
            }
            if !IsObject(targetRelease) {
                local errMsg := sourceName . " 更新检查：最终未能确定有效的 targetRelease 对象。"
                if (isManualCheck) MsgBox(errMsg, sourceName . "检查更新错误", "IconX")
                    AddLog(errMsg)
                return
            }
            ; 版本号
            if (targetRelease.HasProp("version")) {
                latestObj.version := targetRelease.version
            } else if (targetRelease.HasProp("tag_name")) {
                latestObj.version := targetRelease.tag_name
            } else {
                latestObj.version := ""
                AddLog(sourceName . " 警告: Release 对象缺少 'version' 或 'tag_name' 属性")
            }
            ; 更新内容
            if (targetRelease.HasProp("change_notes")) {
                latestObj.change_notes := targetRelease.change_notes
            } else if (targetRelease.HasProp("body")) {
                latestObj.change_notes := targetRelease.body
            } else {
                latestObj.change_notes := "无更新说明。"
            }
            if Trim(latestObj.change_notes) = "" {
                latestObj.change_notes := "无更新说明。"
            }
            ; 下载链接
            latestObj.download_url := "" ; 初始化
            if (targetRelease.HasProp("downloadURL") && Trim(targetRelease.downloadURL) != "") {
                latestObj.download_url := targetRelease.downloadURL
                AddLog(sourceName . " 找到下载链接 (from downloadURL): " . latestObj.download_url)
            }
            else if (targetRelease.HasProp("assets") && targetRelease.assets is Array && targetRelease.assets.Length > 0) { ; AHK v2: is Array
                AddLog(sourceName . " DEBUG: (Fallback) 'downloadURL' not found. Checking 'assets'.")
                for asset in targetRelease.assets {
                    if IsObject(asset) && asset.HasProp("name") && asset.HasProp("browser_download_url") {
                        AddLog(sourceName . " DEBUG: Checking asset: " . asset.name)
                        if (InStr(asset.name, "DoroHelper") && InStr(asset.name, ".exe")) {
                            latestObj.download_url := asset.browser_download_url
                            AddLog(sourceName . " 找到 .exe asset 下载链接 (from assets): " . latestObj.download_url)
                            break
                        }
                    }
                }
                if (latestObj.download_url = "")
                    AddLog(sourceName . " 警告: 在 'assets' 中未精确匹配到 'DoroHelper*.exe' 或 'assets' 结构不符")
            }
            else if (targetRelease.HasProp("downloadURLs") && targetRelease.downloadURLs is Array && targetRelease.downloadURLs.Length > 0 && Trim(targetRelease.downloadURLs[1]) != "") { ; AHK v2: is Array
                latestObj.download_url := targetRelease.downloadURLs[1]
                AddLog(sourceName . " 使用 downloadURLs[1] 作为下载链接 (Fallback): " . latestObj.download_url)
            }
            else if (targetRelease.HasProp("download_url") && Trim(targetRelease.download_url) != "") {
                latestObj.download_url := targetRelease.download_url
                AddLog(sourceName . " 使用顶层 download_url 属性作为下载链接 (Fallback): " . latestObj.download_url)
            }
            else {
                AddLog(sourceName . " 警告: Release 对象未找到任何有效的下载链接属性 (已尝试: downloadURL, assets, downloadURLs, download_url)")
            }
            if latestObj.version = "" {
                local errMsg := sourceName . " 更新检查：未能从选定的 Release 对象获取版本号。"
                if (isManualCheck) MsgBox(errMsg, sourceName . "检查更新错误", "IconX")
                    AddLog(errMsg)
                return
            }
            if latestObj.download_url = "" {
                AddLog(sourceName . " 警告: 未能为版本 " . latestObj.version . " 找到有效的下载链接")
            }
            AddLog(sourceName . " 更新检查：获取到版本 " . latestObj.version . (latestObj.download_url ? "" : " (下载链接未找到)"))
            if (CompareVersionsSemVer(latestObj.version, currentVersion) > 0) {
                foundNewVersion := true
                AddLog(sourceName . " 版本比较：发现新版本")
            } else {
                AddLog(sourceName . " 版本比较：当前已是最新或更新")
            }
        } catch as githubError {
            if (isManualCheck) {
                MsgBox("Github 检查更新失败: `n" . githubError.Message . (githubError.HasProp("Extra") ? "`nExtra: " . githubError.Extra : ""), sourceName . "检查更新错误", "IconX")
            }
            AddLog(sourceName . " 检查更新失败: " . githubError.Message . (githubError.HasProp("Extra") ? ". Extra: " . githubError.Extra : ""))
            return
        }
    }
    ; ==================== 处理检查结果 ====================
    if foundNewVersion {
        AddLog(sourceName . " 更新检查：发现新版本 " . latestObj.version . "，准备提示用户")
        if (latestObj.download_url = "" && isManualCheck) {
            MsgBox("已检测到新版本 " . latestObj.version . "，但未能获取到下载链接。请检查 Github 库或手动下载。", "更新提示", "IconW")
        }
        local MyGui := Gui("+Resize", "更新提示 (" . latestObj.display_name . ")")
        MyGui.SetFont("s10", "Microsoft YaHei UI")
        MyGui.Add("Text", "w300 xm ym", "发现 DoroHelper 新版本 (" . channelInfo . " - " . latestObj.display_name . "):")
        MyGui.Add("Text", "xp+10 yp+25 w300", "最新版本: " . latestObj.version)
        MyGui.Add("Text", "xp yp+20 w300", "当前版本: " . currentVersion)
        MyGui.Add("Text", "xp yp+25 w300", "更新内容:")
        local notes_for_edit := latestObj.change_notes
        notes_for_edit := StrReplace(notes_for_edit, "`r`n", "`n") ; 先统一为 \n
        notes_for_edit := StrReplace(notes_for_edit, "`r", "`n")   ; \r 也统一为 \n
        notes_for_edit := StrReplace(notes_for_edit, "`n", "`r`n") ; 再统一为 Edit 控件的 \r\n
        MyGui.Add("Edit", "w250 h200 ReadOnly VScroll Border", notes_for_edit)
        MyGui.Add("Button", "xm+20 w100 h30 yp+220", "立即下载").OnEvent("Click", DownloadUpdate)
        MyGui.Add("Button", "x+20 w100 h30", "稍后提醒").OnEvent("Click", (*) => MyGui.Destroy())
        MyGui.Show("w320 h400 Center")
    } else if latestObj.version != "" {
        AddLog(sourceName . " 更新检查：当前已是最新版本 " . currentVersion)
        if (isManualCheck) {
            MsgBox("当前通道为:" . channelInfo . "通道 - " . latestObj.display_name . "`n最新版本为:" . latestObj.version "`n当前版本为:" . currentVersion "`n当前已是最新版本", "检查更新", "IconI")
        }
    } else {
        AddLog((sourceName ? sourceName : "更新") . " 更新检查：未能获取到有效的版本信息或检查被中止")
        if (isManualCheck) {
            MsgBox("未能完成更新检查。请查看日志了解详情。", "检查更新", "IconX")
        }
    }
}
;tag 统一更新下载
DownloadUpdate(*) {
    global latestObj
    if !IsObject(latestObj) || !latestObj.Has("source") || latestObj.source = "" || !latestObj.Has("version") || latestObj.version = "" {
        MsgBox("下载错误：更新信息不完整，无法开始下载。", "下载错误", "IconX")
        AddLog("下载错误：latestObj 信息不完整。 Source: " . latestObj.Get("source", "N/A") . ", Version: " . latestObj.Get("version", "N/A"))
        return
    }
    downloadTempName := "DoroDownload.exe"
    finalName := "DoroHelper-" latestObj.version ".exe"
    downloadUrlToUse := latestObj.download_url
    if downloadUrlToUse = "" {
        MsgBox("错误：找不到有效的 " . latestObj.display_name . " 下载链接。", "下载错误", "IconX")
        AddLog(latestObj.display_name . " 下载错误：下载链接为空")
        return
    }
    AddLog(latestObj.display_name . " 下载：开始下载 " . downloadUrlToUse . " 到 " . A_ScriptDir "\" finalName)
    local downloadStatusCode := 0 ; 用于存储下载结果
    try {
        if latestObj.source == "github" {
            ErrorLevel := 0
            Github.Download(downloadUrlToUse, A_ScriptDir "\" downloadTempName)
            downloadStatusCode := ErrorLevel
            if downloadStatusCode != 0 {
                throw Error("Github 下载失败 (ErrorLevel: " . downloadStatusCode . "). 检查 Github.Download 库的内部提示或网络")
            }
        } else if latestObj.source == "mirror" {
            ErrorLevel := 0
            Download downloadUrlToUse, A_ScriptDir "\" downloadTempName
            downloadStatusCode := ErrorLevel
            if downloadStatusCode != 0 {
                throw Error("Mirror酱下载失败 (错误代码: " . downloadStatusCode . ")")
            }
        } else {
            throw Error("未知的下载源: " . latestObj.source)
        }
        FileMove A_ScriptDir "\" downloadTempName, A_ScriptDir "\" finalName, 1
        MsgBox("新版本已通过 " . latestObj.display_name . " 下载至当前目录: `n" . A_ScriptDir "\" finalName, "下载完成")
        AddLog(latestObj.display_name . " 下载：成功下载并保存为 " . finalName)
        ExitApp
    } catch as downloadError {
        MsgBox(latestObj.display_name . " 下载失败: `n" . downloadError.Message, "下载错误", "IconX")
        AddLog(latestObj.display_name . " 下载失败: " . downloadError.Message)
        if FileExist(A_ScriptDir "\" downloadTempName) {
            try {
                FileDelete(A_ScriptDir "\" downloadTempName)
            } catch {
                ; 忽略删除临时文件失败
            }
        }
    }
}
;tag 点击检查更新
ClickOnCheckForUpdate(*) {
    AddLog("=== 更新检查启动 (手动) ===")
    CheckForUpdate(true)
}
;tag 版本比较
CompareVersionsSemVer(v1, v2) {
    _IsNumericString(str) => RegExMatch(str, "^\d+$")
    v1 := RegExReplace(v1, "^v", "")
    v2 := RegExReplace(v2, "^v", "")
    v1Parts := StrSplit(v1, "+", , 2)
    v2Parts := StrSplit(v2, "+", , 2)
    v1Base := v1Parts[1]
    v2Base := v2Parts[1]
    v1CoreParts := StrSplit(v1Base, "-", , 2)
    v2CoreParts := StrSplit(v2Base, "-", , 2)
    v1Core := v1CoreParts[1]
    v2Core := v2CoreParts[1]
    v1Pre := v1CoreParts.Length > 1 ? v1CoreParts[2] : ""
    v2Pre := v2CoreParts.Length > 1 ? v2CoreParts[2] : ""
    v1CoreNums := StrSplit(v1Core, ".")
    v2CoreNums := StrSplit(v2Core, ".")
    loop 3 {
        local seg1Str := A_Index <= v1CoreNums.Length ? Trim(v1CoreNums[A_Index]) : "0"
        local seg2Str := A_Index <= v2CoreNums.Length ? Trim(v2CoreNums[A_Index]) : "0"
        if !_IsNumericString(seg1Str) {
            seg1Str := "0"
        }
        if !_IsNumericString(seg2Str) {
            seg2Str := "0"
        }
        num1 := Integer(seg1Str)
        num2 := Integer(seg2Str)
        if (num1 > num2) {
            return 1
        }
        if (num1 < num2) {
            return -1
        }
    }
    hasV1Pre := v1Pre != ""
    hasV2Pre := v2Pre != ""
    if (hasV1Pre && !hasV2Pre) {
        return -1
    }
    if (!hasV1Pre && hasV2Pre) {
        return 1
    }
    if (!hasV1Pre && !hasV2Pre) {
        return 0
    }
    v1PreSegments := StrSplit(v1Pre, ".")
    v2PreSegments := StrSplit(v2Pre, ".")
    maxLen := Max(v1PreSegments.Length, v2PreSegments.Length)
    loop maxLen {
        if (A_Index > v1PreSegments.Length) {
            return -1
        }
        if (A_Index > v2PreSegments.Length) {
            return 1
        }
        seg1 := Trim(v1PreSegments[A_Index])
        seg2 := Trim(v2PreSegments[A_Index])
        isNum1 := _IsNumericString(seg1)
        isNum2 := _IsNumericString(seg2)
        if (isNum1 && isNum2) {
            numSeg1 := Integer(seg1)
            numSeg2 := Integer(seg2)
            if (numSeg1 > numSeg2)
                return 1
            if (numSeg1 < numSeg2)
                return -1
        } else if (!isNum1 && !isNum2) {
            ; 强制进行字符串比较
            compareResult := StrCompare(seg1, seg2)
            if (compareResult > 0)
                return 1
            if (compareResult < 0)
                return -1
        } else {
            if (isNum1)
                return -1
            if (isNum2)
                return 1
        }
    }
    return 0
}
;endregion 软件更新
;region 消息辅助函数
MsgSponsor(*) {
    Run("https://github.com/1204244136/DoroHelper?tab=readme-ov-file#%E6%94%AF%E6%8C%81%E5%92%8C%E9%BC%93%E5%8A%B1")
}
ClickOnHelp(*) {
    msgbox "
    (
1. 游戏分辨率需要设置成 **16:9** 的分辨率，小于1080p 可能有问题，暂不打算特殊支持
   - 1080p用户请全屏运行游戏、1080p的异形屏不能设置全屏，按ctrl+3按到画面不动为止，此时nikke应该位于画面左上角
   - 2k和4k（包括异形屏）用户请按ctrl+3按到画面不动为止，不要开启全屏，此时nikke应该位于画面左上角，图片缩放应该是1
   <!-- 2. ~~如果游戏使用**全屏模式**，则需要 显示器屏幕的分辨率也是**16:9**，否则只能使用窗口模式~~
   - 异形屏或部分笔记本电脑用户需要特别注意这点 -->
2. 由于使用的是图像识别，请确保游戏画面完整在屏幕内，且**游戏画面没有任何遮挡**
   - 多显示器请支持的显示器作为主显示器，将游戏放在主显示器内
   - 不要使用微星小飞机、游戏加加等悬浮显示数据的软件
   - 游戏画质越高，脚本出错的几率越低。
   - 游戏帧数建议保持60，帧数过低时，部分场景的行动可能会被吞，导致问题
3. 请不要开启会改变画面颜色相关的功能或设置，例如
   - 软件层面：各种驱动的色彩滤镜，部分笔记本的真彩模式
   - 设备层面：显示器的护眼模式、色彩模式、色温调节、HDR 等。
4. 游戏语言设置为**简体中文**，设定-画质-开启光晕效果，设定-画质-开启颜色分级，不要使用太亮的大厅背景
5. 以**管理员身份**运行 DoroHelper
    )"
}
;endregion 消息辅助函数
;region 数据辅助函数
;tag 写入数据
WriteSettings(*) {
    global g_settings, g_numeric_settings
    ;从 g_settings Map 写入开关设置
    for key, value in g_settings {
        IniWrite(value, "settings.ini", "Toggles", key)
    }
    for key, value in g_numeric_settings {
        IniWrite(value, "settings.ini", "NumericSettings", key)
    }
}
;tag 读入数据
LoadSettings() {
    global g_settings, g_numeric_settings
    default_settings := g_settings.Clone()
    ;从 Map 加载开关设置
    for key, defaultValue in default_settings {
        readValue := IniRead("settings.ini", "Toggles", key, defaultValue)
        g_settings[key] := readValue
    }
    default_numeric_settings := g_numeric_settings.Clone() ; 保留一份默认数值设置
    for key, defaultValue in default_numeric_settings {
        ; 不再检查是否为数字，直接读取并赋值
        readValue := IniRead("settings.ini", "NumericSettings", key, defaultValue)
        g_numeric_settings[key] := readValue
    }
}
;tag 改变滑条数据
ChangeSlider(settingName, CtrlObj) {
    global g_numeric_settings, toleranceDisplayEditControl
    ; 将滑动条的整数值除以100，以获得1.00到2.00之间的浮点数
    local actualValue := CtrlObj.Value / 100.0
    g_numeric_settings[settingName] := actualValue
    ; 使用 Format 函数将浮点数格式化为小数点后两位
    local formattedValue := Format("{:.2f}", actualValue)
    toleranceDisplayEditControl.Value := formattedValue
}
;tag 保存数据
SaveSettings(*) {
    WriteSettings()
    MsgBox "设置已保存！"
    AddLog("设置已保存！", true)
}
IsCheckedToString(foo) {
    if foo
        return "Checked"
    else
        return ""
}
/**
 * 添加一个与 g_settings Map 关联的复选框到指定的 GUI 对象.
 * @param guiObj Gui - 要添加控件的 GUI 对象.
 * @param settingKey String - 在 g_settings Map 中对应的键名.
 * @param displayText String - 复选框旁边显示的文本标签.
 * @param options String - (可选) AutoHotkey GUI 布局选项字符串 (例如 "R1.2 xs+15").
 */
AddCheckboxSetting(guiObj, settingKey, displayText, options := "") {
    global g_settings ;确保能访问全局 Map 和处理函数
    ;检查 settingKey 是否存在于 g_settings 中
    if !g_settings.Has(settingKey) {
        MsgBox("错误: Setting key '" settingKey "' 在 g_settings 中未定义!", "添加控件错误", "IconX")
        return ;或者抛出错误
    }
    ;构建选项字符串，确保 Checked/空字符串 在选项之后，文本之前
    initialState := IsCheckedToString(g_settings[settingKey])
    fullOptions := options (options ? " " : "") initialState ;如果有 options，加空格分隔
    ;添加复选框控件，并将 displayText 作为第三个参数
    cbCtrl := guiObj.Add("Checkbox", fullOptions, displayText)
    ;绑定 Click 事件，使用胖箭头函数捕获当前的 settingKey
    cbCtrl.OnEvent("Click", (guiCtrl, eventInfo) => ToggleSetting(settingKey, guiCtrl, eventInfo))
    ;返回创建的控件对象 (可选，如果需要进一步操作)
    return cbCtrl
}
;通用函数，用于切换 g_settings Map 中的设置值
ToggleSetting(settingKey, guiCtrl, *) {
    global g_settings
    ;切换值 (0 变 1, 1 变 0)
    g_settings[settingKey] := 1 - g_settings[settingKey]
    ;可选: 如果需要，可以在这里添加日志记录
    ;ToolTip("切换 " settingKey " 为 " g_settings[settingKey])
}
;切换数字
ChangeNum(settingKey, GUICtrl, *) {
    global g_numeric_settings
    g_numeric_settings[settingKey] := GUICtrl.Value
}
;endregion 数据辅助函数
;region 坐标辅助函数
;tag 点击
UserClick(sX, sY, k) {
    uX := Round(sX * k) ;计算转换后的坐标
    uY := Round(sY * k)
    CoordMode "Mouse", "Client"
    Send "{Click " uX " " uY "}" ;点击转换后的坐标
}
;tag 按住
UserPress(sX, sY, k) {
    uX := Round(sX * k) ;计算转换后的坐标
    uY := Round(sY * k)
    CoordMode "Mouse", "Client"
    Send "{Click " uX " " uY "}" ;点击转换后的坐标
}
;tag 移动
UserMove(sX, sY, k) {
    uX := Round(sX * k) ;计算转换后的坐标
    uY := Round(sY * k)
    Send "{Click " uX " " uY " " 0 "}" ;点击转换后的坐标
}
;tag 颜色判断
IsSimilarColor(targetColor, color) {
    tr := Format("{:d}", "0x" . substr(targetColor, 3, 2))
    tg := Format("{:d}", "0x" . substr(targetColor, 5, 2))
    tb := Format("{:d}", "0x" . substr(targetColor, 7, 2))
    pr := Format("{:d}", "0x" . substr(color, 3, 2))
    pg := Format("{:d}", "0x" . substr(color, 5, 2))
    pb := Format("{:d}", "0x" . substr(color, 7, 2))
    distance := sqrt((tr - pr) ** 2 + (tg - pg) ** 2 + (tb - pb) ** 2)
    if (distance < 15)
        return true
    return false
}
;tag 颜色
UserCheckColor(sX, sY, sC, k) {
    loop sX.Length {
        uX := Round(sX[A_Index] * k)
        uY := Round(sY[A_Index] * k)
        uC := PixelGetColor(uX, uY)
        if (!IsSimilarColor(uC, sC[A_Index]))
            return 0
    }
    return 1
}
;tag 画面调整
AdjustSize(TargetX, TargetY) {
    WinGetPos(&X, &Y, &Width, &Height, nikkeID)
    WinGetClientPos(&ClientX, &ClientY, &ClientWidth, &ClientHeight, nikkeID)
    ; 计算非工作区（标题栏和边框）的高度和宽度
    NonClientHeight := Height - ClientHeight
    NonClientWidth := Width - ClientWidth
    NewClientX := (A_ScreenWidth / 2) - (NikkeWP / 2)
    NewClientY := (A_ScreenHeight / 2) - (NikkeHP / 2)
    NewClientWidth := TargetX
    NewClientHeight := TargetY
    ; 计算新的窗口整体大小，以适应新的工作区大小
    NewWindowX := NewClientX
    NewWindowY := NewClientY
    NewWindowWidth := NewClientWidth + NonClientWidth
    NewWindowHeight := NewClientHeight + NonClientHeight
    ; 使用 WinMove 移动和调整窗口大小
    WinMove 0, 0, NewWindowWidth, NewWindowHeight, nikkeID
}
;endregion 坐标辅助函数
;region 日志辅助函数
;tag 添加日志
AddLog(text, forceOutput := false) {  ;默认参数设为false
    if (!IsObject(LogBox) || !LogBox.Hwnd) {
        return
    }
    static lastText := ""  ;静态变量保存上一条内容
    global LogBox
    ;如果内容与上一条相同且不强制输出，则跳过
    if (text = lastText && !forceOutput)
        return
    lastText := text  ;保存当前内容供下次比较
    timestamp := FormatTime(, "HH:mm:ss")
    LogBox.Value .= timestamp " - " text "`r`n"
    SendMessage(0x0115, 7, 0, LogBox) ;自动滚动到底部
}
;tag 日志的时间戳转换
TimeToSeconds(timeStr) {
    ;期望 "HH:mm:ss" 格式
    parts := StrSplit(timeStr, ":")
    if (parts.Length != 3) {
        return -1 ;格式错误
    }
    ;确保部分是数字
    if (!IsInteger(parts[1]) || !IsInteger(parts[2]) || !IsInteger(parts[3])) {
        return -1 ;格式错误
    }
    hours := parts[1] + 0 ;强制转换为数字
    minutes := parts[2] + 0
    seconds := parts[3] + 0
    ;简单的验证范围（不严格）
    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59 || seconds < 0 || seconds > 59) {
        return -1 ;无效时间
    }
    return hours * 3600 + minutes * 60 + seconds
}
;tag 读取日志框内容 根据 HH:mm:ss 时间戳推算跨度，输出到日志框
CalculateAndShowSpan(ExitReason := "", ExitCode := "") {
    global outputText
    local logContent := LogBox.Value
    local lines := StrSplit(logContent, "`n")  ;按换行符分割
    local timestamps := []
    local match := ""
    ;提取所有时间戳（格式 HH:mm:ss）
    for line in lines {
        if (RegExMatch(line, "^\d{2}:\d{2}:\d{2}(?=\s*-\s*)", &match)) {
            timestamps.Push(match[])
        }
    }
    ;直接取最早（正式运行时的第5个）和最晚（最后1个）时间戳（日志已按时间顺序追加）
    earliestTimeStr := timestamps[5]
    latestTimeStr := timestamps[timestamps.Length]
    ;转换为秒数
    earliestSeconds := TimeToSeconds(earliestTimeStr)
    latestSeconds := TimeToSeconds(latestTimeStr)
    ;检查转换是否有效
    if (earliestSeconds = -1 || latestSeconds = -1) {
        AddLog("推算跨度失败：日志时间格式错误")
        return
    }
    ;处理跨午夜情况（如 23:59:59 → 00:00:01）
    if (latestSeconds < earliestSeconds) {
        latestSeconds += 24 * 3600  ;加上一天的秒数（86400）
    }
    ;计算总时间差（秒）
    spanSeconds := latestSeconds - earliestSeconds
    spanMinutes := Floor(spanSeconds / 60)
    remainingSeconds := Mod(spanSeconds, 60)
    ;格式化输出
    outputText := "已帮你节省时间: "
    if (spanMinutes > 0) {
        outputText .= spanMinutes " 分 "
    }
    outputText .= remainingSeconds " 秒"
    ;添加到日志
    AddLog(outputText)
}
;endregion 日志辅助函数
;region 流程辅助函数
;tag 点左下角的小房子的对应位置的右边（不返回）
Confirm() {
    UserClick(474, 2028, scrRatio)
    Sleep 500
}
;tag 按Esc
GoBack() {
    AddLog("返回")
    Send "{Esc}"
    Sleep 1000
}
;tag 结算招募
Recruit() {
    AddLog("结算招募")
    while !(ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.944 * NikkeW . " ", NikkeY + 0.011 * NikkeH . " ", NikkeX + 0.944 * NikkeW + 0.015 * NikkeW . " ", NikkeY + 0.011 * NikkeH + 0.029 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("SKIP的箭头"), , 0, , , , , TrueRatio, TrueRatio)) { ;如果没找到SKIP就一直点左下角（加速动画）
        Confirm
    }
    FindText().Click(X, Y, "L") ;找到了就点
    Sleep 1000
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.421 * NikkeW . " ", NikkeY + 0.889 * NikkeH . " ", NikkeX + 0.421 * NikkeW + 0.028 * NikkeW . " ", NikkeY + 0.889 * NikkeH + 0.027 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("确认"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
}
;tag 点掉推销
RefuseSale() {
    sleep 3000
    AddLog("尝试关闭可能的推销页面")
    Confirm
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.518 * NikkeW . " ", NikkeY + 0.609 * NikkeH . " ", NikkeX + 0.518 * NikkeW + 0.022 * NikkeW . " ", NikkeY + 0.609 * NikkeH + 0.033 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
    }
    sleep 1000
}
;tag 进入战斗
EnterToBattle() {
    global BattleActive := 1
    AddLog("尝试进入战斗")
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.506 * NikkeW . " ", NikkeY + 0.826 * NikkeH . " ", NikkeX + 0.506 * NikkeW + 0.145 * NikkeW . " ", NikkeY + 0.826 * NikkeH + 0.065 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("快速战斗的图标"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击快速战斗")
        FindText().Click(X + 50 * TrueRatio, Y, "L")
        Sleep 500
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.553 * NikkeW . " ", NikkeY + 0.683 * NikkeH . " ", NikkeX + 0.553 * NikkeW + 0.036 * NikkeW . " ", NikkeY + 0.683 * NikkeH + 0.040 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("MAX"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
        }
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("进行战斗的进"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
        }
    }
    else if (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("进入战斗的进"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击进入战斗")
        FindText().Click(X + 50 * TrueRatio, Y, "L")
    }
    else {
        BattleActive := 0
        AddLog("无法战斗")
        GoBack
    }
}
;tag 判断是否开启自动
CheckAuto() {
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.005 * NikkeW . " ", NikkeY + 0.012 * NikkeH . " ", NikkeX + 0.005 * NikkeW + 0.073 * NikkeW . " ", NikkeY + 0.012 * NikkeH + 0.043 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("AUTO的图标"), , , , , , , TrueRatio, TrueRatio)) {
        Send "{Tab}"
    }
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.005 * NikkeW . " ", NikkeY + 0.012 * NikkeH . " ", NikkeX + 0.005 * NikkeW + 0.073 * NikkeW . " ", NikkeY + 0.012 * NikkeH + 0.043 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("射击的图标"), , , , , , , TrueRatio, TrueRatio)) {
        Send "{LShift}"
    }
}
;tag 战斗结算
BattleSettlement(Screenshot := false) {
    global Victory
    ;如果没战斗次数就跳过
    if (BattleActive = 0) {
        return
    }
    check := 0
    AddLog("等待战斗结算")
    while true {
        ; 检测自动战斗和爆裂
        if (A_Index = 20) {
            CheckAuto
        }
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("TAB的图标"), , 0, , , , , TrueRatio, TrueRatio)) {
            check := check + 1
            ;AddLog("TAB已命中，共" check "次")
        }
        else if (ok := FindText(&X, &Y, NikkeX + 0.012 * NikkeW . " ", NikkeY + 0.921 * NikkeH . " ", NikkeX + 0.012 * NikkeW + 0.036 * NikkeW . " ", NikkeY + 0.921 * NikkeH + 0.072 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("重播的图标"), , , , , , , TrueRatio, TrueRatio)) {
            check := check + 1
            ;AddLog("重播的图标已命中，共" check "次")
        }
        else if (ok := FindText(&X, &Y, NikkeX + 0.453 * NikkeW . " ", NikkeY + 0.866 * NikkeH . " ", NikkeX + 0.453 * NikkeW + 0.094 * NikkeW . " ", NikkeY + 0.866 * NikkeH + 0.056 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("点击"), , , , , , , TrueRatio, TrueRatio)) {
            check := check + 1
            ;AddLog("点击已命中，共" check "次")
        }
        else {
            ;AddLog("均未命中，重新计数")
            check := 0
        }
        ;需要连续三次命中代表战斗结束
        if (check = 3) {
            break
        }
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("红圈的上边缘"), , 0, , , , , TrueRatio, TrueRatio)) or (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("红圈的下边缘"), , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("检测到红圈，尝试打红圈")
            loop 20 {
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("红圈的上边缘"), , 0, , , , 1, TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y + 30 * TrueRatio, 0)
                    Click "Down"
                    Sleep 700
                    Click "Up"
                }
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("红圈的下边缘"), , 0, , , , 1, TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y - 30 * TrueRatio, 0)
                    Click "Down"
                    Sleep 700
                    Click "Up"
                }
            }
        }
    }
    ;是否需要截图
    if Screenshot {
        TimeString := FormatTime(, "yyyyMMdd_HHmmss")
        FindText().SavePic(A_ScriptDir "\截图\" TimeString ".jpg", NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, ScreenShot := 1)
    }
    ;有编队代表输了，点Esc
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("编队的图标"), , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("战斗失败！尝试返回")
        GoBack
        Sleep 1000
        return False
    }
    ;如果有下一关，就点下一关（爬塔的情况）
    else if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("下一关卡的图标"), , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("战斗成功！尝试进入下一关")
        Victory := Victory + 1
        if Victory > 1 {
            AddLog("共胜利" Victory "次")
        }
        FindText().Click(X, Y + 20 * TrueRatio, "L")
        Sleep 3000
        BattleSettlement
    }
    ;没有编队也没有下一关就点Esc（普通情况或者爬塔次数用完了）
    else {
        AddLog("战斗结束！")
        GoBack
        Sleep 1000
        return True
    }
    ;递归结束时清零
    Victory := 0
}
;tag 返回大厅
BackToHall() {
    AddLog("返回大厅")
    while !(ok := FindText(&X, &Y, NikkeX + 0.658 * NikkeW . " ", NikkeY + 0.639 * NikkeH . " ", NikkeX + 0.658 * NikkeW + 0.040 * NikkeW . " ", NikkeY + 0.639 * NikkeH + 0.066 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("方舟的眼睛"), , 0, , , , , TrueRatio, TrueRatio)) {
        ; 点左下角的小房子的位置
        UserClick(333, 2041, scrRatio)
        Sleep 500
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 500
        }
    }
    if !WinActive(nikkeID) {
        MsgBox "窗口未聚焦，程序已中止"
        Pause
    }
    Sleep 1000
}
;tag 进入方舟
EnterToArk() {
    AddLog("尝试进入方舟")
    while True {
        Sleep 1000
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.658 * NikkeW . " ", NikkeY + 0.639 * NikkeH . " ", NikkeX + 0.658 * NikkeW + 0.040 * NikkeW . " ", NikkeY + 0.639 * NikkeH + 0.066 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("方舟的眼睛"), , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L") ;找得到就尝试进入
        }
        if (ok := FindText(&X := "wait", &Y := 5, NikkeX + 0.005 * NikkeW . " ", NikkeY + 0.010 * NikkeH . " ", NikkeX + 0.005 * NikkeW + 0.052 * NikkeW . " ", NikkeY + 0.010 * NikkeH + 0.058 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("左上角的方舟文本"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("已进入方舟")
            break
        }
        else BackToHall() ;找不到就先返回大厅
    }
    Sleep 2000
}
;endregion 流程辅助函数
;region 登录
Login() {
    AddLog("正在登录")
    check := 0
    while True {
        if (check = 3) {
            break
        }
        if (ok := FindText(&X, &Y, NikkeX + 0.658 * NikkeW . " ", NikkeY + 0.639 * NikkeH . " ", NikkeX + 0.658 * NikkeW + 0.040 * NikkeW . " ", NikkeY + 0.639 * NikkeH + 0.066 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("方舟的眼睛"), , 0, , , , , TrueRatio, TrueRatio)) {
            check := check + 1
            continue
        }
        else check := 0
        ;点击蓝色的确认按钮（如果出现更新提示等消息）
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("确认的白色勾"), , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("发现更新，尝试点击")
            FindText().Click(X + 50 * TrueRatio, Y, "L")
            Sleep 1000
        }
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("灰色空心方框"), , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("发现公告，尝试勾选一周内不再提示")
            FindText().Click(X, Y, "L")
        }
        if (ok := FindText(&X, &Y, NikkeX + 0.534 * NikkeW . " ", NikkeY + 0.906 * NikkeH . " ", NikkeX + 0.534 * NikkeW + 0.114 * NikkeW . " ", NikkeY + 0.906 * NikkeH + 0.062 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("勾"), , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        Confirm
        Sleep 500
        if !WinActive(nikkeID) {
            MsgBox "窗口未聚焦，程序已中止"
            Pause
        }
    }
    AddLog("已处于大厅页面，登录成功")
}
;endregion 登录
;region 商店
;tag 付费商店每日每周免费钻
CashShop() {
    BackToHall
    AddLog("===付费商店任务开始===")
    AddLog("寻找付费商店")
    if (ok := FindText(&X, &Y, NikkeX + 0.329 * NikkeW . " ", NikkeY + 0.583 * NikkeH . " ", NikkeX + 0.329 * NikkeW + 0.012 * NikkeW . " ", NikkeY + 0.583 * NikkeH + 0.022 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击付费商店")
        FindText().Click(X, Y, "L")
        Sleep 1000
        if (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("灰色空心方框"), , , , , , 3, TrueRatio, TrueRatio)) {
            AddLog("发现日服特供的框")
            FindText().Click(X, Y, "L")
            Sleep 1000
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("点击确认")
                FindText().Click(X, Y, "L")
            }
        }
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.182 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.330 * NikkeW . " ", NikkeY + 0.182 * NikkeH + 0.075 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("礼物的图标"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("点击一级页面")
            FindText().Click(X + 20 * TrueRatio, Y + 20 * TrueRatio, "L")
            Sleep 1000
        }
        while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.010 * NikkeW . " ", NikkeY + 0.259 * NikkeH . " ", NikkeX + 0.010 * NikkeW + 0.351 * NikkeW . " ", NikkeY + 0.259 * NikkeH + 0.051 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("点击二级页面")
            FindText().Click(X - 20 * TrueRatio, Y + 20 * TrueRatio, "L")
            Sleep 1000
            if (ok := FindText(&X := "wait", &Y := 2, NikkeX + 0.089 * NikkeW . " ", NikkeY + 0.334 * NikkeH . " ", NikkeX + 0.089 * NikkeW + 0.019 * NikkeW . " ", NikkeY + 0.334 * NikkeH + 0.034 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("点击三级页面")
                FindText().Click(X - 20 * TrueRatio, Y + 20 * TrueRatio, "L")
                Sleep 1000
                Confirm
            }
        }
    }
    else {
        AddLog("付费商店已领取！")
        AddLog("===付费商店任务结束===")
        return
    }
    AddLog("===付费商店任务结束===")
    BackToHall
}
;tag 普通商店
NormalShop() {
    AddLog("===普通商店任务开始===")
    BackToHall
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.341 * NikkeW . " ", NikkeY + 0.625 * NikkeH . " ", NikkeX + 0.341 * NikkeW + 0.010 * NikkeW . " ", NikkeY + 0.625 * NikkeH + 0.017 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击商店图标")
        FindText().Click(X - 20 * TrueRatio, Y + 20 * TrueRatio, "L")
    } else {
        AddLog("普通商店已领取")
        AddLog("===普通商店任务结束===")
        BackToHall
        return
    }
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.005 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.065 * NikkeW . " ", NikkeY + 0.005 * NikkeH + 0.055 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("已进入百货商店")
    }
    Sleep 1000
    ; 定义所有可购买物品的信息 (使用 Map)
    PurchaseItems := Map(
        "免费商品", {
            Text: FindText().PicLib("红点"),
            Setting: true,
            Tolerance: 0.1 * PicTolerance },
        "芯尘盒", {
            Text: FindText().PicLib("芯尘盒"),
            Setting: g_settings["NormalShopDust"],
            Tolerance: 0.3 * PicTolerance },
        "简介个性化礼包", {
            Text: FindText().PicLib("简介"),
            Setting: g_settings["NormalShopPackage"],
            Tolerance: 0.3 * PicTolerance }
    )
    loop 2 {
        for Name, item in PurchaseItems {
            if (!item.Setting) {
                continue ; 如果设置未开启，则跳过此物品
            }
            if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.057 * NikkeW . " ", NikkeY + 0.483 * NikkeH . " ", NikkeX + 0.057 * NikkeW + 0.938 * NikkeW . " ", NikkeY + 0.483 * NikkeH + 0.050 * NikkeH . " ", item.Tolerance, item.Tolerance, item.Text, , , , , , , TrueRatio, TrueRatio)) {
                loop ok.Length {
                    FindText().Click(ok[A_Index].x, ok[A_Index].y, "L")
                    Sleep 1000
                    if name = "芯尘盒" {
                        if (ok0 := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("信用点的图标"), , 0, , , , , TrueRatio, TrueRatio)) {
                            AddLog("检测到信用点支付选项")
                        }
                        else {
                            AddLog("未检测到信用点支付选项")
                            Confirm
                            Sleep 1000
                            continue
                        }
                    }
                    if (ok1 := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , 0, , , , , TrueRatio, TrueRatio)) {
                        AddLog("购买" . Name)
                        FindText().Click(X, Y, "L")
                        Sleep 500
                    }
                    while !(ok2 := FindText(&X := "wait", &Y := 3, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.005 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.065 * NikkeW . " ", NikkeY + 0.005 * NikkeH + 0.055 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , 0, , , , , TrueRatio, TrueRatio)) {
                        Confirm
                    }
                }
            } else {
                AddLog(Name . "未找到，跳过购买")
            }
        }
        while (ok := FindText(&X, &Y, NikkeX + 0.173 * NikkeW . " ", NikkeY + 0.423 * NikkeH . " ", NikkeX + 0.173 * NikkeW + 0.034 * NikkeW . " ", NikkeY + 0.423 * NikkeH + 0.050 * NikkeH . " ", 0.25 * PicTolerance, 0.25 * PicTolerance, FindText().PicLib("FREE"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X - 50 * TrueRatio, Y + 30 * TrueRatio, "L")
            if (ok1 := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                AddLog("刷新成功")
            }
        } else {
            AddLog("没有免费刷新次数了，跳过刷新")
            break ; 退出外层 loop 2 循环，因为没有免费刷新了
        }
        Sleep 3000
    }
    AddLog("===普通商店任务结束===")
}
;tag 竞技场商店
ArenaShop() {
    AddLog("===竞技场商店任务开始===")
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.355 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.041 * NikkeW . " ", NikkeY + 0.355 * NikkeH + 0.555 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("竞技场商店的图标"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("进入竞技场商店")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    ; 定义所有可购买物品的信息 (使用 Map)
    PurchaseItems := Map(
        "燃烧代码手册", {
            Text: FindText().PicLib("燃烧代码的图标"),
            Setting: g_settings["BookFire"],
            Tolerance: 0.2 * PicTolerance },
        "水冷代码手册", {
            Text: FindText().PicLib("水冷代码的图标"),
            Setting: g_settings["BookWater"],
            Tolerance: 0.2 * PicTolerance },
        "风压代码手册", {
            Text: FindText().PicLib("风压代码的图标"),
            Setting: g_settings["BookWind"],
            Tolerance: 0.2 * PicTolerance },
        "电击代码手册", {
            Text: FindText().PicLib("电击代码的图标"),
            Setting: g_settings["BookElec"],
            Tolerance: 0.2 * PicTolerance },
        "铁甲代码手册", {
            Text: FindText().PicLib("铁甲代码的图标"),
            Setting: g_settings["BookIron"],
            Tolerance: 0.2 * PicTolerance },
        "代码手册宝箱", {
            Text: FindText().PicLib("代码手册宝箱的图标"),
            Setting: g_settings["BookBox"],
            Tolerance: 0.3 * PicTolerance },
        "简介个性化礼包", {
            Text: FindText().PicLib("简介"),
            Setting: g_settings["ArenaShopPackage"],
            Tolerance: 0.3 * PicTolerance },
        "公司武器熔炉", {
            Text: FindText().PicLib("熔炉"),
            Setting: g_settings["ArenaShopFurnace"],
            Tolerance: 0.3 * PicTolerance }
    )
    ; 遍历并购买所有物品
    for Name, item in PurchaseItems {
        if (!item.Setting) {
            continue ; 如果设置未开启，则跳过此物品
        }
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.054 * NikkeW . " ", NikkeY + 0.481 * NikkeH . " ", NikkeX + 0.054 * NikkeW + 0.934 * NikkeW . " ", NikkeY + 0.481 * NikkeH + 0.242 * NikkeH . " ", item.Tolerance, item.Tolerance, item.Text, , , , , , , TrueRatio, TrueRatio)) {
            ; 手册要根据找到个数多次执行
            loop ok.Length {
                FindText().Click(ok[A_Index].x, ok[A_Index].y, "L")
                if (ok1 := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("购买" . Name)
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                    while !(ok2 := FindText(&X := "wait", &Y := 3, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.005 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.065 * NikkeW . " ", NikkeY + 0.005 * NikkeH + 0.055 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , 0, , , , , TrueRatio, TrueRatio)) {
                        Confirm
                    }
                }
            }
        }
        else {
            AddLog(Name . "未找到，跳过购买")
        }
    }
    AddLog("===竞技场商店任务结束===")
}
;tag 废铁商店
ScrapShop() {
    AddLog("===废铁商店任务开始===")
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.355 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.041 * NikkeW . " ", NikkeY + 0.355 * NikkeH + 0.555 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("废铁商店的图标"), , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    ; 定义所有可购买物品的信息 (使用 Map)
    PurchaseItems := Map(
        "珠宝", {
            Text: "|<珠宝>*150$39.00k01k7wb00C0zis3zzrxz0zzzCDz7zztnzww07CTs7U0zzb0Tzzzcs1zzrzzw7zwCTzU1k1nzw3zsC3w0zzVkTk7zwDbz03r7xzw0Cwzyvk3rb7bQTzz0Mt3zzs070TzzU",
            Setting: g_settings["ScrapShopGem"],
            Tolerance: 0.1 * PicTolerance },
        "好感券", {
            Text: FindText().PicLib("黄色的礼物图标"),
            Setting: g_settings["ScrapShopVoucher"],
            Tolerance: 0.2 * PicTolerance },
        "养成资源", {
            Text: "|<资源的图标>*170$17.1zU7zUS7VnnWTtgTnMCqk7hUTP0yq1xb3i7ZtDzl7y73k1U01zzU",
            Setting: g_settings["ScrapShopResources"],
            Tolerance: 0.2 * PicTolerance },
        "信用点", {
            Text: "|<信用点的图标>*125$31.zXzs0TUzw0DUDz0703zk3U1zw1k3zy0w3zzUT3zzsDnzzy7ztzzXzw0Tlzk07wzw07zTy0zzzz2Djzz0bbzzWNlzzlaMzzsl4TzwQkTzz7ADzzVm7zzsM3zzyA1wzzi7xzzzzxzzzzszzzzsPzzzsB",
            Setting: g_settings["ScrapShopResources"],
            Tolerance: 0.1 * PicTolerance }
    )
    ; 遍历并购买所有物品
    for Name, item in PurchaseItems {
        if (!item.Setting) {
            continue ; 如果设置未开启，则跳过此物品
        }
        if (ok := FindText(&X, &Y, NikkeX + 0.054 * NikkeW . " ", NikkeY + 0.485 * NikkeH . " ", NikkeX + 0.054 * NikkeW + 0.939 * NikkeW . " ", NikkeY + 0.485 * NikkeH + 0.419 * NikkeH . " ", item.Tolerance, item.Tolerance, item.Text, , , , , , , TrueRatio, TrueRatio)) {
            ; 根据找到的同类图标数量进行循环购买
            loop ok.Length {
                FindText().Click(ok[A_Index].x, ok[A_Index].y, "L")
                if (okMax := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("MAX"), , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("点击max")
                    FindText().Click(X, Y, "L")
                }
                if (ok1 := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("购买" . Name)
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                    while !(ok2 := FindText(&X := "wait", &Y := 3, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.005 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.065 * NikkeW . " ", NikkeY + 0.005 * NikkeH + 0.055 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , 0, , , , , TrueRatio, TrueRatio)) {
                        Confirm
                    }
                }
            }
        } else {
            AddLog(Name . "未找到，跳过购买")
        }
    }
    AddLog("===废铁商店任务结束===")
}
;endregion 商店
;region 模拟室
;tag 模拟室
SimulationRoom() {
    EnterToArk
    AddLog("===模拟室任务开始===")
    AddLog("查找模拟室入口")
    while (ok := FindText(&X, &Y, NikkeX + 0.370 * NikkeW . " ", NikkeY + 0.596 * NikkeH . " ", NikkeX + 0.370 * NikkeW + 0.069 * NikkeW . " ", NikkeY + 0.596 * NikkeH + 0.031 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("模拟室"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("进入模拟室")
        FindText().Click(X, Y - 50 * TrueRatio, "L")
    }
    while true {
        if (ok := FindText(&X, &Y, NikkeX + 0.442 * NikkeW . " ", NikkeY + 0.535 * NikkeH . " ", NikkeX + 0.442 * NikkeW + 0.118 * NikkeW . " ", NikkeY + 0.535 * NikkeH + 0.101 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("开始模拟的开始"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("点击开始模拟")
            FindText().Click(X + 30 * TrueRatio, Y, "L")
            Sleep 1000
            break
        }
        else Confirm
    }
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.502 * NikkeW . " ", NikkeY + 0.814 * NikkeH . " ", NikkeX + 0.502 * NikkeW + 0.147 * NikkeW . " ", NikkeY + 0.814 * NikkeH + 0.063 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("快速模拟的图标"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击快速模拟")
        FindText().Click(X + 100 * TrueRatio, Y, "L")
    }
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("跳过增益效果选择的图标"), , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("跳过增益选择")
        FindText().Click(X + 100 * TrueRatio, Y, "L")
    }
    EnterToBattle
    BattleSettlement
    while (ok := FindText(&X, &Y, NikkeX + 0.433 * NikkeW . " ", NikkeY + 0.683 * NikkeH . " ", NikkeX + 0.433 * NikkeW + 0.135 * NikkeW . " ", NikkeY + 0.683 * NikkeH + 0.070 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("模拟结束的图标"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击模拟结束")
        FindText().Click(X + 50 * TrueRatio, Y, "L")
    }
    while !(ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.005 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.065 * NikkeW . " ", NikkeY + 0.005 * NikkeH + 0.055 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , 0, , , , , TrueRatio, TrueRatio)) {
        Confirm
    }
    AddLog("===模拟室任务结束===")
}
;tag 模拟室超频
SimulationOverClock() {
    AddLog("===模拟室超频任务开始===")
    Text := "|<剩余奖励的0>*80$26.s001wTzyCDzzl600C3001lU00AE0014000F0004E3w141VUF0E84E421410UF0E84E66140z0F0004E0014000FU00AA0071U03WDzzllzzsy000S"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("模拟室超频未完成")
        Text := "|<开始超频>*173$63.zzyD7ztzwzs01nszyA1a000CTBX0FY077DUF4Q6Abnttw2QXtk4k7DDU00M0E0000C40E7z02001UrrHUACE00A7zs41U27DDkk70aA0Eltz60kA1806DDs3a3UD34Xty0QkDzsw8zDXk6E0AC0jtyy0n01Xlo"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
    }
    else {
        AddLog("模拟室超频已完成！")
        return
    }
    Text := "|<BIOS>*168$49.03wzVzk3U0yT0Dk0E0DD03k09z7b3kszUzXn7wQzy01tXz60D00wlzX01U0CMzls0Hz7ATszz1zlaDwTzUzsnXwQzkDstk0S7k00Qy0TU0U0STUTs0s"
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    Text := "|<25>*121$44.U00y000k007U00A000s003000C000k001000DzzUEDzzzzw63zzzzz1Uzzzk00M00Dk006000w003U00C001s001U00y0000Dzzzzw03zzzzz00zzzzzk0001U000000E0010006000s001U00S000M00DU"
    if (ok := !FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("难度不是25！跳过")
        return
    }
    Text := "|<开始模拟>*177$110.zzzzzzzzzzTztzzzzzzzzzzlzszzXwQDwTzyT0003wTwDzkw00z7Xz3U000T7z7zwC007lsTks000DlzVzz3U01wS0wS0003wTsszkz73z3UD7z3wDw0QCDk3ttz08Flzkz3y077ls0k07U2AQTwDkzU1VwD0A00w1X37z3wDyAEE3wD00Tlsslzkz3zX000T3lz7wSCATwDkzsl007kM00z7XX7U008QQEDlw200Tkszlk00076Dzzy0Vz3w2DsQ0001lXzzzU000w0XyDU000w8s03k000S0MzXzlz3z0C00w3z1zUCCkTsTkzw3U0C0zszx7U47y7wDzUszXUC007ls00zVz3zsCDss3001wS0UDkzkzy1XyDMk00T7UM1sDwDz0MzXyDs1zlkQ8Q7z3zVa7kzXwADwQC763zkzkTU0Dss70S7b1k0zwDwDs03wA3s71zkwMTz3z7y60z33zXkTyTjTzlzzzbzTtzzzyzzzzU"
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    final := false
    while true {
        Text := "|<获得>*120$30.xvzzzU0D8000C8sstwM0duxcsVkT80XnSA100A80s0880llwDlVlz009UzBntYTAnkCDCHWTDD3U"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        Text := "|<模拟通关>*103$63.rqzTzzzzzzyM1tbbQ0TDXm07AAkk3sswAHl1b71z2700A04yk3U0AM1l47w0C03V0DAUtUFz7w01s7640DszU0A0ssUF00001V67Y0A0130CA0wUFy3sE0t03YkDUDnUT8UM63sMSMEl8E0087UmD4TaHU1Xy4"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            final := True
            AddLog("挑战最后一关")
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        EnterToBattle
        BattleSettlement
        if final = True {
            break
        }
        AddLog("模拟室超频第" A_Index "关已通关！")
        Text := "|<对象>*200$24.zvxzzvsD1vXDt1U1tnm91vk1XPURn/g3lvk3Zvk9DXVAzbyTU"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("获取第" A_Index "次增益")
            FindText().Click(X, Y + 100 * TrueRatio, "L")
            Sleep 500
            FindText().Click(X, Y + 100 * TrueRatio, "L")
            Sleep 500
            FindText().Click(X, Y + 100 * TrueRatio, "L")
        }
        Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
    }
    Text := "|<模拟结束的图标>*159$38.03zzzy01zzzzs0zzzzy0Dk00Dk3k001w0w000D0D0003k00000w00000D000003k0U000w0M000D0S0003kDU000w7zzU0D3zzs03nzzy00xzzzU0Dzzzs03zzzy00xzzzU0DDzzs03lzzy00wDzzU0D0y0003k7U000w0s000D020003k00000w00000D000003k3k000w0w000T0DU00Dk3zzzzw0Tzzzy03zzzz0000302"
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("模拟结束")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("确认模拟结束")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    Text := "|<Lv>*215$15.k0600k0K1bkAy1qk7q0wz3bwMU"
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("获取最后的增益")
        FindText().Click(X, Y, "L")
        Sleep 500
        FindText().Click(X, Y, "L")
        Sleep 500
        FindText().Click(X, Y, "L")
    }
    Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    AddLog("===模拟室超频任务结束===")
}
;endregion 模拟室
;region 竞技场
;tag 竞技场收菜
Arena() {
    EnterToArk()
    AddLog("===竞技场收菜任务开始===")
    AddLog("查找奖励")
    foundReward := false
    while (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("SPECIAL"), , 0, , , , , TrueRatio, TrueRatio)) {
        foundReward := true
        AddLog("点击奖励")
        FindText().Click(X + 30 * TrueRatio, Y, "L")
    }
    if foundReward {
        while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("点击领取")
            FindText().Click(X + 50 * TrueRatio, Y, "L")
        }
        AddLog("尝试确认并返回方舟大厅")
        while !(ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.005 * NikkeW . " ", NikkeY + 0.010 * NikkeH . " ", NikkeX + 0.005 * NikkeW + 0.052 * NikkeW . " ", NikkeY + 0.010 * NikkeH + 0.058 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("左上角的方舟文本"), , , , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
    }
    else AddLog("未找到奖励")
    AddLog("===竞技场收菜任务结束===")
    AddLog("进入竞技场")
    while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.541 * NikkeW . " ", NikkeY + 0.712 * NikkeH . " ", NikkeX + 0.541 * NikkeW + 0.068 * NikkeW . " ", NikkeY + 0.712 * NikkeH + 0.030 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("竞技场"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击竞技场")
        FindText().Click(X, Y - 50 * TrueRatio, "L")
        Sleep 1000
    }
    while !(ok := FindText(&X, &Y, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.002 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.060 * NikkeW . " ", NikkeY + 0.002 * NikkeH + 0.060 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("左上角的竞技场"), , , , , , , TrueRatio, TrueRatio)) {
        Confirm
    }
}
;tag 新人竞技场
RookieArena() {
    AddLog("===新人竞技场任务开始===")
    AddLog("查找新人竞技场")
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.372 * NikkeW . " ", NikkeY + 0.542 * NikkeH . " ", NikkeX + 0.372 * NikkeW + 0.045 * NikkeW . " ", NikkeY + 0.542 * NikkeH + 0.024 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("新人"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击新人竞技场")
        FindText().Click(X + 20 * TrueRatio, Y, "L")
        Sleep 1000
        if A_Index > 3 {
            AddLog("新人竞技场未在开放期间，跳过任务")
            AddLog("===新人竞技场任务结束===")
            return
        }
    }
    AddLog("检测免费次数")
    skip := false
    while True {
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.565 * NikkeW . " ", NikkeY + 0.775 * NikkeH . " ", NikkeX + 0.565 * NikkeW + 0.082 * NikkeW . " ", NikkeY + 0.775 * NikkeH + 0.101 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("免费"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("有免费次数，尝试进入战斗")
            FindText().Click(X, Y + 10 * TrueRatio, "L")
            Sleep 1000
        }
        else break
        if skip = false {
            if (ok := FindText(&X, &Y, NikkeX + 0.393 * NikkeW . " ", NikkeY + 0.815 * NikkeH . " ", NikkeX + 0.393 * NikkeW + 0.081 * NikkeW . " ", NikkeY + 0.815 * NikkeH + 0.041 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("ON"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("快速战斗已开启")
                skip := true
            }
            else if (ok := FindText(&X, &Y, NikkeX + 0.393 * NikkeW . " ", NikkeY + 0.815 * NikkeH . " ", NikkeX + 0.393 * NikkeW + 0.081 * NikkeW . " ", NikkeY + 0.815 * NikkeH + 0.041 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("OFF"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("有笨比没开快速战斗，帮忙开了！")
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        EnterToBattle
        BattleSettlement
        while !(ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.005 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.065 * NikkeW . " ", NikkeY + 0.005 * NikkeH + 0.055 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , 0, , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
    }
    AddLog("没有免费次数，尝试返回")
    while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.001 * NikkeW . " ", NikkeY + 0.005 * NikkeH . " ", NikkeX + 0.001 * NikkeW + 0.065 * NikkeW . " ", NikkeY + 0.005 * NikkeH + 0.055 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , 0, , , , , TrueRatio, TrueRatio)) {
        GoBack
    }
    AddLog("已返回竞技场页面")
    AddLog("===新人竞技场任务结束===")
}
;tag 特殊竞技场
SpecialArena() {
    AddLog("===特殊竞技场任务开始===")
    AddLog("查找特殊竞技场")
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.516 * NikkeW . " ", NikkeY + 0.543 * NikkeH . " ", NikkeX + 0.516 * NikkeW + 0.045 * NikkeW . " ", NikkeY + 0.543 * NikkeH + 0.022 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("特殊"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击特殊竞技场")
        FindText().Click(X + 20 * TrueRatio, Y, "L")
        Sleep 1000
        if A_Index > 3 {
            AddLog("特殊竞技场未在开放期间，跳过任务")
            AddLog("===特殊竞技场任务结束===")
            return
        }
    }
    AddLog("检测免费次数")
    skip := false
    while True {
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.565 * NikkeW . " ", NikkeY + 0.775 * NikkeH . " ", NikkeX + 0.565 * NikkeW + 0.082 * NikkeW . " ", NikkeY + 0.775 * NikkeH + 0.101 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("免费"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("有免费次数，尝试进入战斗")
            FindText().Click(X, Y + 10 * TrueRatio, "L")
            Sleep 1000
        }
        else break
        if skip = false {
            if (ok := FindText(&X, &Y, NikkeX + 0.393 * NikkeW . " ", NikkeY + 0.815 * NikkeH . " ", NikkeX + 0.393 * NikkeW + 0.081 * NikkeW . " ", NikkeY + 0.815 * NikkeH + 0.041 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("ON"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("快速战斗已开启")
                skip := true
            }
            else if (ok := FindText(&X, &Y, NikkeX + 0.393 * NikkeW . " ", NikkeY + 0.815 * NikkeH . " ", NikkeX + 0.393 * NikkeW + 0.081 * NikkeW . " ", NikkeY + 0.815 * NikkeH + 0.041 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("OFF"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("有笨比没开快速战斗，帮忙开了！")
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        EnterToBattle
        BattleSettlement
        while !(ok := FindText(&X, &Y, NikkeX + 0.002 * NikkeW . " ", NikkeY + 0.003 * NikkeH . " ", NikkeX + 0.002 * NikkeW + 0.083 * NikkeW . " ", NikkeY + 0.003 * NikkeH + 0.059 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , , , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
    }
    AddLog("没有免费次数，尝试返回")
    while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.002 * NikkeW . " ", NikkeY + 0.006 * NikkeH . " ", NikkeX + 0.002 * NikkeW + 0.078 * NikkeW . " ", NikkeY + 0.006 * NikkeH + 0.049 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , 0, , , , , TrueRatio, TrueRatio)) {
        GoBack
    }
    AddLog("已返回竞技场页面")
    AddLog("===特殊竞技场任务结束===")
}
;tag 冠军竞技场
ChampionArena() {
    AddLog("===冠军竞技场任务开始===")
    AddLog("查找冠军竞技场")
    Text := "|<应援>*80$30.z7yQ0z3yM500CRg7zw4VDjQ80BjCQ09aSQDBaS00Aaw6TAkwS0CwyQ9DtyQ9DlyNX006F0M0AKQU"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        AddLog("已找到一级应援文本")
        Sleep 1000
    }
    else {
        AddLog("未在应援期间")
        AddLog("===冠军竞技场任务结束===")
        return
    }
    Text := "|<冠军竞技场内部的应援>*140$29.zbyTlyDwk200toYxrVd9vr20GbDA0YaSM19AwE2GHkk4X7XU3iTb27wzA1CUyN2E0MY2"
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y - 50 * TrueRatio, "L")
        AddLog("已找到二级应援文本")
        Sleep 1000
    }
    Text := "|<晋级赛内部的应援>*100$41.0D00kzy0S01Xzzzzy33yrzzwD6NzzzszCnQ001yTzsC71tzzzQC1VzzyMQ31s7Qts7DzyRnUTzzwvb3zDytzw7wTzlps7UzzX3U73xy07067vg0S0ATzTzzkttyzzzXrzzDzz7aSy"
    while true {
        if !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
        else {
            while (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
            Sleep 3000
            break
        }
    }
    if UserCheckColor([1926], [1020], ["0xF2762B"], scrRatio) {
        AddLog("左边支持的人多")
        UserClick(1631, 1104, scrRatio)
    }
    else {
        AddLog("右边支持的人多")
        UserClick(2097, 1096, scrRatio)
    }
    Sleep 1000
    Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    AddLog("===冠军竞技场任务结束===")
    BackToHall
}
;endregion 竞技场
;region 无限之塔
;tag 企业塔
CompanyTower() {
    EnterToArk
    AddLog("===企业塔任务开始===")
    while (ok := FindText(&X, &Y, NikkeX + 0.559 * NikkeW . " ", NikkeY + 0.423 * NikkeH . " ", NikkeX + 0.559 * NikkeW + 0.069 * NikkeW . " ", NikkeY + 0.423 * NikkeH + 0.029 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("无限之塔的无限"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("进入无限之塔")
        FindText().Click(X, Y - 50 * TrueRatio, "L")
    }
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.353 * NikkeW . " ", NikkeY + 0.827 * NikkeH . " ", NikkeX + 0.353 * NikkeW + 0.290 * NikkeW . " ", NikkeY + 0.827 * NikkeH + 0.029 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("每日通关"), , , , , , , TrueRatio, TrueRatio)) {
        count := ok.Length
        AddLog("今天有" count "座塔要打")
        Sleep 1000
        FindText().Click(X, Y, "L")
        loop count {
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.426 * NikkeW . " ", NikkeY + 0.405 * NikkeH . " ", NikkeX + 0.426 * NikkeW + 0.025 * NikkeW . " ", NikkeY + 0.405 * NikkeH + 0.024 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("STAGE"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("已进入塔的内部")
                Sleep 1000
                FindText().Click(X + 100 * TrueRatio, Y, "L")
                EnterToBattle
                BattleSettlement
                RefuseSale
            }
            if !(A_Index = count) {
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("无限之塔·向右的箭头"), , , , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X + 30 * TrueRatio, Y, "L")
                }
            }
        }
        AddLog("所有塔都打过了")
    }
    AddLog("===企业塔任务结束===")
    BackToHall
}
;tag 通用塔
UniversalTower() {
    EnterToArk
    AddLog("===通用塔任务开始===")
    while (ok := FindText(&X, &Y, NikkeX + 0.559 * NikkeW . " ", NikkeY + 0.423 * NikkeH . " ", NikkeX + 0.559 * NikkeW + 0.069 * NikkeW . " ", NikkeY + 0.423 * NikkeH + 0.029 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("无限之塔的无限"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("进入无限之塔")
        FindText().Click(X, Y - 50 * TrueRatio, "L")
    }
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.548 * NikkeW . " ", NikkeY + 0.312 * NikkeH . " ", NikkeX + 0.548 * NikkeW + 0.096 * NikkeW . " ", NikkeY + 0.312 * NikkeH + 0.172 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("塔内的无限之塔"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击塔内的无限之塔")
        FindText().Click(X, Y, "L")
    }
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.426 * NikkeW . " ", NikkeY + 0.405 * NikkeH . " ", NikkeX + 0.426 * NikkeW + 0.025 * NikkeW . " ", NikkeY + 0.405 * NikkeH + 0.024 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("STAGE"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("已进入塔的内部")
        FindText().Click(X + 100 * TrueRatio, Y, "L")
        EnterToBattle
        BattleSettlement
        RefuseSale
    }
    AddLog("===通用塔任务结束===")
    BackToHall
}
;endregion 无限之塔
;region 拦截战
;tag 异常拦截
Interception() {
    BackToHall
    EnterToArk
    AddLog("===异常拦截任务开始===")
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.431 * NikkeW . " ", NikkeY + 0.869 * NikkeH . " ", NikkeX + 0.431 * NikkeW + 0.069 * NikkeW . " ", NikkeY + 0.869 * NikkeH + 0.031 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("拦截战"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y - 50 * TrueRatio, "L")
    }
    while !(ok := FindText(&X, &Y, NikkeX + 0.580 * NikkeW . " ", NikkeY + 0.956 * NikkeH . " ", NikkeX + 0.580 * NikkeW + 0.074 * NikkeW . " ", NikkeY + 0.956 * NikkeH + 0.027 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("红字的异常"), , , , , , , TrueRatio, TrueRatio)) {
        Confirm
        if A_Index > 20 {
            MsgBox("异常个体拦截战未解锁！本脚本暂不支持普通拦截！")
            Pause
        }
    }
    AddLog("已进入异常拦截界面")
    Sleep 1000
    Text := "|<0/3>*90$31.zzwTzw7yDUw0z70A0T7V2D7XnkDXlzs7lszkXsszkFwQTs8yCDzUT7Dzl737lsU3Xw0M3ly0S3lzkTzwzzy"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("异常拦截次数已耗尽")
        AddLog("===异常拦截任务结束===")
        return
    }
    loop 5 {
        switch g_numeric_settings["InterceptionBoss"] {
            case 1:
                if (ok := FindText(&X, &Y, NikkeX + 0.438 * NikkeW . " ", NikkeY + 0.723 * NikkeH . " ", NikkeX + 0.438 * NikkeW + 0.119 * NikkeW . " ", NikkeY + 0.723 * NikkeH + 0.061 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("克拉肯的克"), , , , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS克拉肯")
                    break
                }
            case 2:
                if (ok := FindText(&X, &Y, NikkeX + 0.438 * NikkeW . " ", NikkeY + 0.723 * NikkeH . " ", NikkeX + 0.438 * NikkeW + 0.119 * NikkeW . " ", NikkeY + 0.723 * NikkeH + 0.061 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("镜像容器的镜"), , , , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS镜像容器")
                    break
                }
            case 3:
                if (ok := FindText(&X, &Y, NikkeX + 0.438 * NikkeW . " ", NikkeY + 0.723 * NikkeH . " ", NikkeX + 0.438 * NikkeW + 0.119 * NikkeW . " ", NikkeY + 0.723 * NikkeH + 0.061 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("茵迪维利亚的茵"), , , , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS茵迪维利亚")
                    break
                }
            case 4:
                if (ok := FindText(&X, &Y, NikkeX + 0.438 * NikkeW . " ", NikkeY + 0.723 * NikkeH . " ", NikkeX + 0.438 * NikkeW + 0.119 * NikkeW . " ", NikkeY + 0.723 * NikkeH + 0.061 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("过激派的过"), , , , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS过激派")
                    break
                }
            case 5:
                if (ok := FindText(&X, &Y, NikkeX + 0.438 * NikkeW . " ", NikkeY + 0.723 * NikkeH . " ", NikkeX + 0.438 * NikkeW + 0.119 * NikkeW . " ", NikkeY + 0.723 * NikkeH + 0.061 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("死神的死"), , , , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS死神")
                    break
                }
            default:
                MsgBox "BOSS选择错误！"
                Pause
        }
        AddLog("非对应BOSS，尝试切换")
        if (ok := FindText(&X, &Y, NikkeX + 0.584 * NikkeW . " ", NikkeY + 0.730 * NikkeH . " ", NikkeX + 0.584 * NikkeW + 0.023 * NikkeW . " ", NikkeY + 0.730 * NikkeH + 0.039 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("异常拦截·向右的箭头"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X + 10 * TrueRatio, Y, "L")
        }
        Sleep 1000
    }
    FindText().Click(X, Y + 100 * TrueRatio, "L")
    Sleep 1000
    switch g_numeric_settings["InterceptionBoss"] {
        case 1:
            if (ok := FindText(&X, &Y, NikkeX + 0.472 * NikkeW . " ", NikkeY + 0.648 * NikkeH . " ", NikkeX + 0.472 * NikkeW + 0.179 * NikkeW . " ", NikkeY + 0.648 * NikkeH + 0.060 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("01"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        case 2:
            if (ok := FindText(&X, &Y, NikkeX + 0.472 * NikkeW . " ", NikkeY + 0.648 * NikkeH . " ", NikkeX + 0.472 * NikkeW + 0.179 * NikkeW . " ", NikkeY + 0.648 * NikkeH + 0.060 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("02"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        case 3:
            if (ok := FindText(&X, &Y, NikkeX + 0.472 * NikkeW . " ", NikkeY + 0.648 * NikkeH . " ", NikkeX + 0.472 * NikkeW + 0.179 * NikkeW . " ", NikkeY + 0.648 * NikkeH + 0.060 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("03"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        case 4:
            if (ok := FindText(&X, &Y, NikkeX + 0.472 * NikkeW . " ", NikkeY + 0.648 * NikkeH . " ", NikkeX + 0.472 * NikkeW + 0.179 * NikkeW . " ", NikkeY + 0.648 * NikkeH + 0.060 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("04"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        case 5:
            if (ok := FindText(&X, &Y, NikkeX + 0.472 * NikkeW . " ", NikkeY + 0.648 * NikkeH . " ", NikkeX + 0.472 * NikkeW + 0.179 * NikkeW . " ", NikkeY + 0.648 * NikkeH + 0.060 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("05"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        default:
            MsgBox "BOSS选择错误！"
            Pause
    }
    AddLog("已切换到对应队伍")
    Sleep 1000
    while True {
        if !(ok := FindText(&X, &Y, NikkeX + 0.505 * NikkeW . " ", NikkeY + 0.879 * NikkeH . " ", NikkeX + 0.505 * NikkeW + 0.148 * NikkeW . " ", NikkeY + 0.879 * NikkeH + 0.105 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("异常拦截·进入战斗的进"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("异常拦截次数已耗尽")
            break
        }
        if (ok := FindText(&X, &Y, NikkeX + 0.506 * NikkeW . " ", NikkeY + 0.826 * NikkeH . " ", NikkeX + 0.506 * NikkeW + 0.145 * NikkeW . " ", NikkeY + 0.826 * NikkeH + 0.065 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("拦截战·快速战斗的图标"), , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("已激活快速战斗")
            FindText().Click(X + 50 * TrueRatio, Y, "L")
        }
        else if (ok := FindText(&X, &Y, NikkeX + 0.505 * NikkeW . " ", NikkeY + 0.879 * NikkeH . " ", NikkeX + 0.505 * NikkeW + 0.148 * NikkeW . " ", NikkeY + 0.879 * NikkeH + 0.105 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("异常拦截·进入战斗的进"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("未激活快速战斗，尝试普通战斗")
            FindText().Click(X, Y, "L")
            Sleep 1000
            while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("ESC"), , 0, , , , , TrueRatio, TrueRatio)) {
                UserClick(2123, 1371, scrRatio)
                Sleep 500
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , 0, , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y, "L")
                    AddLog("跳过动画")
                    break
                }
                if (A_Index > 30) {
                    break
                }
            }
        }
        if g_settings["InterceptionShot"] {
            BattleSettlement(true)
        }
        else BattleSettlement
        Sleep 2000
    }
    AddLog("===异常拦截任务结束===")
    BackToHall
}
;endregion 拦截战
;region 前哨基地
;tag 前哨基地收菜
OutpostDefence() {
    BackToHall
    AddLog("===前哨基地收菜任务开始===")
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX + 0.240 * NikkeW . " ", NikkeY + 0.755 * NikkeH . " ", NikkeX + 0.240 * NikkeW + 0.048 * NikkeW . " ", NikkeY + 0.755 * NikkeH + 0.061 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("前哨基地的图标"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击进入前哨基地")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    else {
        AddLog("未找到前哨基地！")
        return
    }
    while !(ok := FindText(&X, &Y, NikkeX + 0.884 * NikkeW . " ", NikkeY + 0.904 * NikkeH . " ", NikkeX + 0.884 * NikkeW + 0.114 * NikkeW . " ", NikkeY + 0.904 * NikkeH + 0.079 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("溢出资源的图标"), , , , , , , TrueRatio, TrueRatio)) {
        Confirm
    }
    while (ok := FindText(&X, &Y, NikkeX + 0.884 * NikkeW . " ", NikkeY + 0.904 * NikkeH . " ", NikkeX + 0.884 * NikkeW + 0.114 * NikkeW . " ", NikkeY + 0.904 * NikkeH + 0.079 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("溢出资源的图标"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击左下角资源")
        FindText().Click(X - 100 * TrueRatio, Y, "L")
        Sleep 1000
    }
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.490 * NikkeW . " ", NikkeY + 0.820 * NikkeH . " ", NikkeX + 0.490 * NikkeW + 0.010 * NikkeW . " ", NikkeY + 0.820 * NikkeH + 0.017 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X - 50 * TrueRatio, Y + 50 * TrueRatio, "L")
        Sleep 1000
        if (ok := FindText(&X, &Y, NikkeX, NikkeX + 0.465 * NikkeW . " ", NikkeY + 0.738 * NikkeH . " ", NikkeX + 0.465 * NikkeW + 0.163 * NikkeW . " ", NikkeY + 0.738 * NikkeH + 0.056 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("歼灭"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("点击进行歼灭")
            FindText().Click(X, Y, "L")
            Sleep 1000
            while !(ok := FindText(&X, &Y, NikkeX + 0.503 * NikkeW . " ", NikkeY + 0.825 * NikkeH . " ", NikkeX + 0.503 * NikkeW + 0.121 * NikkeW . " ", NikkeY + 0.825 * NikkeH + 0.059 * NikkeH . " ", 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("获得奖励的图标"), , , , , , , TrueRatio, TrueRatio)) {
                Confirm
                Sleep 1000
            }
        }
    }
    else AddLog("没有免费一举歼灭")
    AddLog("尝试常规收菜")
    if (ok := FindText(&X, &Y, NikkeX + 0.503 * NikkeW . " ", NikkeY + 0.825 * NikkeH . " ", NikkeX + 0.503 * NikkeW + 0.121 * NikkeW . " ", NikkeY + 0.825 * NikkeH + 0.059 * NikkeH . " ", 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("获得奖励的图标"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击收菜")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    AddLog("尝试返回前哨基地主页面")
    while !(ok := FindText(&X, &Y, NikkeX + 0.884 * NikkeW . " ", NikkeY + 0.904 * NikkeH . " ", NikkeX + 0.884 * NikkeW + 0.114 * NikkeW . " ", NikkeY + 0.904 * NikkeH + 0.079 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("溢出资源的图标"), , , , , , , TrueRatio, TrueRatio)) {
        Confirm
    }
    AddLog("已返回前哨基地主页面")
    AddLog("===前哨基地收菜任务结束===")
    if g_settings["Expedition"] ;派遣
        Expedition()
    BackToHall()
}
;tag 派遣
Expedition() {
    AddLog("===派遣委托任务开始===")
    AddLog("查找派遣公告栏")
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX + 0.500 * NikkeW . " ", NikkeY + 0.901 * NikkeH . " ", NikkeX + 0.500 * NikkeW + 0.045 * NikkeW . " ", NikkeY + 0.901 * NikkeH + 0.092 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("派遣公告栏的图标"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击派遣公告栏")
        FindText().Click(X, Y, "L")
        while (ok := FindText(&X := "wait", &Y := 2, NikkeX + 0.547 * NikkeW . " ", NikkeY + 0.807 * NikkeH . " ", NikkeX + 0.547 * NikkeW + 0.087 * NikkeW . " ", NikkeY + 0.807 * NikkeH + 0.066 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("获得奖励的图标"), , , , , , , TrueRatio * 0.8, TrueRatio * 0.8)) {
            AddLog("点击全部领取")
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        else AddLog("没有可领取的奖励")
        while !(ok := FindText(&X, &Y, NikkeX + 0.378 * NikkeW . " ", NikkeY + 0.137 * NikkeH . " ", NikkeX + 0.378 * NikkeW + 0.085 * NikkeW . " ", NikkeY + 0.137 * NikkeH + 0.040 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("派遣公告栏的派遣"), , , , , , , TrueRatio, TrueRatio)) {
            UserClick(1595, 1806, scrRatio)
            Sleep 500
        }
        AddLog("点击全部派遣")
        if (ok := FindText(&X := "wait", &Y := 2, NikkeX + 0.456 * NikkeW . " ", NikkeY + 0.807 * NikkeH . " ", NikkeX + 0.456 * NikkeW + 0.087 * NikkeW . " ", NikkeY + 0.807 * NikkeH + 0.064 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("全部派遣的图标"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        if (ok := FindText(&X := "wait", &Y := 2, NikkeX + 0.501 * NikkeW . " ", NikkeY + 0.814 * NikkeH . " ", NikkeX + 0.501 * NikkeW + 0.092 * NikkeW . " ", NikkeY + 0.814 * NikkeH + 0.059 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白底蓝色右箭头"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("点击全部派遣")
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
    }
    else AddLog("派遣公告栏未找到！")
    AddLog("===派遣委托任务结束===")
    BackToHall()
}
;endregion 前哨基地
;region 咨询
;tag 好感度咨询
LoveTalking() {
    BackToHall
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.370 * NikkeW . " ", NikkeY + 0.883 * NikkeH . " ", NikkeX + 0.370 * NikkeW + 0.039 * NikkeW . " ", NikkeY + 0.883 * NikkeH + 0.066 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("妮姬的图标"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X + 10 * TrueRatio, Y, "L")
        AddLog("点击妮姬的图标，进入好感度咨询")
        Sleep 1000
    }
    else {
        AddLog("妮姬的图标未找到，无法进行好感度咨询，`n请尝试更换背景图")
        return
    }
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.818 * NikkeW . " ", NikkeY + 0.089 * NikkeH . " ", NikkeX + 0.818 * NikkeW + 0.089 * NikkeW . " ", NikkeY + 0.089 * NikkeH + 0.056 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("咨询的图标"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    while !(ok := FindText(&X, &Y, NikkeX + 0.471 * NikkeW . " ", NikkeY + 0.079 * NikkeH . " ", NikkeX + 0.471 * NikkeW + 0.019 * NikkeW . " ", NikkeY + 0.079 * NikkeH + 0.037 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("咨询的图标"), , , , , , , TrueRatio, TrueRatio)) {
        Confirm
    }
    AddLog("已进入好感度咨询界面")
    ; 花絮鉴赏会
    if g_settings["Appreciation"] {
        Appreciation
    }
    Sleep 1000
    while (ok := FindText(&X, &Y, NikkeX + 0.118 * NikkeW . " ", NikkeY + 0.356 * NikkeH . " ", NikkeX + 0.118 * NikkeW + 0.021 * NikkeW . " ", NikkeY + 0.356 * NikkeH + 0.022 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("》》》"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X + 50 * TrueRatio, Y, "L")
        AddLog("点击左上角的妮姬")
        Sleep 500
    }
    Sleep 1000
    AddLog("===妮姬咨询任务开始===")
    while true {
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.620 * NikkeW . " ", NikkeY + 0.655 * NikkeH . " ", NikkeX + 0.620 * NikkeW + 0.012 * NikkeW . " ", NikkeY + 0.655 * NikkeH + 0.020 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("20/"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("图鉴已满")
            if (ok := FindText(&X, &Y, NikkeX + 0.541 * NikkeW . " ", NikkeY + 0.637 * NikkeH . " ", NikkeX + 0.541 * NikkeW + 0.030 * NikkeW . " ", NikkeY + 0.637 * NikkeH + 0.028 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("MAX"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("好感度也已满，跳过")
                if (ok := FindText(&X, &Y, NikkeX + 0.361 * NikkeW . " ", NikkeY + 0.512 * NikkeH . " ", NikkeX + 0.361 * NikkeW + 0.026 * NikkeW . " ", NikkeY + 0.512 * NikkeH + 0.046 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("收藏的图标"), , , , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y, "L")
                    AddLog("尝试取消收藏该妮姬")
                }
            }
            else if (ok := FindText(&X, &Y, NikkeX + 0.501 * NikkeW . " ", NikkeY + 0.726 * NikkeH . " ", NikkeX + 0.501 * NikkeW + 0.130 * NikkeW . " ", NikkeY + 0.726 * NikkeH + 0.059 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("快速咨询的图标"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("图鉴已满，尝试快速咨询")
                FindText().Click(X, Y, "L")
                Sleep 1000
                Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
                if (ok := FindText(&X, &Y, NikkeX + 0.506 * NikkeW . " ", NikkeY + 0.600 * NikkeH . " ", NikkeX + 0.506 * NikkeW + 0.125 * NikkeW . " ", NikkeY + 0.600 * NikkeH + 0.054 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , , , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y, "L")
                    AddLog("已咨询" A_Index "次")
                    Sleep 1000
                }
            }
            else AddLog("该妮姬已咨询")
        }
        else {
            AddLog("图鉴未满")
            if (ok := FindText(&X, &Y, NikkeX + 0.502 * NikkeW . " ", NikkeY + 0.780 * NikkeH . " ", NikkeX + 0.502 * NikkeW + 0.131 * NikkeW . " ", NikkeY + 0.780 * NikkeH + 0.088 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("咨询的咨"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("尝试普通咨询")
                FindText().Click(X, Y, "L")
                Sleep 1000
                if (ok := FindText(&X, &Y, NikkeX + 0.506 * NikkeW . " ", NikkeY + 0.600 * NikkeH . " ", NikkeX + 0.506 * NikkeW + 0.125 * NikkeW . " ", NikkeY + 0.600 * NikkeH + 0.054 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , , , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                    AddLog("已咨询" A_Index "次")
                }
                Sleep 2000
                while !(ok := FindText(&X, &Y, NikkeX + 0.003 * NikkeW . " ", NikkeY + 0.009 * NikkeH . " ", NikkeX + 0.003 * NikkeW + 0.069 * NikkeW . " ", NikkeY + 0.009 * NikkeH + 0.050 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , , , , , , TrueRatio, TrueRatio)) {
                    UserClick(1894, 1440, scrRatio) ;点击1号位默认位置
                    Sleep 200
                    UserClick(1903, 1615, scrRatio) ;点击2号位默认位置
                    Sleep 200
                    Send "{]}" ;尝试跳过
                    Sleep 200
                }
                Sleep 1000
            }
            else {
                AddLog("该妮姬已咨询")
            }
        }
        if (ok := FindText(&X, &Y, NikkeX + 0.502 * NikkeW . " ", NikkeY + 0.780 * NikkeH . " ", NikkeX + 0.502 * NikkeW + 0.131 * NikkeW . " ", NikkeY + 0.780 * NikkeH + 0.088 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("0/"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("咨询次数已耗尽")
            break
        }
        while !(ok := FindText(&X, &Y, NikkeX + 0.003 * NikkeW . " ", NikkeY + 0.009 * NikkeH . " ", NikkeX + 0.003 * NikkeW + 0.069 * NikkeW . " ", NikkeY + 0.009 * NikkeH + 0.050 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("圈中的感叹号"), , , , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
        if (ok := FindText(&X, &Y, NikkeX + 0.970 * NikkeW . " ", NikkeY + 0.403 * NikkeH . " ", NikkeX + 0.970 * NikkeW + 0.024 * NikkeW . " ", NikkeY + 0.403 * NikkeH + 0.067 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("咨询·向右的图标"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("下一个妮姬")
            FindText().Click(X - 30 * TrueRatio, Y, "L")
            Sleep 1000
        }
    }
    AddLog("===妮姬咨询任务结束===")
    BackToHall
}
;tag 花絮鉴赏
Appreciation() {
    AddLog("===花絮鉴赏任务开始===")
    Sleep 1000
    Text := "|<花絮>*200$44.zTrzzzzzXszyDzzkQ6y0A000070300001sElXsyDyCQwyTrzU7DDbzzw1lXsszzUQ0wSDTU00C7X3ksAzXs0zsCDky0zs63sD0zy07Q3Uzzk7XUkDzw1UTA3zw003XsyT01gsyDbwwnzDXly7ADns0S7Xkwz0DXUyDDzzzwzy"
    while (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X + 50 * TrueRatio, Y, "L")
        AddLog("点击花絮")
    }
    Text := "|<EPISO>*191$67.DztzwC7zU7sDzwzzb7zsDzDzyTznbzyDzr00C0tnU77VvU070Qtk070Tzy3zyQzy3U7zz1zyCDzXU3zzUzy73ztk1y00Q03U0SQ0z00C01k07C0TU0700tk3bUTk03U0Qw3lsSzztk0CDzkTyDzws077zs7y3zyQ03Uzk0w4"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("播放第一个片段")
        FindText().Click(X, Y, "L")
    }
    else {
        AddLog("花絮鉴赏任务已完成")
        AddLog("===花絮鉴赏任务结束===")
        Text := "|<左上角的咨询>*200$35.zbzzvz60DbXzw0Db3zn6zw0DiRzlyTwTznyVkTXUQDCTbavsyDjBrvyzS3DXvywqM07wtglzDsENbzTlbn7wz7za01yTsSTnzztk"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
        return
    }
    Text领取 := "|<领取>*200$40.wzzzzzzVU1U1zy706000kD3wEU24QTl608E070Qs0U0Q1n4lkFl74P7976QFUAYQ1s60GFk7UzX970S3yA4QMwDtkFl1ls716063Uz1s0E7Xs3V60D767yMsyswTtbrzrzzbzs"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text领取, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("播放下一个片段")
        Send "{]}" ;尝试跳过
        Text播放 := "|<播放>*200$53.sTzlztz7zks01zVy7zVk03z3wDz3U0Dz7sTy7W4D01kzk328y0100U601w02010000w7w03VU01wDkMT3U03sTUky7k0Tk01VwC00TU037s0AED000DU0sky480Q0003w8S0w3U07sEw3s700DlVs7wC4ATX3sTsQ00y67kTks01wAD0TVk03sMM0T3V37VkU0M700C001UES00SA67Vkw00ysQzr"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text播放, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
        }
    }
    FindText().Click(X, Y, "L")
    AddLog("领取奖励")
    Text := "|<左上角的咨询>*200$35.zbzzvz60DbXzw0Db3zn6zw0DiRzlyTwTznyVkTXUQDCTbavsyDjBrvyzS3DXvywqM07wtglzDsENbzTlbn7wz7za01yTsSTnzztk"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        Confirm
    }
    AddLog("===花絮鉴赏任务结束===")
}
;endregion 咨询
;region 好友点数收取
FriendPoint() {
    BackToHall
    AddLog("===好友点数任务开始===")
    while (ok := FindText(&X, &Y, NikkeX + 0.980 * NikkeW . " ", NikkeY + 0.213 * NikkeH . " ", NikkeX + 0.980 * NikkeW + 0.009 * NikkeW . " ", NikkeY + 0.213 * NikkeH + 0.016 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击好友")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    while (ok := FindText(&X, &Y, NikkeX + 0.628 * NikkeW . " ", NikkeY + 0.822 * NikkeH . " ", NikkeX + 0.628 * NikkeW + 0.010 * NikkeW . " ", NikkeY + 0.822 * NikkeH + 0.017 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击赠送")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    AddLog("===好友点数任务结束===")
    BackToHall
}
;endregion 好友点数收取
;region 邮箱收取
Mail() {
    BackToHall
    AddLog("===邮箱任务开始===")
    while (ok := FindText(&X, &Y, NikkeX + 0.962 * NikkeW . " ", NikkeY + 0.017 * NikkeH . " ", NikkeX + 0.962 * NikkeW + 0.008 * NikkeW . " ", NikkeY + 0.017 * NikkeH + 0.015 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击邮箱")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    else {
        AddLog("邮箱已领取")
        AddLog("===邮箱任务结束===")
        return
    }
    while (ok := FindText(&X, &Y, NikkeX + 0.519 * NikkeW . " ", NikkeY + 0.817 * NikkeH . " ", NikkeX + 0.519 * NikkeW + 0.110 * NikkeW . " ", NikkeY + 0.817 * NikkeH + 0.063 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("白底蓝色右箭头"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击全部领取")
        FindText().Click(X + 50 * TrueRatio, Y, "L")
    }
    AddLog("===邮箱任务结束===")
    BackToHall
}
;endregion 邮箱收取
;region 方舟排名奖励
;tag 排名奖励
RankingReward() {
    EnterToArk()
    while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.979 * NikkeW . " ", NikkeY + 0.138 * NikkeH . " ", NikkeX + 0.979 * NikkeW + 0.010 * NikkeW . " ", NikkeY + 0.138 * NikkeH + 0.018 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X - 30 * TrueRatio, Y + 30 * TrueRatio, "L")
    }
    else {
        AddLog("没有可领取的排名奖励，跳过")
        return
    }
    AddLog("===排名奖励任务开始===")
    loop 2 {
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.623 * NikkeW . " ", NikkeY + 0.213 * NikkeH . " ", NikkeX + 0.623 * NikkeW + 0.047 * NikkeW . " ", NikkeY + 0.213 * NikkeH + 0.125 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("点击大标题上的红点")
            FindText().Click(X, Y, "L")
            Sleep 1000
            while (ok1 := FindText(&X := "wait", &Y := 3, NikkeX + 0.632 * NikkeW . " ", NikkeY + 0.799 * NikkeH . " ", NikkeX + 0.632 * NikkeW + 0.012 * NikkeW . " ", NikkeY + 0.799 * NikkeH + 0.023 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
                AddLog("点击领取")
                FindText().Click(X, Y, "L")
            }
            Confirm
            GoBack
        }
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.330 * NikkeW . " ", NikkeY + 0.513 * NikkeH . " ", NikkeX + 0.330 * NikkeW + 0.340 * NikkeW . " ", NikkeY + 0.513 * NikkeH + 0.109 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
            loop ok.Length {
                FindText().Click(ok[A_Index].x, ok[A_Index].y, "L")
                AddLog("点击小标题上的红点")
                Sleep 1000
                while (ok1 := FindText(&X := "wait", &Y := 3, NikkeX + 0.632 * NikkeW . " ", NikkeY + 0.799 * NikkeH . " ", NikkeX + 0.632 * NikkeW + 0.012 * NikkeW . " ", NikkeY + 0.799 * NikkeH + 0.023 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
                    AddLog("点击领取")
                    FindText().Click(X, Y, "L")
                }
                Confirm
                GoBack
            }
        }
        UserMove(1858, 615, scrRatio)
        Send "{WheelDown 30}"
        Sleep 1000
    }
    AddLog("===排名奖励任务结束===")
    BackToHall
}
;endregion 方舟排名奖励
;region 每日任务收取
Mission() {
    BackToHall
    AddLog("===每日任务奖励领取开始===")
    while (ok := FindText(&X, &Y, NikkeX + 0.874 * NikkeW . " ", NikkeY + 0.073 * NikkeH . " ", NikkeX + 0.874 * NikkeW + 0.011 * NikkeW . " ", NikkeY + 0.073 * NikkeH + 0.019 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 3000
    }
    else {
        AddLog("每日任务奖励已领取")
        AddLog("===每日任务奖励领取结束===")
        return
    }
    while true {
        while !(ok := FindText(&X, &Y, NikkeX + 0.548 * NikkeW . " ", NikkeY + 0.864 * NikkeH . " ", NikkeX + 0.548 * NikkeW + 0.093 * NikkeW . " ", NikkeY + 0.864 * NikkeH + 0.063 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("灰色的全部"), , , , , , , TrueRatio, TrueRatio)) {
            UserClick(2412, 1905, scrRatio)
            Sleep 1000
        }
        if (ok := FindText(&X, &Y, NikkeX + 0.354 * NikkeW . " ", NikkeY + 0.154 * NikkeH . " ", NikkeX + 0.354 * NikkeW + 0.292 * NikkeW . " ", NikkeY + 0.154 * NikkeH + 0.023 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("浅红点"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
        }
        else break
    }
    AddLog("===每日任务奖励领取结束===")
    BackToHall
}
;endregion 每日任务收取
;region 剧情活动
;tag 小活动
Session() {
    BackToHall
    if (ok := FindText(&X, &Y, NikkeX + 0.645 * NikkeW . " ", NikkeY + 0.719 * NikkeH . " ", NikkeX + 0.645 * NikkeW + 0.123 * NikkeW . " ", NikkeY + 0.719 * NikkeH + 0.131 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("作战出击的击"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y + 100 * TrueRatio, "L")
    }
    Text := "|<挑战>*200$42.vxrzzyznwrznyPnwrznyPngrTnyT00qTkCT0kkzlyRnkkzns0nwrznsDnwrznyTkwnzVyRUsky0CN3kkSSD3nVqSzD3ndrSzD7ntryzDDntryzCCnnrC0A6nXnC08UXDkST9lU"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , , , , , , TrueRatio, TrueRatio)) {
        Confirm
        Send "{]}"
    }
    AddLog("===剧情活动任务开始===")
    AddLog("尝试完成挑战任务")
    Text := "|<挑战>*200$42.vxrzzyznwrznyPnwrznyPngrTnyT00qTkCT0kkzlyRnkkzns0nwrznsDnwrznyTkwnzVyRUsky0CN3kkSSD3nVqSzD3ndrSzD7ntryzDDntryzCCnnrC0A6nXnC08UXDkST9lU"
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 3000
        Text红 := "|<红色的关卡的循环图标>B40000-0.70$61.00000000000000000000000000000000000000000000000000000000000000000000000000001U000000000w000000000TU0000003zzsDzs0001zzz7zw0000zzzvzy0000Tzztzz0000DzzkzzU0007kTU07k0003sD003s0001w7001w0000y2000y0000T0000T0000DU000DU0007k0007k0003s0063s0001w00D1w0000y00TUy0000T00TkT0000DzkzzzU0007ztzzzk0003zwzzzs0001zy7zzw0000000zU000000007k000000001s000000000A00000000000000000000000000000000000000000000000000004"
        Text黄 := "|<黄色的关卡的循环图标>F5A317-0.60$49.0000000000000000000000000000000000000000000000000000A00000007U0000003w00000Dzz1zy00DzzszzU07zzyTzk03zzyDzs01zzw7zw00y3w00y00T1s00T00DUk00DU07k0007k03s0003s01w0001w00y0000y00T000kT00DU01sDU07k03w7k03s03y3s01zy7zzw00zzDzzy00TzXzzz00DzkTzz000007w0000000y0000000700000000U000000000000000001"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text红, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
        }
        else if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text黄, , 0, , , , 3, TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
        }
        Text := "|<快速战斗的图标>*194$29.UD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0Ty0w1zs3k7zUD0Ty0w1zs3k7zUD0Ty0w1zs3k7zUD0Ty0w1zs3k7zs"
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("快速战斗已激活")
            FindText().Click(X, Y, "L")
            Text := "|<进行战斗的战斗>*186$45.zzrzzzbzbwPzzwTszWDyDXz3wMzUwTs3X7y1Xz0ARzwATs1VbzvXz3s0TTwTsy07kzXz7k9y3wTsTlbsDXs0C8zlwT01k7zTXs0C1zzs07lkDzk00yD3w0007lsz003syC6M1wT01U3zzXs000TzwT0047zzXsy1kzzwTzzzDzzbw"
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
            Text := "|<左上角的挑战>*110$38.ls7yT7wS1z7kD607kwF000w16k00T0Ea207ss1lU3yS0QC1z7Ui30D061001k1UEE0A0MC44H763l15llVwMFAMM76AH040V30k00MFkAM66TzDzznU"
            while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                Confirm
            }
            AddLog("完成挑战任务")
        }
        else {
            EnterToBattle
            BattleSettlement
            AddLog("完成挑战任务")
        }
    }
    Text := "|<剧情活动>*200$73.zzvvyTzztzzrk3xxk0wS0y1vs1ayM0zC1z0xwynT7XzztzzwS0Ni00Dzwzzw10Ar3wzzwDzy0aSPX01lk0M1bH7Blzzwz3w1nc0ayw0zznzbtolnTQ0TztzrwsttjiTjzU3viQ04rr07xk1tnQ03vvXnwvww1C1txxk1wxyQ072wyys0ySTDDXX0QTQzST07zn3aSTiSDzU3zzX"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        GoBack
    }
    Text := "|<加成>*200$32.nzzzawzzztbDYw00UPjDbwqvntzRiwyNrPj0qxqvnBDRiwn7rPjAltqvrAyxixbCiMCTdbCvbr6"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y - 100 * TrueRatio, "L")
        Sleep 1000
        ;Text := "|<离活动开始还剩下的剩下>*200$36.zbtzzzU7tzzzwztU00yTNznz01NznzyzNznzqbNzlzaXNzkTqbNzk7qrNznXalNznnwTNznzsDtznzsXtznzavtznziznznzyzXznzU"
        ;if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        ;    AddLog("困难未在开放期间，可以继续")
        ;}
        UserClick(1662, 2013, scrRatio)
        Sleep 1000
        UserClick(1662, 2013, scrRatio)
        Sleep 1000
        UserClick(1662, 2013, scrRatio)
        Sleep 1000
        Text := "|<1-11>*100$53.y3zzzw7z1k7zzzUDs20Dzzw0T040Tzzs0y001zzzU3s0q3zzzA7n1w7zzzsDy3sDzzzkTw7kzzzzVzsT1zzzy3zUy3s07w7z1w7k0TsDy3sTU0zkzwDUz01z1zkT1zzzy3zUy3zzzw7z1wDzzzsTy7kTzzzUzsDUzzzz1zkT1zzzy3zUy7zzzwDz3sDzzzkTw7s"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("刷11关")
            FindText().Click(X, Y, "L")
            Text := "|<快速战斗的图标>*194$29.UD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0Ty0w1zs3k7zUD0Ty0w1zs3k7zUD0Ty0w1zs3k7zUD0Ty0w1zs3k7zs"
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("快速战斗已激活")
                FindText().Click(X, Y, "L")
                Text := "|<MAX>*130$23.66CMAAQYMMt8klkFV1lX2HX64b649CA2GQM4Ysk91lUG399UWGH3YZa73XBiLM"
                if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.15 * PicTolerance, 0.15 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("进行多倍率快速战斗")
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                }
                Text := "|<进行战斗的战斗>*186$45.zzrzzzbzbwPzzwTszWDyDXz3wMzUwTs3X7y1Xz0ARzwATs1VbzvXz3s0TTwTsy07kzXz7k9y3wTsTlbsDXs0C8zlwT01k7zTXs0C1zzs07lkDzk00yD3w0007lsz003syC6M1wT01U3zzXs000TzwT0047zzXsy1kzzwTzzzDzzbw"
                if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y, "L")
                }
                AddLog("完成活动关卡")
            }
            else {
                EnterToBattle
                BattleSettlement
                AddLog("完成活动关卡")
            }
        }
        else {
            AddLog("未找到第11关")
        }
    }
    Text := "|<剧情活动>*200$73.zzvvyTzztzzrk3xxk0wS0y1vs1ayM0zC1z0xwynT7XzztzzwS0Ni00Dzwzzw10Ar3wzzwDzy0aSPX01lk0M1bH7Blzzwz3w1nc0ayw0zznzbtolnTQ0TztzrwsttjiTjzU3viQ04rr07xk1tnQ03vvXnwvww1C1txxk1wxyQ072wyys0ySTDDXX0QTQzST07zn3aSTiSDzU3zzX"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        GoBack
    }
    AddLog("===剧情活动任务结束===")
    BackToHall
}
;tag 大活动
Festival() {
    BackToHall
    AddLog("===大活动任务开始===")
    BackToHall
    if (ok := FindText(&X, &Y, NikkeX + 0.645 * NikkeW . " ", NikkeY + 0.719 * NikkeH . " ", NikkeX + 0.645 * NikkeW + 0.123 * NikkeW . " ", NikkeY + 0.719 * NikkeH + 0.131 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("作战出击的击"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y + 100 * TrueRatio, "L")
        Sleep 500
    }
    while !(ok := FindText(&X, &Y, NikkeX + 0.002 * NikkeW . " ", NikkeY + 0.002 * NikkeH . " ", NikkeX + 0.002 * NikkeW + 0.061 * NikkeW . " ", NikkeY + 0.002 * NikkeH + 0.053 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("活动地区"), , , , , , , TrueRatio, TrueRatio)) {
        Confirm
    }
    AddLog("已进入活动地区")
    AddLog("===签到===")
    while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.553 * NikkeW . " ", NikkeY + 0.781 * NikkeH . " ", NikkeX + 0.553 * NikkeW + 0.105 * NikkeW . " ", NikkeY + 0.781 * NikkeH + 0.058 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("签到"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X - 50 * TrueRatio, Y, "L")
        Sleep 500
    }
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX + 0.530 * NikkeW . " ", NikkeY + 0.915 * NikkeH . " ", NikkeX + 0.530 * NikkeW + 0.106 * NikkeW . " ", NikkeY + 0.915 * NikkeH + 0.049 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("全部领取的全部"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("点击全部领取")
    }
    while !(ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.002 * NikkeW . " ", NikkeY + 0.002 * NikkeH . " ", NikkeX + 0.002 * NikkeW + 0.061 * NikkeW . " ", NikkeY + 0.002 * NikkeH + 0.053 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("活动地区"), , , , , , , TrueRatio, TrueRatio)) {
        GoBack
        Sleep 1000
    }
    AddLog("===刷挑战===")
    while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.356 * NikkeW . " ", NikkeY + 0.840 * NikkeH . " ", NikkeX + 0.356 * NikkeW + 0.107 * NikkeW . " ", NikkeY + 0.840 * NikkeH + 0.060 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("挑战"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X - 50 * TrueRatio, Y, "L")
        Sleep 500
    }
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX + 0.003 * NikkeW . " ", NikkeY + 0.005 * NikkeH . " ", NikkeX + 0.003 * NikkeW + 0.063 * NikkeW . " ", NikkeY + 0.005 * NikkeH + 0.050 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("挑战关卡"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("进入挑战关卡页面")
    }
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.354 * NikkeW . " ", NikkeY + 0.344 * NikkeH . " ", NikkeX + 0.354 * NikkeW + 0.052 * NikkeW . " ", NikkeY + 0.344 * NikkeH + 0.581 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("红色的关卡的循环图标"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
    }
    else if (ok := FindText(&X, &Y, NikkeX + 0.354 * NikkeW . " ", NikkeY + 0.344 * NikkeH . " ", NikkeX + 0.354 * NikkeW + 0.052 * NikkeW . " ", NikkeY + 0.344 * NikkeH + 0.581 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("黄色的关卡的循环图标"), , , , , , 3, TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
    }
    EnterToBattle
    BattleSettlement
    while !(ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.002 * NikkeW . " ", NikkeY + 0.002 * NikkeH . " ", NikkeX + 0.002 * NikkeW + 0.061 * NikkeW . " ", NikkeY + 0.002 * NikkeH + 0.053 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("活动地区"), , , , , , , TrueRatio, TrueRatio)) {
        GoBack
        Sleep 1000
    }
    AddLog("===刷11关===")
    while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.355 * NikkeW . " ", NikkeY + 0.719 * NikkeH . " ", NikkeX + 0.355 * NikkeW + 0.107 * NikkeW . " ", NikkeY + 0.719 * NikkeH + 0.062 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("STORYⅠ"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X - 50 * TrueRatio, Y, "L")
        Sleep 500
    }
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX + 0.002 * NikkeW . " ", NikkeY + 0.005 * NikkeH . " ", NikkeX + 0.002 * NikkeW + 0.060 * NikkeW . " ", NikkeY + 0.005 * NikkeH + 0.052 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("剧情活动"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("进入剧情活动页面")
    }
    else MsgBox("进入剧情活动超时")
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.453 * NikkeW . " ", NikkeY + 0.769 * NikkeH . " ", NikkeX + 0.453 * NikkeW + 0.040 * NikkeW . " ", NikkeY + 0.769 * NikkeH + 0.031 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("时间"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y - 50 * TrueRatio, "L")
    }
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.003 * NikkeW . " ", NikkeY + 0.002 * NikkeH . " ", NikkeX + 0.003 * NikkeW + 0.054 * NikkeW . " ", NikkeY + 0.002 * NikkeH + 0.058 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("活动关卡"), , , , , , , TrueRatio, TrueRatio)) {
        AddLog("进入活动关卡页面")
        Sleep 500
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.499 * NikkeW . " ", NikkeY + 0.523 * NikkeH . " ", NikkeX + 0.499 * NikkeW + 0.079 * NikkeW . " ", NikkeY + 0.523 * NikkeH + 0.089 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("REPEAT"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            EnterToBattle
            BattleSettlement
        }
    }
    while !(ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.002 * NikkeW . " ", NikkeY + 0.002 * NikkeH . " ", NikkeX + 0.002 * NikkeW + 0.061 * NikkeW . " ", NikkeY + 0.002 * NikkeH + 0.053 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("活动地区"), , , , , , , TrueRatio, TrueRatio)) {
        GoBack
        Sleep 1000
    }
    AddLog("===协同作战===")
    if g_settings["Cooperate"] {
        while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.463 * NikkeW . " ", NikkeY + 0.895 * NikkeH . " ", NikkeX + 0.463 * NikkeW + 0.073 * NikkeW . " ", NikkeY + 0.895 * NikkeH + 0.043 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("协同作战的协同"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X - 50 * TrueRatio, Y, "L")
            Sleep 500
        }
        if (ok := FindText(&X := "wait", &Y := 5, NikkeX + 0.367 * NikkeW . " ", NikkeY + 0.570 * NikkeH . " ", NikkeX + 0.367 * NikkeW + 0.269 * NikkeW . " ", NikkeY + 0.570 * NikkeH + 0.027 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X - 50 * TrueRatio, Y + 50 * TrueRatio, "L")
        }
        CooperateBattle
        while !(ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.002 * NikkeW . " ", NikkeY + 0.002 * NikkeH . " ", NikkeX + 0.002 * NikkeW + 0.061 * NikkeW . " ", NikkeY + 0.002 * NikkeH + 0.053 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("活动地区"), , , , , , , TrueRatio, TrueRatio)) {
            GoBack
            Sleep 1000
        }
    }
    AddLog("===领取奖励===")
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.951 * NikkeW . " ", NikkeY + 0.230 * NikkeH . " ", NikkeX + 0.951 * NikkeW + 0.045 * NikkeW . " ", NikkeY + 0.230 * NikkeH + 0.072 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("任务的图标"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
    }
    while !(ok := FindText(&X, &Y, NikkeX + 0.548 * NikkeW . " ", NikkeY + 0.864 * NikkeH . " ", NikkeX + 0.548 * NikkeW + 0.093 * NikkeW . " ", NikkeY + 0.864 * NikkeH + 0.063 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("灰色的全部"), , , , , , , TrueRatio, TrueRatio)) {
        UserClick(2412, 1905, scrRatio)
        Sleep 1000
    }
    AddLog("===大活动任务结束===")
    BackToHall
}
;endregion 剧情活动
;region 通行证收取
;tag 查找通行证
Pass() {
    BackToHall()
    AddLog("===通行证任务开始===")
    loop 4 {
        t := 0
        if (ok := FindText(&X, &Y, NikkeX + 0.988 * NikkeW . " ", NikkeY + 0.127 * NikkeH . " ", NikkeX + 0.988 * NikkeW + 0.010 * NikkeW . " ", NikkeY + 0.127 * NikkeH + 0.020 * NikkeH . " ", 0.4 * PicTolerance, 0.4 * PicTolerance, FindText().PicLib("红点"), , , , , , , TrueRatio, TrueRatio)) {
            t := t + 1
            AddLog("执行第" t "个通行证")
            OnePass()
        }
        UserMove(3787, 369, scrRatio)
        Click "Down"
        UserMove(3458, 369, scrRatio)
        Click "Up"
        Sleep 500
    }
    AddLog("===通行证任务结束===")
    BackToHall()
}
;tag 执行一次通行证
OnePass() {
    UserClick(3633, 405, scrRatio)
    loop 2 {
        Sleep 1000
        if A_Index = 1 {
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.498 * NikkeW . " ", NikkeY + 0.280 * NikkeH . " ", NikkeX + 0.498 * NikkeW + 0.145 * NikkeW . " ", NikkeY + 0.280 * NikkeH + 0.086 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("任务"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        if A_Index = 2 {
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.356 * NikkeW . " ", NikkeY + 0.278 * NikkeH . " ", NikkeX + 0.356 * NikkeW + 0.145 * NikkeW . " ", NikkeY + 0.278 * NikkeH + 0.070 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("奖励"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        while !(ok := FindText(&X, &Y, NikkeX + 0.429 * NikkeW . " ", NikkeY + 0.903 * NikkeH . " ", NikkeX + 0.429 * NikkeW + 0.143 * NikkeW . " ", NikkeY + 0.903 * NikkeH + 0.050 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("灰色的全部"), , , , , , , TrueRatio, TrueRatio)) {
            UserClick(2168, 2020, scrRatio) ;点领取
            Sleep 200
            UserClick(2168, 2020, scrRatio) ;点领取
            Sleep 200
            UserClick(2168, 2020, scrRatio) ;点领取
            Sleep 200
        }
    }
    BackToHall()
}
;endregion 通行证收取
;region 招募
;tag 每日免费招募
FreeRecruit() {
    BackToHall()
    AddLog("===每日免费招募开始===")
    Text每天免费 := "|<每天免费>*156$64.wzzzzzbzz9zU0s03w1z00S01U0DU7zmNnzzyTwQzk0601ztzU07Abs07zby00Q00t6S00QttwNna9s01nba3aE01z3z00Q03167wDw03s0DgNzUTz9zbAw03wMzsbSNnk07Xky6Qt0TztsTVUs20kTyDbzbDUMTsU"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text每天免费, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        AddLog("进入招募页面")
        Sleep 1000
        while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text每天免费, , 0, , , , , TrueRatio, TrueRatio)) {
            Text每日免费 := "|<每日免费>*122$73.szzs07z3zw00s01w01z07y00A00y00z03zU04TzzDwT3XzU0001zbyD007k0200Dnz7U01s00U07szXkkkw00MlXw01wQwS3W0E0y00y00C1l800D7wT007U04007byDk07s03a6Tnz7z0zwtll07tzXz2TyQss01w01z3DDA0w00y00y3X7UEDz1z00S3k30S3zVzbzDjw3Vzt"
            if (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.3 * PicTolerance, 0.3 * PicTolerance, Text每日免费, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("进行招募")
                FindText().Click(X, Y, "L")
                Recruit()
            }
            else {
                ;点击翻页
                Sleep 1000
                UserClick(3774, 1147, scrRatio)
                Sleep 1000
            }
        }
    }
    AddLog("===每日免费招募结束===")
    UserClick(1929, 1982, scrRatio) ;点击大厅
}
;endregion 招募
;region 协同作战
Cooperate() {
    BackToHall
    AddLog("===协同作战任务开始===")
    ;把鼠标移动到活动栏
    UserMove(150, 257, scrRatio)
    Text := "|<COOP的P>*40$40.00000Q000001U00000A000001U00000A000001U00000A000001U00000A000003U000Dzw00E0zzU0303zw00Q0C0003k0s000T03U003w0C000Tk0s003z03U00Tw0C003zk0s00Tz03U03zw0Dzzzzk0zzzzz03zzzzw0Dzzzzk0zzzzz03zzzzw0Dzzzzk0zzzzz03zzzzw0Dzzzzk0zzzzz03zzzzw0Dzzzzs"
    while true {
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            break
        }
        else {
            AddLog("尝试滑动左上角的活动栏")
            Send "{WheelDown 3}"
            Sleep 500
        }
        if (A_Index > 15) {
            AddLog("未能找到协同作战")
            return
        }
    }
    CooperateBattle
    AddLog("===协同作战任务结束===")
    BackToHall
}
CooperateBattle() {
    while true {
        if (ok := FindText(&X := "wait", &Y := 5, NikkeX + 0.851 * NikkeW . " ", NikkeY + 0.750 * NikkeH . " ", NikkeX + 0.851 * NikkeW + 0.134 * NikkeW . " ", NikkeY + 0.750 * NikkeH + 0.068 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("开始匹配的开始"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 500
        }
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.508 * NikkeW . " ", NikkeY + 0.600 * NikkeH . " ", NikkeX + 0.508 * NikkeW + 0.120 * NikkeW . " ", NikkeY + 0.600 * NikkeH + 0.053 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , , , , , , TrueRatio, TrueRatio)) {
            AddLog("协同作战次数已耗尽")
            return
        }
        else {
            AddLog("协同作战次数已耗尽或未在开放时间")
            AddLog("===协同作战任务结束===")
            BackToHall
            return
        }
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.375 * NikkeW . " ", NikkeY + 0.436 * NikkeH . " ", NikkeX + 0.375 * NikkeW + 0.250 * NikkeW . " ", NikkeY + 0.436 * NikkeH + 0.103 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("普通"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 500
        }
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.373 * NikkeW . " ", NikkeY + 0.644 * NikkeH . " ", NikkeX + 0.373 * NikkeW + 0.253 * NikkeW . " ", NikkeY + 0.644 * NikkeH + 0.060 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("确认"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
        }
        while true {
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.511 * NikkeW . " ", NikkeY + 0.660 * NikkeH . " ", NikkeX + 0.511 * NikkeW + 0.106 * NikkeW . " ", NikkeY + 0.660 * NikkeH + 0.054 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("白色的圆圈加勾"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.444 * NikkeW . " ", NikkeY + 0.915 * NikkeH . " ", NikkeX + 0.444 * NikkeW + 0.112 * NikkeW . " ", NikkeY + 0.915 * NikkeH + 0.052 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("准备"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                break
            }
        }
        BattleSettlement
        sleep 5000
    }
}
;endregion 协同作战
;region 单人突击
SoloRaid() {
    BackToHall
    AddLog("===单人突击任务开始===")
    Text := "|<单人突击的图标>*101$54.zU3w0D303z01s0D301z00s0C301z00k06200y00k06600y3kkw467Uy3UUw447Vy7UUwAA71w7VUs8AD1w710088D3s0100MMC3s0300MMS3s0700EES7s023kkkS7k063Ukkw7kQ67UUUw7kw47VVUwDUwA71VVsDUsAD11VsDVs8D3100T1sMC3300z1kMS2301z3kES6203z7ksy6607zzUzw7zzzzzVzwDzzzzzbzwzzzzzzjztzzzzzU"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
    }
    else {
        AddLog("不在单人突击活动时间")
        AddLog("===单人突击任务结束===")
        return
    }
    Text := "|<左上角的单人突击>*112$73.syDzVzzkzzwTwT7zkzs00TyDy73zsTw00700400TwDy003U0200Dy7z4Qlk01667z3zUA3zszU03zVzsDUzsDk01zUTwQEs008kkzkDzy1y00400Ts3zy0T11200DsFz001llny7zsMTU00sss001wC7zUTwQQ000wD1zU7yCA000MDkT0Uz007wTwDw61s3U03yDyDzb1z3k01"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        Text := "|<奖励内容的图标>*183$30.zkT3zzWSFzzbAxzzjgwzzbVxzzXVlzzkn3zU0001bzUztDzVzwDzVzw00000TzVzyTzVzyTzVzyTzVzyTzVzyTzVzyTzVzyTzVzy00000U0001bzVztbzVztbzVztbzVztbzVztbzVztbzVztbzVztbzVztk0001U"
        Confirm
        Text方舟 := "|<方舟的图标>*200$57.0000w00000003zzU000003zzzk00003zzzzU0000zzzzz0000Tzzzzz0007zzzzzw003zzxzzzk00zzw7bzz00Dzz0wDzw03zzk7UTzk0Tzs0w1zz07zz0Tk7zw1zzkDzUzzkDzy3zy3zz3zzUzzkTzsTzw7zz3zzbzzzzzsDzyTzzzzzzzznzzzzzzzzzDzxzzzzzztzzUzzzzzz7zy7zz1zzsTzkTzsTzy3zz1zy3zzUDzs7zUTzw0zzUDk7zz03zy0w1zzk0Dzs7UTzy00zzkw7zzU03zz7Vzzs00Dzzzzzy000zzzzzz0001zzzzzk0003zzzzs00007zzzw000007zzy0000007zw000U"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text方舟, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("单人突击活动已结束")
            AddLog("===单人突击任务结束===")
            return
        }
    }
    ;选中第七关
    UserClick(2270, 231, scrRatio)
    Sleep 1000
    while True {
        Text := "|<左上角的单人突击>*112$73.syDzVzzkzzwTwT7zkzs00TyDy73zsTw00700400TwDy003U0200Dy7z4Qlk01667z3zUA3zszU03zVzsDUzsDk01zUTwQEs008kkzkDzy1y00400Ts3zy0T11200DsFz001llny7zsMTU00sss001wC7zUTwQQ000wD1zU7yCA000MDkT0Uz007wTwDw61s3U03yDyDzb1z3k01"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
        Sleep 1000
        Text := "|<快速战斗的图标>*194$29.UD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0TzUD0Ty0w1zs3k7zUD0Ty0w1zs3k7zUD0Ty0w1zs3k7zUD0Ty0w1zs3k7zs"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("快速战斗已激活")
            FindText().Click(X, Y, "L")
            Sleep 1000
            Text := "|<MAX>*130$23.66CMAAQYMMt8klkFV1lX2HX64b649CA2GQM4Ysk91lUG399UWGH3YZa73XBiLM"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.15 * PicTolerance, 0.15 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("进行多倍率快速战斗")
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
            Text := "|<进行战斗>*200$93.zzzzzzzzzzzzzzrxzbbzbzzzbwTzzwTXwszss07wzWTyTXwDb7yD01zbwNzkwTlsET3zzzwTXDz3XzQ00szzzzUCTzwQTzU0DCTzzw3XzzzXzz37zXzzzbw0zzwTzwszsM07wy07lzXsDb7z600zbkDy3wT1sMTls07sznjwDXw800sDz7w0SMzlwTlU071zsz03lDzzXyD77sDz7swS1zzw0ltsztzsz7nkTzs06CD7zDz7syT3y001lVsztzszDnsz003yCT7zDz7syS6s7wTUrxztzsz1XUnzzXs0TwzDz7s080zzwTC007tz0z00A7zzXvy00zDsDtyPkzzwTzzzzxzzzzzzzzzrw"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
            AddLog("===单人突击任务结束===")
            BackToHall
            return
        }
        Text := "|<挑战>*180$55.szbDzzzkzwTV3zwTsNyDkVzy7w8z7sEzz3y4DXY8FzVz320048Tk1VX0020Ts0kzU010Dw0M0E20UDy7k0C3UE7z3s07Xk87zVw03kS4Dzky0rs723y01sEk3V0T00w8E10U7U0S0M30E1k0D0A2080sS7UDVU48QDXk7sk66S7lw7wR33T3sy2yD1VbVsS3D7Uklk0C03XUsMs040210w0Q00010kS0C0030kQzUD3snkszzwTzzzww"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        else {
            AddLog("已无挑战次数，返回")
            AddLog("===单人突击任务结束===")
            BackToHall
            return
        }
        Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        Sleep 3000
        Text := "|<进入战斗>*200$109.zzzzzzzzzzbzbzzzwTtzXXzzbzzzlzXjzzyDsTlkzzVzzzszlXzlz7y7ssTzkTzzwTslzsDXzVsQDzw7zzyDwQTy1lztU00zz1zzz0CDzzUszzk00TzkzzzU7bzzwwTzw00TzwDzzkzV3zzyDzzlkzzw3zzsz00yTz7zzssTzy1zzwT01z3zXw3wQDzz0TzyDkDzUTly0yC7zzUDzz7z7Ts7szUE00TzV3zw0DX7z3wTw800Dzklzw03lXzvyDyC007zksTy01sXzzz7z7lsTzsS7z7sw1zzz03XswDzsT3zXwT1zzs01lsS7zsDkzlyDUzs001ssT3zsDsDsz7kzU00TwADVzwDy3wTXsPk1yDw7DtzwDzUyDlsAtzz7w0zzzs7zsD00k4TzzXw8001s7zy3U0E0DzzlyD000wDzzXk00MDzzszjs00TDzztsz4w7zzwTzzzzzzzzzzzzzbzzyTs"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
            BattleSettlement()
        }
    }
    AddLog("===单人突击任务结束===")
    BackToHall
}
;endregion 单人突击
;region 其他限时活动
;tag 德雷克·反派之路
RoadToVillain() {
    BackToHall()
    AddLog("===反派之路任务开始===")
    Text := "|<ROAD>*200$29.zzzznzzzy3zzwtbztlnCDbVaEC73BaNA6HQaPAYtAqN9WPgWOAq11kNw270XNYSN6bzxm9DznY5zy7AzzwCTzzzU"
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    else {
        AddLog("===找不到反派之路任务===")
        return
    }
    loop 3 {
        if A_Index = 1 {
            Text := "|<任务>*181$41.1U103U03Uz0D00Dzz0zzkTzs3zzVvz0Tzy7US0zXsD0w0rzUy1s0Tz3w3kDzzvzzyTsznzzwQQ33zzs0w070w1zzwC1s3zzsQ3k0T3ks7U0w71nzw7kC3bztzDw7DzlsTkC0030T2"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("点击任务")
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        if A_Index = 2 {
            Text := "|<周任务>*183$62.7zz0Q1s0s03zzs7zz0TzUzzy3zzkDzwDzzUzzkDzz3XlsSTk7yTUzzyDUw1zzkDzzbsD0Bzs3zxty3k7zzszzyTzztzzzDzzXzzyTwzXzzsTzzX7U0vzS7zzkzzwSzrVsD0Dzz7jxsS3k3zzlvrS7Uw07kwQzrUsDU3sDDDzsCzzXw7nnny3jztyTsMET0vzyS3w003UC0000Q2"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("点击周任务")
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        if A_Index = 3 {
            Text := "|<奖励>*181$40.3VU0031CD0DzQCtzszxkzzzXzr1jwSC0Q1vvkzzzTXy3zzzyDkDzzyzy0z1rnjU3zbQCs0TyRk3U1rtrzzzbRbTzzyRytzzztrvb0zU7zyQTzUTjlzwTtzzyzUzjzttk0Q/Mb8"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("点击奖励")
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        Text := "|<灰色的全部领取>*170$81.zrzzbzzxzzzzzzwTzwz0zDU707zzVzw0s7sy0s107lbz07Qy3xzbA0wSDwsvbrDjwvX67szrjRww0DUSw1zUytvD9wsw3rcDw7nDPzjjbaSNs07s0PDxxgwvnDwDz03Rw3hbaTNznzzzvbkBgw3sTyTzzzQznhbWT3w0Dw0vbyRgwlwTU1zU7QzrVba7Xznzwwv7kzDs0sTyTzjbNyDsz0C1znzwsvztyNzlX400DU7TzbbbzQwU"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("点击全部领取")
            UserClick(1662, 2013, scrRatio)
            Sleep 500
        }
        Text := "|<活动结束>*150$67.byDztzbnzwzsUDUQzXsy00SuDzyTnU300Dzjzw1nQDzbzzXzy0FDDw06A040n873w03Xsz0ta60SQtzyznwnbzzCQzyDtivUzzU0TM0xqRUM3s0D4yQlCvwtz0zaTC06Tywz07bDb77D1SS4lnU3zW61UCCQ/k1zv3jk7DDg"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("点击全部领取")
            UserClick(1662, 2013, scrRatio)
            Sleep 500
        }
        Sleep 1000
    }
    AddLog("===反派之路任务结束===")
    BackToHall()
}
;endregion 其他限时活动
;region 妙妙工具
;tag 剧情模式
StoryMode(*) {
    Initialization
    WriteSettings
    while True {
        while (ok := FindText(&X, &Y, NikkeX + 0.936 * NikkeW . " ", NikkeY + 0.010 * NikkeH . " ", NikkeX + 0.936 * NikkeW + 0.051 * NikkeW . " ", NikkeY + 0.010 * NikkeH + 0.025 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("SKIP的图标"), , , , , , , TrueRatio, TrueRatio)) {
            if (ok := FindText(&X, &Y, NikkeX + 0.361 * NikkeW . " ", NikkeY + 0.638 * NikkeH . " ", NikkeX + 0.361 * NikkeW + 0.018 * NikkeW . " ", NikkeY + 0.638 * NikkeH + 0.282 * NikkeH . " ", 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("1"), , , , , , , TrueRatio, TrueRatio)) {
                if !g_settings["StoryModeAutoChoose"] {
                    if (ok := FindText(&X, &Y, NikkeX + 0.361 * NikkeW . " ", NikkeY + 0.638 * NikkeH . " ", NikkeX + 0.361 * NikkeW + 0.018 * NikkeW . " ", NikkeY + 0.638 * NikkeH + 0.282 * NikkeH . " ", 0.1 * PicTolerance, 0.1 * PicTolerance, FindText().PicLib("2"), , , , , , , TrueRatio, TrueRatio)) {
                        continue
                    }
                }
                Sleep 800
                Send "{1}"
                Sleep 500
            }
            if (ok := FindText(&X, &Y, NikkeX + 0.785 * NikkeW . " ", NikkeY + 0.004 * NikkeH . " ", NikkeX + 0.785 * NikkeW + 0.213 * NikkeW . " ", NikkeY + 0.004 * NikkeH + 0.071 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("AUTO"), , , , , , , TrueRatio, TrueRatio)) {
                Send "{LShift Down}"
                Sleep 500
                Send "{LShift Up}"
                Click NikkeX + NikkeW, NikkeY + NikkeH, 0
            }
        }
        if g_settings["StoryModeAutoStar"] {
            Sleep 3000
            while (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.353 * NikkeW . " ", NikkeY + 0.319 * NikkeH . " ", NikkeX + 0.353 * NikkeW + 0.293 * NikkeW . " ", NikkeY + 0.319 * NikkeH + 0.361 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("灰色的星星"), , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 500
            }
        }
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX + 0.500 * NikkeW . " ", NikkeY + 0.514 * NikkeH . " ", NikkeX + 0.500 * NikkeW + 0.139 * NikkeW . " ", NikkeY + 0.514 * NikkeH + 0.070 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("记录播放的播放"), , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 500
            FindText().Click(X, Y, "L")
            Sleep 2000
        }
        if !WinActive(nikkeID) {
            MsgBox "窗口未聚焦，程序已终止"
            Pause
        }
    }
}
TestMode(BtnTestMode, Info) {
    ; 获取 TestModeEditControl 文本框中的内容
    funcName := TestModeEditControl.Value
    ; 检查函数名是否为空
    if (funcName = "") {
        MsgBox("请输入要执行的函数名！")
        return
    }
    ; 尝试动态调用函数
    Initialization()
    %funcName%() ; 无参数调用
}
;endregion 妙妙工具
;region 快捷键
;tag 关闭程序
^1:: {
    ExitApp
}
;tag 暂停程序
^2:: {
    try {
        if g_settings["AdjustSize"] {
            AdjustSize(OriginalW, OriginalH)
        }
    }
    Pause
}
;tag 初始化并调整窗口大小
^3:: {
    Initialization()
    AdjustSize(2331, 1311)
}
^4:: {
    Initialization()
    AdjustSize(1920, 1080)
}
^5:: {
    initialization()
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX + 0.951 * NikkeW . " ", NikkeY + 0.230 * NikkeH . " ", NikkeX + 0.951 * NikkeW + 0.045 * NikkeW . " ", NikkeY + 0.230 * NikkeH + 0.072 * NikkeH . " ", 0.2 * PicTolerance, 0.2 * PicTolerance, FindText().PicLib("任务的图标"), , , , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
    }
    while !(ok := FindText(&X, &Y, NikkeX + 0.548 * NikkeW . " ", NikkeY + 0.864 * NikkeH . " ", NikkeX + 0.548 * NikkeW + 0.093 * NikkeW . " ", NikkeY + 0.864 * NikkeH + 0.063 * NikkeH . " ", 0.3 * PicTolerance, 0.3 * PicTolerance, FindText().PicLib("灰色的全部"), , , , , , , TrueRatio, TrueRatio)) {
        UserClick(2412, 1905, scrRatio)
        Sleep 1000
    }
    AddLog("===大活动任务结束===")
}
^9:: {
    ;添加基本的依赖
    Initialization()
    ;下面写要调试的函数
    AdjustSize(1920, 1080)
}
;tag 调试指定函数
^0:: {
    ;添加基本的依赖
    Initialization()
    ;下面写要调试的函数
    ; AdjustSize(1280, 720)
    ; AdjustSize(1920, 1080)
    AdjustSize(2331, 1311)
}
;endregion 快捷键
