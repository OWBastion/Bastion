var result = "";

// 1) 名字列表（索引顺序必须与 playerdatabase / TITLE_PLAYER_NAMES 完全一致）
var TITLE_PLAYER_NAMES = [
  "他又", "别感冒", "草艮", "烛台与南九", "顾北酒笙", "WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold",
  "豆本豆豆奶", "神之岛風咲", "溪云初起日沉阁", "卖核弹的小女孩", "挽风", "水濑祈", "别打老顾我啊", "看啊情", "眼镜小宅", "初一吖",
  "锦木千束", "她说话有股孩子气", "白银之鹰", "蝎子莱莱", "雨鸢", "Jargon", "我心飞扬", "绿里奇迹", "EruIluvatar", "糯米进脑子",
  "半夜汽笛", "雷个大憨憨", "一痕沙", "Augenstern", "明月有时", "旅店老板", "谁能体谅我的雨天", "岂不六哉"
];


// 2) 建立 name -> index
var dict = {};
for (var i = 0; i < TITLE_PLAYER_NAMES.length; i++) {
  dict[TITLE_PLAYER_NAMES[i]] = i;
}

// 3) 转换：names(传入的一维数组) => indices(一维数字数组)
// 不允许混写：这里默认 names 全是字符串；未知名字：跳过
var indices = [];
for (var j = 0; j < names.length; j++) {
  var pname = names[j];
  var idx = dict[pname];
  if (idx === undefined) continue;
  indices.push(idx);
}

// 4) 输出为字符串数组结构，例如 "[0,1]"
result = JSON.stringify(indices.sort((function(a,b){return a>b?1:-1})));

result;
