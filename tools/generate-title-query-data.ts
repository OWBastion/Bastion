import path from 'node:path';
import { fileURLToPath } from 'node:url';

import { generateTitleQueryData } from './sync-title-data.ts';

export { generateTitleQueryData };

const __filename = fileURLToPath(import.meta.url);
const invokedPath = process.argv[1] ? path.resolve(process.argv[1]) : null;

if (invokedPath === __filename) {
  generateTitleQueryData()
    .then((data) => {
      console.log(
        `Generated ${data.meta.playerCount} players and ${data.meta.titleCount} titles at web/title-query/public/data/titles.json`
      );
    })
    .catch((error) => {
      console.error(error.message);
      process.exitCode = 1;
    });
}
