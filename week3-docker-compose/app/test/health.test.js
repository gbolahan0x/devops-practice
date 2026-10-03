const { test, after } = require("node:test");
const assert = require("node:assert/strict");
const { once } = require("node:events");

const { app, pool } = require("../app");

after(async () => {
  await pool.end();
});

test("GET /health returns HTTP 200 and healthy status", async () => {
  const server = app.listen(0);

  await once(server, "listening");

  try {
    const address = server.address();
    const response = await fetch(
      `http://127.0.0.1:${address.port}/health`
    );

    assert.equal(response.status, 200);

    const body = await response.json();

    assert.deepEqual(body, {
      status: "healthy"
    });
  } finally {
    await new Promise((resolve, reject) => {
      server.close((error) => {
        if (error) {
          reject(error);
          return;
        }

        resolve();
      });
    });
  }
});
