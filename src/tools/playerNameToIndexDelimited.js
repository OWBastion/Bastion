const TITLE_PLAYER_NAMES = [
  "自律达人游十三",
  "EruIluvatar",
  "Fajacy",
  "云雀",
  "他又",
  "八月八月八",
  "初一",
  "卖核弹的小女孩",
  "吾携秋水揽星河",
  "嘤嘤嘤丶",
  "墙上静止的钟",
  "天树是只臭猫",
  "眼镜小宅",
  "训犬大师",
  "豆本豆豆奶",
  "銀狼",
  "锄禾日当午"
];

const titleIndexByName = Object.fromEntries(
  TITLE_PLAYER_NAMES.map((name, index) => [name, index])
);

const indices = names
  .map((name) => titleIndexByName[name])
  .filter((index) => index !== undefined)

const delimiter = sep == null || sep === "" ? "-" : sep;

JSON.stringify(indices.join(delimiter));
