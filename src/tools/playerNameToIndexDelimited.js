const TITLE_PLAYER_NAMES = [
  "自律达人游十三"
];

const titleIndexByName = Object.fromEntries(
  TITLE_PLAYER_NAMES.map((name, index) => [name, index])
);

const indices = names
  .map((name) => titleIndexByName[name])
  .filter((index) => index !== undefined)

const delimiter = sep == null || sep === "" ? "-" : sep;

JSON.stringify(indices.join(delimiter));
