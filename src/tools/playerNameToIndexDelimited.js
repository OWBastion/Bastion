const TITLE_PLAYER_NAMES = [
  "他又", "别感冒", "草艮", "烛台与南九", "顾北酒笙", "WildRage", "尘风歌者", "吾携秋水揽星河", "寒霜冰湮", "Cold",
  "豆本豆豆奶", "神之岛風咲", "溪云初起日沉阁", "卖核弹的小女孩", "挽风", "水濑祈", "别打老顾我啊", "看啊情", "眼镜小宅", "初一吖",
  "锦木千束", "她说话有股孩子气", "白银之鹰", "蝎子莱莱", "雨鸢", "Jargon", "我心飞扬", "绿里奇迹", "EruIluvatar", "糯米进脑子",
  "半夜汽笛", "雷个大憨憨", "一痕沙", "Augenstern", "明月有时", "旅店老板", "谁能体谅我的雨天", "岂不六哉"
];

const titleIndexByName = Object.fromEntries(
  TITLE_PLAYER_NAMES.map((name, index) => [name, index])
);

const indices = names
  .map((name) => titleIndexByName[name])
  .filter((index) => index !== undefined);

const delimiter = sep == null || sep === "" ? "-" : sep;

JSON.stringify(indices.join(delimiter));
