var result = "";

// 1) 名字表（必须与 playerNameToIndex.js 使用的顺序完全一致）
var TITLE_PLAYER_NAMES = [
  "他又", "别感冒", "草艮", "烛台与南九", "顾北酒笙", "WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold",
  "豆本豆豆奶", "神之岛風咲", "溪云初起日沉阁", "卖核弹的小女孩", "挽风", "水濑祈", "别打老顾我啊", "看啊情", "眼镜小宅", "初一吖",
  "锦木千束", "她说话有股孩子气", "白银之鹰", "蝎子莱莱", "雨鸢", "Jargon", "我心飞扬", "绿里奇迹", "EruIluvatar", "糯米进脑子",
  "半夜汽笛", "雷个大憨憨", "一痕沙", "Augenstern", "明月有时", "旅店老板", "谁能体谅我的雨天", "岂不六哉"
];

// 2) name -> index
var dict = {};
for (var i = 0; i < TITLE_PLAYER_NAMES.length; i++) {
  dict[TITLE_PLAYER_NAMES[i]] = i;
}

// 3) names -> indices（跳过未知）
var indices = [];
for (var j = 0; j < names.length; j++) {
  var pname = names[j];
  var idx = dict[pname];
  if (idx === undefined) continue;
  indices.push(idx);
}

var delimiter = (typeof sep === "undefined" || sep === null || sep === "") ? "-" : sep;

// 4) 用自定义分隔符拼接，并返回“带引号的字符串字面量”
var joined = indices.join(delimiter);      // 例如: 0-1-7
result = JSON.stringify(joined);     // 例如: "0-1-7"

result;
