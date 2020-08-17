const mysql = require("mysql2/promise");
const { exec, execSync, spawn } = require('child_process');
const { pascalCase, camelCase } = require('change-case');

const mysqlConfig = {
  host: "duckspace.tech",
  user: "root",
  password: "test123",
  database: "Quizzing",
  charset: "utf8",
};

const getRelationsFromDatabase = async () => {
  const connection = await mysql.createConnection(mysqlConfig);
  return (await connection.execute(
    `
        SELECT
          TABLE_NAME,
          COLUMN_NAME,
          CONSTRAINT_NAME,
          REFERENCED_TABLE_NAME,
          REFERENCED_COLUMN_NAME
        FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE
        NATURAL JOIN INFORMATION_SCHEMA.TABLE_CONSTRAINTS where CONSTRAINT_TYPE = 'FOREIGN KEY' AND CONSTRAINT_SCHEMA = '${mysqlConfig.database}';`
  ))[0];
}

const generateRelationCommand = (sourceTable, targetTable, columnName) => {
  return `lb4 relation --sourceModel=${pascalCase(sourceTable)} --destinationModel=${pascalCase(targetTable)} --foreignKeyName=${camelCase(columnName)} --relationType=belongsTo`;
}

(async () => {
  const relations = await getRelationsFromDatabase();
  for(const relation of relations) {
    console.log('Running: ' + generateRelationCommand(relation.TABLE_NAME, relation.REFERENCED_TABLE_NAME, relation.COLUMN_NAME));
    execSync(generateRelationCommand(relation.TABLE_NAME, relation.REFERENCED_TABLE_NAME, relation.COLUMN_NAME), { stdio: 'inherit', stderr: 'inherit' });
  }
  console.log('Finished generating relations!');
  process.exit(0);
})().catch((e) => {
  throw e;
});
