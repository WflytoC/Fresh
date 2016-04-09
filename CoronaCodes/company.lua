local codes ={}
codes.companies = {"申通","顺丰","圆通速递","韵达快递","邮政小包","中通速递","EMS","百世汇通","天天快递","UPS","宅急送","安信达","百福东方","百福东方","邦送物流","大田物流","国通快递"}
--HTML
codes["申通"] = "shentong"
codes["顺丰"] = "shunfeng"
codes["圆通速递"] = "yuantong"
codes["韵达快递"] = "yunda"
codes["邮政小包"] = "youzhengguonei"
codes["中通速递"] = "zhongtong"
codes["EMS"] = "ems"

--API
codes["百世汇通"] = "huitongkuaidi"
codes["天天快递"] = "tiantian"
codes["UPS"] = "ups"
codes["宅急送"] = "zhaijisong"
codes["安信达"] = "anxindakuaixi"
codes["百福东方"] = "baifudongfang"
codes["邦送物流"] = "bangsongwuliu"
codes["大田物流"] = "datianwuliu"
codes["国通快递"] = "guotongkuaidi"

codes.foodTypes = {"速冻食品","肉类","冰淇淋","水果","蔬菜","饮料","鲜奶制品","巧克力","糖果"}
codes.goodTypes = {"冷冻运输(-18℃- -22℃)","冷藏运输(0℃- 7℃)","恒温运输(18℃- 22℃)"}


return codes