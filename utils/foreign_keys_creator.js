const fs = require('fs');
const path = require('path');
const mysql = require("mysql2/promise");
const JSON5 = require('json5');
const { exec, execSync } = require('child_process');
const { snakeCase, pascalCase, camelCase } = require('change-case');

const mysqlConfig = {
  host: "duckspace.tech",
  user: "root",
  password: "test123",
  database: "Quizzing",
  charset: "utf8",
};

const targetDatabase = "Quizzing";

const modelsDirectory = '../api/src/models';

const getModelFilesList = () => fs.readdirSync(modelsDirectory).filter((entry) => entry.slice(-3) == '.ts');

const getForeignKeysFromDatabase = async (table) => {
  console.log(table)
  const connection = await mysql.createConnection(mysqlConfig);
  return (await connection.execute(
    `
      SELECT
        TABLE_NAME,
        COLUMN_NAME,
        CONSTRAINT_TYPE,
        CONSTRAINT_NAME,
        REFERENCED_TABLE_NAME,
        REFERENCED_COLUMN_NAME
      FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE t1
      NATURAL JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS t2 where CONSTRAINT_TYPE = 'FOREIGN KEY' 
      AND TABLE_NAME = '${table}'
      AND CONSTRAINT_SCHEMA = '${targetDatabase}';`
  ))[0].map((entry) => {
    return {
      "fk_name": entry.CONSTRAINT_NAME,
      "fk_column": entry.COLUMN_NAME,
      "target_column": entry.REFERENCED_COLUMN_NAME,
      "target_table": entry.REFERENCED_TABLE_NAME
    };
  });
}

const generateForeignKeysSettings = async (file) => {
  const modelSettingsRegexp = /@model\(([0-9A-Za-z'"\[\]{}:,_\-\s]*)\)/g;
  const belongsToRegexp = /@belongsTo\(.?\) => ([A-Za-z]+).+\n  (\S+):.+/g;

  const pathToFile = path.join(modelsDirectory, file);
  const fileContent = fs.readFileSync(pathToFile, { encoding: 'utf8' });

  const relations = []
  // const relations = await getForeignKeysFromDatabase(snakeCase(file.slice(0, -9)));
  console.log(relations);
  fileContent.replace(belongsToRegexp, (match, g1, g2) => relations.push({ 'model': g1, 'key': g2 }));

  if (relations.length) {
    const modelSettingsMatch = modelSettingsRegexp.exec(fileContent);
    const modelSettings = modelSettingsMatch[1] != '' ? JSON5.parse(modelSettingsMatch[1]) : { 'settings': {} };
    const foreignKeys = {};

    for (const relation of relations) {
      console.log(relation);
      // const foreignKeyName = `fk_${file.split('.')[0].toLowerCase()}_${relation.key}`;
      const foreignKeyName = `${pascalCase(file.split('.')[0])}-${pascalCase(relation.key)}-FK`

      foreignKeys[foreignKeyName] = {
        name: foreignKeyName,
        foreignKey: relation.key,
        entityKey: "id",
        entity: relation.model,
        // name: relation.fk_name,
        // foreignKey: relation.fk_column,
        // entityKey: relation.target_column,
        // entity: relation.target_table,
      };
    }

    modelSettings.settings.foreignKeys = foreignKeys;
    const newFileContent = fileContent.replace(modelSettingsMatch[0], `@model(${JSON5.stringify(modelSettings, null, 2)})`)

    fs.writeFileSync(pathToFile, newFileContent);

    console.log(`<FILE WRITING> New code was injected into ${file}`);
  }
}

(async () => {
  try {
    const modelFiles = getModelFilesList();
    // const foreignKeys = await getForeignKeysFromDatabase();
    // await generateForeignKeysSettings('quiz-owners.model.ts');
    // console.log(modelFiles[0]);
    for (const modelFile of modelFiles) {
      await generateForeignKeysSettings(modelFile);
    }
  } catch (e) {
    console.error(e);
    process.exit(1);
  }

  console.log('<SCRIPT> All files were edited successfully!')
  console.log('<SCRIPT> Starting to build...')

  try {
    execSync(`cd ${modelsDirectory} && npm run build`, { stdio: 'inherit', stderr: 'inherit' });
  } catch (e) {
    console.error(e);
    process.exit(1);
  }

  console.log('<SCRIPT> Building was successful!')
  console.log('<SCRIPT> Starting to migrate...')

  const migrate = exec(`cd ${modelsDirectory} && npm run migrate`, (err, stdout, stderr) => {
    if (err) {
      console.error(`<MIGRATION> Migration FAILED! Error message:`);
      console.error(err)
    } else {
      console.log(`<MIGRATION> stdout: ${stdout}`);
      console.log(`<MIGRATION> stderr: ${stderr}`);

      console.log(`<MIGRATION> Migration was successful!`)
    }
  });

  // // migrate.on('exit', function (code) {
  // //   console.log(`<MIGRATE> Migration FAILED with code ${code}`);
  // //   process.exit(code);
  // // });

  migrate.on('close', function (code) {
    if (code == 0) {
      console.log(`<MIGRATION> Migration finished with code ${code}`);
    } else {
      console.error(`<MIGRATION> Migration FAILED! Return code: ${code}`);
    }
    process.exit(code);
  });
})().catch((e) => {
  throw e;
});
