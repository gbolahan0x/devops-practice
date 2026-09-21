const express = require("express");
const { Pool } = require("pg");

const app = express();
const port = process.env.PORT || 3000;

const pool = new Pool({
  host: process.env.DB_HOST || "localhost",
  port: Number(process.env.DB_PORT || 5432),
  database: process.env.DB_NAME || "week3_app",
  user: process.env.DB_USER || "app_user",
  password: process.env.DB_PASSWORD || "development_only_password"
});


app.get("/", (_request, response) => {
  response.json({
    message: "Week 3 Docker Compose app is running",
    environment: process.env.NODE_ENV || "development"
  });
});

app.get("/health", (_request, response) => {
  response.status(200).json({ status: "healthy" });
});

app.get("/db-health", async (_request, response) => {
  try {
    await pool.query("SELECT 1");
    response.status(200).json({
      status: "healthy",
      database: "connected"
  });
  } catch (error) {
    console.error("Database health check failed:", error.message);
    response.status(503).json({
      status: "unhealthy",
      database: "unreachable"
    });
  }
});

app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});