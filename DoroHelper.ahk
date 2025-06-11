#Requires AutoHotkey >=v2.0
#Include <github>
#Include <FindText>
#Include <GuiCtrlTips>
CoordMode "Pixel", "Client"
CoordMode "Mouse", "Client"
;region 设置常量
try TraySetIcon "doro.ico"
currentVersion := "v1.0.0-beta.16"
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
    "Activity", 1,             ;小活动
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
;region 识图素材
Text百货 := "|<百货>*200$36.zzzyRz003wwV003ks3zbzUUTzbzoswk0Dww1k07wy3nz7zzznzbs03nz7s03k07tznk07tnnnzbtnrnzbtnzk07z6Dk07sD1nzDkztU"
;endregion 识图素材
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
;region 运行前提示
if g_numeric_settings["Username"] != A_Username
    ClickOnHelp
if g_numeric_settings["Username"] != A_Username {
    Result := msgbox(
        (
            "你是" A_Username
            "`n反馈任何问题前，请先尝试复现，如能复现再进行反馈，反馈时必须有录屏和全部日志。"
            "`n如果什么资料都没有就唐突反馈的话将会被斩首示众，使用本软件视为你已阅读并同意此条目。"
            "`n==========================="
            "`n人机检测：你是否想立刻关闭程序"
            "`n可以在配置文件settings.ini中将Username改成自己的永久关闭提示"
            "`n==========================="
            "`n鼠标悬浮在控件上会有对应的提示，请勾选或点击前仔细阅读！"
        ), , "YesNo")
    if Result = "Yes" {
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
doroGui.Tips.SetTip(BtnSponsor, "如果您觉得 DoroHelper 对您有帮助，可以考虑点击这里支持开发者，激励项目持续更新与维护")
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
doroGui.Tips.SetTip(cbOpenBlablalink, "勾选后，当 DoroHelper 完成所有已选任务后，会自动在您的默认浏览器中打开 Blablalink 网站")
cbSelfClosing := AddCheckboxSetting(doroGui, "SelfClosing", "任务完成后自动关闭程序", "R1.2")
doroGui.Tips.SetTip(cbSelfClosing, "勾选后，当 DoroHelper 完成所有已选任务后，程序将自动退出`r`n注意：测试版本中此功能可能会被禁用")
TextToleranceLabel := doroGui.Add("Text", "Section +0x0100", "识图宽容度")
doroGui.Tips.SetTip(TextToleranceLabel, "调整图像识别的相似度阈值`r`n数值越高，匹配越宽松，更容易识别到目标但也可能发生误判`r`n数值越低，匹配越严格，准确性更高但可能错过一些稍有差异的目标`r`n请根据您的游戏分辨率和缩放情况适当调整")
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
doroGui.Tips.SetTip(cbAward, "总开关：控制是否执行各类日常奖励的自动收取任务`r`n具体的奖励项目请在「奖励」标签页中选择")
Tab.UseTab("商店")
TextCashShopTitle := doroGui.Add("Text", "R1.2 Section +0x0100", "===付费商店===")
doroGui.Tips.SetTip(TextCashShopTitle, "设置与游戏内付费商店相关购买选项")
cbCashShop := AddCheckboxSetting(doroGui, "CashShop", "领取免费珠宝", "R1.2 xs")
doroGui.Tips.SetTip(cbCashShop, "自动领取付费商店中每日、每周、每月可获得的免费珠宝`r`n重要：如果您的游戏账号因网络原因无法正常进入付费商店，请不要勾选此项，否则可能导致程序卡住")
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
doroGui.Tips.SetTip(DropDownListBoss, "在此选择异常拦截任务中优先挑战的BOSS`r`n请确保游戏内对应编号的队伍已经配置好针对该BOSS的阵容`r`n例如，选择克拉肯(石)，编队1，则程序会使用您的编队1去挑战克拉肯`r`n会使用3号位的狙击或发射器角色打红圈")
DropDownListBoss.OnEvent("Change", (CtrlObj, Info) => ChangeNum("InterceptionBoss", CtrlObj))
cbInterceptionShot := AddCheckboxSetting(doroGui, "InterceptionShot", "结果截图", "x+5 yp+3 R1.2")
doroGui.Tips.SetTip(cbInterceptionShot, "勾选后，在每次异常拦截战斗结束后，自动截取结算画面的图片，并保存在程序目录下的「截图」文件夹中")
TextSimRoomTitleBattle := doroGui.Add("Text", "R1.2 xs Section +0x0100", "===模拟室===")
doroGui.Tips.SetTip(TextSimRoomTitleBattle, "设置与模拟室挑战相关的选项")
TextNormalSimRoomLabel := doroGui.Add("Text", "R1.2 xs Section +0x0100", "普通模拟室")
doroGui.Tips.SetTip(TextNormalSimRoomLabel, "普通模拟室的日常扫荡。此功能需要您在游戏内已经解锁了快速模拟功能才能正常使用`r`n此选项的勾选在「任务」标签里")
cbSimulationOverClock := AddCheckboxSetting(doroGui, "SimulationOverClock", "模拟室超频", "R1.2")
doroGui.Tips.SetTip(cbSimulationOverClock, "勾选后，自动进行模拟室超频挑战`r`n程序会默认尝试使用您上次进行超频挑战时选择的增益标签组合`r`n挑战难度必须是25")
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
doroGui.Tips.SetTip(cbLoveTalking, "自动进行每日的妮姬咨询，以提升好感度`r`n您可以通过在游戏内将妮姬设置为收藏状态来调整咨询的优先顺序`r`n会循环直到次数耗尽")
cbAppreciation := AddCheckboxSetting(doroGui, "Appreciation", "花絮鉴赏", "R1.2 xs+15")
doroGui.Tips.SetTip(cbAppreciation, "自动观看并领取花絮鉴赏中当前可领取的奖励")
cbFriendPoint := AddCheckboxSetting(doroGui, "FriendPoint", "好友点数收取", "R1.2 xs")
doroGui.Tips.SetTip(cbFriendPoint, "自动收取并回赠好友点数")
cbMail := AddCheckboxSetting(doroGui, "Mail", "邮箱收取", "R1.2")
doroGui.Tips.SetTip(cbMail, "自动收取邮箱中所有奖励")
;cbRankingReward := AddCheckboxSetting(doroGui, "RankingReward", "方舟排名奖励", "R1.2")
;doroGui.Tips.SetTip(cbRankingReward, "自动领取方舟内各类排名活动（如无限之塔排名、竞技场排名等）的结算奖励")
cbMission := AddCheckboxSetting(doroGui, "Mission", "任务收取", "R1.2")
doroGui.Tips.SetTip(cbMission, "自动收取每日任务、每周任务、主线任务以及成就等已完成任务的奖励")
cbPass := AddCheckboxSetting(doroGui, "Pass", "通行证收取", "R1.2")
doroGui.Tips.SetTip(cbPass, "自动收取当前通行证中所有可领取的等级奖励")
cbActivity := AddCheckboxSetting(doroGui, "Activity", "小活动(需刷到11关)", "R1.2")
doroGui.Tips.SetTip(cbActivity, "针对当前正在进行的小型剧情活动`r`n自动对最新的挑战关卡进行战斗或快速战斗`r`n然后对主要活动的第11关消耗所有次数进行快速战斗")
TextLimitedAwardTitle := doroGui.Add("Text", "R1.2 Section +0x0100", "===限时奖励===")
doroGui.Tips.SetTip(TextLimitedAwardTitle, "设置在特定活动期间可领取的限时奖励或可参与的限时活动")
cbFreeRecruit := AddCheckboxSetting(doroGui, "FreeRecruit", "活动期间每日免费招募", "R1.2")
doroGui.Tips.SetTip(cbFreeRecruit, "勾选后，如果在特定活动期间有每日免费招募机会，则自动进行募")
cbCooperate := AddCheckboxSetting(doroGui, "Cooperate", "协同作战", "R1.2")
doroGui.Tips.SetTip(cbCooperate, "自动参与每日三次的协同作战，战斗期间摆烂什么都不会干")
cbSoloRaid := AddCheckboxSetting(doroGui, "SoloRaid", "单人突击日常", "R1.2")
doroGui.Tips.SetTip(cbSoloRaid, "自动参与单人突击，自动对最新的关卡进行战斗或快速战斗")
cbRoadToVillain := AddCheckboxSetting(doroGui, "RoadToVillain", "德雷克·反派之路", "R1.2")
doroGui.Tips.SetTip(cbRoadToVillain, "针对德雷克·反派之路的特殊限时活动，自动领取相关的任务奖励和进度奖励")
Tab.UseTab("日志")
LogBox := doroGui.Add("Edit", "r20 w270 ReadOnly")
LogBox.Value := "日志开始...`r`n" ;初始内容
Tab.UseTab()
BtnDoro := doroGui.Add("Button", "Default w80 xm+100", "DORO!")
doroGui.Tips.SetTip(BtnDoro, "点击启动 DoroHelper 主程序！`r`nDoro 将会按照您在各个标签页中的设置，开始自动执行所有已勾选的任务`r`n在点击前，请确保游戏客户端已在前台运行并处于大厅界面")
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
        ;if g_settings["RankingReward"] ;方舟排名奖励
        ;    RankingReward()
        if g_settings["Mission"]
            Mission()
        if g_settings["Pass"]
            Pass()
        if g_settings["Activity"]
            Activity()
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
    AddLog("`n当前的doro版本是" currentVersion "`n屏幕宽度是" A_ScreenWidth "`n屏幕高度是" A_ScreenHeight "`nnikke宽度是" NikkeW "`nnikke高度是" NikkeH "`n游戏画面比例是" GameRatio "`ndpi缩放比例是" currentScale "`n额定缩放比例是" WinRatio "`n图片缩放系数是" TrueRatio "`n识图宽容度是" PicTolerance)
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
            MsgBox("1080p及以下尺寸暂时不适配")
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
            AddLog(sourceName . " 更新检查：CDK为空。")
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
                        AddLog(sourceName . " 警告: SafeArray 大小为0或无效。")
                        ResponseTextForJson := "" ; 确保 ResponseTextForJson 有定义
                    }
                } catch as e_sa {
                    AddLog(sourceName . " 错误: 处理 ResponseBody (SafeArray) 失败: " . e_sa.Message ". 类型: " . ComObjType(ResponseBody, "Name"))
                    ResponseTextForJson := HttpRequest.ResponseText ; 回退
                    AddLog(sourceName . " 警告: SafeArray 处理失败，回退到 HttpRequest.ResponseText，可能存在编码问题。")
                }
            } else if (IsObject(ResponseBody)) {
                AddLog(sourceName . " 警告: ResponseBody 是对象但不是 SafeArray (类型: " . ComObjType(ResponseBody, "Name") . ")，尝试 ADODB.Stream。")
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
                    AddLog(sourceName . " 警告: ADODB.Stream 失败，回退到 HttpRequest.ResponseText，可能存在编码问题。")
                }
            } else {
                AddLog(sourceName . " 警告: ResponseBody 不是 COM 对象，或请求未成功。将直接使用 HttpRequest.ResponseText。")
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
                latestObj.change_notes := mirrorData.Get("release_note", "无更新说明。")
                latestObj.download_url := mirrorData.Get("url", "")
                if latestObj.version = "" {
                    if (isManualCheck) {
                        MsgBox(sourceName . " API 响应中版本信息为空。", sourceName . "检查更新错误", "IconX")
                    }
                    AddLog(sourceName . " 更新检查：API响应中版本信息为空。")
                    return
                }
                AddLog(sourceName . " 更新检查：获取到版本 " . latestObj.version)
                if (CompareVersionsSemVer(latestObj.version, currentVersion) > 0) {
                    foundNewVersion := true
                    AddLog(sourceName . " 版本比较：发现新版本。")
                } else {
                    AddLog(sourceName . " 版本比较：当前已是最新或更新。")
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
                AddLog(sourceName . " 更新检查：无法获取版本列表。")
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
                AddLog(sourceName . " 更新检查：预发布版优先，已选定 Release。")
            } else {
                AddLog(sourceName . " 更新检查：稳定版优先，正在查找...")
                for release_item in allReleases {
                    if !(IsObject(release_item) && (release_item.HasProp("version") || release_item.HasProp("tag_name"))) {
                        AddLog(sourceName . " DEBUG: 跳过一个无效的或缺少版本信息的 Release 对象。")
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
                    AddLog(sourceName . " 更新检查：未找到稳定版，将使用最新版本进行比较。")
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
                AddLog(sourceName . " 警告: Release 对象缺少 'version' 或 'tag_name' 属性。")
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
                    AddLog(sourceName . " 警告: 在 'assets' 中未精确匹配到 'DoroHelper*.exe' 或 'assets' 结构不符。")
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
                AddLog(sourceName . " 警告: Release 对象未找到任何有效的下载链接属性 (已尝试: downloadURL, assets, downloadURLs, download_url)。")
            }
            if latestObj.version = "" {
                local errMsg := sourceName . " 更新检查：未能从选定的 Release 对象获取版本号。"
                if (isManualCheck) MsgBox(errMsg, sourceName . "检查更新错误", "IconX")
                    AddLog(errMsg)
                return
            }
            if latestObj.download_url = "" {
                AddLog(sourceName . " 警告: 未能为版本 " . latestObj.version . " 找到有效的下载链接。")
            }
            AddLog(sourceName . " 更新检查：获取到版本 " . latestObj.version . (latestObj.download_url ? "" : " (下载链接未找到)"))
            if (CompareVersionsSemVer(latestObj.version, currentVersion) > 0) {
                foundNewVersion := true
                AddLog(sourceName . " 版本比较：发现新版本。")
            } else {
                AddLog(sourceName . " 版本比较：当前已是最新或更新。")
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
        AddLog(sourceName . " 更新检查：发现新版本 " . latestObj.version . "，准备提示用户。")
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
        AddLog((sourceName ? sourceName : "更新") . " 更新检查：未能获取到有效的版本信息或检查被中止。")
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
        AddLog(latestObj.display_name . " 下载错误：下载链接为空。")
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
                throw Error("Github 下载失败 (ErrorLevel: " . downloadStatusCode . "). 检查 Github.Download 库的内部提示或网络。")
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
1. 游戏分辨率需要设置成 **16:9** 的分辨率，小于**等于** 1080p 可能有问题，暂不打算特殊支持
   - 2k和4k（包括异形屏）用户请按ctrl+3按到画面不动为止，不要开启全屏，此时nikke应该位于画面左上角的，图片缩放应该是1
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
4. 游戏语言设置为**简体中文**，设定-画质-开启光晕效果，设定-画质-开启颜色分级
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
    Text := "|<SKIP>*119$57.k1z7wT7k0w07kz1kw0100S7kS7U0003ky7kw003sS7Vy7Vy0T3ksTkwDk3zy63y7Vy0TzkkzkwDk07y47y7Vy00Dk0zkw00k0S03y7U07U3k0Tkw01zsS11y7U0Tz3kQDkwDz3sS7Uy7VzsT3ky7kwDz00S7kS7Vzs03kz3kwDz00S7wC7Vzy07kzVkwDzU"
    while !(ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) { ;如果没找到SKIP就一直点左下角（加速动画）
        Confirm
    }
    FindText().Click(X, Y, "L") ;找到了就点
    Sleep 1000
    Text := "|<确认>*143$52.zzXzzzzby0C7zwTwDk0E1zkzkz0303z1z7z0M0Dy3wTyDVVzwDlzsw01zzz7zXU01zzwTwA0060zlzk000M1z3y00llU7wDs0U07kTkz0200Tlz3w6801z7s7kMU27wTUT1WAMTly1y6801z7s3wM007wL0DlU00TkA8T00UVy01Vw0777s073k0QQTUUw723k1w47sAQD07tkzkzly0zz7zW"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
}
;tag 点掉推销
RefuseSale() {
    sleep 3000
    AddLog("尝试关闭可能的推销页面")
    Confirm
    Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
    }
    sleep 1000
}
;tag 进入战斗
EnterToBattle() {
    global BattleActive := 1
    AddLog("尝试进入战斗")
    Text := "|<进入战斗的进>*175$32.tzsS7wDy7Vz1zVsTkDsQ7y1w71zkE003yQ000zz000Dzs003zzsQ7zzy7Vy0zVsT0DsQ7k3U00A0k001wA000T30007ky3kTwDUw7z3sTVzkw7kTwD1w7z3UzVzkwTkTk3byDs0Dzzw000001k000Mz0006Tw001U"
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击进入战斗")
        FindText().Click(X + 100 * TrueRatio, Y, "L")
        Sleep 500
        FindText().Click(X + 100 * TrueRatio, Y, "L")
        Sleep 500
        FindText().Click(X + 100 * TrueRatio, Y, "L")
    }
    else {
        BattleActive := 0
        AddLog("无法战斗")
        GoBack
    }
}
;tag 判断自动按钮颜色
isAutoOff(sX, sY, k) {
    uX := Round(sX * k)
    uY := Round(sY * k)
    uC := PixelGetColor(uX, uY)
    r := Format("{:d}", "0x" . substr(uC, 3, 2))
    g := Format("{:d}", "0x" . substr(uC, 5, 2))
    b := Format("{:d}", "0x" . substr(uC, 7, 2))
    if Abs(r - g) < 10 && Abs(r - b) < 10 && Abs(g - b) < 10
        return true
    return false
}
;tag 检查自动瞄准和自动爆裂按钮颜色
CheckAutoBattle() {
    static autoBurstOn := false
    static autoAimOn := false
    ;检查并开启自动瞄准
    if !autoAimOn && UserCheckColor([216], [160], ["0xFFFFFF"], scrRatio) {
        ;如果自动瞄准按钮是灰色/关闭状态
        if isAutoOff(60, 57, scrRatio) {
            UserClick(60, 71, scrRatio) ;点击开启自动瞄准
            Sleep 1000
        }
        autoAimOn := true ;设置标志位，表示已尝试开启或已开启
    }
    ;检查并开启自动爆裂
    if !autoBurstOn && UserCheckColor([216], [160], ["0xFFFFFF"], scrRatio) { ;假设检查点与 Auto Aim 相同
        ;如果自动爆裂按钮是灰色/关闭状态
        if isAutoOff(202, 66, scrRatio) {
            Send "{Tab}" ;发送 Tab 键尝试开启自动爆裂
            Sleep 1000
        }
        autoBurstOn := true ;设置标志位，表示已尝试开启或已开启
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
    ;无限塔胜利或失败会出现该图标
    TextTAB := "|<TAB的图标>*200$30.0Tzzz0Tzzz0Tzzz0Tzzz0Tzzz0Tzzz0Tzzz0T0Tz0T0Tz0T0Tz0T0Tz0T0Tz0T0Tz0T0S00T0S00T0S00T0S00T0S00T0S00T0S00T0S00T0S00T0S00T0S00T0S0zzzy0zzzzzzzzzzzzzzzzzzzz0000000000U0000U"
    ;竞技场快速战斗会出现该图标
    TextR := "|<R的图标>*147$41.zzk07zzzy003zzzk001zzy0000zzs1zw0xzUDzy0ny1zzz03s7zzz07UTzzz0D1zzzz0Q7zzzw0sTzzzk1UzyTz033zwTzy27zsTzzsDzkTzzkzzUDzzVzz0Dzz3zy0Dzy7zw07zwDzs07zsTzk0TzkzzU1zzVzz07zz3zy0TzU3zw3zy27zsDzw4DzkzzsMDzbzzUsDzTzz3kTzzzw7kTzzzkTkTzzz1zUTzzw3zUDzzUDzUDzy0zzU3zU3zzk000Tzzk001zzzs00Dzzzy01zzk"
    ;拦截扫荡会出现该图标
    Text点击 := "|<点击>*100$37.zlzzwTzszzyDzw0Dz7zy07U03z7zk01zXzzszk01zwTs00w00ATwQ006DyD0033y7zlzU03ssss03wQQTzzyCCAH4T776MX7U02ANXk00CAMs00U"
    while true {
        ; 检测自动战斗和爆裂
        if (A_Index = 20) {
            CheckAutoBattle
        }
        ; 检测完成战斗频率降低
        if (Mod(A_Index, 2) = 0) {
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, TextTAB, , 0, , , , , TrueRatio, TrueRatio)) {
                check := check + 1
                ;AddLog("TAB已命中，共" check "次")
            }
            else if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, TextR, 0, 0, , , , , TrueRatio, TrueRatio)) {
                check := check + 1
                ;AddLog("R已命中，共" check "次")
            }
            else if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text点击, 0, 0, , , , , TrueRatio, TrueRatio)) {
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
        }
        Text上 := "|<红圈的上边缘>FEFE7B-323232$27.0Djk1zxzyzzjzzzxzzzzjzzw00z0000A"
        Text下 := "|<红圈的下边缘>*220$27.7zzz0020000E00020000E07020DU"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text上, , 0, , , , , TrueRatio, TrueRatio)) or (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text下, 0, 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("检测到红圈，尝试打红圈")
            loop 20 {
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text上, , 0, , , , 1, TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y + 30 * TrueRatio, 0)
                    Click "Down"
                    Sleep 700
                    Click "Up"
                }
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text下, 0, 0, , , , 1, TrueRatio, TrueRatio)) {
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
    Text编队 := "|<编队>*103$46.tznzzznzXy7y0SDyC01s0szls07U7Xz7U0SASDsaTlslszW807WDXw1U0S8yDk601sXsz0szzWDVz3U0SAS7wQ00slsTUE03XX1w118CCQ3k44UsVkD7k03W60Tt00C8slw0Y0sz3302G3XsS4C98CD3s3lYUswTkzaG7Xnza"
    Text下一关 := "|<下一关>*192$69.zzzzzzzzwzls001zzzzz3yD0007zzzzwTVs000zzzzzlwTzlzzzzzzk00TyDzzzzzw003zlzzzzzzU00TyDzzzzzzy7zzkDzzzzzzszzy0zk000zz7zzk1y0007zkzzyA3k000s000zlkTzzzz0007yDXzzzzzw3zzlyzzzzzzUTzyDzzzzzzs1zzlzzzzzzy23zyDzzzzzzUsDzlzzzzzzkDUTyDzzzzzk3y0zlzzzzzz1zwDyDzzzzzxzzxU"
    ;有编队代表输了，点Esc
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text编队, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("战斗失败！尝试返回")
        GoBack
        Sleep 1000
        return False
    }
    ;如果有下一关，就点下一关（爬塔的情况）
    else if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text下一关, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("战斗成功！尝试进入下一关")
        Victory := Victory + 1
        if Victory > 1 {
            AddLog("共胜利" Victory "次")
        }
        FindText().Click(X, Y + 10 * TrueRatio, "L")
        Sleep 1000
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
    Text方舟 := "|<方舟的图标>*200$57.0000w00000003zzU000003zzzk00003zzzzU0000zzzzz0000Tzzzzz0007zzzzzw003zzxzzzk00zzw7bzz00Dzz0wDzw03zzk7UTzk0Tzs0w1zz07zz0Tk7zw1zzkDzUzzkDzy3zy3zz3zzUzzkTzsTzw7zz3zzbzzzzzsDzyTzzzzzzzznzzzzzzzzzDzxzzzzzztzzUzzzzzz7zy7zz1zzsTzkTzsTzy3zz1zy3zzUDzs7zUTzw0zzUDk7zz03zy0w1zzk0Dzs7UTzy00zzkw7zzU03zz7Vzzs00Dzzzzzy000zzzzzz0001zzzzzk0003zzzzs00007zzzw000007zzy0000007zw000U"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text方舟, , 0, , , , , TrueRatio, TrueRatio)) { ;如果没有找到大厅的文本，就一直点击左下角的小房子
        UserClick(333, 2041, scrRatio)
        Sleep 500
        Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 500
        }
    }
    if !WinActive(nikkeID) {
        MsgBox "窗口未聚焦，程序已终止"
        Pause
    }
    Sleep 1000
}
;tag 进入方舟
EnterToArk() {
    AddLog("尝试进入方舟")
    Text方舟 := "|<方舟内部左上角的文本>*111$36.zXzzVzzXzzVzz1zs03001s03001s33sDzsVXwTzslXw07st3w07U00w07U00sT7kX3sz7sXXkz7kVXkz7llXVy7VzX3UDXy37kDXy7zszzzDU" ;判断方舟内部左上角的文本是否存在
    Text大厅 := "|<大厅方舟的图标>*161$56.000zzk000001zzzs00001zzzzU0001zzzzy0001zzzzzs000zzzzzz000TzyDzzw00Dzy3VzzU07zy0s7zw03zz0C0zzU1zzU3U7zw0zzs3w0zzUDzw3zkDzw7zz1zy1zz1zzUTzkDzszzsDzy3zzDzzzzzUzznzzzzzzzzyTzzzzzzzzrzy7zzzzzxzzUzzzzzzDzw7zy3zzlzz0zz0zzsTzsDzkTzw3zy0zs7zz0Tzk7k3zzU3zy0s0zzk0TzkC0Tzw03zy3UDzw00TzssDzz003zzzzzz000DzzzzzU001zzzzzk0007zzzzk0000Dzzzk00000zzzU000000zy0008"
    while True {
        Sleep 1000
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.3 * PicTolerance, 0.3 * PicTolerance, Text大厅, , , , , , , TrueRatio, TrueRatio)) { ;查找并点击大厅的方舟按钮
            FindText().Click(X, Y, "L") ;找得到就尝试进入
            if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.3 * PicTolerance, 0.3 * PicTolerance, Text方舟, , , , , , , TrueRatio, TrueRatio)) {
                AddLog("已进入方舟")
                Sleep 1000
                break
            }
        }
        else BackToHall() ;找不到就先返回大厅
    }
    Sleep 1000
}
;tag 登录
Login() {
    AddLog("正在登录")
    check := 0
    while True {
        Text := "|<方舟的图标>*200$57.0000w00000003zzU000003zzzk00003zzzzU0000zzzzz0000Tzzzzz0007zzzzzw003zzxzzzk00zzw7bzz00Dzz0wDzw03zzk7UTzk0Tzs0w1zz07zz0Tk7zw1zzkDzUzzkDzy3zy3zz3zzUzzkTzsTzw7zz3zzbzzzzzsDzyTzzzzzzzznzzzzzzzzzDzxzzzzzztzzUzzzzzz7zy7zz1zzsTzkTzsTzy3zz1zy3zzUDzs7zUTzw0zzUDk7zz03zy0w1zzk0Dzs7UTzy00zzkw7zzU03zz7Vzzs00Dzzzzzy000zzzzzz0001zzzzzk0003zzzzs00007zzzw000007zzy0000007zw000U"
        if (check = 3) {
            break
        }
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            check := check + 1
            continue
        }
        else check := 0
        ;点击蓝色的确认按钮（如果出现更新提示等消息）
        Text := "|<确认>*192$51.zz1zyDy7s0s0TUzkz0601y3y7s0U0TkTkzksT3z3y7yC3kTwzkzlk00zzy7wC0073zkzU800kDy7s1X761zkz0AMMsDw7s1U07lzUT2A00yDw3sFU07lzUT2AMMyDs1sFX77kb2DWAEEy0kkwF007k663W800y0VsA1737k8D0U0wsy23w407W7UUTUXkw0wC7y6SDU7nlzsU"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("发现更新，尝试点击")
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        Text := "|<一周内不再提示的空框>*200$28.7zzzVzzzz7zzzyzzzzzk003z000Dw000zk003z000Dw000zk003z000Dw000zk003z000Dw000zk003z000Dw000zk003z000Dw000zk003z000DzzzzxzzzzXzzzwU"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("发现公告，尝试勾选一周内不再提示后关闭")
            FindText().Click(X, Y, "L")
            Sleep 1000
            Text := "|<叉叉>*174$29.bzzzxDzzzmDzzz6DzzwSDzzlyDzz7yDzwTyDzlzyDz7zyDwTzyDlzzy77zzy8Tzzy1zzzy7zzzs7zzzU7zzy67zzsS7zzVy7zy7y7zsTy7zVzy7y7zy7sTzy7Vzzy67zzy0Tzzy1zzzyE"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        Text := "|<全部>*200$39.zrzzbzzwTzsy0z1zw0k7k7z028wQDs0na7kzb6N1z0wNn8Dw7nCF001s0ED00z02NzXzzznbwTzzyQw0Ds0nb00z06QzVzssl7yTzDa0zXzssnM00706TU01s0nzzzzjrzU"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        UserClick(331, 2040, scrRatio)
        Sleep 500
    }
    AddLog("已处于大厅页面，登录成功")
}
;endregion 流程辅助函数
;region 商店
;tag 付费商店每日每周免费钻
CashShop() {
    BackToHall
    AddLog("===付费商店任务开始===")
    AddLog("寻找付费商店")
    Text := "|<付费>*190$44.003U3zz0M0sDzzsD0C3zzy7k3UTzz1s1y7zzkyzznzzzTzzwzzzrzzyDyxzw0S0yDSz23VzXqDlksDzzVwSC1zzsD7XUDyS3kws3XXUQCC0tss703UDzy3k0s3yzwQ3y7z1z71zVz01VkTkA000Q000000U"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击付费商店")
        FindText().Click(X, Y, "L")
        Sleep 1000
        Text一级红点 := "|<带红点的礼物>*100$62.zzzzzzzzk3zzzzzzzzk0Tzzzzzzzs03zzzzzzzy00Tzzzzzzz007zzzzzzzk00zzzzzzzs00Dzzzzzzy003zzzzzzzU00znzyDzzs00DkDy0zzz003s1z07zzk01w0Dk1zzy00T7VsQDzzU0DlwADXzzw07wTU7kzzzk7z0000Tzzzzzs0007zzzzzz0007zzzzzzzzzzzzzzzzzzzzzzzzzz007U07zzzzk01s00zzzzw00S00Dzzzz007U03zzzzk01s00zzzzw00S00Dzzzz007U03zzzzk01s00zzzzw00S00Dzzzz007U03zzzzk01s00zzzzy"
        Text二级红点 := "|<二级页面小红点>*200$69.000000000zk000000000TzU000000003kD000000000k0M00000000CTlbzzzzzzzXbzCzzzzzzzztzwrzzzzzzzzDzbzzzzzzzztzyTzzzzzzzzDznzzzzzzzztzyTzzzzzzzzDznzzzzzzzztzwzzzzzzzzz7zazzzzzzzzwTtrzzzzzzzzkwAzzzzzzzzz07bzzzzzzzzz3szzzzzzzzzzw7zzzzzzzzzzUzzzzzzzzzzw7zzzzzzzzzzUU"
        Text三级红点 := "|<三级页面带礼包的红点>*157$80.zzzzzzzzzzzwDzzzzzzzzzzzs0zzzzzzzzzzzwC7zzzzzzzzzzyDszzzzzzzzzzz7z7zzzzzzzzzznztzzzzzzzzzzwzyDzzzzzzzzzzDznzzzzzzzzzzXzwzzzzzzzzzzwzzDzzzzzzzzzzDzbzzzzzzzzzzlzlzzzzzzzzzzyDsTzzzzzzzzzzUwDzzzzzzzzzzw07zzzzzzzzzzzk7zzzzzzzzzzzzzzzzzzzzzzzzzzzxzzzzzzzzzzzzyD7zsTzzzzzzzzXlzy7zzzzzzzzswTz007zzzzzzk37zk01zzzzzzw0lzs00TzzzzzzgATwDz7zzzzzzz77y01lzzzzzzzllzk0QTzzzzzzsQTz077zzzzzzs37zlllzzzzzzw0FzwQQzzzzzzz04Tz06Dzzzzzzm/7zk03zzzzzzzXltwTkzzzzzzzswST7zzzzzzzzyD7blzszzzzzzzXk1w00Dzzzzzzsy0TU03zzzzzzyDsTy03zzzzzzy"
        Text日服的框 := "|<框框>*178$22.7zzks07a006M00D000w001k007000Q001k007000Q001k007000Q001k007000q003M00Ms07VzzwU"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text日服的框, , , , , , 3, TrueRatio, TrueRatio)) {
            AddLog("发现日服特供的框")
            FindText().Click(X, Y, "L")
            Sleep 1000
            Text确认 := "|<确认的图标>*200$34.zzU7zzzk07zzw00zzzU7rzzw3zzzzUzzzbwDzzwDVzzzUy7zzw7kzzzUz7zzw7sTzzUzXzzw7yDzzUzszTw7z3szUzwD1w7zky3Uzs3w47zWDs0zy8zk7zsXzUzz27z7zwQTyzzVkzzzy7Vzzzky7zzy7w7zzkTsDzy3zkDzUTzU7k3zz000zzz00DzzzU7zy"
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text确认, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("点击确认")
                FindText().Click(X, Y, "L")
            }
        }
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text一级红点, , 0, , , , , TrueRatio, TrueRatio)) {
            Sleep 1000
            AddLog("点击一级页面")
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        else {
            AddLog("付费商店已领取！")
            AddLog("===付费商店任务结束===")
            return
        }
        while (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text二级红点, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("点击二级页面")
            FindText().Click(X, Y, "L")
            Sleep 500
            if (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text三级红点, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("点击三级页面")
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
            Text := "|<付费商店>*154$74.szby0TzszzwTyDtw00Q00Dz3z7yTU07001k00lz3k01k00w008E0Q00Tllz7Xw407003wMTlsz103k00s00wS0ETty34C00D7U06SS1l7a8nls0lXbk03s60wSDwMty00y1kD00776TW4DU03U01lnbslXt6AsU0QTty8syFXC8z77wTU0TY0nW01ls7U40t78lU0QS1sDsCTsCM07DVzzzzbzDzTvU"
            while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                Confirm
            }
        }
        else AddLog("付费商店已领取！")
    }
    else AddLog("付费商店未找到！")
    AddLog("===付费商店任务结束===")
    BackToHall
}
;tag 普通商店
NormalShop() {
    AddLog("===普通商店任务开始===")
    BackToHall
    Text := "|<商店的商>*200$29.zzlzzzy1zzzw004000000000U000z00z1zz1y7zy3sDzy700w0001k0003U0AC71ssAC3Vk0Q47s0s0Tk1k0013UU0771U0CC33sQQ67UssA01lkM033kkzy7VXzUD3zz1y7zzzwTzzzk"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击商店图标")
        FindText().Click(X, Y, "L")
    } else {
        AddLog("未找到商店图标，任务结束。")
        BackToHall
        return
    }
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text百货, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("已进入百货商店。")
    }
    ; 定义所有可购买物品的信息 (使用 Map)
    PurchaseItems := Map(
        "免费商品", {
            Text: "|<100%>*205$34.XUC0loA0k3KQnnDBPnDAwlDAwnnmAnnDDbnDAwyTAwnnmAnnDD+n0A0tfC0s3a8",
            Setting: true,
            Tolerance: 0.1 * PicTolerance
        },
        "芯尘盒", {
            Text: "|<芯尘盒>*174$62.1UM00k00600wD00S003k0Tzw1ba03z0Tzzkxvk3zwDzzwSSy3zztzzyDbbnzzz3mw7lsyzzzUNq1sS77zzk0w0A7UUTzs07U00k07zy0RsE0S01zzVzDS07U0DzkTn7Vzzs7zy7w1sTzy3zzlz0D7zzUzzwxkTk1s0DzzDSDw0S03zzkbzkTzzvzzz1zs7zzyzzzk7w1zzzjzzy",
            Setting: g_settings["NormalShopDust"],
            Tolerance: 0.2 * PicTolerance
        },
        "简介个性化礼包", {
            Text: "|<礼包>*179$37.6301k03Xk0s01ls0zzbyw0zzvzS0zzwzj0zyS3bUTzD3nk7zrXts1zvryw0Qxvzy0Dytzz07zwLrb3zy3XnVkDVltks1sszsTzwQDsDzwC3s1zwU",
            Setting: g_settings["NormalShopPackage"],
            Tolerance: 0.1 * PicTolerance
        }
    )
    loop 2 {
        for Name, item in PurchaseItems {
            if (!item.Setting) {
                continue ; 如果设置未开启，则跳过此物品
            }
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, item.Tolerance, item.Tolerance, item.Text, , , , , , , TrueRatio, TrueRatio)) {
                loop ok.Length {
                    FindText().Click(ok[A_Index].x, ok[A_Index].y, "L")
                    Sleep 1000
                    Text确认 := "|<确认的图标>*200$34.zzU7zzzk07zzw00zzzU7rzzw3zzzzUzzzbwDzzwDVzzzUy7zzw7kzzzUz7zzw7sTzzUzXzzw7yDzzUzszTw7z3szUzwD1w7zky3Uzs3w47zWDs0zy8zk7zsXzUzz27z7zwQTyzzVkzzzy7Vzzzky7zzy7w7zzkTsDzy3zkDzUTzU7k3zz000zzz00DzzzU7zy"
                    Text信用点 := "|<信用点的图标>*172$29.000M0003s000Ds000ts007Vs00Tjk01zlk07zbk0zyTk3zzzUDzzzVzzzv7zzzyTzzzkjzzr6Dzzw4DzzU4jzy01zys0/zzU0Dzw00DQk00Dd000Dk000TU000S002"
                    if name = "芯尘盒" {
                        if (ok0 := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text信用点, , 0, , , , , TrueRatio, TrueRatio)) {
                            AddLog("检测到信用点支付选项")
                        }
                        else {
                            AddLog("未检测到信用点支付选项")
                            Confirm
                            Sleep 1000
                            continue
                        }
                    }
                    if (ok1 := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text确认, , 0, , , , , TrueRatio, TrueRatio)) {
                        AddLog("购买" . Name)
                        FindText().Click(X, Y, "L")
                        Sleep 1000
                    }
                    while !(ok2 := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text百货, , 0, , , , , TrueRatio, TrueRatio)) {
                        Confirm
                    }
                }
            } else {
                AddLog(Name . "未找到，跳过购买。")
            }
        }
        Text := "|<FREE>*184$36.UA7kC0081U607slXyT7ssXyT7ssUC10MlUC10M1XyT7s3XyT7slU60bstU60U"
        if (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            TextRefreshIcon := "|<刷新的图标>*154$19.zlzz07y00C7w77z37z1bzs3zzVzz8zzUTzlzzs7zwUDwMDwA7wC0sD80Dz0Tk"
            if (okRefreshIcon := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, TextRefreshIcon, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("点击免费刷新按钮。")
                FindText().Click(X - 50 * TrueRatio, Y, "L")
                Sleep 1000
                Text确认 := "|<确认的图标>*200$34.zzU7zzzk07zzw00zzzU7rzzw3zzzzUzzzbwDzzwDVzzzUy7zzw7kzzzUz7zzw7sTzzUzXzzw7yDzzUzszTw7z3szUzwD1w7zky3Uzs3w47zWDs0zy8zk7zsXzUzz27z7zwQTyzzVkzzzy7Vzzzky7zzy7w7zzkTsDzy3zkDzUTzU7k3zz000zzz00DzzzU7zy"
                if (ok1 := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text确认, , 0, , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                    AddLog("刷新成功。")
                }
            }
        } else {
            AddLog("没有免费刷新次数了，跳过刷新。")
            break ; 退出外层 loop 2 循环，因为没有免费刷新了
        }
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text百货, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("等待返回百货商店页面。")
            Confirm
        }
        Sleep 1000
    }
    AddLog("===普通商店任务结束===")
}
;tag 竞技场商店
ArenaShop() {
    AddLog("===竞技场商店任务开始===")
    Text := "|<竞技场商店的图标>*127$42.zzs0DzzzzU03zzzz001zzzy1y1zzzw7z0zzzsTTUzzzswDUzzzkwDUlzylwDUwTsVsDVz7lXsD1zXXXsS3zl7XsE7zt7XU0TzsD301zzsD3U0Tzs73kkTzsb3ksDzlXXks7zntXkw7wrxVUw3szzVUy1kzzk1z01zzk1z03zzw1zU7zzy3zsTzU"
    if (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("进入竞技场商店")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    ; 定义所有可购买物品的信息 (使用 Map)
    PurchaseItems := Map(
        "燃烧代码手册", {
            Text: "|<燃烧代码的图标>*100$15.ztzyDz1zkDw0z07k0S23UsAD01s0DUVw4DldyD7nwww",
            Setting: g_settings["BookFire"],
            Tolerance: 0.23 * PicTolerance },
        "水冷代码手册", {
            Text: "|<水冷代码的图标>*122$17.zrvzDbwSDkQDUkS1Vs1bU3z07w0Ds0TU0z01z07y0Ty1zs",
            Setting: g_settings["BookWater"],
            Tolerance: 0.1 * PicTolerance },
        "风压代码手册", {
            Text: "|<风压代码的图标>*150$21.zwTzz1zzkCDy00s017U6QbzrU000z00Czzzk07zs0TzznzzDTztnzz4Tzw7w",
            Setting: g_settings["BookWind"],
            Tolerance: 0.1 * PicTolerance },
        "电击代码手册", {
            Text: "|<电击代码的图标>*110$12.zxztznznzXz7y7y7w7s7k1k0U001w3y7w7wDwTwztztzvzrzU",
            Setting: g_settings["BookElec"],
            Tolerance: 0.1 * PicTolerance },
        "铁甲代码手册", {
            Text: "|<铁甲代码的图标>*150$20.sDVs1kC00000000000000000006001k00z00zk1zw0zy0DzU3zs0zy0Tzk7zy7zs",
            Setting: g_settings["BookIron"],
            Tolerance: 0.1 * PicTolerance },
        "代码手册宝箱", {
            Text: "|<代码手册宝箱>*159$82.000000zs00000000000TXw0000000000300Q0000000000T03k000000000Drnzs000000007kCD1w00000003s1sy0z0000003w1v0r0Tk00001w0t001U7s000Sy0QE000s1zs0Dj0C40I0EM1ss3U4CI01s07600MM0r00000003A0l0/Y00000003m1g1n00000080E06yz00/0003k13lzzX000000004Vjzw1k0000001k3zU",
            Setting: g_settings["BookBox"],
            Tolerance: 0.1 * PicTolerance },
        "简介个性化礼包", {
            Text: "|<礼包>*179$37.6301k03Xk0s01ls0zzbyw0zzvzS0zzwzj0zyS3bUTzD3nk7zrXts1zvryw0Qxvzy0Dytzz07zwLrb3zy3XnVkDVltks1sszsTzwQDsDzwC3s1zwU",
            Setting: g_settings["ArenaShopPackage"],
            Tolerance: 0.1 * PicTolerance },
        "公司武器熔炉", {
            Text: "|<熔炉>*171$40.60k0k20s3U30Q3XzsS1kCTzVs7Uzzy7zzzzltzzzzzjbzzzyySTzVzrztzC7yDzbszzsTwT3znXzsQTzDTzltsQzzy7rU7zzsTS0Trj3zk3qQQCz0CFzltw0s7z73U10TwA608",
            Setting: g_settings["ArenaShopFurnace"],
            Tolerance: 0.1 * PicTolerance }
    )
    ; 遍历并购买所有物品
    for Name, item in PurchaseItems {
        if (!item.Setting) {
            continue ; 如果设置未开启，则跳过此物品
        }
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, item.Tolerance, item.Tolerance, item.Text, , , , , , , TrueRatio, TrueRatio)) {
            ; 手册要根据找到个数多次执行
            loop ok.Length {
                FindText().Click(ok[A_Index].x, ok[A_Index].y, "L")
                Text确认 := "|<确认的图标>*200$34.zzU7zzzk07zzw00zzzU7rzzw3zzzzUzzzbwDzzwDVzzzUy7zzw7kzzzUz7zzw7sTzzUzXzzw7yDzzUzszTw7z3szUzwD1w7zky3Uzs3w47zWDs0zy8zk7zsXzUzz27z7zwQTyzzVkzzzy7Vzzzky7zzy7w7zzkTsDzy3zkDzUTzU7k3zz000zzz00DzzzU7zy"
                if (ok1 := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text确认, , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("购买" . Name)
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                    while !(ok2 := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text百货, , 0, , , , , TrueRatio, TrueRatio)) {
                        Confirm
                    }
                }
            }
        }
    }
    AddLog("===竞技场商店任务结束===")
}
;tag 废铁商店
ScrapShop() {
    AddLog("===废铁商店任务开始===")
    Text := "|<废铁商店的图标>*160$40.zw000zzzU001zzy0003zzk000Dzz3zzkTzsDzzVzz1zzy3zw7zzwDzUy7zkTy7s7zVzkTU7y3z3z07w7sDz0TsT1zz1zUwDzy7z3UzsTzw67zUTzsETy0TzU1zw0Tz27zw1zs8Dzw7z1kzzsTw71zVzzUy7y1zy7sDs1zkTkTk1z3zVzk7sDy3zkT1zwDzVwDzkTzzUzzVzzy7zy3zzkTzw0003zzs000DzzU001zzz000DzU"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    ; 定义所有可购买物品的信息 (使用 Map)
    PurchaseItems := Map(
        "珠宝", {
            Text: "|<珠宝>*150$39.00k01k7wb00C0zis3zzrxz0zzzCDz7zztnzww07CTs7U0zzb0Tzzzcs1zzrzzw7zwCTzU1k1nzw3zsC3w0zzVkTk7zwDbz03r7xzw0Cwzyvk3rb7bQTzz0Mt3zzs070TzzU",
            Setting: g_settings["ScrapShopGem"],
            Tolerance: 0.1 * PicTolerance
        },
        "好感券", {
            Text: "|<礼物的图标>*195$22.3sS0Tnw1XwM67VUMQCDzDzzwzzznzzzDzzwzzznzzzDzzwzs0000000Dwzkznz3zDwDwzkznz3zDwDwzW",
            Setting: g_settings["ScrapShopVoucher"],
            Tolerance: 0.15 * PicTolerance
        },
        "养成资源", {
            Text: "|<资源的图标>*170$17.1zU7zUS7VnnWTtgTnMCqk7hUTP0yq1xb3i7ZtDzl7y73k1U01zzU",
            Setting: g_settings["ScrapShopResources"],
            Tolerance: 0.2 * PicTolerance
        },
        "信用点", {
            Text: "|<信用点的图标>*125$31.zXzs0TUzw0DUDz0703zk3U1zw1k3zy0w3zzUT3zzsDnzzy7ztzzXzw0Tlzk07wzw07zTy0zzzz2Djzz0bbzzWNlzzlaMzzsl4TzwQkTzz7ADzzVm7zzsM3zzyA1wzzi7xzzzzxzzzzszzzzsPzzzsB",
            Setting: g_settings["ScrapShopResources"],
            Tolerance: 0.1 * PicTolerance
        }
    )
    ; 遍历并购买所有物品
    for Name, item in PurchaseItems {
        if (!item.Setting) {
            continue ; 如果设置未开启，则跳过此物品
        }
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, item.Tolerance, item.Tolerance, item.Text, , , , , , , TrueRatio, TrueRatio)) {
            ; 根据找到的同类图标数量进行循环购买
            loop ok.Length {
                FindText().Click(ok[A_Index].x, ok[A_Index].y, "L")
                TextMAX := "|<MAX>*124$23.76CMCAAkQMN0kksEVVkV33V267649DA0GCM0UME10kU21V8Ym2F1YUW31Vgi78"
                if (okMax := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, TextMAX, , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("点击max")
                    FindText().Click(X, Y, "L")
                }
                Text确认 := "|<确认的图标>*200$34.zzU7zzzk07zzw00zzzU7rzzw3zzzzUzzzbwDzzwDVzzzUy7zzw7kzzzUz7zzw7sTzzUzXzzw7yDzzUzszTw7z3szUzwD1w7zky3Uzs3w47zWDs0zy8zk7zsXzUzz27z7zwQTyzzVkzzzy7Vzzzky7zzy7w7zzkTsDzy3zkDzUTzU7k3zz000zzz00DzzzU7zy"
                if (ok1 := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text确认, 0, 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("购买" . Name)
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                    while !(ok2 := FindText(&X_found, &Y_found, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text百货, , 0, , , , , TrueRatio, TrueRatio)) {
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
    Text := "|<方舟中的模拟室>*125$59.ssEyCz7zXzlU0wMyC003X01skAM006327UUMk00820C10llzwM80A283k03sk0SAEDk07kU0wMkTkMT101sFsz00S00303ly00Q00C17Xw0tkA0Q607tVrUk0SA07U031U0wM0D007XU1skUDw7z703V24M00CA627QMU00QMyCDwvU00xzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzs00000000000000000000000000000U"
    while (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("进入模拟室")
        FindText().Click(X, Y - 50 * TrueRatio, "L")
    }
    AddLog("成功进入模拟室")
    while true {
        Text := "|<开始模拟>*174$88.zzzz7wzyTbDtzzy001wTlzts0DXbwk007lyDzb00SSPnU00T7szyQ03ssDDsyDs77DUSQy1YMzXtz0AQQ1U1s6NXyDbw0Xss403UNWDsyTsU03slyDXa8zXszW007X00yCQX000CNUwQ403styQ000tbzzk1yDVbtk0036Tzy000s6TbwTby1U0sK07UtwTlyTwC031z7yXYEz7tzssyA600SC03szbzVXsuQ01ssM7XyTw2DXty0zX34QTtzV8yDbkVyAQM1zbwDU0yQ71VnXUDyTly03tUy67ySPztzztyTbTywzzzU"
        if (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("点击开始模拟")
            FindText().Click(X, Y, "L")
            Sleep 1000
            break
        }
        Text := "|<模拟室重置的确认>*200$37.0tzxzbUM3yTnss1zbtwsszzwyQ8TzyTC03zzDXU1kz7UNAsTXkA0TDlta0DbsQn9bnwCNU3tw7gU1wCNkH4y6As1aT0DAlnDW7Www7rbt"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
        }
    }
    ;打过了就直接退
    Text := "|<已通关>*197$62.00000001047zz0kzy0s7XzzsSDzUD1kTzy3kzk1kw007UQDs1zzk00s3DzUzzyQ0C03zwDzzb03U0zz03k1zzsTDzk0Q0Tzy7nzw0DU7zzVwzz7zzxs0s7DzlzzzQ001nzwTzzb000Qzz07w1k0C7ATk1zUS03Vz7w1xw7U0szli0yDkzzyTzztz1zDzz7DzyT07kzzUUTz7U0u"
    if (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("今日模拟室已通关")
        GoBack
        AddLog("===模拟室任务结束===")
        Sleep 1000
        return
    }
    AddLog("选中5C")
    Text := "|<5>*163$22.7zzUTzz3zzwDzzkzzz3zzsDk00z003w00Dk00zz03zz0Dzz1zzy7zzwTzztz0zU01y007w00Dk00z003xw0Tzs1yTkDtzzzXzzw7zzUDzw0TzU0Ts2"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 500
    }
    Text := "|<C>*164$26.01zU03zz03zzw1zzzUzzzwTzzy7zUz3z03lzU08Tk007s003y000z000Dk003w000z000Dk003w000z000Dk001y000Tk007w000zk0MDy0T1zzzsDzzz1zzzUDzzk1zzs07zs007U2"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 500
    }
    Text := "|<快速模拟的图标>*200$42.zzk07zzzz000zzzw000Dzzk0007zzU0001zz00000zy00000Tw00000Ds00000Ds000007k0U1003k1k3U03U3s7k01U3yDs0103z7w0100zXy0000Tlz0000DsTk0007wDs0003y7w0001z3y0001z3w0003wDs0007wTk000TkzU000zVz0001z3y00U3y7w01U3w7s01U3s7k03k0k3U03k000007s000007w00000Dw00000Ty00000Tz00000zzU0003zzs0007zzw000Tzzz001zzzzs07zzU"
    while (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击快速模拟")
        FindText().Click(X + 100 * TrueRatio, Y, "L")
    }
    Text := "|<跳过增益选择的图标>*141$26.s0k0D0D03w3s0zUzUDyDw3znzkzzzyDzzzvzzzzzzzzjzzznzvzszwzsDwDw3y3w0y0y0D0C010300U"
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("跳过增益选择")
        FindText().Click(X, Y, "L")
    }
    EnterToBattle
    BattleSettlement
    Text := "|<模拟结束的图标>*159$38.03zzzy01zzzzs0zzzzy0Dk00Dk3k001w0w000D0D0003k00000w00000D000003k0U000w0M000D0S0003kDU000w7zzU0D3zzs03nzzy00xzzzU0Dzzzs03zzzy00xzzzU0DDzzs03lzzy00wDzzU0D0y0003k7U000w0s000D020003k00000w00000D000003k3k000w0w000T0DU00Dk3zzzzw0Tzzzy03zzzz0000302"
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击模拟结束")
        FindText().Click(X + 50 * TrueRatio, Y, "L")
    }
    Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    Text := "|<左上角的模拟室>*200$54.rn7vzvztzr03vbvk00nn7nUvlzs1zjVavnzw1U7VaPzzznbbnaPy03nXbvbvz7bXbbtbny77Vbblbnw031U7Vbnztz7wznbnztz7wTvUVzkTL03vVVw03rk7vb1ztzrnbnjAzszr7nXyRk00U"
    while !(ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
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
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
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
    Text := "|<SPECIAL>*103$36.V132Qn1162Mn99CGMHB9COMHD9CSMH312SMHV12SMHt3CSMHtDCSEH9DCGE31DC2H31D22H0XjX7H0U"
    foundReward := false
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        foundReward := true
        AddLog("点击奖励")
        FindText().Click(X + 30 * TrueRatio, Y, "L")
        Sleep 1000
    }
    if foundReward {
        Text := "|<领取>*179$44.sw0C07zwC0300zz3k0s000UTXzCA01XszlX74Q00w0tt1U0D0CQKDBXlXb7nn8wsslswmD6CAk3AXk3mA0m8w0w3yAWD4D1zb8XnXsTlmMwsS7UwaS03VkDkT01kC7w3k0s1kyATyAACC7XzW7XnXwzsnxU"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("点击领取")
            FindText().Click(X, Y, "L")
            Sleep 1000
            AddLog("尝试确认并返回方舟大厅")
            Text := "|<方舟页面左上角的方舟>*111$36.zXzzVzzXzzVzz1zs03001s03001s33wDzsVXwTzslXw07st3w07U00w07U00sT7k33sz7sXXkz7kVXkz7llXVy7VzX3UDXy37kDXy7ztzzzDU"
            while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                Confirm
            }
        }
    }
    else AddLog("未找到奖励")
    AddLog("===竞技场收菜任务结束===")
    AddLog("进入竞技场")
    Text := "|<竞技场>*80$59.zUzwDVz70T001sT3y80C003kU0wE0S00C000sk1y3Vw0010w7U0081Uy0UT000MDVw001U03sE0Q403007k00QM0600C001ss0ADsQ033lk0M00s647U00k01sC0T00Vk07sQ1s013sEnkw3k66D1V3V01Vw8E704001jk0US0MAC3zW1Xz1stzDzyD"
    while (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击竞技场")
        FindText().Click(X, Y - 50 * TrueRatio, "L")
        Sleep 1000
    }
    Text := "|<新人竞技场>*92$92.wznzlzzszwTXyTzy7UDwTy00D7sz60C007z7zU03lk1tU3U0Tzlzy43s00CQ0wF7zwTz0kw0021kz4Fzy7z0010QDUEDU00zUzk00QD3s00000DsDz00T607303Vk3y3zk07k00tk0U0Fz0Tw01k00QS0804Tk3z00Q1677420F7sEzk071k3s18U4FwC7w01wS0w0W804S3kzkXj7US0FUE371w3sMtlk3VwMUElUzUE60EE09w0ACAMTyA3U4463z67bz7jzr3y3XbtzvXU"
    while true {
        if !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
        else {
            break
        }
    }
}
;tag 新人竞技场
RookieArena() {
    AddLog("===新人竞技场任务开始===")
    AddLog("查找新人竞技场")
    Text := "|<新人竞技场>*92$92.wznzlzzszwTXyTzy7UDwTy00D7sz60C007z7zU03lk1tU3U0Tzlzy43s00CQ0wF7zwTz0kw0021kz4Fzy7z0010QDUEDU00zUzk00QD3s00000DsDz00T607303Vk3y3zk07k00tk0U0Fz0Tw01k00QS0804Tk3z00Q1677420F7sEzk071k3s18U4FwC7w01wS0w0W804S3kzkXj7US0FUE371w3sMtlk3VwMUElUzUE60EE09w0ACAMTyA3U4463z67bz7jzr3y3XbtzvXU"
    while (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
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
    Text免费 := "|<免费>*186$36.wTzy4Ls0zk01k0zz4FVkzk01103k03003k00U1Xk00XXXwQMnXXUQFk03k03k03s03z0zszXy8zslXwMtsXXksts671s1UC0bw3UzsU"
    while True {
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text免费, , , , , , 3, TrueRatio, TrueRatio)) { ;3代表从下往上找
            AddLog("有免费次数，尝试进入战斗")
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        else break
        if skip = false {
            Text := "|<ON>*185$32.z7zzyT0TjzXU1szsksC7y8zXUzWDwM7s7z60S1zlX3UTwMsMbz6D08zVXs27kszUk0SDwC0DXzXs7szzU"
            if (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("快速战斗已开启")
                skip := true
            }
            else {
                Text := "|<OFF>*159$49.z7zk0TU0y0zU0700C07U0300671lzzXzyDsszzlzz7yATzszz7z601w03XzX00y01lzlXzz7zwzslzzXzyDsszzlzz3sQTzszzk0SDzwTzw0T7zyDzzUzXzz7zw"
                if (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("有笨比没开快速战斗，帮忙开了！")
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                }
            }
        }
        EnterToBattle
        BattleSettlement
        Text := "|<左上角的感叹号>*200$22.zwzzw0Dz3wTszwT7ztszznbwzaznyHzzwDzzkzzz3zDwDwzkznz3zDwjwzaTnyQzzntzyTXzXzVsTzU7zznzs"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
    }
    AddLog("没有免费次数，尝试返回")
    GoBack
    Text := "|<新人竞技场>*92$92.wznzlzzszwTXyTzy7UDwTy00D7sz60C007z7zU03lk1tU3U0Tzlzy43s00CQ0wF7zwTz0kw0021kz4Fzy7z0010QDUEDU00zUzk00QD3s00000DsDz00T607303Vk3y3zk07k00tk0U0Fz0Tw01k00QS0804Tk3z00Q1677420F7sEzk071k3s18U4FwC7w01wS0w0W804S3kzkXj7US0FUE371w3sMtlk3VwMUElUzUE60EE09w0ACAMTyA3U4463z67bz7jzr3y3XbtzvXU"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("已返回竞技场页面")
    }
    AddLog("===新人竞技场任务结束===")
}
;tag 特殊竞技场
SpecialArena() {
    AddLog("===特殊竞技场任务开始===")
    AddLog("查找特殊竞技场")
    Text := "|<特殊竞技场>*93$91.tyDzzDzlzsyDszzws1U07s00wT7wM0kQ0E03w00SA0CA0M60AC0DVkw0077kQ1sy207UkS0031kS0010030010wT0ED000U2DU00kyDU004k0l13w01wM0QM0CTsl00C00y00CC0600000700Q0077000040U7U0C137X00003kk7k071l3k000lXss3s03sw3k20QslwE0z0CwS3k34CSMsEUD36CC0sD6CDUMMF41U4406z07bsQSsy3k2633zW3nwDzwT7y77jtzv3U"
    while (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
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
    Text免费 := "|<免费>*200$35.wTzy8zk3zU0707zsXASDy00EsTw01U03s00337k01DDDstWQQS3nA00y00w01y01z0zwznyNztnbknrnCD3bDUEsT0Q3k/z1szyE"
    while True {
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text免费, , , , , , 3, TrueRatio, TrueRatio)) { ;3代表从下往上找
            AddLog("有免费次数，尝试进入战斗")
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        else break
        if skip = false {
            Text := "|<ON>*185$32.z7zzyT0TjzXU1szsksC7y8zXUzWDwM7s7z60S1zlX3UTwMsMbz6D08zVXs27kszUk0SDwC0DXzXs7szzU"
            if (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("快速战斗已开启")
                skip := true
            }
            else {
                Text := "|<OFF>*159$49.z7zk0TU0y0zU0700C07U0300671lzzXzyDsszzlzz7yATzszz7z601w03XzX00y01lzlXzz7zwzslzzXzyDsszzlzz3sQTzszzk0SDzwTzw0T7zyDzzUzXzz7zw"
                if (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("有笨比没开快速战斗，帮忙开了！")
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                }
            }
        }
        EnterToBattle
        BattleSettlement
        Text := "|<左上角的感叹号>*200$22.zwzzw0Dz3wTszwT7ztszznbwzaznyHzzwDzzkzzz3zDwDwzkznz3zDwjwzaTnyQzzntzyTXzXzVsTzU7zznzs"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
    }
    AddLog("没有免费次数，尝试返回")
    GoBack
    Text := "|<新人竞技场>*92$92.wznzlzzszwTXyTzy7UDwTy00D7sz60C007z7zU03lk1tU3U0Tzlzy43s00CQ0wF7zwTz0kw0021kz4Fzy7z0010QDUEDU00zUzk00QD3s00000DsDz00T607303Vk3y3zk07k00tk0U0Fz0Tw01k00QS0804Tk3z00Q1677420F7sEzk071k3s18U4FwC7w01wS0w0W804S3kzkXj7US0FUE371w3sMtlk3VwMUElUzUE60EE09w0ACAMTyA3U4463z67bz7jzr3y3XbtzvXU"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("已返回竞技场页面")
    }
    AddLog("===特殊竞技场任务结束===")
}
;tag 冠军竞技场
ChampionArena() {
    AddLog("===冠军竞技场任务开始===")
    AddLog("查找冠军竞技场")
    Text := "|<应援>*80$30.z7yQ0z3yM500CRg7zw4VDjQ80BjCQ09aSQDBaS00Aaw6TAkwS0CwyQ9DtyQ9DlyNX006F0M0AKQU"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
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
    Text := "|<无限之塔>*125$79.zzzzzzzzDznlns00Q00Dz3zsU0Q00C007zkzwE0600703Xs01y807z7zYE1s00S32DzXzk80w00C1k7zVzsA0Tzw70s7U00A26Dzy7kk0k006N07zy7wEM4007A03zy7y007w1za05zy7z40Ty0zl0UTw7zXzzy0Ts0MDw7zkU1y4CQ2ADsDzk00y376T67kDzk8QS3U3DU1k3zMQCA3k3bUME007y077s1nsCQw07z03zzztzzzzkDzntk"
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击无限之塔")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    ;只要有一座塔是0/3就当作任务执行过了
    Text := "|<塔的外部0/3>*121$23.szi7UyM28wn4tty9lbw3XDV76T3CBzWQnzYtbj83C0MCS1ztzzznzzzbzw"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("今日企业塔已打过，返回")
        AddLog("===企业塔任务结束===")
        BackToHall
        return
    }
    Text每日通关 := "|<每日通关>*124$58.vzzzzzzzzz7zs0Qs1sww0701lkDnXXzwTbX1w0407nyTs1k000DDtz07wTmAw0740Tty01k0QE1U00037tt0600W8wzbY0Tky8XnySH1y1s0701sA7lXs0w07008D3y7lyQk1Vy8"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text每日通关, , , , , , 5, TrueRatio, TrueRatio)) { ;5代表从左往右
        count := ok.Length
        AddLog("今天有" count "座塔要打")
        FindText().Click(X, Y, "L")
        Sleep 1000
        loop count {
            Text := "|<STAGE>*83$39.0kCD0s041ls705kQ74scz7Usz77sw77ssz7Usz70sw76M877YsX10ssX4MD774MX7sssX4Mz770MX7sss34Ms7748300sll0M4TbSSL1U"
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("已进入塔的内部")
                Text := "|<极乐>*90$37.lzzzz1sk1w00wM1y00w68z7zw14TXXz1WDllzll1sszsMUs00M4QQ00A06D00663DzXy307sl71a7sslsX3sQQQF0sSCC004M7X0XXw7zrzzzDzU"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) { ;0代表使用上一次截屏
                    AddLog("这座塔是极乐净土之塔")
                }
                Text := "|<米西>*96$36.nnnU00lnVU00lnXzaTsn7zaTtn7k00zlzk00000l08000l6My0Tl6My0TkC0w0DkS0sH7lzskn3lzsVnUk003nkk00jnxk00U"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("这座塔是米西利斯之塔")
                }
                Text := "|<泰特>*93$37.zXzwT7s01uC0s00Q60DsTw30700C0wTU07000y7zUE0000GDsM00T7wT6MzU027C70001a10tXY0BkMlz07yC8w01z7gS0MTXsDADTlw7zDzxzDU"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("这座塔是泰特拉之塔")
                }
                Text := "|<朝圣>*99$37.sw1k01U00w00k0CT7kz7bDkky0E7w0z683w0DU4FU00E2QsTkNl0TyTw00DU0y0U7k0Dklns0701tztzU0wzsTyAMM0076QC002"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("这座塔是朝圣者/超标准之塔")
                }
                Text := "|<STAGE>*83$39.0kCD0s041ls705kQ74scz7Usz77sw77ssz7Usz70sw76M877YsX10ssX4MD774MX7sssX4Mz770MX7sss34Ms7748300sll0M4TbSSL1U"
                while (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    stdTargetX := 1850
                    stdTargetY := 984
                    AddLog("点击最新关卡")
                    UserClick(stdTargetX, stdTargetY, scrRatio)
                    Sleep 1000
                    EnterToBattle
                }
                BattleSettlement
                RefuseSale
            }
            if !(A_Index = count) {
                AddLog("点击下一个塔")
                UserClick(2239, 1868, scrRatio)
                Sleep 1000
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
    Text := "|<无限之塔>*125$79.zzzzzzzzDznlns00Q00Dz3zsU0Q00C007zkzwE0600703Xs01y807z7zYE1s00S32DzXzk80w00C1k7zVzsA0Tzw70s7U00A26Dzy7kk0k006N07zy7wEM4007A03zy7y007w1za05zy7z40Ty0zl0UTw7zXzzy0Ts0MDw7zkU1y4CQ2ADsDzk00y376T67kDzk8QS3U3DU1k3zMQCA3k3bUME007y077s1nsCQw07z03zzztzzzzkDzntk"
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击无限之塔")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    Text := "|<塔内的无限之塔>*194$63.000000000E3zwTzs1U37QTznzz0C0PzsD0PMszz3Dy0k3Pz7zwyzU60TTs0D7nszzvvb01kMzbzzPTs0Q3zT1s3Dy070PzkD0Nvs1k3003s3zD0Q0Tzkv3TNkD07zyCQv3i7k0slrXzMTxzzk7ysDn3nATw0zo"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击塔内的无限之塔")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    Text := "|<STAGE>*83$39.0kCD0s041ls705kQ74scz7Usz77sw77ssz7Usz70sw76M877YsX10ssX4MD774MX7sssX4Mz770MX7sss34Ms7748300sll0M4TbSSL1U"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("已进入塔的内部")
        stdTargetX := 1926
        stdTargetY := 908
        Sleep 1000
        AddLog("点击最新关卡")
        UserClick(stdTargetX, stdTargetY, scrRatio)
        Sleep 1000
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
    Text := "|<拦截战>*200$57.nnnzDDzbxyTSz0NbwzBnvbyDCzbxkD8ztszw7j0U1k00TXxyQ0C003wz0nzzxrbzbkSTzzYxzwzjlzzs1az3xo7zy4Qbk7Y3k3k3UywwCTzz0QDrrVnzzsXXyyySTzz0QTrrXnzztbXSQsSM0D0E3k20b01s0MSQH4"
    while (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y - 50 * TrueRatio, "L")
        Sleep 500
    }
    Text := "|<异常个体拦截战>*200$94.07nRznzDTrhwBjjdzS03y7xszSrtrySk1vzjnDa0sEC03svDzc2wyCSDrzw8zj0zjbjbStszTzrryws1z0zxzb1wzy1/VvzzzDzrzRPX0tCS3WSz07zTxhjTzUtvy00wWDxzk2RzzHjjxjjrQzrzSDrzxAqvZyzQbzTxxzM1k0s48"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        Confirm
        if A_Index > 20 {
            MsgBox("异常个体拦截战未解锁！本脚本不支持普通拦截！")
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
                Text := "|<克>*200$43.zzz0zzzzzzUTzzzzzkDzzzzzs3zzy00000030000001U000000k000000M000000Tzzs3zzzzzw3zzzzzy1zzzzzz0TzzzU0000Dzk00007zs00003zw00001zy00000zz0zzzUTzUTzzkDzkDzzs7zs7zzw3zw00001zy00000zz00000TzU0000Dzk00007zs00003zzs3w3zzzw1y1zzzy0z0zzzz0TUTzzz0TkDxzzUDs7yDzU7w3y1zU7y1z0z03z0zUQ03zUDUE03zk00803zs00603zw003U7zz003kDzzk03wzzzzzzs"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS克拉肯")
                    break
                }
            case 2:
                Text := "|<镜>*200$44.zTzzw7zzUzzy0zzsDz0003w1zk000z00Q000DU070003k01z3s7w00TUz1y007sDkT0Tzy3s7kDzz000w7zw0001Uzz0000M00k000700A0001s03zzzzy00zzzzzk0D0007z0zk001zkDw000Tw3z1zw7z0zkTz1zU7w3zUS0070007U01k001s00Q3zUS0071zw7y0TkDz1zkDw000Tw3z0007z0zk001zkCzUQ7zw37s71zz01y3kTzk0TUw7zs07kD1zy03s3kQz01w1w73k1w0T0Uw1y0Dk0DUzk7w07wzw7zU3zTzbzzXs"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS镜像容器")
                    break
                }
            case 3:
                Text := "|<茵>*200$41.zs7zUDzzkDz0TzzUDy0zs0000000000000000000000000000000007zUTy0zzz0zy1zzzzzzzzzzzzzzzk000007U00000D000000S000000w000001s7zzzw3kDy3zs7UTw3zkD0zs7zUS1U0030w300061s6000A3kA000M7UM001kD0zs1zUS1zU1z0w3z01y1s7w01w3kDU01s7UQ0M0kD0k1w1US1U7w30w3UTwC1s7Xzww3kDTzvs7U00000D000000S000000w000001s000003k7zzzk7UzzzzkS"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS茵迪维利亚")
                    break
                }
            case 4:
                Text := "|<过>*200$43.zzzzzkDzzzzzs7z7zzzw3z1zzzy1z0Tzzz0zU7zzzUTs1zzzkDy0zzzk3zUC00007sD00003wTU0001zTk0000zzs0000Tzzzzk7zzzzzw3zzzzzy1zzzwTz0z03s7zUTU1w1zkDk0z0Ts7s0TkDw3w0Ds3y1zs7y0z0zy3zUTUTz1zkzkDzUzwzs7zkTzzw3zsDzzy1zw7zzy0zy3zy00zz1zz00TzUzzk0DzUTzs0DzU7zw0Tz00zzzzz007zzzz0007zw000000008D0000047s000077z00003rzw0001vzzzzzzk"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS过激派")
                    break
                }
            case 5:
                Text := "|<死>*200$42.U0000010000000000000000000000000000U000001zUDz0zzzUTz0zzzUTz0zzz0Tz0zzz0Tz0zzz0070zzy0030zDy0030y7w0030w3s0030s1s7s3001k7s7003UDs700D0Ts700T0TsD01z0nkD07zVUUD0DzvU0T0zzz00T0zzzU0T0zzzk0z0zzzs1z0zzzw1z0zzzs3z0zzzk3z0zXzU7z0zUz0Dz0zUy0Tz0z0s0Tz060U0zzU0101zzU01U7zzU01kDzzk03szzzy0TU"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    AddLog("已选择BOSS死神")
                    break
                }
            default:
                MsgBox "BOSS选择错误！"
                Pause
        }
        AddLog("非对应BOSS，尝试切换")
        UserClick(2287, 891, scrRatio)
        Sleep 1000
    }
    Text := "|<挑战>*200$53.tzzzzzzzznyATznzbzbyNzzbzCTDwnzzDzASStbDyTyQsMnCTw1wz086Mzs1ty0sAHzlznzbkM7zbz07DkkTzDk0yTtbzyTkTwznDzwzwzsDaDzsztnUSQ7w07nY3ss7s0DaMD1l7nyTUyQ3b7bwz1wtbDDDty7tzCTyTnwTnwQzwzbszbttttzDVrDXnnk0S3iSDXbU0s0MszUD7k3UVnz0yTnDXTzzzzzzzi"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    Text := "|<异常>*130$40.U03z77400DwQMEAEz0003zXw00000Dkzz000z7zw3zvwE0GDzln01c007wz7U00zk0Tk0Tz01yDnzzlzszDy000001s000007U00000SD7W7wzswS0TnzXlU3zDyD62"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        Confirm
    }
    switch g_numeric_settings["InterceptionBoss"] {
        case 1:
            Text := "|<01>*200$13.Us0A3bVnktsQwCS7D3bVnktsQwCS7D3bVnktsQwCS3D87Y"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        case 2:
            Text := "|<02>*200$16.Uw41U3aQCNktb3bwCTktz3bwCTUtkHa3CNwtbnaTCNwtbnaTCNwFbkC0U"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        case 3:
            Text := "|<03>*200$16.Uw01U3aQCNktb3aQCTktz3bwCTUtsHbkCTktz3bwCTktb3aQCNkNX870U"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        case 4:
            Text := "|<04>*200$18.UTXUD36D37D37CH7CH7CH7Cn7Cn7An7An7Bn7Bn79l7807Dl7Dn7Dn7Dn6DnUTnU"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        case 5:
            Text := "|<05>*200$17.kQ10M0QnstblnDXaT7AyCNwQm8tU1ny3bw7DsCTkQzUtz1nC3aQbAt4MW1sA"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
            }
        default:
            MsgBox "BOSS选择错误！"
            Pause
    }
    AddLog("已切换到对应队伍")
    Sleep 1000
    Text快速战斗的图标 := "|<快速战斗的图标>*200$34.zzzzzzzzzzzy0w1zzw1s3zzs3k7zzk7UDzzUD0Tzz0S0zzy0w1zzw1s3zzs3k7zzk7UDzzUD0Tzz0S0zzs3s3zz0T0Tzs3s3zz0T0Tzs3s3zz0T0Tzs3s3zz0T0Tzs3s3zz0T0Tzs3s3zz0T0Tzzzzzzzzzzzzy"
    Text进入战斗 := "|<进入战斗>*200$115.zzzzzzzzzzzzyzzzzsztzlszztzzzyDyCzzzwTsTswTzsTzzz7z6DznyDy7wSDzw7zzzXzX7zkT7zVyD7zz1zzzlzllzs7Xzsk00TzkTzzs0wszz1lzys00DzwDzzw0SDzzkszzw007zz3zzy0D7zzywTzzsMTzzUzzz7z03zzyDzzwSDzzkTzzXw01yDz7zzyD7zzk7zzly07y1zXz0z7Xzzs3zzszURzUDlz0T10Dzw0zzwDyCTw3szkA003zwATzU0T6Dz3wTz6001zy67zk07X7zvyDzXU01zy7Vzs03l7zzz3zlwD7zz3kzwTVw3zzzU1syDXzz3wDyDsy3zzs00wS7lzzVz3z7wT1zs000yC7szzVzUzXyDVz000Dz73wTzUzsDlz7krU0CDz1nyDzUzy3sz3kNkDz7z0Tzzz0zz0w01kAzzzXz01zyD0zzkC00U0Tzzlz3U0070zzwD000kDzzsznw003kzzz7Xw8sDzzwTxzk03xzzzvlzDy7zzyDw"
    while True {
        Text := "|<异常个体拦截战>*200$94.07nRznzDTrhwBjjdzS03y7xszSrtrySk1vzjnDa0sEC03svDzc2wyCSDrzw8zj0zjbjbStszTzrryws1z0zxzb1wzy1/VvzzzDzrzRPX0tCS3WSz07zTxhjTzUtvy00wWDxzk2RzzHjjxjjrQzrzSDrzxAqvZyzQbzTxxzM1k0s48"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
        if !(ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text进入战斗, 0, 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("异常拦截次数已耗尽")
            break
        }
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text快速战斗的图标, 0, 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("已激活快速战斗")
            FindText().Click(X, Y, "L")
        }
        else if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text进入战斗, 0, 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("未激活快速战斗，尝试普通战斗")
            FindText().Click(X, Y, "L")
            Sleep 1000
            Text := "|<ESC>*100$35.03k7k60606040A0A000M0M00zksks1zVzVk070D3y0C067w0S0ADsTzk8Q0zlsEs1XVUVU0301000606040C0C0A"
            while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                UserClick(2123, 1371, scrRatio)
                Sleep 500
                if (A_Index > 30) {
                    break
                }
            }
            Sleep 1000
            Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                AddLog("跳过动画")
            }
        }
        if g_settings["InterceptionShot"] {
            BattleSettlement(true)
        }
        else BattleSettlement
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
    Text := "|<前哨基地的图标>*130$37.7k00SAEw00SAS7U0SAP3s0SAQsT0SAQC7kSAQXUwSAQMQDyAQC73yAQ7VsTAQ1wC7wS0T3lyQ07ksDy01wT3y00DlkzU03sQ7s00y31y00TUsTU0RsC3w0QT3kz0QDkw7kQAw71wQADVsSQADsS3QACS7Uk"
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击进入前哨基地")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    else {
        AddLog("未找到前哨基地！返回")
        return
    }
    Text := "|<LV>*80$17.DlkDXUT70z41y8Xw17s6DsA3kM3lk7Xk"
    while (ok := FindText(&X := "wait", &Y := 10, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击左下角资源")
        FindText().Click(X + 50 * TrueRatio, Y, "L")
        Sleep 1000
    }
    Text := "|<免费一举歼灭的红点>*194$67.000000000C0000000000zs000000000sD000000001k1k00000001kwQ00000000lz600000000lzlU0000000tzwk0000000Rzy80000000QzzbzzzzzzzyTzm00000003Dzt00000000nztU0000000Nzwk00000004TwM000000017wM00000000k0M00000000A0M000000001zs0000000007s0000000003k0000000001U0000000000k0000000000M0000000000A0E"
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
        Text := "|<歼灭>*182$46.U3s7U000000S0008003s000kz0zzsTz3zXzzlzw0yDzz7zk3szwsSD0DXzlVsssU0y67XX001ssQQ40073Ulk1U0wS3D07szvk7zkzXzz0TzXyDzsEzwDszzVVzVzXzsC3wDyDz1w7UzszUDs27zXw1zk8zyDsTzkzztzrzzy"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("点击进行歼灭")
            FindText().Click(X, Y, "L")
            Sleep 1000
            Text := "|<获得奖励的图标>*191$34.zzsTzzzzVzzzzy7zzzzsTzzzzVzzzzy7zzzzsTzzzzVzzzzy7zzzzsTzzzzVzzzzy7zzzk00TzzU01zzz00Dzzw01zzzs07zzzk0zzzz07zwTy0Tw1zw3zk7zkTz0TzVzw1zzDzk7zxzz0Tzzzw1zzzzk7zzzz0Tzzzw1zzzzk3zzzz000000000001U00007U0001s"
            while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                Confirm
                Sleep 1000
            }
        }
    }
    else AddLog("没有免费一举歼灭")
    AddLog("尝试常规收菜")
    Text := "|<获得奖励的图标>*191$34.zzsTzzzzVzzzzy7zzzzsTzzzzVzzzzy7zzzzsTzzzzVzzzzy7zzzzsTzzzzVzzzzy7zzzk00TzzU01zzz00Dzzw01zzzs07zzzk0zzzz07zwTy0Tw1zw3zk7zkTz0TzVzw1zzDzk7zxzz0Tzzzw1zzzzk7zzzz0Tzzzw1zzzzk3zzzz000000000001U00007U0001s"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击收菜")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    AddLog("尝试返回前哨基地主页面")
    Text := "|<%>*74$24.U7y703y703w713wD33wD33sD33sT33sT33kT33kz33Uz33Vz33Vz033z033zU73zkC3zzy7zzw7zzwDzzwDzzsTzzsTzzsTzzks7zkk1zUU1zVU0zVUkz3Vkz3Vkz3Vky7Vky7Vky7VkwDVkwDVksTU0sTU0szk1szs3U"
    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        Confirm
        Sleep 1000
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
    Text := "|<派遣公告栏的图标>*145$58.zzzzsTzzzzzzzy0zzzzzzzzU0zzzzzzzw00zzzzzzz000zzzzzzk1k1zzzzzw0Dk1zzzzzU3zU1zzzzs0yDU1zzzy0DUDU3zzzU1wQDU3zzw0T3wTU3zz07kzsT03zk1yDzsT07w0DVzzsT07U3sTzzsz040y7zzzsy00Dlzzzzky01wTzxzzky0D3zzXzzls0szzw7zzVU3bzzUDzza0CTzw0TzyM0tzzs1zztU3bzzkDzza0CTzzVzzyM0tyzzDzjtU3btzzzyza0CTbzzznyM0tyDzzzDtU3bszzzsza0CTVzzzXyM0ty7zDwDtU3bsDkTkza0CTUy0y3yM0ty1k0kDtU3bs6010za0CTU0003yM0ty0000DtU3bs0000za0CTU0003yM0ty0000DtU3by0001za0CTw000TyM0tzw007ztU3Vzw01zy60DXzw0DzVs0T3zs3zsT00T3zszz7k00T7zzzky080z7zzwDU3s0y7zz3s0Ts0y7zsz07zk0y7y7k1zzk1yDVw0Tzzk1w8T03zzzk1w7s0zzzzU1wy0DzzzzU3zU3zzzzzU3s0TzzzzzU307zzzzzz001zzzzzzz00Tzzzzzzz03zzzzzzzz0zzzzzzzzyDzzzzU"
    if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击派遣公告栏")
        FindText().Click(X, Y, "L")
        Sleep 1000
        Text := "|<全部领取的符号>*190$28.zz3zzzwDzzzkzzzz3zzzwDzzzkzzzz3zzzwDzzzkzzzU07zy00zzw03zzs0TzzU3zzz0Dz7y1zUTs7y1zkzs7zbzUTyzy1zzzs7zzzUTzzy1zzzs7zzzU000000000U0006"
        while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("点击全部领取")
            FindText().Click(X + 50 * TrueRatio, Y, "L")
            Sleep 1000
        }
        Text := "|<左上角的派遣>*149$68.000040001w01k00TU20TzzUS03zw1sDzzsDszzzUz3zzy3zTzzsDsyTDUTbzzk1zDzzs1tzy00Dnzzy0AT0101szzzU07k7s0Q07k001wzz00Dzzzm0TDzs03zzzxs7nzy00zzzyzVwzs001zzwDwTDS0TwTzz1z7nrk7z7zzk7VwxxVzlw1w0sTDDwTwTzz007nnzXz7zzk01wwzs7lzzw08SDDw1wT00077Xny0T7zzw1tswT07lzzz0yyD7k1wTzzkDjXlw0T7k3w7nswTU7lzzz1wyDDs3wTzzkyD7yz1zrzzsTblzrszzU01rlwTxyTzzzzxwyDyD7nzzzzSDVy3kwDzzzVXsQ0M60zzzs0A2000U0zzwU"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            UserClick(1595, 1806, scrRatio)
            Sleep 500
        }
        Text := "|<全部派遣的符号>*193$35.00Ty0007zz000zzzU03zzzU0DzzzU0zzzzU3zzzzUDzzzzUTzzzzVzbwzz3y7kzz7w3UzyTw3Uzwzw3Uztzw3Uzvzw3Uzzzy3Uzzzs71zTzUQ7yzy1kTxzs71znzUw7zXy3UTz7wDVzwDwzbzsDzzzzUTzzzz0Tzzzw0Tzzzk0Tzzz00Tzzw00Dzzk007zy0001zU08"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
        Text := "|<派遣的符号>*191$33.zzUDzzzU0Dzzk00Tzs000zy0003zU000Ds0000y00003k0000Q0k601UD1s081wTU007ly000T7s001wTU007ky000T3s003wT000z7k00Dlw003sT000y7k00DXw041sT01U61k0C00003k0000T00007w0001zk000Tz0007zw001zzs00zzzk0TzU"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("点击全部派遣")
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
    }
    else AddLog("派遣公告栏未找到！")
    AddLog("===派遣委托任务结束===")
    BackToHall
}
;endregion 前哨基地
;region 咨询
;tag 好感度咨询
LoveTalking() {
    BackToHall
    UserClick(1497, 1994, scrRatio) ;点击妮姬图标位置（识图很困难）
    Text := "|<咨询>*109$44.rlzzjkzsQ7blwDy200wC3zk00DVU0DkU3sk03wMEzs00yC6Tq7wA70zUU101U7kC0E00EC3U41kC3ss13yDkyC0Fs00TXU4S007ssV7U01y20FsTkTU04SDy7s017Vz1y2DVs00T1z0S007lzkDU01yzw3U"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    Text := "|<左上角的咨询>*111$37.nXztszkE0sQTw00CA07U0Da03sl7y01wM3U7sUMDUU4001kM28kMCAF7sSD60XU0DX0Fk07l20s03s00QTlw00C7ky0SD00T7s7U0Dby3lz7zz7U"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        if g_settings["Appreciation"] {
            Appreciation
        }
        UserClick(313, 756, scrRatio) ;点击妮姬头像位置（识图很困难）
        Sleep 500
        UserClick(313, 756, scrRatio)
        Sleep 500
        UserClick(313, 756, scrRatio)
        Sleep 500
    }
    AddLog("===妮姬咨询任务开始===")
    Text咨询 := "|<咨询的咨>*178$30.zzXzzlz3zzUT3zzUC000sC000yA001zw63VzsC7VzsS7Xzsy3XzXw3rw3s1zU3k0z0DUED0y0s13s1w0zs7z1zwTzlzwTzzw0007w0007w0007w7zw7wDzw7wDzw7wDzw7w7zw7w0007w0007w0007w7zw7yDzzzU"
    Text快速咨询 := "|<快速咨询>*195$91.szbzzzDzzXzzTXzwTnzXz3zVlzz7lzyDtzsk03kM07lszz701w801yM03sM060U0z7wTzsMlyQ01000Tz00TwMNzwDlU7bDzU0DwQAzwDwk3nbzlX7sQ3y206MDtnkNlXUQ0z1k387sMsA01ksA7sslbX00D600tsD1wQMnlU07ns7zyTsyC0Nsy1zts1zk01z708wTUzws0Ds00zXX4SDUTyEF3w00TlE2D7l7z0NlyDyDs017XlVz2wzz7z7w0TXlksT0TzzXzXy7TlsUy30007k01y7y1wEzXbU03s00zbz0yBztzz07wTwTzzkw"
    Text20 := "|<20/>*240$24.3000DkM3Tly3Tvz71vz71vb73zbD3rbC7rbCTXbCzvzQzvzQTtyQ00Qs000s000k000kU"
    Text0 := "|<0/>*200$28.00000000000zkC07zUs0zz7U3UQS0C1lk0s7703UQw0C1nk0s7C03kws07zbU0DwQ0000U0000000008"
    while true {
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.05 * PicTolerance, 0.1 * PicTolerance, Text20, , , , , , , TrueRatio, TrueRatio)) {
            AddLog("图鉴已满")
            Text := "|<MAX>*180$45.00000S1z070M1sSw1s7073bkT0w0QwzjsDU3z7zz1y0DktwsTk0w7773b07Us0sss1y70773UTss0tkQ3bb07C1ksQs0vUCD1r07Q0vkDU"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, , , , , , TrueRatio, TrueRatio)) {
                AddLog("好感度也已满，跳过")
                Text := "|<已关注的图标>FC4E3C-323232$28.zzbzzzwTzzzkzzzy3zzzs7zzz0Tzzw0zzzU1zzk00zU0004000080001k000DU001z000Dy001zw00Dzk00zz003zw00Dzk00zy003zs00DzUC0Ty3y1zszy7zzzyzU"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, , , , , , TrueRatio, TrueRatio)) {
                    AddLog("尝试取消收藏该妮姬")
                    FindText().Click(X, Y, "L")
                }
            }
            else if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.05 * PicTolerance, 0.05 * PicTolerance, Text快速咨询, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("图鉴已满，尝试快速咨询")
                FindText().Click(X, Y, "L")
                Sleep 1000
                Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y, "L")
                    AddLog("已咨询" A_Index "次")
                    Sleep 1000
                }
            }
            else AddLog("该妮姬已咨询")
        }
        else {
            AddLog("图鉴未满")
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text咨询, 0, 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("尝试普通咨询")
                FindText().Click(X, Y, "L")
                Text := "|<确认的图标>*184$34.zy03zzzU07zzs00zzz0Tzzzs7zzvz1zzz7sDzzsD1zzz1wDzzsDVzzz1y7zzsDkzzz1z3zzsDwDzz1zlyTsDz7kz1zwT1sDzly31zk7w0Dz0Ts1zw0zkDzl3zVzz6DzDzsMTzzzXkzzzwD3zzzVy7zzw7wDzzUzkDzw7zkDz0zzU007zz001zzz00TzzzkDzy"
                if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y, "L")
                    AddLog("已咨询" A_Index "次")
                }
                Sleep 1000
                Text := "|<左上角的咨询>*200$35.zbzzvz60DbXzw0Db3zn6zw0DiRzlyTwTznyVkTXUQDCTbavsyDjBrvyzS3DXvywqM07wtglzDsENbzTlbn7wz7za01yTsSTnzztk"
                while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
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
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.05 * PicTolerance, 0.05 * PicTolerance, Text0, 0, 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("咨询次数已耗尽，跳过任务")
            break
        }
        Text := "|<左上角的咨询>*200$35.zbzzvz60DbXzw0Db3zn6zw0DiRzlyTwTznyVkTXUQDCTbavsyDjBrvyzS3DXvywqM07wtglzDsENbzTlbn7wz7za01yTsSTnzztk"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            Confirm
        }
        Text := "|<向右的符号>*126$29.03zzy03zzy07zzy07zzy07zzw0Dzzw0Dzzw0Dzzs0Tzzs0Tzzs0Tzzk0zzzk0zzzk0zzzU1zzzU1zzzU1zzz03zzz03zzz03zzy03zzy07zzy07zzw07zzw0Dzzw0Dzzs0Dzzs0Tzzs0TzzU1zzz03zzw0Dzzs0zzzU1zzy07zzw0Tzzk0zzz03zzy07zzs0TzzU1zzz03zzw0Dzzk0zzzU1zzy07zzs0Tzzk0zzz03zzw0Dzzs0TzzU1zzy07zzw0Dzzk0zzz03zzy07zzs0Tzzs"
        if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("下一个妮姬")
            FindText().Click(X, Y, "L")
            Sleep 1000
        }
    }
    AddLog("===妮姬咨询任务结束===")
    BackToHall
}
;tag 花絮鉴赏
Appreciation() {
    AddLog("===花絮鉴赏任务开始===")
    Text := "|<花絮鉴赏会的N>*184$44.000000000000000000Dy00000zzz0000k00M000M00300087xU8004DzzV002Dzzy8017zzzl00lzzzwE08zzzzU02DzzzsU1bxzsy80NzDyDm0CTlzXwk7bw7szDztz0yDnzyTk7XwzzbwsMzDztzD2DnzyTns3wzzbwz0zDztzDwDnzyTnzXwzzbwzwy/zxzDzzWzzDzzzsjzlzzzwPzyTzzz4zzXzzzWDzwDzzV3zzVzzUUzzy000EDzzw00M3zzzzzw0zzzzzs0Dzzzzk02"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, 0, 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Text := "|<EPISO>*191$67.DztzwC7zU7sDzwzzb7zsDzDzyTznbzyDzr00C0tnU77VvU070Qtk070Tzy3zyQzy3U7zz1zyCDzXU3zzUzy73ztk1y00Q03U0SQ0z00C01k07C0TU0700tk3bUTk03U0Qw3lsSzztk0CDzkTyDzws077zs7y3zyQ03Uzk0w4"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("播放第一个片段")
            FindText().Click(X, Y, "L")
        }
        Text领取 := "|<领取>*200$40.wzzzzzzVU1U1zy706000kD3wEU24QTl608E070Qs0U0Q1n4lkFl74P7976QFUAYQ1s60GFk7UzX970S3yA4QMwDtkFl1ls716063Uz1s0E7Xs3V60D767yMsyswTtbrzrzzbzs"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text领取, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("播放下一个片段")
            Send "{]}" ;尝试跳过
        }
        FindText().Click(X, Y, "L")
        AddLog("领取奖励")
        GoBack
        Sleep 1000
        GoBack
        Sleep 1000
    }
    else AddLog("花絮鉴赏任务已完成")
    AddLog("===花絮鉴赏任务结束===")
}
;endregion 咨询
;region 好友点数收取
FriendPoint() {
    BackToHall
    AddLog("===好友点数任务开始===")
    Text := "|<好友>*200$33.rzzyzyy0zrzbzDU007tzbzayTwzxrrzbziyTw0NY0TXnByTsSQDrzPrlyzngyDryyDkyzbVwzrttXDszwT4"
    while (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击好友")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    Text := "|<赠送>*192$44.0AQT7lwE377kwC4sk1yDXXD80DlU02G03ws00YWEzy00984Dzy7mG0HUzlwYY4sDs0980C3002G03wk00Yk1zDsD9A0Tnw1kG07wz0AAXtzD1Vns0TnUwAC07sETWNXlw2Tx68wS03w3m07X001zU1tw00U"
    while (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击赠送")
        FindText().Click(X, Y, "L")
    }
    AddLog("===好友点数任务结束===")
    BackToHall
}
;endregion 好友点数收取
;region 邮箱收取
Mail() {
    BackToHall
    AddLog("===邮箱任务开始===")
    Text := "|<带红点的邮箱>*140$49.zzzzzzzzzzzzzzzzzzzzzzszzzzzzzU7zzzzzzVkzzzzzzXwDzzzzzXzbzzzzznzlzzzzzlzwzzzzzszyTzzzzwzzDzzzzyDzbzU0077zXzU003lzlzm001s0Fztk00S00zwy00DU0zyTk07s1zz7w0DzrzzUzUDzzzzk7sTnzzzs1zzUDzzw0Dz01zzy03z00zzz00S00TzzU0000Dzzk00007zzs00003zzw00001zzy00000zzz00000TzzU0000Dzzk00007zzs00003zzw00003zzzU0003zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzk"
    while (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击邮箱")
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    else {
        AddLog("邮箱已领取")
        AddLog("===邮箱任务结束===")
        return
    }
    Text := "|<全部领取的图标>*240$33.zz07zzz007zzU00Dzs000zy0003zU000Ds0000y00003k60k0Q1sD01UTXw0A1yTk107sz000TXw001zDk007wz000TXw007wz001zDk00Tnw007sz041yTk1UTXw0A1sD01k60k0S00003s0000zU000Dy0003zs000zzU00Dzz007zzz07zw"
    while (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        AddLog("点击全部领取")
        FindText().Click(X + 50 * TrueRatio, Y, "L")
    }
    AddLog("===邮箱任务结束===")
    BackToHall
}
;endregion 邮箱收取
;region 方舟排名奖励
;tag 排名奖励（停用）
RankingReward() {
    EnterToArk()
    AddLog("===排名奖励任务开始===")
    Text := "|<带红点的奖杯>*200$56.zzzzzzzyDzzzzzzzw0zzzzzzzwTXzzzzzzzDwTzzzzzzbzbzzzzzzvzwzzzzzzyzzDzzzzzzDznzzzzzznzwzzzzzzyzzDzzzzzzbznzzzzzztztz00000zDwTk0000DkyDw00003y07z00000zwDy000001zzz0000007zzXU0000tzzls0000TDzwy00007nzzDU0001wzzns0000TDzwy00007nzzDU0001wzzns0000TDzwS00007nzzbU0001tzzsw0000QTzz30000ADzzs000007zzz000003zzzy00003zzzzs0007zzzzz0003zzzzzs000zzzzzy000Tzzzzzk00Dzzzzzy007zzzzzzs07zzzzzzzU7zzzzzzzs1zzzzzzzz0Tzzzzzzzk7zzzzzzzw1zzzzzzzz0TzzzzzzzU7zzzzzzzs1zzzzzzzk03zzzzzy0001zzzzz0000DzzzU"
    while (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.05 * PicTolerance, 0.05 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        Sleep 1000
        FindText().Click(X, Y, "L")
        Sleep 1000
        loop 2 {
            Text := "|<红点>*200$19.0T00zs1kD0U1kVwMnz6HzlNzwtzyQzzCTzbDznnztdzsqTsn7ssk0sC1s3zk0DU8"
            while (ok := FindText(&X := "wait", &Y := 1, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                AddLog("发现红点，尝试点击")
                FindText().Click(X, Y, "L")
                Sleep 1000
                Text := "|<获得>*143$57.zXzDzzzzzzwDkzzlk03U000DwC0080000z1k01U0007kS7wA0001s7k01zXy7z1y00DwTlzstk01lby8zi67wC0Tl3zkk01s7yADwC00D0zlXz3s03U7w4TkTzzs0U00s3000X00070M007sE00s3U01y3w7z0TzVzUTUzxXvs7s3w7zwM0040T0TzX0001Xs3zwM00AQS4DzXlyDzXUkzwS7lzsMC3zXsSDz23sDwTXVy0UzUzXykDkADyDwTy1z3nztzXzkTU"
                if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                    FindText().Click(X, Y, "L")
                    Sleep 1000
                    Text := "|<排名>*143$35.lsXzVzXl7y0D72Ds0404700008A7kkQFs73lsXy4DX11y0z023w1s34TU00C8s00EkEM7slUUuDlXl7wTX7WDs04D4Tk08S8zU0TyFz7wU"
                    while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                        Confirm
                    }
                    GoBack
                }
            }
            stdTargetX := 1858
            stdTargetY := 615
            UserMove(stdTargetX, stdTargetY, scrRatio)
            Send "{WheelDown 30}"
            Sleep 1000
        }
    }
    else AddLog("没有可领取的奖励，跳过")
    AddLog("===排名奖励任务结束===")
    BackToHall
}
;endregion 方舟排名奖励
;region 每日任务收取
Mission() {
    BackToHall
    AddLog("===每日任务奖励领取开始===")
    Text := "|<带红点的任务>*200$48.zzzzzrzwzzzzzrzwzzzzznzxzzwDznztzz00znztzs007sznzk003wT7zUTy0y0Dy1zzkTlzw7zzsDzzwDzzwDzzsTzzy7zzkzzzz3zzU"
    if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.05 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y, "L")
        Sleep 1000
    }
    else {
        AddLog("每日任务奖励已领取")
        AddLog("===每日任务奖励领取结束===")
        return
    }
    loop 4 {
        if A_Index = 2 {
            Text := "|<周任务的图标>*150$37.zzU0zzzy003zzw000Tzw1zk7zw3zy1zw7zzkTw7zzw7w7zlz1y7zsDky7zw3wD3zy0T73zz0DVXzzU3klzzk0wEzzs0S0Tzw0D0Dzy07U7zz03k3zz01s1zz00w0zz00S4Tz00D6Dz00DX3z007VVz007lsT007kwDk07sT3y07sTkzszsTsDzzsDy1zzkDzUTzkDzw0z0Tzz000Tzzs00zzzzU3zzU"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        if A_Index = 3 {
            Text := "|<主线任务的图标>*150$36.zzU1zzzw00Dzzs003zzU001zz0VV0zy3VVkTw73ksDsD3kw7sT7sS7ky7sT3ky7sT3U00001U00001U00001XwDyDl3wDyDt3wTyDs3wTyDs3wTyDs3wDyDs3wDwDlU00081U00001U00001k00003ky7wT3sS7sS7sT7sy7wD3kwDy3XlkTz1VVUzzU0U1zzk003zzw00Dzzz00zzU"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        if A_Index = 4 {
            Text := "|<成就的图标>*150$36.zzyTzzzz00zzzw00Dzzk003zzUDw1zz1zzUTw7zzkTwDzzwDsTyzy7kzwTy3lzwDz3VzsDzVXzs7zV3zk7zk7y00Dk7k003k7U003s7U003s7k007s7s00Ds7y00Ts7z00zk7y00zk3y00zk3y00TkVy00TVVy1UTVky7kT3kSTwy3sDzzw7w7zzsDy3zzkTz0zz0zzU7s1zzk007zzw00TzzzU3zzU"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        Text := "|<灰色的领取>*157$40.wzzs0zzVU1U00y706000kD3wE024QDl200E070Ak0U0Q0l4lkFl74P7874QFU4UQ0s60GFk3UTX170C3yA4QEsDlkFk1Uw71S063kz1s007Xs3U20D677w0EysyTkXW"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            UserClick(2130, 1982, scrRatio) ;点领取
            Sleep 500
        }
    }
    AddLog("===每日任务奖励领取结束===")
    BackToHall
}
;endregion 每日任务收取
;region 通行证收取
;tag 查找通行证
Pass() {
    BackToHall()
    AddLog("===通行证任务开始===")
    AddLog("执行第一个通行证")
    OnePass()
    Text := "|<通行证的旋转符号>*200$27.zy7zzy07zz00Dzk00zw3wDzVzvzsTzzz3zzbkzzsS7zy1lzzU6Dzz70Dzsw3zz7kzzkzDzy7zzzVzxzsDz3w3zk00zz00Dzy07zzy7zw"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        UserClick(3387, 389, scrRatio)
        Text := "|<带红点的通行证的旋转符号>*200$35.zzzzs7zzzzDbzzzwzbzzzvzjzzzrzTzzzDyzzzyTxzzzyzvzzzxzrzkztzDw0Dsszk07w3y007zzs7sTzzkzxzzz3zzzzy7zzTzsTzwDzkzzkDzXzz0Tz7zzXzs1zz7zs7zyDzsTzsTztzzkzzzzz3zzyzw7zzsTUTzzU01zzzU07zzzk0zzzzwDzzy"
        if (ok := FindText(&X := "wait", &Y := 2, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            AddLog("执行第二个通行证")
            UserClick(3387, 389, scrRatio)
            Sleep 1000
            OnePass()
        }
    }
    else AddLog("只有这么一个通行证")
    AddLog("===通行证任务结束===")
    BackToHall()
}
;tag 执行一次通行证
OnePass() {
    UserClick(3633, 405, scrRatio)
    Sleep 1000
    loop 2 {
        if A_Index = 1 {
            Text := "|<任务>*200$41.30307U07Xz0T00Tzz1zzUzzs7zzXzy0zzyDUw1zbsT1s1zzVy3k1zzXzzyTzzzzzyTzzbzzwwwD7zzsTxwD1s3zzwS3k7zzsw7U7zzVsD01wD3rzwDkS7jzvzTwDTznszkSTz70z2"
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        if A_Index = 2 {
            Text := "|<奖励>*200$41.1VU0010Lbk3zb1zTzDzy7zzyTzw7zzwzxs7znlzzyDrzXzzzzby7zzzzzsDzzzzzUTyzkzw0zxzUzU1zvzTzznzrzzzzbzyzzzzTzxvzzwzzvkzy1zzrjzzvzzyztzrzzwz0zDzvsk0A183Y"
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        Text := "|<灰色的全部>*170$39.zbzzDzzwTzsy1z1zs1k7n7z06NswTwtrCDkzbCt3z1wlmMTsDaCHk07k0GTwTy06NzXzzzrDwTzzyts0Ts0rj03z46NzXztsmDwTzD6HzXzssns00D06Tzzzttrw"
        while !(ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            UserClick(2168, 2020, scrRatio) ;点领取
            Sleep 500
            UserClick(2168, 2020, scrRatio) ;点领取
            Sleep 500
            UserClick(2168, 2020, scrRatio) ;点领取
            Sleep 500
        }
    }
    BackToHall()
}
;endregion 通行证收取
;region 剧情活动
;tag 小活动
Activity() {
    BackToHall
    Text := "|<作战出击的出击>*200$78.zzkDzzzzzzzzzzzkDzzzzzzzzzsDkDzzzzzzzzzsDkDzzzzzzzzzsDkDsDzzzsDzzsDkDs7zzzsDzzsDkDs7zzzsDzzsDkDs7zUzsDzzsDkDs7zU007zzsDkDs7zU0007zs7kDs7zU00003s007s7zU00003s00007zzs0003s00007zzzk003s00007zzzs7y3zw0007zzzsDzzzzk007y0zsDzz0zkDzDw0007zz0zkDzzy0000Dz0zkDzzy0000000zkDw3y0000000zkDw1zzk00000zkDw1zzzk0000zkDw1zrzs7s00zkDw1zkTsDzz0zkDw1zkDsDzz0TkDw1zkDsDsD000Dw1zkDsDs70001w1zkDsDs7000001zkDsDs7U00001zkDsDs7z00001zkDsDs7zzw001zk0k7s7zzzzU1zk003s7zzzzw1zk00007zzzzw1zk00007zzzzzzzy00007zzzzzzzzzs007zzzzzzzzzzz07zzzzzzzzzzzs7zzzzzzzzzzzzjU"
    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
        FindText().Click(X, Y + 100 * TrueRatio, "L")
        Sleep 1000
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
        else if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text黄, 0, 0, , , , 3, TrueRatio, TrueRatio)) {
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
;endregion 剧情活动
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
    stdTargetX := 150
    stdTargetY := 257
    UserMove(stdTargetX, stdTargetY, scrRatio)
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
    while true {
        ;一直找开始匹配
        Text匹配 := "|<匹配>*200$51.0000s0400000700U00001z4zz0yC7zs7zs7lkzw0Dz0yC7z00zs7Vkzs07z0wD7z48zs7Xszsd600wT7z5ck07Xstsh600sT771Uls37sssA6DsEz273slz0Ds1sz6Ds1z0D00lz2Tzzs04Dszzzz3kVw3zzzsz4DU000D00lw0000s0600000700k0U"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text匹配, , , , , , , TrueRatio, TrueRatio)) {
            FindText().Click(X, Y, "L")
            Sleep 1000
            Text := "|<通知>**50$48.0DzyTU00TA07MUTytw03Mzzzkw07MzU3sT4Ck0U3QS0Sk0U3Cz0TU3XX7s03WDXX0803nAXXzslny7XXUM03U0XXUM03U0XXUMlnU0XXwM03yDXXAM0366XX4MEX63XX4MlXA1XXAMl3A1XXsMt7sM03k3zzksU3V001UxU3nk01ljXXqy07v0zzU"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
                BackToHall
                return
            }
        }
        else {
            AddLog("协同作战次数已耗尽或未在开放时间")
            AddLog("===协同作战任务结束===")
            BackToHall
            return
        }
        while true {
            ;防止有人取消，反复检测
            Text接受 := "|<接受>**50$48.7kT001zw4kNUTzk64rtzM0064w01M03yww01SSTAkDDDCSP4kDDACDCCkDDDSCADww01k0014s01k0014w01nzztQDnznzztsDXzv00Pk001z00Tks01X7sMwzD7VXsk4qDC1llk4o6A0s3U4r0Q1s3sQzkDTU0TMy03E1k1Es7XM7w3U"
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text接受, , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
            Text准备 := "|<准备>**50$54.y6AM067zUX4Q80A01kXAS80M00ElgSDlk00kks00H0TVUMk00G0D3UMkwDmA0709UyDnz0D0D0yDny07z3000z00032000M0D033800w1zs37syDo3zyCAsyDbU00QAMwDlU00E8M00FXkwMMs00lXkwMEsyDlU00Mkca81U00MlcyDtXkwMV800NXkwMX8009U00Mn800NU00MU"
            if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text准备, , , , , , , TrueRatio, TrueRatio)) {
                FindText().Click(X, Y, "L")
                Sleep 1000
                break
            }
            if A_Index > 50 {
                MsgBox "进入作战失败！"
                Pause
            }
        }
        BattleSettlement
        Sleep 5000
    }
    AddLog("===协同作战任务结束===")
    BackToHall
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
        Text := "|<SKIP的图标>*10$39.zzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzzztzDzzzz7szzzzsD1zzzz0s7zzzs30Tzzz000zzzs003zzz000Dzzs001zzz000zzzs10Dzzz0s7zzzsD1zzzz3szzzztzDzzzzzzzzzzzzzzzw"
        while (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
            Text1 := "|<1>*200$10.zzzz3kD0zXyDszXyDszXyDszXyDzzzU"
            Text2 := "|<2>*190$14.zzzzzU7s0wAD7XzszsDk7s3w7z7zlzw0D03k0zzzzzU"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.05 * PicTolerance, 0.05 * PicTolerance, Text1, , 0, , , , , TrueRatio, TrueRatio)) {
                if !g_settings["StoryModeAutoChoose"] {
                    if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text2, 0, 0, , , , , TrueRatio, TrueRatio)) {
                        continue
                    }
                }
                Sleep 800
                Send "{1}"
                Sleep 500
            }
            TextAUTO := "|<AUTO的图标>*220$26.zs1zzs07zw00zz3w7zvzkzzzwDtzzVwDzwS1zz30DzkwTzyD3zw0kzzUSDzwDVzzbwTzzz3zrzsDkzz00Dzs07zzU7zU"
            if (ok := FindText(&X, &Y, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, TextAUTO, 0, 0, , , , , TrueRatio, TrueRatio)) {
                Send "{LShift Down}"
                Sleep 500
                Send "{LShift Up}"
                Click NikkeX + NikkeW, NikkeY + NikkeH, 0
            }
        }
        if g_settings["StoryModeAutoStar"] {
            Text := "|<灰色的星星>*51$28.zzbzzzwDzzzkzzzy1zzzs7zzz0Dzzw0zzzU1zy000700002000080001k000DU001z000Dz001zw00Dzk00zz003zw00Dzk00zz001zs1U7zUTUTy7zVztzzbs"
            if (ok := FindText(&X := "wait", &Y := 5, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.2 * PicTolerance, 0.2 * PicTolerance, Text, , , , , , 8, TrueRatio, TrueRatio)) {
                Sleep 1000
                FindText().Click(X, Y, "L")
                Sleep 1000
            }
        }
        Text := "|<播放>*192$53.sTzlzlz3zks01zVy7zVk03z3wDz3U0Dy7sTy7W4D00Uzk308y0100U400w02010000s0Q031000wDkMD3U03sTUky7k0Tk01VwC00TU037s08ED000D00kky400Q0001w8O0s3U07sEw3s700DkVs7wC4ATX3sDsQ00y67UTks01wAC0TVk03sMM0T3V37VkU08700C001UES00SA47VUw00ysATXjzzzzzzzy"
        if (ok := FindText(&X := "wait", &Y := 3, NikkeX, NikkeY, NikkeX + NikkeW, NikkeY + NikkeH, 0.1 * PicTolerance, 0.1 * PicTolerance, Text, , 0, , , , , TrueRatio, TrueRatio)) {
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
    WinGetPos(&X, &Y, &Width, &Height, "ahk_exe nikke.exe") ; 获取当前窗口的整体位置和大小
    WinGetClientPos(&ClientX, &ClientY, &ClientWidth, &ClientHeight, "ahk_exe nikke.exe") ; 获取当前窗口工作区的位置和大小
    ; 计算非工作区（标题栏和边框）的高度和宽度
    NonClientHeight := Height - ClientHeight
    NonClientWidth := Width - ClientWidth
    NewClientX := (A_ScreenWidth / 2) - (NikkeWP / 2)
    NewClientY := (A_ScreenHeight / 2) - (NikkeHP / 2)
    NewClientWidth := 2331
    NewClientHeight := 1311
    ; 计算新的窗口整体大小，以适应新的工作区大小
    NewWindowX := NewClientX
    NewWindowY := NewClientY
    NewWindowWidth := NewClientWidth + NonClientWidth
    NewWindowHeight := NewClientHeight + NonClientHeight
    ; 使用 WinMove 移动和调整窗口大小
    WinMove NewWindowX, NewWindowY, NewWindowWidth, NewWindowHeight, "ahk_exe nikke.exe"
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
