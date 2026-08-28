const TITLE_PLAYER_NAMES = [
  "他又",
  "吾携秋水揽星河",
  "卖核弹的小女孩",
  "EruIluvatar",
  "天树是只臭猫",
  "銀狼",
  "训犬大师",
  "自律达人游十三",
  "嘤嘤嘤丶",
  "八月八月八",
  "Fajacy",
  "锄禾日当午",
  "初一",
  "云雀",
  "墙上静止的钟",
  "眼镜小宅"
];

const titleIndexByName = Object.fromEntries(
  TITLE_PLAYER_NAMES.map((name, index) => [name, index])
);

const indices = names
  .map((name) => titleIndexByName[name])
  .filter((index) => index !== undefined)

const delimiter = sep == null || sep === "" ? "-" : sep;

JSON.stringify(indices.join(delimiter));
