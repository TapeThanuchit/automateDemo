import { request } from 'playwright';
import fs from 'fs';
import path from 'path';
import yaml from 'js-yaml';

const dir = path.join(process.cwd(), '..', 'config');
const filePath = path.join(dir, 'env.yaml');
const fileContents = fs.readFileSync(filePath, 'utf8');
const data = yaml.load(fileContents);
const userName = process.argv[2] || 'tape2';
const password = process.argv[3] || 'qaz2Wsx!';
const baseURL = data.host;
const endpoint_login = data.login;

(async () => {
  try {
    const apiContext = await request.newContext({ baseURL });

    const response = await apiContext.post(endpoint_login, {
      data: {
        userName,
        password
      }
    });

    const body = await response.json();

    const token = body.token || null;

    const output = {
      status: response.status(),
      token: token,
      response: body,
      timestamp: new Date().toISOString()
    };

    // ใช้ current working directory + path
    const dir = path.join(process.cwd(), '..','result');
    const filePath = path.join(dir, 'token.json');
    fs.rmSync(filePath, { force: true });

    fs.writeFileSync(
      filePath,
      JSON.stringify({ token: output.token,userId: output.response.userId }, null, 2)
    );

    console.log(JSON.stringify(output));

  } catch (err) {
    const errorOutput = {
      status: 'error',
      message: err.message
    };

    const dir = path.join(process.cwd(), '..','result');
    const filePath = path.join(dir, 'token.json');

    fs.writeFileSync(
      filePath,
      JSON.stringify(errorOutput, null, 2)
    );

    console.log(JSON.stringify(errorOutput));
    process.exit(1);
  }
})();
